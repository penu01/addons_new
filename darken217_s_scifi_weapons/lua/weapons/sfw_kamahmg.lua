AddCSLuaFile()
AddCSLuaFile( "base/scifi_base.lua" )
include( "base/scifi_base.lua" )

SWEP.Instructions			= ""
SWEP.Spawnable = GetConVar( "sfw_showhiddenweapons" ):GetBool()
SWEP.ItemRank 				= 4

SWEP.ViewModel				= "models/weapons/cstrike/c_mach_m249para.mdl" -- "pn03/weapons/v_pistol.mdl"
SWEP.WorldModel				= "models/weapons/w_mach_m249para.mdl"
SWEP.HoldType 				= "shotgun"
SWEP.HoldTypeNPC 			= "shotgun"
SWEP.HoldTypeSprint 		= "passive"
SWEP.DeploySpeed 			= 2.6

SWEP.VfxMuzzleParticle	 	= "ngen_muzzle_4"
SWEP.VfxMuzzleAttachment 	= "1"
SWEP.VfxMuzzleColor 		= Color( 210, 100, 20, 220 )
SWEP.VfxMuzzleBrightness 	= 2
SWEP.VfxMuzzleFOV 			= 140
SWEP.VfxMuzzleFarZ 			= 520
SWEP.VfxHeatParticle 		= "gunsmoke"

SWEP.Primary.ClipSize		= 70
SWEP.Primary.DefaultClip	= 70
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.PrintName				= "KAMA hmg"
SWEP.Slot					= 3
SWEP.SlotPos				= 3
SWEP.ViewModelFOV			= 60

SWEP.ReloadSND				= "weapons/pn03/reload.wav"
SWEP.ReloadTime				= 4
SWEP.ReloadPlaybackRate 	= 2
SWEP.ReloadACT 				= ACT_VM_RELOAD
SWEP.ReloadLegacy 			= false

SWEP.AdsPos 				= Vector(-6.12, 10, 2)
SWEP.AdsAng 				= Vector(0, 0, 0)
SWEP.AdsZoom 				= 1.5

SWEP.ViewModelMeleePos		= Vector( 6, 2, -16 )
SWEP.ViewModelMeleeAng		= Angle( 60, 30, 25 )

SWEP.SciFiMeleeTime			= 0
SWEP.SciFiMeleeASpeed		= 0.45
SWEP.SciFiMeleeRange		= 50
SWEP.SciFiMeleeDamage		= 6
SWEP.SciFiMeleeSound		= "scifi.melee.swing.light"

SWEP.ViewModelSprintPos 	= Vector( 4, 1, 0 ) -- Vector( 5, 1.5, 1 )
SWEP.ViewModelSprintAng		= Angle( -15, 35, -15 ) -- Angle( -17.5, 25, -15 )
SWEP.ViewModelSwayDirection = Vector( -0.5, 4, 3 ) -- Vector( -0.25, 4, 0.6 )
SWEP.ViewModelSprintRatio 	= 1
SWEP.ViewModelSprintSway 	= 5
SWEP.SprintAnimSpeed		= 7
SWEP.SprintSwayScale		= 0.4
SWEP.SprintBobScale			= 0.0

SWEP.SciFiWorldStats		= { 
	["1"] = { text = "Damage: 				 8 + 8", color = Color( 180, 180, 180 ) },
	["1a"] = { text = "Crit. mul.: 				1.5x", color = Color( 180, 180, 180 ) },
	["3"] = { text = "Damage type: 	Bullet, Blast", color = Color( 240, 240, 80 ) },
	["4"] = { text = "Fire rate: 				 6 (full-auto)", color = Color( 180, 180, 180 ) },
	["5"] = { text = "Clip size: 					45", color = Color( 180, 180, 180 ) }
}

SWEP.SciFiWorldStats		= {
	Primary = {
		DamageComposition = "16, 8",
		DamageAmount = 24,
		DamageType = { DMG_BULLET, DMG_BLAST },
		CritMul = 1.5,
		FireRate = { 
			{ RateTitle = "full-auto", RateDelay = 0.16 },
		},
	},
	ClipSize = 45,
	ReloadSpeed = 4,
	Recoil = 12,
	PerkSet = { SCIFI_PERK_AMMO_EXPLOSIVE, SCIFI_PERK_AMMO_DAMAGEFALLOFF }
}

