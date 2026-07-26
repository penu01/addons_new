AddCSLuaFile()
AddCSLuaFile( "base/scifi_projectile.lua" )
include( "base/scifi_projectile.lua" )

local cmd_pfx = GetConVarNumber( "sfw_fx_particles" )
local cmd_sprites = GetConVarNumber( "sfw_sprites" )

ENT.SvThinkDelay 	= 0
ENT.ClThinkDelay 	= 0
ENT.PrintName 		= "storm projectile"
ENT.LifeTime		= 3
ENT.PhxCGroup 		= COLLISION_GROUP_PROJECTILE
ENT.PhxSProp 		= "gmod_silent"
ENT.PhxSSize		= 1
ENT.PhxMaxVelocity 	= 4800
ENT.PhxMass 		= 1
ENT.PhxGrav			= false
ENT.PhxDrag			= false
ENT.FxTracerNew 	= true
ENT.FxTracer 		= "_wraithgun_tracer" 
ENT.SndImpact 		= "scifi.wraithshot.hit"
ENT.OnWater			= PROJECTILE_RULE_XPLODE
ENT.OnDamaged		= PROJECTILE_RULE_IGNORE
ENT.LightEmit		= true
ENT.LightColor		= "10 40 255 255"
ENT.LightDistance	= 180
ENT.LightBrightness	= 1
ENT.LightDieTime	= 1
ENT.LightDecay		= 4096
ENT.LightFlareMat 	= Material( "particle/Particle_Glow_05_AddNoFog.vmt" )
ENT.LightFlareColor	= Color( 20, 40, 255 )
ENT.LightFlareAdd 	= true
ENT.LightFlareAlpha = 64
ENT.LightFlareSize  = 0.75
ENT.LightFlarePos 	= -24
ENT.SoundEmit		= true
ENT.SoundFile 		= "scifi.wraithshot.flyby"

ENT.SciFi 			= true

-- ENT.RMdl = false
-- ENT.RMdl = "models/hunter/misc/sphere025x025.mdl"

local nLineTraceLength = 64

function ENT:SubInit( ent, phys )

	ent:SetXPloding( false )
	
	self.BaseDamage = self.BaseDamage || 10

	-- local size = 1
	-- self:SetCollisionBounds( Vector( -size, -size, -size ), Vector( size, size, size ) )	
-- self:SetModel("")
-- print(self:GetModel())

end
--[[
local panicents = {
	storm_pfire = true
}

function ENT:HitFilter( ent )

	if ( CLIENT ) then return true end

	if !( ent || IsValid( ent ) ) then 
		return true 
	end
	
	if ( panicents[ ent:GetClass() ] ) then
		return false
	end
	
	if ( ent == self || ent == self.Owner || ent:GetOwner() == self.Owner ) then 
		return true
	end

	return true

end

function ENT:SubThink()

	local vOrigin = self:GetPos()
	local aRotation = self:GetAngles()
	local vOffset = aRotation:Forward()

	local trData = {}
	local trResult = {}
	local trSize = Vector( 1, 8, 8 )

	trData.start 		= vOrigin - vOffset * 2
	trData.endpos 		= vOrigin + vOffset * 2
	trData.filter 		= function( ent ) 	
							if !( ent || IsValid( ent ) ) then 
								return false
							end
							
							if ( ent.SciFi ) then -- ent:GetClass() == self.ClassName ) then
								return false
							end
							
							if ( ent == self || ent == self.Owner || ent:GetOwner() == self.Owner ) then 
								return false
							end

							return true 
						end
	
	trData.mins 		= trSize * -1
	trData.maxs 		= trSize
	trData.mask 		= MASK_SHOT_HULL
	trData.ignoreworld 	= false --true
	trData.output 		= trResult

	util.TraceHull( trData )

	local lnData = {}
	local lnResult = {}

	lnData.start 		= vOrigin - vOffset * 86
	lnData.endpos 		= vOrigin + vOffset * 86
	lnData.filter 		= trData.filter
	lnData.mask 		= MASK_SHOT_HULL
	lnData.ignoreworld 	= false
	lnData.output 		= lnResult
	
	util.TraceLine( lnData )
	
	if ( SERVER ) && ( trResult.HitSky || lnResult.HitSky ) && ( !self:GetXPloding() ) then
		self:SetXPloding( true )
		self:Remove()
	end

	if ( SERVER ) && ( lnResult.Hit || trResult.Hit ) && ( !self:GetXPloding() ) then
		local data
		if ( trResult.Hit ) then
--			print("hull")
			data = trResult
		else
--			print("line")
			data = lnResult
		end
		
		self:XPlode( data )
	end

end
]]--

