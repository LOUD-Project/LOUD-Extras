local SIFInainoStrategicMissile = import('/lua/seraphimprojectiles.lua').SIFInainoStrategicMissile
local EffectTemplate = import('/lua/EffectTemplates.lua')
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

SIFMIRVInainoStrategicMissile02 = Class(SIFInainoStrategicMissile) {

    FxSplashScale = 0.5,
    FxTrails = {},

    LaunchSound = 'Nuke_Launch',
    ExplodeSound = 'Nuke_Impact',
    AmbientSound = 'Nuke_Flight',

    InitialEffects = {
		'/effects/emitters/seraphim_inaino_fxtrails_01_emit.bp',
		'/effects/emitters/seraphim_inaino_fxtrails_02_emit.bp',
	},    
    ThrustEffects = {
		'/effects/emitters/seraphim_inaino_fxtrails_01_emit.bp',
		'/effects/emitters/seraphim_inaino_fxtrails_02_emit.bp',
	},
    LaunchEffects = {
		'/effects/emitters/seraphim_inaino_fxtrails_01_emit.bp',
		'/effects/emitters/seraphim_inaino_fxtrails_02_emit.bp',
	},
    
    OnCreate = function(self)
        SIFInainoStrategicMissile.OnCreate(self)
        local launcher = self:GetLauncher()
        if launcher and not launcher:IsDead() and launcher.EventCallbacks.ProjectileDamaged then
            self.ProjectileDamaged = {}
            for k,v in launcher.EventCallbacks.ProjectileDamaged do
                table.insert( self.ProjectileDamaged, v )
            end
        end
        self:SetCollisionShape('Sphere', 0, 0, 0, 2.0)
        self.MovementTurnLevel = 1
        self:ForkThread( self.MovementThread )
    end,

    OnImpact = function(self, TargetType, TargetEntity)
        if not TargetEntity or not EntityCategoryContains(categories.PROJECTILE, TargetEntity) then
            # Play the explosion sound
            local myBlueprint = self:GetBlueprint()
            if myBlueprint.Audio.Explosion then
                self:PlaySound(myBlueprint.Audio.Explosion)
            end
    
            nukeProjectile = self:CreateProjectile('/effects/entities/InainoEffectController01/InainoEffectController01_proj.bp', 0, 0, 0, nil, nil, nil):SetCollision(false)
            nukeProjectile:PassData(self.Data)
        end

        local rotation = RandomFloat(0,2*math.pi)
        #local size = RandomFloat(13,5)
        
        CreateDecal(self:GetPosition(), rotation, 'scorch_004_albedo', '', 'Albedo', 13, 13, 300, 15, self:GetArmy())

        SIFInainoStrategicMissile.OnImpact(self, TargetType, TargetEntity)
    end,

    DoTakeDamage = function(self, instigator, amount, vector, damageType)
        if self.ProjectileDamaged then
            for k,v in self.ProjectileDamaged do
                v(self)
            end
        end
        SIFInainoStrategicMissile.DoTakeDamage(self, instigator, amount, vector, damageType)
    end,

    CreateEffects = function( self, EffectTable, army, scale)
        for k, v in EffectTable do
            self.Trash:Add(CreateAttachedEmitter(self, -1, army, v):ScaleEmitter(scale))
        end
    end,

    MovementThread = function(self)
        local army = self:GetArmy()
        local launcher = self:GetLauncher()
        self.CreateEffects( self, self.InitialEffects, army, 1 )
        self:TrackTarget(false)
        WaitSeconds(2.5)		# Height
        self:SetCollision(true)
        self.CreateEffects( self, self.LaunchEffects, army, 1 )
        WaitSeconds(2.5)
        self.CreateEffects( self, self.ThrustEffects, army, 3 )
        WaitSeconds(2.5)
        self:TrackTarget(true) # Turn ~90 degrees towards target
        self:SetTurnRate(47.36)
        WaitSeconds(2) 					# Now set turn rate to zero so nuke flies straight
        self:SetTurnRate(0)
        self:SetAcceleration(0.001)
        self.WaitTime = 0.5
        while not self:BeenDestroyed() do
            self:SetTurnRateByDist()
            WaitSeconds(self.WaitTime)
        end
    end,

    SetTurnRateByDist = function(self)
        local dist = self:GetDistanceToTarget()
        #Get the nuke as close to 90 deg as possible
        if dist > 150 then        
            #Freeze the turn rate as to prevent steep angles at long distance targets
            self:SetTurnRate(0)
        elseif dist > 75 and dist <= 150 then
						# Increase check intervals
            self.WaitTime = 0.3
        elseif dist > 32 and dist <= 75 then
						# Further increase check intervals
            self.WaitTime = 0.1
        elseif dist < 32 then
						# Turn the missile down
            self:SetTurnRate(50)
        end
    end,

    GetDistanceToTarget = function(self)
        local tpos = self:GetCurrentTargetPosition()
        local mpos = self:GetPosition()
        local dist = VDist2(mpos[1], mpos[3], tpos[1], tpos[3])
        return dist
    end,
}

TypeClass = SIFMIRVInainoStrategicMissile02
