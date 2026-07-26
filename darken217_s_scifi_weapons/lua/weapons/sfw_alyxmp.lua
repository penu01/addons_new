AddCSLuaFile()
AddCSLuaFile( "base/scifi_base.lua" )
include( "base/scifi_base.lua" )

SWEP.Spawnable = GetConVar( "sfw_showhiddenweapons" ):GetBool()

SWEP.ViewModel				= "models/weapons/cstrike/c_smg_mac10.mdl" -- "pn03/weapons/v_pistol.mdl"
SWEP.WorldModel				= "models/weapons/w_smg_mac10.mdl"
SWEP.HoldType 				= "pistol"
SWEP.HoldTypeNPC 			= "pistol"
SWEP.HoldTypeSprint 		= "normal"
SWEP.DeploySpeed 			= 2.6

SWEP.VfxMuzzleParticle	 	= "alyxshot_muzzle"
SWEP.VfxMuzzleAttachment 	= "1"
SWEP.VfxMuzzleColor 		= Color( 80, 250, 220, 255 )
SWEP.VfxMuzzleBrightness 	= 0.4
SWEP.VfxMuzzleFOV 			= 140
SWEP.VfxMuzzleFarZ 			= 520

SWEP.Primary.ClipSize		= 45
SWEP.Primary.DefaultClip	= 46
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"

SWEP.PrintName				= "sfw_alyxmp"
SWEP.Slot					= 1
SWEP.SlotPos				= 1
SWEP.ViewModelFOV			= 60

SWEP.ReloadSND				= "weapons/pn03/reload.wav"
SWEP.ReloadTime				= 1.2
SWEP.ReloadPlaybackRate 	= 2.2
SWEP.ReloadACT 				= ACT_VM_DRAW

SWEP.AdsPos 				= Vector(-6.5, 15, 0)
SWEP.AdsAng 				= Vector(0, 0, -10)
SWEP.AdsZoom 				= 1.5

SWEP.ViewModelMeleePos		= Vector( 2, 2, -16 )
SWEP.ViewModelMeleeAng		= Angle( 60, 10, 25 )

SWEP.SciFiMeleeTime			= 0
SWEP.SciFiMeleeASpeed		= 0.45
SWEP.SciFiMeleeRange		= 50
SWEP.SciFiMeleeDamage		= 6
SWEP.SciFiMeleeSound		= "scifi.melee.swing.light"

SWEP.ViewModelSprintPos 	= Vector( -4, 0, 0 )
SWEP.ViewModelSprintAng		= Angle( -16, -10, 0 )
SWEP.ViewModelSwayDirection = Vector( -0.25, 4, 2 )
SWEP.ViewModelSprintRatio 	= 1
SWEP.ViewModelSprintSway 	= 2
SWEP.SprintAnimSpeed		= 10

SWEP.SciFiWorldStats		= {
	Primary = {
		DamageAmount = 10,
		DamageType = DMG_BULLET,
		CritMul = 20,
		FireRate = { 
			{ RateTitle = "full-auto", RateDelay = 0.05 }
		},
	},
	ClipSize = 45,
	ReloadSpeed = 1.2,
	Recoil = 1.2
}

SWEP.mat_laser_line = Material( "effects/laser_line2.vmt" )
-- SWEP.mat_laser_glow = Material( "models/weapons/v_mk23/dot2.vmt" )

