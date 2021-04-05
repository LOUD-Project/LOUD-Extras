--[[------------------------------------------------------------------------
--  File.... :  /units/UEL0108/UEL0108_script.lua
--  Author(s):  John Comes, David Tomandl, Jessica St. Croix
--  Summary  :  UEF Medium Tank Script UEL0201
--  -----------------------------
--  Modif.by :  AsdrubaelVect
--  Rev.Date :  5 septembre 2009
--  -----------------------------
--  Revis.by :  Manimal
--  Rev.Date :  20 novembre 2009
--  -----------------------------
--  Modif.by :  AsdrubaelVect
--  Rev.Date : 24 Mars 2010
--  Note1 : Correction de l'activation des armes avant la fin de l'animation
--  Note2 : Modification des niveaux de vet cause V2.0
--  Note3 : Voir commentaire "NOTES" plus bas
--  -----------------------------
--  Revis.by :  Manimal
--  Rev.Date :  21 mars 2011 17:32 -> CORRECTIONS DES GROSSES BOULETTES + REFONTE CODE.
--  Pour Asdrubael => Voir Notes : OnCreate, OnStopBeingBuilt !
--  Rev.Date :  23 mars 2011 18:50 -> Ajout Variable Globale EW_Enhancements
--  -----------------------------
--  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
------------------------------------------------------------------------]]--


--=======================================================================
local Game = import( '/lua/game.lua' )

-- VARIABLE ''GLOBALE'' ( par Manimal )
local ExpWarsPath = Game.ExpWarsPath
--=======================================================================

local EW_Enhancements =  { 'VeterancyI', 'VeterancyII', 'VeterancyIII', 'VeterancyIV', 'VeterancyV' }

local TLandUnit = import( '/lua/terranunits.lua' ).TLandUnit

local TerranWeapons = import( '/lua/terranweapons.lua' )

---- Double Canon Central D�ployable
local TDFGaussCannonWeapon = TerranWeapons.TDFGaussCannonWeapon
---- Mini Canons Lat�raux Permanents
local TDFMachineGunWeapon = TerranWeapons.TDFMachineGunWeapon


local Buff = import( '/lua/sim/Buff.lua' )


