--
-- Cybran "Loa" Tactical Missile, child missiles that create when the mother projectile is shot down by
-- enemy anti-missile systems
--
local CLOATacticalChildMissileProjectile = import('/lua/cybranprojectiles.lua').CLOATacticalChildMissileProjectile
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker
local EffectTemplate = import('/lua/EffectTemplates.lua')
local utilities = import('/lua/utilities.lua')

CIFMissileTacticalSplit01 = Class(CLOATacticalChildMissileProjectile) {
    OnCreate = function(self)
        CLOATacticalChildMissileProjectile.OnCreate(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 2.0)
        self.MovementTurnLevel = 1
        self:ForkThread(self.TargetTracking)
    end,

    TargetTracking = function(self)
        self:TrackTarget(false)
        self:SetCollision(true)
        self:SetTurnRate(90)
        WaitSeconds(0.5)
        self:TrackTarget(true)
        self:SetTurnRate(90)
        WaitSeconds(0.2)
        local target = self:GetTrackingTarget()
        if table.getsize (target) < 1 then
            self:Retarget()
        else

            if target.IncommingDamage then
                if target.IncommingDamage<target:GetHealth()*1.5 then
                    target.IncommingDamage=target.IncommingDamage+self.DamageData.DamageAmount
                else
                    self:Retarget()
                end
            else
                target.IncommingDamage=self.DamageData.DamageAmount
            end
           
            while not self:BeenDestroyed() do
                WaitSeconds(0.1)
                if target:IsDead() then
                    self:Retarget()
                else
                WaitSeconds(0.1)
                    self:SetTurnRateByDist()
                end
            end
        end
    end,

    Retarget = function(self)
        self:SetTurnRate(1)
        self:ChangeMaxZigZag(12)
        self.MovementTurnLevel = 1
        self:SetMaxSpeed(25)

        local launcher = self:GetLauncher()
        local aiBrain = launcher:GetAIBrain()
        local position = self:GetPosition()
        local radius = 50
        local targetlist = aiBrain:GetUnitsAroundPoint(categories.ALLUNITS - categories.AIR - categories.SUBMERSIBLE - categories.WALL, position, radius, 'ENEMY')
        local num = table.getsize (targetlist)
        local ran = Random(1, num)

        if table.getsize (targetlist) > 0 then
           self:SetNewTarget(targetlist[ran])
           self:TargetTracking()
        else
           WaitSeconds(0.1)
           self:Retarget()
        end
    end,

    SetTurnRateByDist = function(self)
        local dist = self:GetDistanceToTarget()
        if dist > 150 and dist <= 250 then
            self:SetTurnRate(150)
            self:ChangeMaxZigZag(20)
            self:SetMaxSpeed(25)
            self.MovementTurnLevel = 1
        elseif dist > 100 and dist <= 150 then
            self:SetTurnRate(125)
            self:ChangeMaxZigZag(15)
            self:SetMaxSpeed(25)
            self.MovementTurnLevel = 2
        elseif dist > 50 and dist <= 50 then
            self:SetTurnRate(150)
            self:ChangeMaxZigZag(10)
            self:SetMaxSpeed(25)
            self.MovementTurnLevel = 3
        elseif dist < 25 then
            self:SetTurnRate(160)
            self:ChangeMaxZigZag(5)
            self:SetMaxSpeed(25)
            self.MovementTurnLevel = 4
        elseif dist < 10 then
            self:SetTurnRate(180)
            self:ChangeMaxZigZag(1)
            self:SetMaxSpeed(25)
            self.MovementTurnLevel = 5
        end
    end,

    GetDistanceToTarget = function(self)
        local tpos = self:GetCurrentTargetPosition()
        local mpos = self:GetPosition()
        local dist = VDist2(mpos[1], mpos[3], tpos[1], tpos[3])
        return dist
    end,

    OnDestroy = function(self)
        local target = self:GetTrackingTarget()
        if target and target.IncommingDamage then
            target.IncommingDamage=target.IncommingDamage-self.DamageData.DamageAmount
        end   
        if self.Trash then
            self.Trash:Destroy()
        end
    end, 
}
TypeClass = CIFMissileTacticalSplit01