-- function ENT:Touch( entTarget )
	-- if !( bit.band( self.ProjectileImpactLogic, PROJECTILE_IMPACT_TRIGGER ) == PROJECTILE_IMPACT_TRIGGER ) then return end
	-- if !( entTarget:IsNPC() || entTarget:IsPlayer() || entTarget:IsWorld() ) then return end

	-- if !( self:GetXPloding() ) then
		-- self:XPlode( { Entity = entTarget, HitPos = self:GetPos() } ) -- self:GetTouchTrace() )
		-- self:SetXPloding( true )
	-- end
-- end

function ENT:StartTouch( entTarget )
	if ( entTarget:IsWorld() || entTarget:IsPlayer() || entTarget:IsNPC() ) then
		if ( !self:GetXPloding() ) then
			self:XPlode( { Entity = entTarget, HitPos = self:GetPos() } )
		end
	end
end

function ENT:PhysicsCollide( pCollisionData, pPhysicsObject )

	if ( true ) then
		self:XPlode( pCollisionData )
		return
	end

-- print( pCollisionData, pPhysicsObject, pCollisionData.HitEntity )
	if ( pCollisionData.HitSky ) || ( self.OnImpact == PROJECTILE_RULE_KILLME ) then
		self:KillSilent()
		
		return
	end
	
	if ( bit.band( self.ProjectileImpactLogic, PROJECTILE_IMPACT_PHYSICS ) == PROJECTILE_IMPACT_PHYSICS || self.NewHitMechanic ) then
		local bXploding = self:GetXPloding()

		if ( self.NewHitMechanic ) then
			if ( !self.NewHitMechanicOnWorld ) && ( pCollisionData.HitEntity:IsWorld() ) && ( !bXploding ) then
				self:XPlode( pCollisionData )
			end
		else
			if ( !bXploding ) then
				self:XPlode( pCollisionData )
			end
		end
	end
	
	if ( self.OnImpact != PROJECTILE_RULE_XPLODE ) then return end
	
	self:KillSilent()
	
end

function ENT:XPlode( pCollisionData )

	if ( !pCollisionData ) then return end
	if ( self:GetXPloding() ) then return end
	
	if ( pCollisionData.PhysObject ) then
		pCollisionData.PhysObject:EnableMotion( false )
	end

	local target = pCollisionData.Entity || pCollisionData.HitEntity

	if ( target && target.SciFi ) then return end

	self:SetXPloding( true )

	local vOrigin = pCollisionData.HitPos -- self:GetPos()
	local aRotation = self:GetAngles()
	local vOffset = aRotation:Forward()

	if ( IsValid( target ) ) then 
		local amp = GetConVar( "sfw_damageamp" ):GetFloat()

		local lnData = {}
		local lnResult = {}

		lnData.start 		= vOrigin - vOffset * nLineTraceLength
		lnData.endpos 		= vOrigin + vOffset * nLineTraceLength
		lnData.filter 		= {self}
		-- lnData.mask 		= MASK_SHOT_HULL
		lnData.ignoreworld 	= true
		lnData.output 		= lnResult
		
		util.TraceLine( lnData )

--		local fLifeFraction = ( self.DieTime - CurTime() ) / self.LifeTime -- Could be used to create damage falloff over projectile lifetime, but seriously, how needs that...?
--		print( fLifeFraction )
		local iDamage = self.BaseDamage * amp -- * fLifeFraction
		-- print( lnResult.Entity, target )
		if ( lnResult.HitGroup == HITGROUP_HEAD ) then
			iDamage = iDamage * 1.5
		end

		if ( lnResult.HitGroup == HITGROUP_CHEST || lnResult.HitGroup == HITGROUP_STOMACHE ) then
			iDamage = iDamage * 1.25
		end
		
		local fForceMul = 0.4
		if ( target:IsNPC() ) then
			fForceMul = 400
		end
		
		-- local vForce = ( vOffset - pCollisionData.HitNormal ) * iDamage * 4
		local vForce = vOffset * iDamage * fForceMul

		if ( SERVER ) then
			self:DealDirectDamage( DMG_SF_ENERGYSHOCKWAVE, iDamage, target, self.Owner, vForce, true )
		end
	end
	
	if ( SERVER ) then
		ParticleEffect( "_wraithgun_hit", vOrigin, aRotation )
		util.ScreenShake( vOrigin, 6, 2, 0.25, 256 )
		self:EmitSound( self.SndImpact )
		
		self:KillSilent()
	end

end