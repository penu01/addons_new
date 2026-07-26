AddCSLuaFile()
AddCSLuaFile( "base/scifi_projectile.lua" )
include( "base/scifi_projectile.lua" )

local cmd_pfx = GetConVarNumber( "sfw_fx_particles" )
local cmd_sprites = GetConVarNumber( "sfw_sprites" )

PrecacheParticleSystem( "alyxshot_muzzle" )
PrecacheParticleSystem( "alyxshot_tracer" )
PrecacheParticleSystem( "alyxshot_impact" )

-- ENT.Type 			= "point"
ENT.NewHitMechanic 	= false
-- ENT.ProjectileImpactRule = PROJECTILE_IMPACT_TRIGGER -- bit.bor( PROJECTILE_IMPACT_TRIGGER, PROJECTILE_IMPACT_TRACECAST )
ENT.SvThinkDelay 	= 0
ENT.ClThinkDelay 	= 0
ENT.PrintName 		= "wraithshot"
ENT.LifeTime		= 0.4
-- ENT.PhxCGroup 		= COLLISION_GROUP_PROJECTILE
ENT.PhxCGroup 		= COLLISION_GROUP_DEBRIS
ENT.ProjectileImpactLogic = bit.bor( PROJECTILE_IMPACT_PHYSICS, PROJECTILE_IMPACT_TRACECAST )
-- ENT.ProjectileImpactLogic = bit.bor( PROJECTILE_IMPACT_PHYSICS )
-- ENT.ProjectileImpactLogic = bit.bor( PROJECTILE_IMPACT_PHYSICS, PROJECTILE_IMPACT_TRIGGER, PROJECTILE_IMPACT_TRACECAST )
ENT.ProjectileImpactTraceLength = 256
ENT.CollisionProxySize = Vector( 1.2, 0.2, 0.2 )
ENT.PhxSSize		= 0.001
ENT.PhxMaxVelocity 	= 4800
ENT.PhxMass 		= 0
ENT.PhxGrav			= false
ENT.PhxDrag			= false
ENT.FxTracerNew 	= true
ENT.FxTracer 		= "alyxshot_tracer" 
ENT.SndImpact 		= "scifi.wraithshot.hit"
ENT.OnWater			= PROJECTILE_RULE_IGNORE
ENT.OnDamaged		= PROJECTILE_RULE_IGNORE
ENT.LightEmit		= true
ENT.LightColor		= Color( 40, 240, 255, 255 )
ENT.LightDistance	= 120
ENT.LightBrightness	= 1
ENT.LightDieTime	= 0.2
ENT.LightDecay		= 8192
ENT.LightFlareMat 	= Material( "bloom/halo_static_2.vmt" )
ENT.LightFlareColor	= Color( 10, 255, 225, 255 )
ENT.LightFlareAdd 	= false
ENT.LightFlareAlpha = 180
ENT.LightFlareSize  = 0.2
ENT.LightFlarePos 	= 0
ENT.SoundEmit		= true
ENT.SoundFile 		= "scifi.wraithshot.flyby"
ENT.SoundRate 		= 0.1
ENT.SoundNext 		= 0.1
ENT.SoundDistance 	= 200

ENT.SciFi 			= true

ENT.MeteorEnabled 			= true
ENT.MeteorAlwaysTrack 		= false
ENT.MeteorDetectionRange 	= 64
ENT.MeteorIgnoreworld 		= true
ENT.MeteorVelocityInital 	= 0
ENT.MeteorVelocityScale 	= 0
ENT.MeteorHomingFactor 		= 100
ENT.MeteorSwayScale 		= 1
ENT.MeteorVelocityDecay 	= true
ENT.MeteorNeverForget 		= true
ENT.MeteorPreserveInitial 	= true
ENT.MeteorVelocityDecayRatio = 1
ENT.MeteorVelocityDecayExponent = 4

local nLineTraceLength = 128
local nHullTraceSize = 8
	
function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 0, "MTarLocked" )
	self:NetworkVar( "Bool", 1, "XPloding" )
	self:NetworkVar( "Int", 0, "BaseDamage" )
	self:NetworkVar( "Float", 0, "HBoxMulHead" )
	self:NetworkVar( "Float", 1, "HBoxMulBody" )
	self:NetworkVar( "Entity", 0, "MTarEntity" )

