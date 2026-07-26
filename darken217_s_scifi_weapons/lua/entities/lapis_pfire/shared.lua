AddCSLuaFile()
AddCSLuaFile( "base/scifi_projectile.lua" )
include( "base/scifi_projectile.lua" )

local cmd_pfx = GetConVarNumber( "sfw_fx_particles" )
local cmd_sprites = GetConVarNumber( "sfw_sprites" )

-- ENT.Type 			= "point"
-- ENT.NewHitMechanic 	= false
-- ENT.ProjectileImpactRule = bit.bor( PROJECTILE_IMPACT_TRIGGER, PROJECTILE_IMPACT_TRACECAST )
ENT.SvThinkDelay 	= 0
ENT.ClThinkDelay 	= 0
ENT.PrintName 		= "wraithshot"
ENT.LifeTime		= 2.5
ENT.PhxCGroup 		= COLLISION_GROUP_PROJECTILE
-- ENT.PhxCGroup 		= COLLISION_GROUP_DEBRIS
ENT.ProjectileImpactLogic = bit.bor( PROJECTILE_IMPACT_PHYSICS, PROJECTILE_IMPACT_TRIGGER, PROJECTILE_IMPACT_TRACECAST )
ENT.ProjectileImpactTraceLength = 32
ENT.PhxSSize		= 0.001
ENT.PhxMaxVelocity 	= 7200
ENT.PhxMass 		= 1
ENT.PhxGrav			= false
ENT.PhxDrag			= false
ENT.FxTracerNew 	= true
ENT.FxTracer 		= "_wraithgun_tracer" 
ENT.SndImpact 		= "scifi.wraithshot.hit"
ENT.LifeTime		= 10
ENT.OnWater			= PROJECTILE_RULE_IGNORE
ENT.OnDamaged		= PROJECTILE_RULE_IGNORE
ENT.LightEmit		= true
ENT.LightColor		= "10 30 255 255"
ENT.LightDistance	= 180
ENT.LightBrightness	= 1
ENT.LightDieTime	= 1
ENT.LightDecay		= 4096
ENT.LightFlareColor	= Color( 10, 60, 255 )
ENT.LightFlareAdd 	= true
ENT.LightFlareAlpha = 16
ENT.LightFlareSize  = 0.32
ENT.LightFlarePos 	= -32
ENT.SoundEmit		= true
ENT.SoundFile 		= "scifi.wraithshot.flyby"
ENT.SoundRate 		= 0.1
ENT.SoundNext 		= 0.1
ENT.SoundDistance 	= 200

ENT.SciFi 			= true

local nLineTraceLength = 32
local nHullTraceSize = 8

function ENT:SubInit( ent, phys )

	ent:SetXPloding( false )

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

	if true then return end -- no need to do any of this, really...

	local vOrigin = self:GetPos()
	local aRotation = self:GetAngles()
	local vOffset = aRotation:Forward()

	if ( self.HomingEnabled && IsValid( self.HomingTarget ) ) then
		local tOrigin = self.HomingTarget:EyePos()
	
		local dir = ( tOrigin - vOrigin )
		local acc = dir:Length() * 0.01

		local phys = self:GetPhysicsObject()
		phys:ApplyForcvOffset( ( dir * acc ), tOrigin )
	end

	local trData = {}
	local trResult = {}
	local trSize = Vector( 1, 1, 1 ) * nHullTraceSize

	trData.start 		= vOrigin - vOffset * nLineTraceLength -- ( nLineTraceLength * 0.25 )
	trData.endpos 		= vOrigin + vOffset * nLineTraceLength -- ( nLineTraceLength * 0.25 )
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
						end --{ self, self.Owner, "_*" }
	
	trData.mins 		= trSize * -1
	trData.maxs 		= trSize
	trData.mask 		= MASK_SHOT_HULL
	trData.ignoreworld 	= true
	trData.output 		= trResult

	util.TraceHull( trData )

	local lnData = {}
	local lnResult = {}

	lnData.start 		= vOrigin - vOffset * nLineTraceLength
	lnData.endpos 		= vOrigin + vOffset * nLineTraceLength
	lnData.filter 		= trData.filter
	lnData.mask 		= MASK_SHOT_HULL
	lnData.ignoreworld 	= true
	lnData.output 		= lnResult
	
	util.TraceLine( lnData )
	
	if ( SERVER ) && ( trResult.HitSky || lnResult.HitSky ) && ( !self:GetXPloding() ) then
		self:SetXPloding( true )
		self:Remove()
	end
	
	-- print( lnResult.Hit, trResult.Hit )

	if ( SERVER ) && ( lnResult.Hit || trResult.Hit ) && ( !self:GetXPloding() ) then
		local data
		if ( trResult.Hit ) then
			data = trResults
			-- print( "Hit via hull-trace " .. tostring(data), trResult.Entity )
		else
			data = lnResult
			-- print( "Hit via line-trace " .. tostring(data), lnResult.Entity )
		end
		
		-- self:XPlode( data )
	end

end

function ENT:PhysicsCollide( pCollisionData, pPhysicsObject )

	self:XPlode( pCollisionData )
	-- print( "Hit via physics actor", pCollisionData.Entity )
		
end

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

	if ( IsValid( target ) ) then -- && !pCollisionData.Speed ) then 
		local amp = GetConVar( "sfw_damageamp" ):GetFloat()

		local iDamage = 10 * amp

		local lnData = {}
		local lnResult = {}

		lnData.start 		= vOrigin - vOffset * nLineTraceLength
		lnData.endpos 		= vOrigin + vOffset * nLineTraceLength
		lnData.filter 		= {self}
		lnData.mask 		= MASK_SHOT_HULL
		lnData.ignoreworld 	= true
		lnData.output 		= lnResult
		
		util.TraceLine( lnData )
		
		-- PrintTable(lnResult)
		-- debugoverlay.Line(lnResult.StartPos, lnResult.HitPos,4, Color(255,0,255,255),true)
	
		if ( lnResult.HitGroup == HITGROUP_HEAD || lnResult.HitBoxBone == 6 ) then
			iDamage = iDamage * 2
		end
		
		local vForce = vOffset * iDamage * -2

		if ( SERVER ) then
			self:DealDirectDamage( DMG_SF_ENERGYSHOCKWAVE, iDamage, target, self.Owner, vForce )
		end
--[[
		if ( target:IsRagdoll() ) then
			vForce = vForce / 1
			if ( target:IsConstrained() ) then
				local entParent, entChild = target:GetConstrainedEntities()

				if ( IsValid( entParent ) ) then
					self:FakeKillRagdollPoses( entParent, -vOffset + pCollisionData.HitNormal, vForce )
				end
				
				if ( IsValid( entChild ) ) then
					self:FakeKillRagdollPoses( entChild, -vOffset + pCollisionData.HitNormal, vForce )
				end
				self:FakeKillRagdollPoses( target, vOffset + pCollisionData.HitNormal, vForce )
			else
				self:FakeKillRagdollPoses( target, vOffset + pCollisionData.HitNormal, vForce )
			end
		end
]]--
	end
	
	if ( SERVER ) then
		ParticleEffect( "_wraithgun_hit", vOrigin, aRotation )
		util.ScreenShake( vOrigin, 4, 4, 0.25, 256 )
		self:EmitSound( self.SndImpact )
		
		self:KillSilent()
	end

end

function ENT:ImpactTrace( tr, dmgtype, AirboatGunImpact )
	
end