SWEP.ViewModelBoneMods = {
	["v_weapon.mac10_parent"] = { pos = Vector( 0, 0, 0 ), angle = Angle( -4.5, 10, 0.2 ), scale = Vector( 1, 1, 1 ) },
	["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector( 1, 1, 1 ), pos = Vector( -20, -20, 0 ), angle = Angle( 0, 0, 0 ) },
	["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector( 1, 1, 1 ), pos = Vector( 0, 0, 0 ), angle = Angle( 0, 0, 0 ) }
}

SWEP.VElements = {
--	["soilentgreen"] = { type = SCIFI_SCK_TYPE_MODEL, model = "models/props_citizen_tech/steamengine001a.mdl", bone = "USP", rel = "", pos = Vector(-0.04, -9.5, -2.9), angle = Angle(0, -90, 180), size = Vector(0.024, 0.014, 0.014), color = Color(230, 225, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
--	["point"] = { type = SCIFI_SCK_TYPE_LASER, color = Color( 255, 10, 30 ), bone = "USP", pos = Vector( -0.65, -5.5, -0.5 ), angle = Angle( 0, 90, 0 ), range = 8192, line_size = 0.6, haze_size = 0.2, dot_size = 2 }
	["point"] = { type = SCIFI_SCK_TYPE_LASER, color = Color( 255, 10, 30 ), bone = "v_weapon.mac10_parent", pos = Vector( 0, -3.5, -4 ), angle = Angle( -90, 0, 0 ), range = 8192, line_size = 0.6, haze_size = 0.2, dot_size = 2 }
}

SWEP.WElements = {
	["point"] = { type = SCIFI_SCK_TYPE_LASER, color = Color( 255, 10, 30 ), bone = "ValveBiped.Bip01_R_Hand", pos = Vector( 10.6, 2.2, -3.7 ), angle = Angle( -7, -7, 0 ), range = 8192, line_size = 0.6, haze_size = 0.2, dot_size = 2 }
}

local echo_snd = Sound( "weapons/alyx_gun/alyx_gun_fire5.wav" )
local snd_fire_lowclip = Sound( "weapons/pistol/pistol_empty.wav" )
local dState, fHandOffset = 0, 0

function SWEP:Think()

	local fNextPFire = self:GetNextPrimaryFire() - ( CurTime() + FrameTime() )
	fNextPFire = fNextPFire * self.ChargeDeltaFactor

	if ( CLIENT ) then
		if ( self:GetSciFiState() == SCIFI_STATE_RELOADING ) then
			local vmEntity = self.Owner:GetViewModel()

			if ( fNextPFire > 0 ) then
				fHandOffset = Lerp( FrameTime() * 10, fHandOffset, 1 )
			end

			if ( fNextPFire < 0 ) then
				fHandOffset = Lerp( FrameTime() * 10, fHandOffset, 0 )
			end
			
			if ( fNextPFire <= -0.15 ) then
				fHandOffset = 0
			end

			self.ViewModelBoneMods["ValveBiped.Bip01_L_UpperArm"].pos = Vector( -20, -20, 0 ) + Vector( 20, 20, 0 ) * fHandOffset
			self.ViewModelBoneMods["ValveBiped.Bip01_L_UpperArm"].angle = Angle( 0, 0, 0 ) + Angle( 0, 0, 0 ) * fHandOffset
			
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
	
	fHandOffset = 1
	
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
	
	self:SetNextPrimaryFire( CurTime() + 0.055 )
	
	local bullet = {}
	bullet.Num = 1
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = self.Owner:GetAimVector() + ( Vector( 0, 0, 0.2 ) * ( self:GetSciFiACC() * 0.02 ) )
	bullet.Spread = Vector( .016, .016 ) + ( Vector( 0.1, 0.1 ) * ( self:GetSciFiACC() * 0.02 ) )
	bullet.Tracer = 1
	bullet.Force = 2
	bullet.HullSize = 1
	bullet.Damage = 4
	bullet.AmmoType = "SMG1"
	bullet.TracerName = "spr_tracer"
	bullet.Callback = function( attacker, tr, dmginfo )
		if ( tr.HitGroup == HITGROUP_HEAD ) then
			dmginfo:ScaleDamage( 0.75 )
		end
	end
	
	-- self.Owner:FireBullets( bullet, false )

	local entCreator=self:GetOwner()
	
	local vOrigin
	if(self:GetSciFiState()==SCIFI_STATE_ADS)then
		vOrigin=entCreator:GetShootPos()
	else
		vOrigin=self:GetProjectileSpawnPos()
	end

	local fw, rt, up = entCreator:GetForward(), entCreator:GetRight(), entCreator:GetUp()
	local vSpray = ( rt * math.random( -10, 10 ) + up * math.random( -10, 10 ) ) * 0.002
	
	local vDirection = bullet.Dir + vSpray
	local aDirection = vDirection:Angle()
	
	local x=ents.Create("proj_alyxshot")
	x:SetPos(vOrigin)
	x:SetAngles(entCreator:EyeAngles())
	x:SetOwner(entCreator)
	-- x.PhxMaxVelocity=12000
	x.DieTime=CurTime()+0.1
	x:Spawn()
		
	local phxBullet = x:GetPhysicsObject()
	phxBullet:ApplyForceCenter( vDirection * 12000 )
	
	if ( self.Owner:IsPlayer() ) then
		self.Owner:ViewPunch( Angle( math.random( -40, -60 ), math.random( -10, 10 ), 0 ) * ( 0.001 + self:GetSciFiACC() * 0.001 ) )
		self:AddSciFiACC( 1.2 )
	end
	
	self:DoMuzzleEffect()
	self:EmitSound( "scifi.pn0x.fire" )
	
	if ( self:Clip1() < 20 ) then
		local offset = 20 - self:Clip1()
		local iPitchMin, iPitchMax = 98, 102
		
		iPitchMin, iPitchMax = iPitchMin + offset, iPitchMax + offset

		local pitch = math.random( iPitchMin, iPitchMax )
		
		self:EmitSound( snd_fire_lowclip, 70, pitch, 1, CHAN_STATIC )
	end
	
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self:TakePrimaryAmmo( 1 )

end

function SWEP:NPCShoot_Primary( ShootPos, ShootDir )

	if ( self.Owner:GetTarget() ) then
		ShootDir = self.Owner:GetShootPos() - self.Owner:GetTarget():EyePos()
	end
	
	local sTimerName = "bfire" .. self:EntIndex()

	timer.Create( sTimerName, 0.064, 5, function() 
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

function SWEP:DoImpactEffect( tr, nDamageType )

	if ( tr.HitSky ) then return end

end