UEL0108 = Class( TLandUnit ) {

	Weapons = {
		ArmCannonTurret = Class( TDFMachineGunWeapon ) {},
		MainGun = Class( TDFGaussCannonWeapon ) {
			SetOnTransport = function( self, transportstate )
				self.unit:SetScriptBit( 'RULEUTC_WeaponToggle', false )
			end,
		},
		---- UPGRADE03
		UpgradeGun01 = Class( TDFGaussCannonWeapon ) {},
		---- UPGRADE04
		UpgradeGun02 = Class( TDFMachineGunWeapon ) {},
		UpgradeGun03 = Class( TDFMachineGunWeapon ) {},

	},


	OnCreate = function( self )
		TLandUnit.OnCreate( self )

		------VET------
		---- UPGRADE01
		self:HideBone( 'Upgrade01_01', true )
		self:HideBone( 'Upgrade01_02', true )
		self:HideBone( 'Upgrade01_03', true )
		self:HideBone( 'Upgrade01_04', true )
		self:HideBone( 'Upgrade01_05', true )
		self:HideBone( 'Upgrade01_06', true )
		---- UPGRADE02
		self:HideBone( 'Upgrade02_01', true )
		self:HideBone( 'Upgrade02_02', true )
		---- UPGRADE03
		self:HideBone( 'Upgrade03_01', true )
		---- UPGRADE04
		self:HideBone( 'Upgrade04_01', true )
		self:HideBone( 'Upgrade04_02', true )
		---- UPGRADE05
		self:HideBone( 'Upgrade05_01', true )
		self:HideBone( 'Upgrade05_02', true )
		------/VET------

		if not self.AnimationManipulator then
			self.AnimationManipulator = CreateAnimator( self )
			self.Trash:Add( self.AnimationManipulator )
		end

		local bp = self:GetBlueprint()
		self.AnimationManipulator:PlayAnim( bp.Display.AnimationActivate, false ):SetRate(0)
		-- NOTE DE MANIMAL : UNIT� PAS ENCORE CONSTRUITE ! => SUPPRIM� SetWeaponEnabledByLabel
		--self:SetWeaponEnabledByLabel( 'ArmCannonTurret', false )
		--self:SetWeaponEnabledByLabel( 'MainGun', false )
		--self:SetWeaponEnabledByLabel( 'UpgradeGun01', false )

		-- NOTE DE MANIMAL : UNIT� PAS ENCORE CONSTRUITE ! => SUPPRIM� Commands
		--IssueClearCommands( {self} )
		--self:AddCommandCap( 'RULEUCC_Move' )
		--self:SetSpeedMult( 1.0 )
		--self:SetTurnMult( 1.0 )
        self.hasENH = {}
	end,


	OnStopBeingBuilt = function( self, builder, layer )
		TLandUnit.OnStopBeingBuilt( self, builder, layer )

		-- NOTE DE MANIMAL : CAS O� UNIT� CONSTRUITE EST NIVEAU V�T 3 OU + ??? => ACTIVER UpgradeGun01 ???
		self:SetWeaponEnabledByLabel( 'ArmCannonTurret', true )
		self:SetWeaponEnabledByLabel( 'MainGun', false )
		self:SetWeaponEnabledByLabel( 'UpgradeGun01', false )
		self:SetWeaponEnabledByLabel( 'UpgradeGun02', false )
		self:SetWeaponEnabledByLabel( 'UpgradeGun03', false )

		IssueClearCommands( {self})
		self:AddCommandCap( 'RULEUCC_Move' )
		self:SetSpeedMult( 1.0 )
		self:SetTurnMult( 1.0 )

		----VET----
		self:AddUnitCallback( self.OnVeteran, 'OnVeteran' )
		------/VET------
	end,


	OnScriptBitSet = function( self, bit )
		TLandUnit.OnScriptBitSet( self, bit )
		if bit == 1 then
			if self.AnimationManipulator then
				self:ForkThread( function()
					WaitSeconds( self.AnimationManipulator:GetAnimationDuration() * self.AnimationManipulator:GetRate() )

					self:SetUnSelectable( true )
					IssueClearCommands( {self} )
					self:RemoveCommandCap( 'RULEUCC_Move' )
					self:SetSpeedMult(0)
					self:SetTurnMult(0)

					self.AnimationManipulator:SetRate( 0.5 )
					self.IsWaiting = true
					WaitFor( self.AnimationManipulator )
					self.IsWaiting = false

					------ ACTIVATION ARME PRINCIPALE ----
					self:SetWeaponEnabledByLabel( 'MainGun', true )

					------ ACTIVATION ARME V�T SECONDAIRE BAS�E SUR PRINCIPALE ----
					local niveauVet = self.VeteranLevel
					if  niveauVet > 0  and  self.hasENH[niveauVet] == true  then
						local bp = self:GetBlueprint()
						local enh = EW_Enhancements[niveauVet]
						local bpEnh = bp.ExpeWars_Enhancement[enh]
						if  not bpEnh  then  return  end
						local EnabledAtVeterancyLevel = bpEnh.EnabledAtVeterancyLevel
						if  EnabledAtVeterancyLevel  and  EnabledAtVeterancyLevel > 0  then
							self:SetWeaponEnabledByLabel( 'UpgradeGun01', true )
						end
					end
					---------- FIN ACTIVATION ARME V�T SECONDAIRE ------------

					self:SetUnSelectable(false)
				end )
			end
		end
	end,


	OnScriptBitClear = function( self, bit )
		TLandUnit.OnScriptBitClear( self, bit )
		if bit == 1 then
			if self.AnimationManipulator then

				self:ForkThread( function()
					self:SetUnSelectable(true)
					WaitSeconds( self.AnimationManipulator:GetAnimationDuration() * self.AnimationManipulator:GetRate() )

					self.AnimationManipulator:SetRate(-0.5)
					self.IsWaiting = true
					WaitFor( self.AnimationManipulator )
					self.IsWaiting = false

					------ D�SACTIVATION ARME PRINCIPALE ----
					self:SetWeaponEnabledByLabel( 'MainGun', false )

					------ D�SACTIVATION ARME V�T SECONDAIRE BAS�E SUR PRINCIPALE ----
					local niveauVet = self.VeteranLevel
					if  niveauVet > 0  and  self.hasENH[niveauVet] == true  then
						local bp = self:GetBlueprint()
						local enh = EW_Enhancements[niveauVet]
						local bpEnh = bp.ExpeWars_Enhancement[enh]
						if  not bpEnh  then  return  end
						local EnabledAtVeterancyLevel = bpEnh.EnabledAtVeterancyLevel
						if  EnabledAtVeterancyLevel  and  EnabledAtVeterancyLevel > 0  then
							self:SetWeaponEnabledByLabel( 'UpgradeGun01', false )
						end
					end
					---------- FIN D�SACTIVATION ARME V�T SECONDAIRE ------------

					IssueClearCommands( {self} )
					self:AddCommandCap( 'RULEUCC_Move' )
					self:SetSpeedMult( 1.0 )
					self:SetTurnMult( 1.0 )

					self:SetUnSelectable( false )
				end )
			end
		end
	end,


	--Level--
	OnVeteran = function ( self )
		local niveauVet = self.VeteranLevel
		local enh = EW_Enhancements[niveauVet]

		local bp = self:GetBlueprint()
		local bpEnh = bp.ExpeWars_Enhancement[enh]
		if not bpEnh then return end

		local bpEnhEAVLevel = bpEnh.EnabledAtVeterancyLevel

		if bpEnhEAVLevel  and  bpEnhEAVLevel > 0  and  ( niveauVet == bpEnhEAVLevel )  then
			----------------------
			if niveauVet == 1  then  ----if enh =='VeterancyI' then
				self:ShowBone('Upgrade01_01', true)
				self:ShowBone('Upgrade01_02', true)
				self:ShowBone('Upgrade01_03', true)
				self:ShowBone('Upgrade01_04', true)
				self:ShowBone('Upgrade01_05', true)
				self:ShowBone('Upgrade01_06', true)
				----RANGE 15%
				local wep = self:GetWeaponByLabel('MainGun')
				local wep2 = self:GetWeaponByLabel('ArmCannonTurret')
				---- BIZARRE: ASDRUBAEL APPLIQUE BUFF SUR DES ARMES PAS ENCORE DISPONIBLES !!!
				local wep3 = self:GetWeaponByLabel('UpgradeGun01')
				local wep4 = self:GetWeaponByLabel('UpgradeGun02')
				local wep5 = self:GetWeaponByLabel('UpgradeGun03')

				wep:ChangeMaxRadius(26.0)
				wep2:ChangeMaxRadius(16.0)
				wep3:ChangeMaxRadius(26.0)
				wep4:ChangeMaxRadius(16.0)
				wep5:ChangeMaxRadius(16.0)


				BuffBlueprint {
					Name = 'UEFHEALTHBUFF',
					DisplayName = 'UEFHEALTHBUFF',
					BuffType = 'MAXHEALTH',
					Stacks = 'REPLACE',
					Duration = -1,
					Affects = {
						MaxHealth = {
							Add = 32,
							Mult = 1.0,
						},
						Health = {
							Add = 150,
							Mult = 1.0,
						},
					},
				}

				Buff.ApplyBuff(self, 'UEFHEALTHBUFF')

				self.hasENH[niveauVet] = true

			----------------------
			elseif niveauVet == 2  then  ----if enh =='VeterancyII' then
				--self:ShowBone('Upgrade02_01', true)
				--self:ShowBone('Upgrade02_02', true)

				self:ShowBone('Upgrade03_01', true)
				self:SetWeaponEnabledByLabel('UpgradeGun01', true)

				BuffBlueprint {
					Name = 'UEFHEALTHBUFF1',
					DisplayName = 'UEFHEALTHBUFF1',
					BuffType = 'MAXHEALTH',
					Stacks = 'REPLACE',
					Duration = -1,
					Affects = {
						MaxHealth = {
							Add = 34,
							Mult = 1.0,
						},
						Health = {
							Add = 150,
							Mult = 1.0,
						},
					},
				}

				Buff.ApplyBuff(self, 'UEFHEALTHBUFF1')

				self.hasENH[niveauVet] = true

			----------------------
			-- NOTES
			------ Pour Manimal ------
			-- Faudrait trouver un moyen pour que l'arme ne s'active pas si unit�
			-- non deploy�e car actuellement -deploy�e ou pas- est activ�
			------ Pour Asdrubael ------
			-- Ajout� les variables utiles et am�lior� le code que tu avais massacr�.
			------------------------------
			elseif niveauVet == 3  then  --if enh =='VeterancyIII' then
				self:ShowBone('Upgrade02_01', true)
				self:ShowBone('Upgrade02_02', true)

				---- Canon D�ployable Suppl�mentaire sur Tourelle Centrale
				---self:SetWeaponEnabledByLabel('UpgradeGun01', true)

				BuffBlueprint {
					Name = 'UEFHEALTHBUFF2',
					DisplayName = 'UEFHEALTHBUFF2',
					BuffType = 'MAXHEALTH',
					Stacks = 'REPLACE',
					Duration = -1,
					Affects = {
						MaxHealth = {
							Add = 58,
							Mult = 1.0,
						},
						Health = {
							Add = 150,
							Mult = 1.0,
						},
					},
				}

				Buff.ApplyBuff(self, 'UEFHEALTHBUFF2')

				self.hasENH[niveauVet] = true

			------------------------
			elseif niveauVet == 4  then  ----if enh =='VeterancyIV' then
				self:ShowBone('Upgrade04_01', true)
				self:ShowBone('Upgrade04_02', true)

				---- Canons Inf�rieurs sur Mini-Tourelles Lat�rales
				self:SetWeaponEnabledByLabel('UpgradeGun02', true)
				self:SetWeaponEnabledByLabel('UpgradeGun03', true)

				BuffBlueprint {
					Name = 'UEFHEALTHBUFF3',
					DisplayName = 'UEFHEALTHBUFF3',
					BuffType = 'MAXHEALTH',
					Stacks = 'REPLACE',
					Duration = -1,
					Affects = {
						MaxHealth = {
							Add = 65,
							Mult = 1.0,
						},
						Health = {
							Add = 150,
							Mult = 1.0,
						},
					},
				}

				Buff.ApplyBuff(self, 'UEFHEALTHBUFF3')

				self.hasENH[niveauVet] = true

			------------------------
			elseif niveauVet == 5  then  ----if enh =='VeterancyV' then
				self:ShowBone('Upgrade05_01', true)
				self:ShowBone('Upgrade05_02', true)
				---- Tourelle Anti-Air

				BuffBlueprint {
					Name = 'UEFHEALTHBUFF',
					DisplayName = 'UEFHEALTHBUFF',
					BuffType = 'MAXHEALTH',
					Stacks = 'REPLACE',
					Duration = -1,
					Affects = {
						MaxHealth = {
							Add = 117,
							Mult = 1.0,
						},
						Health = {
							Add = 300,
							Mult = 1.0,
						},
					},
				}

				Buff.ApplyBuff(self, 'UEFHEALTHBUFF')

				self.hasENH[niveauVet] = true
			end
		end
	end,

}

TypeClass = UEL0108