end

function ENT:SubInit( ent, phys )

	ent:SetXPloding( false )
	ent:SetBaseDamage( 10 )
	ent:SetHBoxMulHead( 2 )
	ent:SetHBoxMulBody( 1 )
	
	-- if ( SERVER ) then
		-- util.SpriteTrail( 
			-- self, 
			-- 0, 
			-- self.LightColor,
			-- true, 
			-- 4, 
			-- 0, 
			-- 0.05,
			-- 0.6,
			-- "effects/beam_nocolor.vmt" 
		-- )
	-- end

end

function ENT:HitFilter( ent )

	if ( CLIENT ) then return true end

	if !( ent || IsValid( ent ) ) then 
		return true 
	end
	
	if ( ent:GetClass() == "_wraithgun_beam" ) then
		return false
	end
	
	if ( ent == self || ent == self.Owner || ent:GetOwner() == self.Owner ) then 
		return true
	end

	return true

end

ENT.HomingEnabled = false
ENT.HomingTarget = NULL

function ENT:SubThink()

end

-- function ENT:PhysicsCollide( pCollisionData, pPhysicsObject )

	-- self:XPlode( pCollisionData )
		
-- end

function ENT:XPlode( pCollisionData )

	
	if ( !pCollisionData ) then return end
	if ( self:GetXPloding() ) then return end

	local target = pCollisionData.Entity || pCollisionData.HitEntity

	if ( target && target.SciFi ) then return end
	self:SetXPloding( true )
	
	local vNormal = pCollisionData.HitNormal || Vector( 0, 0, 0 )

	local vOrigin = pCollisionData.HitPos - vNormal * 4
	local aRotation = self:GetAngles()
	local vOffset = aRotation:Forward()

	if ( IsValid( target ) ) then
		local amp = GetConVar( "sfw_damageamp" ):GetFloat()

		local iDamage = self:GetBaseDamage() * amp

		-- local lnData = {}
		-- local lnResult = {}

		-- lnData.start 		= vOrigin - vOffset * nLineTraceLength
		-- lnData.endpos 		= vOrigin + vOffset * nLineTraceLength
		-- lnData.filter 		= {self}
		-- lnData.ignoreworld 	= true
		-- lnData.output 		= lnResult
		
		-- util.TraceLine( lnData )
	-- print( lnResult.HitGroup, pCollisionData.HitGroup )
		-- if ( lnResult.HitGroup == HITGROUP_HEAD || lnResult.HitBoxBone == 6 ) then
		local nHitGroup = pCollisionData.HitGroup || 0
		local nHBoxBone = pCollisionData.HitBoxBone || 0
		
		-- PrintTable( pCollisionData )
	
		-- local ply = target
		-- local numHitBoxSets = ply:GetHitboxSetCount()

		-- for hboxset=0, numHitBoxSets - 1 do
		  -- local numHitBoxes = ply:GetHitBoxCount( hboxset )
			
		  -- for hitbox=0, numHitBoxes - 1 do
			-- local bone = ply:GetHitBoxBone(hitbox, hboxset )

			-- if ( bone == pCollisionData.HitBoxBone ) then
				-- print( "Hit box set " .. hboxset .. ", hitbox " .. hitbox .. " is attached to bone " .. ply:GetBoneName(bone) )
			-- end
		  -- end
		-- end
		
		if ( nHitGroup == HITGROUP_HEAD || nHBoxBone == 6 ) then
			iDamage = iDamage * self:GetHBoxMulHead()
		end

		if ( nHitGroup == HITGROUP_CHEST || nHitGroup == HITGROUP_STOMACHE ) then
			iDamage = iDamage * self:GetHBoxMulBody()
		end
		
		local vForce = vOffset * iDamage * 10
		
		if ( SERVER ) then
			self:DealDirectDamage( DMG_SF_ENERGYSHOCKWAVE, iDamage, target, self.Owner, vForce )
		end
	end
	
	if ( SERVER ) then
		ParticleEffect( "alyxshot_impact", vOrigin, aRotation )
		util.ScreenShake( vOrigin, 4, 4, 0.25, 128 )
		self:EmitSound( self.SndImpact )
		
		self:KillSilent()
	end

end

function ENT:ImpactTrace( tr, dmgtype, AirboatGunImpact )
	
end