local CEMPFluxWarheadProjectile = import('/lua/cybranprojectiles.lua').CEMPFluxWarheadProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker

MirvCIFEMPFluxWarhead01 = Class(CEMPFluxWarheadProjectile) {
    FxSplashScale = 0.5,
    FxTrails = {},

    LaunchSound = 'Nuke_Launch',
    ExplodeSound = 'Nuke_Impact',
    AmbientSound = 'Nuke_Flight',

    InitialEffects = {'/effects/emitters/nuke_munition_launch_trail_02_emit.bp',},
    LaunchEffects = {'/effects/emitters/nuke_munition_launch_trail_03_emit.bp',},
    ThrustEffects = {'/effects/emitters/nuke_munition_launch_trail_04_emit.bp',},

    OnCreate = function(self)
        CEMPFluxWarheadProjectile.OnCreate(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 2.0)
        self.MoveThread = self:ForkThread(self.MovementThread)
    end,
    
    PassDamageData = function(self, damageData)
        CEMPFluxWarheadProjectile.PassDamageData(self,damageData)
        local launcherbp = self:GetLauncher():GetBlueprint()  
        self.ChildDamageData = table.copy(self.DamageData) 
    end,
    
        OnImpact = function(self, TargetType, TargetEntity) 
        
        local FxFragEffect = EffectTemplate.TFragmentationSensorShellFrag 
        local ChildProjectileBP = '/mods/RatUnits/projectiles/CIFEMPFluxWarhead14/CIFEMPFluxWarhead14_proj.bp'  
              
        
        # Split effects
        for k, v in FxFragEffect do
            CreateEmitterAtEntity( self, self:GetArmy(), v )
        end
        
        local vx, vy, vz = self:GetVelocity()
        local velocity = 6
    
		# One initial projectile following same directional path as the original
        self:CreateChildProjectile(ChildProjectileBP):SetVelocity(vx, vy, vz):SetVelocity(velocity):PassDamageData(self.DamageData)
   		
		# Create several other projectiles in a dispersal pattern
        local numProjectiles = 8
        local angle = (2*math.pi) / numProjectiles
        local angleInitial = RandomFloat( 0, angle )
        
        # Randomization of the spread
        local angleVariation = angle * 0.35 # Adjusts angle variance spread
        local spreadMul = 2.5 # Adjusts the width of the dispersal        
        
        local xVec = 0 
        local yVec = vy
        local zVec = 0
        

        # Launch projectiles at semi-random angles away from split location
        for i = 0, (numProjectiles -1) do
            xVec = vx + (math.sin(angleInitial + (i*angle) + RandomFloat(-angleVariation, angleVariation))) * spreadMul
            zVec = vz + (math.cos(angleInitial + (i*angle) + RandomFloat(-angleVariation, angleVariation))) * spreadMul 
            local proj = self:CreateChildProjectile(ChildProjectileBP)
            proj:SetVelocity(xVec,yVec,zVec)
            proj:SetVelocity(velocity)
            proj:PassDamageData(self.DamageData)                        
        end
        self:Destroy()
        CEMPFluxWarheadProjectile.OnImpact(self, TargetType, TargetEntity) 
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
        self:SetDestroyOnWater(true)       
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
        elseif dist < 15 then
						# Turn the missile down
            self:SetTurnRate(95)
        end
    end,

    GetDistanceToTarget = function(self)
        local tpos = self:GetCurrentTargetPosition()
        local mpos = self:GetPosition()
        local dist = VDist2(mpos[1], mpos[3], tpos[1], tpos[3])
        return dist
    end,
}

TypeClass = MirvCIFEMPFluxWarhead01
