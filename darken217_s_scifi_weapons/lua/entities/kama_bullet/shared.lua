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
-- ENT.PhxSSize		= 0.001
ENT.PhxSSize		= nil
-- ENT.PhxMaxVelocity 	= 4800
ENT.PhxMass 		= 4
ENT.PhxGrav			= true
ENT.PhxDrag			= true
ENT.FxTracerNew 	= true
ENT.FxTracer 		= "eml_generic_blast_minorfrags_smoke" 
ENT.SndImpact 		= "scifi.wraithshot.hit"
ENT.OnWater			= PROJECTILE_RULE_XPLODE
ENT.OnDamaged		= PROJECTILE_RULE_IGNORE
ENT.LightEmit		= true
ENT.LightColor		= "255 180 80 255"
ENT.LightDistance	= 180
ENT.LightBrightness	= 1
ENT.LightDieTime	= 1
ENT.LightDecay		= 4096
-- ENT.LightFlareMat 	= Material( "particle/Particle_Glow_05_AddNoFog.vmt" )
ENT.LightFlareMat 	= Material( "bloom/halo_static_2.vmt" )
ENT.LightFlareColor	= Color( 255, 180, 80 )
ENT.LightFlareAdd 	= true
ENT.LightFlareAlpha = 200
ENT.LightFlareSize  = 0.1
-- ENT.LightFlarePos 	= -24
ENT.SoundEmit		= false
-- ENT.SoundFile 		= "scifi.wraithshot.flyby"

ENT.SciFi 			= true

-- ENT.RMdl = false
ENT.RMdl = "models/hunter/misc/sphere025x025.mdl"

PrecacheParticleSystem( "eml_generic_blast_minorfrags_smoke" )

local nLineTraceLength = 64

function ENT:SubInit( ent, phys )

	ParticleEffectAttach( "eml_generic_blast_minorfrags_smoke", PATTACH_ABSORIGIN_FOLLOW, self, 0 )

	ent:SetXPloding( false )
	
	self.BaseDamage = self.BaseDamage || 15

	local size = 0.01

	if ( SERVER ) then
		if ( GetConVarNumber( "sfw_fx_sprites" ) == 1 ) then
			util.SpriteTrail( 
				ent, 								-- parent
				1, 									-- attachment ID
				Color( 46, 42, 3, 80 ), 			-- Color
				false, 								-- force additive rendering
				2, 									-- start width
				0, 									-- end width
				0.6,								-- lifetime
				32,									-- texture resulution
				"particle/beam_smoke_01.vmt" 		-- texture
			)
		end
	end

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

		local fLifeFraction = ( self.DieTime - CurTime() ) / self.LifeTime -- Could be used to create damage falloff over projectile lifetime, but seriously, how needs that...?
--		print( fLifeFraction )
		local iDamage = self.BaseDamage * amp * fLifeFraction
		
		if ( lnResult.HitGroup == HITGROUP_HEAD ) then
			iDamage = iDamage * 1.25
		end

		if ( lnResult.HitGroup == HITGROUP_CHEST || lnResult.HitGroup == HITGROUP_STOMACHE ) then
			iDamage = iDamage * 1.25
		end
		
		local fForceMul = 0.8
		if ( target:IsNPC() ) then
			fForceMul = 600
		end
		
		-- local vForce = ( vOffset - pCollisionData.HitNormal ) * iDamage * 4
		local vForce = vOffset * iDamage * fForceMul

		if ( SERVER ) then
			self:DealDirectDamage( DMG_SF_ENERGYSHOCKWAVE, iDamage, target, self.Owner, vForce, true )
			self:DealAoeDamage( DMG_BLAST, self.BaseDamage * 0.5 * amp, vOrigin, 40 )
		end
	end
	
	if ( SERVER ) then
		-- ParticleEffect( "xplo_hit", vOrigin, aRotation )
		ParticleEffect( "spr_hit", vOrigin, aRotation )
		util.ScreenShake( vOrigin, 6, 2, 0.25, 256 )
		self:EmitSound( self.SndImpact )
		
		self:KillSilent()
	end

end