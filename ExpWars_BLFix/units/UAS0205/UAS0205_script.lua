--****************************************************************************
--**
--**  File     :  /units/uas0205/uas0205_script.lua
--**  Author(s):  John Comes, Jessica St. Croix
--**
--**  Summary  :  Aeon Heavy Attack Sub Script
--**
--**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Game = import( '/lua/game.lua' )

-- VARIABLE ''GLOBALE'' ( par Manimal )
local ExpWarsPath = Game.ExpWarsPath
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local ASubUnit = import( '/lua/aeonunits.lua' ).ASubUnit

local AANChronoTorpedoWeapon = import('/lua/aeonweapons.lua').AANChronoTorpedoWeapon
local Buff = import('/lua/sim/Buff.lua')

local hasHEBI = false -- Flag signalant Enhancement avec Heavy Electron Bolter
local hasHEBII = false
local hasHEBI = false
local hasHEBIV = false
local hasHEBV = false

UAS0205 = Class( ASubUnit ) {
    DeathThreadDestructionWaitTime = 0,
    BuildAttachBone = 'UAS0203',
	
    Weapons = {
        Torpedo01 = Class(AANChronoTorpedoWeapon) {},
    },
	
	BuildAttachBone = 'Attachpoint',
	
    OnCreate = function(self)
		ASubUnit.OnCreate(self)
			self:HideBone('Upgrade01', true)  
			self:HideBone('Upgrade02', true) 
			self.hasHEBI = false
			self.hasHEBII = false
			self.hasHEBIII = false
			self.hasHEBIV = false
			self.hasHEBV = false
    end,	
	
    OnStopBeingBuilt = function(self,builder,layer)
        --self:SetWeaponEnabledByLabel('MainGun', true)
        ASubUnit.OnStopBeingBuilt(self,builder,layer)
		self.WeaponsEnabled = true
		self:AddUnitCallback(self.OnVeteran, 'OnVeteran') 		
        if layer == 'Sub' then
            self:RestoreBuildRestrictions()
            self:RequestRefreshUI()
        else
            self:AddBuildRestriction(categories.ALLUNITS)
            self:RequestRefreshUI()
        end
        ChangeState(self, self.IdleState)
    end,

    OnFailedToBuild = function(self)
        ASubUnit.OnFailedToBuild(self)
        ChangeState(self, self.IdleState)
    end,

    OnMotionVertEventChange = function( self, new, old )
        ASubUnit.OnMotionVertEventChange(self, new, old)
        if new == 'Top' then
            self:RestoreBuildRestrictions()
            self:RequestRefreshUI()	

            --self:SetWeaponEnabledByLabel('MainGun', true)
            --self:PlayUnitSound('Open')
        elseif new == 'top' then
            --self:SetWeaponEnabledByLabel('MainGun', false)
            self:RestoreBuildRestrictions()
            self:RequestRefreshUI()
            --self:PlayUnitSound('Close')
        end
    end,

    IdleState = State {
        Main = function(self)
            self:DetachAll(self.BuildAttachBone)
            self:SetBusy(false)
        end,

        OnStartBuild = function(self, unitBuilding, order)
            ASubUnit.OnStartBuild(self, unitBuilding, order)
            self.UnitBeingBuilt = unitBuilding
            ChangeState(self, self.BuildingState)
        end,
    },

    BuildingState = State {
        Main = function(self)
            local unitBuilding = self.UnitBeingBuilt
            self:SetBusy(true)
            local bone = self.BuildAttachBone
            self:DetachAll(bone)
            if not self.UnitBeingBuilt:IsDead() then
                unitBuilding:AttachBoneTo( -0.5, self, bone )
                if EntityCategoryContains( categories.ENGINEER + categories.uas0102 + categories.uas0103, unitBuilding ) then
                    unitBuilding:SetParentOffset( {0,0,0.5} )
                elseif EntityCategoryContains( categories.TECH2 - categories.ENGINEER, unitBuilding ) then
                    unitBuilding:SetParentOffset( {0,0,0.5} )
                elseif EntityCategoryContains( categories.uas0203, unitBuilding ) then
                    unitBuilding:SetParentOffset( {0,0,0.5} )
                else
                    unitBuilding:SetParentOffset( {0,0,0.5} )
                end
            end
            self.UnitDoneBeingBuilt = false
        end,

        OnStopBuild = function(self, unitBeingBuilt)
            ASubUnit.OnStopBuild(self, unitBeingBuilt)
            ChangeState(self, self.FinishedBuildingState)
        end,
    },

    FinishedBuildingState = State {
        Main = function(self)
            self:SetBusy(true)
            local unitBuilding = self.UnitBeingBuilt
            unitBuilding:DetachFrom(true)
            self:DetachAll(self.BuildAttachBone)
            local worldPos = self:CalculateWorldPositionFromRelative({0, 0, 10})
            IssueMoveOffFactory({unitBuilding}, worldPos)
            self:SetBusy(false)
            ChangeState(self, self.IdleState)
        end,
    },
	
	--Level--
	OnVeteran = function ( self )
        local bp = self:GetBlueprint()
		local enh = 'VeterancyI'
		local bpEnh = bp.ExpeWars_Enhancement[enh]
		--local bp = self:GetBlueprint().Enhancements[enh]
		if not bpEnh then return end
        local bpEnhEAVLevel = bpEnh.EnabledAtVeterancyLevel
		if bpEnhEAVLevel and bpEnhEAVLevel > 0 and ( self.VeteranLevel == bpEnhEAVLevel ) then
			if enh =='VeterancyI' then
			self:ShowBone('Upgrade01', true)
				hasHEBI = true    -- Signale HEB INSTALL�
				hasHEBII = false
				hasHEBIII = false
				hasHEBIV = false
				hasHEBV = false
                BuffBlueprint {
                    Name = 'UEFHEALTHBUFF',
                    DisplayName = 'UEFHEALTHBUFF',
                    BuffType = 'MAXHEALTH',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.10,
                        },
                        Regen = {
                            Add = bp.NewRegenRate,
                            Mult = 1,
                        },
                    },
                }
            end
			Buff.ApplyBuff(self, 'UEFHEALTHBUFF')
		end	
	----------------------------------
        local bp = self:GetBlueprint()
		local enh = 'VeterancyII'
		local bpEnh = bp.ExpeWars_Enhancement[enh]
		if not bpEnh then return end
        local bpEnhEAVLevel = bpEnh.EnabledAtVeterancyLevel
		-- ADDS MY CUSTOM ENHANCEMENT !
		if bpEnhEAVLevel and bpEnhEAVLevel > 0 and ( self.VeteranLevel == bpEnhEAVLevel ) then
			if enh =='VeterancyII' then
				local wep = self:GetWeaponByLabel('Torpedo01')  				
				wep:ChangeRateOfFire(bp.NewRateOfFire or 1.0)
				hasHEBI = true
				hasHEBII = true    -- Signale HEB INSTALL�
				hasHEBIII = false
				hasHEBIV = false
				hasHEBV = false
			end
		end
	----------------------------------
        local bp = self:GetBlueprint()
		local enh = 'VeterancyIII'
		local bpEnh = bp.ExpeWars_Enhancement[enh]
		if not bpEnh then return end
        local bpEnhEAVLevel = bpEnh.EnabledAtVeterancyLevel
		-- ADDS MY CUSTOM ENHANCEMENT !
		if bpEnhEAVLevel and bpEnhEAVLevel > 0 and ( self.VeteranLevel == bpEnhEAVLevel ) then
			if enh =='VeterancyIII' then
				self:ShowBone('Upgrade02', true)
				hasHEBI = true
				hasHEBII = true    -- Signale HEB INSTALL�
				hasHEBIII = true
				hasHEBIV = false
				hasHEBV = false
			end
		end
	----------------------------------
        local bp = self:GetBlueprint()
		local enh = 'VeterancyIV'
		local bpEnh = bp.ExpeWars_Enhancement[enh]
		if not bpEnh then return end
        local bpEnhEAVLevel = bpEnh.EnabledAtVeterancyLevel
		-- ADDS MY CUSTOM ENHANCEMENT !
		if bpEnhEAVLevel and bpEnhEAVLevel > 0 and ( self.VeteranLevel == bpEnhEAVLevel ) then
			if enh =='VeterancyIV' then
				hasHEBI = true
				hasHEBII = true    -- Signale HEB INSTALL�
				hasHEBIII = true
				hasHEBIV = true
				hasHEBV = false
                BuffBlueprint {
                    Name = 'UEFHEALTHBUFF',
                    DisplayName = 'UEFHEALTHBUFF',
                    BuffType = 'MAXHEALTH',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.15,
                        },
                        Regen = {
                            Add = bp.NewRegenRate,
                            Mult = 1.2,
                        },
                    },
                }
            end
			Buff.ApplyBuff(self, 'UEFHEALTHBUFF')
		end	
	--------------------------------------
        local bp = self:GetBlueprint()
		local enh = 'VeterancyV'
		local bpEnh = bp.ExpeWars_Enhancement[enh]
		if not bpEnh then return end
        local bpEnhEAVLevel = bpEnh.EnabledAtVeterancyLevel
		-- ADDS MY CUSTOM ENHANCEMENT !
		if bpEnhEAVLevel and bpEnhEAVLevel > 0 and ( self.VeteranLevel == bpEnhEAVLevel ) then
			if enh =='VeterancyV' then
				local wep = self:GetWeaponByLabel('Torpedo01')
			
				wep:AddDamageMod(bpEnh.BolterIDamageMod)  
				wep:ChangeRateOfFire(bp.NewRateOfFireI or 1.95)

				hasHEBI = true
				hasHEBII = true    -- Signale HEB INSTALL�
				hasHEBIII = true
				hasHEBIV = true
				hasHEBV = true
            end
		end
end,		
	
}

TypeClass = UAS0205
