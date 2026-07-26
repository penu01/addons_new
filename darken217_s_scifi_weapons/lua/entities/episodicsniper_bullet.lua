AddCSLuaFile()
AddCSLuaFile( "base/scifi_projectile.lua" )
include( "base/scifi_projectile.lua" )

local cmd_pfx = GetConVarNumber( "sfw_fx_particles" )
local cmd_sprites = GetConVarNumber( "sfw_sprites" )

--ENT.Type 			= "point"
ENT.NewHitMechanic 	= false
ENT.ProjectileImpactLogic = PROJECTILE_IMPACT_PHYSICS
-- ENT.ProjectileImpactTraceLength = 32
ENT.SvThinkDelay 	= 0
ENT.ClThinkDelay 	= 0
ENT.PrintName 		= "epicsn"
ENT.LifeTime		= 2.5
ENT.PhxCGroup 		= COLLISION_GROUP_PROJECTILE
ENT.PhxSSize		= 0.001
ENT.PhxMaxVelocity 	= 72000
ENT.PhxMass 		= 1
ENT.PhxGrav			= true
ENT.PhxDrag			= false
ENT.FxTracerNew 	= true
ENT.FxTracer 		= "gunsmoke" 
ENT.SndImpact 		= "scifi.wraithshot.hit"
ENT.LifeTime		= 10
ENT.OnWater			= PROJECTILE_RULE_IGNORE
ENT.OnDamaged		= PROJECTILE_RULE_IGNORE
ENT.LightEmit		= true
ENT.LightColor		= Color( 20, 60, 255 )
ENT.LightDistance	= 120
ENT.LightBrightness	= 16384
ENT.LightDieTime	= 1
ENT.LightDecay		= 4096
ENT.LightFlareMat 	= Material( "bloom/halo_static_2.vmt" )
ENT.LightFlareAdd 	= true
-- ENT.LightFlareColor = Color( 16384, 1, 16384 )
ENT.LightFlareAlpha = 255
ENT.LightFlareSize  = 0.5
ENT.SoundEmit		= true
ENT.SoundFile 		= "scifi.wraithshot.flyby"
ENT.SoundRate 		= 0.1
ENT.SoundNext 		= 0.1
ENT.SoundDistance 	= 200

ENT.SciFi 			= true
	
function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 0, "MTarLocked" ) 		-- Meteor targeting. Is a target locked?
	self:NetworkVar( "Bool", 1, "XPloding" ) 		-- Is the XPlode() function running or was it triggered?
	self:NetworkVar( "Entity", 0, "MTarEntity" ) 	-- If static meteor targeting is enabled, the target entity will not change, once locked.
	self:NetworkVar( "Int", 0, "Lives" )
--	self:NetworkVar( "Vector", 0, "Pos" )

end

function ENT:SubInit( ent, phys )

	ent:SetXPloding( false )
	
	if ( SERVER ) then
		util.SpriteTrail( 
			self, 
			0, 
			self.LightColor,
			true, 
			24, 
			0, 
			0.2,
			0.6,
			"effects/beam_nocolor.vmt" 
		)
	end
	
	self:SetLives( 2 )

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

	local eOrigin = self:GetPos()
	local eAngles = self:GetAngles()
	local eOffset = eAngles:Forward()

	if ( self.HomingEnabled && IsValid( self.HomingTarget ) ) then
		local tOrigin = self.HomingTarget:EyePos()
	
		local dir = ( tOrigin - eOrigin )
		local acc = dir:Length() * 0.01

		local phys = self:GetPhysicsObject()
		phys:ApplyForceOffset( ( dir * acc ), tOrigin )
	end

	local trData = {}
	local trResult = {}
	local trSize = Vector( 2, 2, 2 )

	trData.start 		= eOrigin - eOffset * 4
	trData.endpos 		= eOrigin + eOffset * 4
	trData.filter 		= function( ent ) 	
							if !( ent || IsValid( ent ) ) then 
								return false
							end
							
							if ( ent:GetClass() == self.ClassName ) then
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
	trData.ignoreworld 	= true
	trData.output 		= trResult

	util.TraceHull( trData )

	local lnData = {}
	local lnResult = {}

	lnData.start 		= eOrigin - eOffset * 64
	lnData.endpos 		= eOrigin + eOffset * 64
	lnData.filter 		= trData.filter
	lnData.mask 		= MASK_SHOT_HULL
	lnData.ignoreworld 	= true
	lnData.output 		= lnResult
	
	util.TraceLine( lnData )
	
	if ( SERVER ) && ( trResult.HitSky || lnResult.HitSky ) && ( !self:GetXPloding() ) then
		self:SetXPloding( true )
		self:Remove()
	end

	if ( SERVER ) && ( lnResult.Hit || trResult.Hit ) && ( !self:GetXPloding() ) then
		local data
		if ( trResult.Hit ) then
			data = trResults
		else
			data = lnResult
		end
		
		self:XPlode( data )
	end