SWEP.mat_laser_line = Material( "effects/laser_line2.vmt" )
SWEP.mat_laser_glow = Material( "models/weapons/v_mk23/dot2.vmt" )

SWEP.ViewModelBoneMods = {
}

SWEP.VElements = {
--	["soilentgreen"] = { type = SCIFI_SCK_TYPE_MODEL, model = "models/props_citizen_tech/steamengine001a.mdl", bone = "USP", rel = "", pos = Vector(-0.04, -9.5, -2.9), angle = Angle(0, -90, 180), size = Vector(0.024, 0.014, 0.014), color = Color(230, 225, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
--	["point"] = { type = SCIFI_SCK_TYPE_LASER, color = Color( 255, 10, 30 ), bone = "USP", pos = Vector( -0.65, -5.5, -0.5 ), angle = Angle( 0, 90, 0 ), range = 8192, line_size = 0.6, haze_size = 0.2, dot_size = 2 }
	-- ["point"] = { type = SCIFI_SCK_TYPE_LASER, color = Color( 255, 10, 30 ), bone = "v_weapon.mac10_parent", pos = Vector( 0, -3.5, -4 ), angle = Angle( -90, 0, 0 ), range = 8192, line_size = 0.6, haze_size = 0.2, dot_size = 2 }
}

SWEP.WElements = {
	-- ["point"] = { type = SCIFI_SCK_TYPE_LASER, color = Color( 255, 10, 30 ), bone = "ValveBiped.Bip01_R_Hand", pos = Vector( 10.6, 2.2, -3.7 ), angle = Angle( -7, -7, 0 ), range = 8192, line_size = 0.6, haze_size = 0.2, dot_size = 2 }
}

local echo_snd = Sound( "weapons/alyx_gun/alyx_gun_fire5.wav" )
local snd_fire_lowclip = Sound( "weapons/pistol/pistol_empty.wav" )
local dState = 0

function SWEP:Think()

	local fNextPFire = self:GetNextPrimaryFire() - ( CurTime() + FrameTime() )
	fNextPFire = fNextPFire * self.ChargeDeltaFactor

	if ( CLIENT ) then
		if ( self:GetSciFiState() == SCIFI_STATE_RELOADING ) then
			local vmEntity = self.Owner:GetViewModel()
			
			if ( IsValid( vmEntity ) ) && !( dState == SCIFI_STATE_RELOADING )  then
				vmEntity:SendViewModelMatchingSequence( vmEntity:SelectWeightedSequence( ACT_VM_RELOAD ) )
				vmEntity:SetPlaybackRate( self.ReloadPlaybackRate )
			end
		end 

		dState = self.SciFiState
	end

	self:Ads()
	self:Anims()
	self:SciFiMath()
	self:SciFiMelee()

end

function SWEP:Deploy() 

	self:SetAds( false )

	if ( game.SinglePlayer() && SERVER ) || ( !game.SinglePlayer() ) then
		self:SetSciFiState( SCIFI_STATE_IDLE )
		self:SetMeleeCharge( 0 )
		self:SetSciFiACC( 4 )
	end
	
	self:ResetAnimationScale()
	
	return true
	
end

function SWEP:FireAnimationEvent( pos, ang, event, options )

	if( event == 5001 ) then
		return true
	end

	local vm = self:GetViewModelEnt() 
	if ( IsValid( vm ) ) then 
		vm:SetPlaybackRate( 2 )
	end

end

function SWEP:PrimaryAttack()

	if ( !self:CanPrimaryAttack( 0, true ) ) then return end
	
	self:SetNextPrimaryFire( CurTime() + 0.16 )
	
	-- local bullet = {}
	-- bullet.Num = 1
	-- bullet.Src = self.Owner:GetShootPos()
	-- bullet.Dir = self.Owner:GetAimVector() + ( Vector( 0, 0, 0.1 ) * ( self:GetSciFiACC() * 0.02 ) )
	-- bullet.Spread = Vector( 0.01, 0.01 ) + ( Vector( 0.02, 0.02 ) * ( self:GetSciFiACC() * 0.02 ) )
	-- bullet.Tracer = 1
	-- bullet.Force = 2
	-- bullet.HullSize = 1
	-- bullet.Damage = 8
	-- bullet.AmmoType = "SMG1"
	-- bullet.TracerName = "moby_tracer"
	-- bullet.Callback = function( attacker, tr, dmginfo )
		-- if ( tr.HitGroup == HITGROUP_HEAD ) then
			-- dmginfo:ScaleDamage( 0.75 )
		-- end
		
		-- dmginfo:SetDamageType( DMG_BULLET )
		
		-- self:DealAoeDamage( DMG_BLAST, 8, tr.HitPos, 40 )
	-- end
	
	-- self.Owner:FireBullets( bullet, false )
	
	local pOwnerAV = self.Owner:GetAimVector()
	local pOwnerSP = self.Owner:GetShootPos()
	
	if ( SERVER ) then
		local ent = ents.Create( "kama_bullet" )
		if ( !IsValid( ent ) ) then return end
		if (self.SciFiState ~= SCIFI_STATE_ADS ) then
			ent:SetPos( self:GetProjectileSpawnPos() )
		else
			ent:SetPos( pOwnerSP + ( pOwnerAV * 8 ) )
		end
		ent:SetAngles( self.Owner:EyeAngles() )
		ent:SetOwner( self.Owner )
		ent:Spawn()
		ent:Activate()
		ent:SetPhysicsAttacker( self.Owner, 10 )
		
		local vSpread = self:GetProjectileSpreadVector() * ( 1 + self:GetSciFiACC() * 12 ) + Vector( 0, 0, 1 ) * self:GetSciFiACC() * 16
		if( self.Owner:IsNPC() ) then
			vSpread = Vector( 0, 0, 0 )
		end

		local phys = ent:GetPhysicsObject()
		if ( !IsValid( phys ) ) then ent:Remove() return end
		phys:ApplyForceCenter( pOwnerAV * 120200 + vSpread )
	end
	
	if ( self.Owner:IsPlayer() ) then
		self.Owner:ViewPunch( Angle( math.random( -20, -40 ), math.random( -10, 10 ), 0 ) * ( 0.01 + self:GetSciFiACC() * 0.001 ) )
	end
	
	self:DoMuzzleEffect()
	-- self:EmitSound( "cat.vk21hv.pfire" )
	self:EmitSound( "scifi.solaris.fire1" )
	self:EmitSound( "scifi.solaris.echo" )

	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self:TakePrimaryAmmo( 1 )
	
	self:AddSciFiACC( 12 )

end

function SWEP:NPCShoot_Primary( ShootPos, ShootDir )

	if ( self.Owner:GetTarget() ) then
		ShootDir = self.Owner:GetShootPos() - self.Owner:GetTarget():EyePos()
	end
	
	local sTimerName = "bfire" .. self:EntIndex()

	timer.Create( sTimerName, 0.16, 4, function() 
		if !( IsValid( self ) && IsValid( self.Owner ) ) then return end
		if ( !self:CanPrimaryAttack() ) then
			timer.Remove( sTimerName )
		end
		
		self:PrimaryAttack()
	end )

end

function SWEP:OnReloadFinish()
	
	self:EmitSound( "scifi.ln0.reload.bback" )
	self:SetSciFiACC( 0 )
	
	self:SetNextPrimaryFire( CurTime() )

	self:SendWeaponAnim( ACT_VM_IDLE )

end

-- function SWEP:DoImpactEffect( tr, nDamageType )

	-- if ( tr.HitSky ) then return end

	-- ParticleEffect( "spr_hit", tr.HitPos, tr.Normal:Angle(), NULL )

	-- if ( CLIENT ) then
		-- local dlight = DynamicLight( self:EntIndex() )
		-- if ( dlight ) then
			-- dlight.pos = tr.HitPos
			-- dlight.r = 255
			-- dlight.g = 120
			-- dlight.b = 10
			-- dlight.brightness = 0.6
			-- dlight.Decay = 2048
			-- dlight.Size = 32
			-- dlight.DieTime = CurTime() + 0.5
		-- end
	-- end

-- end