end

function ENT:GetCritMultiplier( hgroup )

	local mul = 1

	if ( hgroup == HITGROUP_HEAD ) then
		mul = 1
	end

	return mul

end

local sndBounce = Sound( "FX_RicochetSound.Ricochet" )

function ENT:PhysicsCollide( pCollisionData, pPhysicsObject )

	self:XPlode( pCollisionData )
		
	if ( pCollisionData.TheirSurfaceProps == 76 ) then
		self:KillSilent()
	end
	
	-- if ( pCollisionData.TheirSurfaceProps == 28 ) then
		-- pPhysicsObject:SetVelocity( pCollisionData.OurOldVelocity )
	-- end
	
	-- if ( pCollisionData.HitEntity:IsWorld () ) then
		-- local vVelocityNormal = pCollisionData.OurOldVelocity:GetNormalized()
		
		-- pPhysicsObject:SetVelocity( vVelocityNormal - 2 * vVelocityNormal:Dot( pCollisionData.HitNormal ) * pCollisionData.HitNormal * pCollisionData.OurOldVelocity:Length() * 0.5 )
		
		-- self.DieTime = self.DieTime -  3
	
		-- self:EmitSound( sndBounce )
	-- else
		-- if ( pCollisionData.HitEntity:IsNPC() || pCollisionData.HitEntity:IsPlayer() ) then
			-- self:SetLives( 0 )
		-- end
	-- end
	
end

function ENT:XPlode( pCollisionData )
	
	if ( !pCollisionData ) then return end
	if ( self:GetXPloding() ) then return end

	local target = pCollisionData.Entity || pCollisionData.HitEntity

	if ( target && target.SciFi ) then return end
	self:SetXPloding( true )

	local eOrigin = pCollisionData.HitPos - pCollisionData.HitNormal * 4
	local eAngles = self:GetAngles()
	local eOffset = eAngles:Forward()

	if ( IsValid( target ) ) then 
		local amp = GetConVar( "sfw_damageamp" ):GetFloat()

		local iDamage = 100 * amp

		local lnData = {}
		local lnResult = {}

		lnData.start 		= eOrigin - eOffset * 32
		lnData.endpos 		= eOrigin + eOffset * 32
		lnData.filter 		= {self}
--		lnData.mask 		= MASK_SHOT_HULL
		lnData.ignoreworld 	= true
		lnData.output 		= lnResult
		
		util.TraceLine( lnData )
		
		if ( pCollisionData.HitGroup == HITGROUP_HEAD ) || ( lnData.HitBoxBone == 6 ) then
			iDamage = iDamage * 2
		end
		
		local vForce = eOffset * iDamage * 2
	
		
		self:DealPointDamage( DMG_BULLET, 120, eOrigin, 12, 4, 4 )
	end
	
	if ( SERVER ) then
		ParticleEffect( "asa6_hit", self:GetPos(), eAngles )
		util.ScreenShake( eOrigin, 4, 4, 0.25, 256 )
		self:EmitSound( self.SndImpact )
		
		-- if ( self:GetLives() > 0 ) then
			-- self:SetLives( self:GetLives() - 1 )
		-- else
			self:KillSilent()
		-- end
	end

end

function ENT:ImpactTrace( tr, dmgtype, AirboatGunImpact )
	
end