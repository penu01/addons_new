AddCSLuaFile()
AddCSLuaFile( "base/scifi_base.lua" )
include( "base/scifi_base.lua" )

SWEP.Spawnable = GetConVar( "sfw_showhiddenweapons" ):GetBool()

SWEP.PrintName				= "Z-81K 'Talon' Pistol"
SWEP.ItemRank 				= 8

SWEP.Slot					= 1
SWEP.SlotPos				= 2

if ( CLIENT ) then
	SWEP.WepSelectIcon 			= surface.GetTextureID( "/vgui/icons/icon_obsidian.vmt" )
end

SWEP.ViewModel				= "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel				= "models/weapons/w_pist_deagle.mdl"
SWEP.HoldType 				= "pistol"
SWEP.HoldTypeNPC 			= "pistol"
SWEP.HoldTypeSprint 		= "normal"

SWEP.IhlBodyGroups 		= {[1]=0, [2]=1, [3]=0}

SWEP.SciFiSkin 				= "dev/hide"

SWEP.DeploySpeed 			= 2

SWEP.Primary.ClipSize		= 12
SWEP.Primary.DefaultClip	= 12
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.VfxMuzzleParticle	 	= "umbra_muzzle"
SWEP.VfxMuzzleAttachment 	= "1"
SWEP.VfxMuzzleAttachment2 	= "Muzzle"
SWEP.VfxMuzzleColor 		= Color( 250, 60, 45, 255 )
SWEP.VfxMuzzleBrightness 	= 1
SWEP.VfxMuzzleFOV 			= 140
SWEP.VfxMuzzleFarZ 			= 720
SWEP.VfxHeatParticle 		= "gunsmoke"

--SWEP.ReloadSND				= "weapons/vapor/vapor_reload.wav" 
SWEP.ReloadACT				= ACT_VM_RELOAD
SWEP.ReloadRealisticClips 	= false
SWEP.ReloadLegacy 			= false
SWEP.ReloadTime 			= 1.2
SWEP.ReloadPlaybackRate 	= 2

SWEP.SciFiMeleeASpeed		= 0.5
SWEP.SciFiMeleeRange		= 46
SWEP.SciFiMeleeDamage		= 5
SWEP.SciFiMeleeSound		= "scifi.melee.swing.light"

SWEP.ViewModelHomePos		= Vector( 0, 1, 0 )
SWEP.ViewModelSprintPos 	= Vector( -2, 0, 1 )
SWEP.ViewModelSprintAng		= Angle( -18, -5, -5 )
SWEP.ViewModelMeleePos		= Vector( 10, 12, -19 )
SWEP.ViewModelMeleeAng		= Angle( 50, 35, -4 )
SWEP.ViewModelReloadAnim 	= true
SWEP.ViewModelReloadPos		= Vector( -4, 3, -12 )
SWEP.ViewModelReloadAng		= Angle( 35, -10, 5 )

SWEP.SciFiACCRecoverRate 	= 0.225

SWEP.AdsPos 				= Vector(-2.45, 8, 1.5)
SWEP.AdsAng 				= Angle( 0, 0, 0 )
SWEP.AdsFov					= 48

SWEP.AdsSounds 				= true
SWEP.AdsSoundEnable 		= "scifi.fang.zoomin"
SWEP.AdsSoundDisable		= "scifi.fang.zoomout"

SWEP.DataTables = {
	{ dType = "Bool", dName = "IsReloading" },
	{ dType = "Bool", dName = "Silenced" }
}

SWEP.SciFiWorldStats		= { 
	["1"] = { text = "Damage: 				 12", color = Color( 180, 180, 180 ) },
	["1a"] = { text = "Crit. mul.: 				3x", color = Color( 180, 180, 180 ) },
	["3"] = { text = "Damage type: 	Bullet", color = Color( 185, 180, 160 ) },
	["4"] = { text = "Fire rate: 				 4 (semi-auto)", color = Color( 180, 180, 180 ) },
	["5"] = { text = "Clip size: 					12", color = Color( 180, 180, 180 ) }
}

SWEP.SciFiWorldStats		= {
	Primary = {
		DamageAmount = 10,
		DamageType = DMG_BULLET,
		CritMul = 3,
		FireRate = { 
			{ RateTitle = "semi-auto", RateDelay = 0.285 }
		},
	},
	ClipSize = 12,
	ReloadSpeed = 1.2,
	Recoil = 6,
	PerkSet = { SCIFI_PERK_AMMO_PUNCHTHROUGH_LIGHT, SCIFI_PERK_BARREL_STEALTH }
}

SWEP.FeelGoodEnabled = true
SWEP.FeelGoodRatio = 0.2
SWEP.FeelGoodHullEnabled = true
SWEP.FeelGoodHullSize = 6

SWEP.NPCAccuracy 			= 100
SWEP.NPCSkillLevel 			= 0

local c_hud_bg = Color( 255, 50, 50, 0 )
local c_hud_fg = Color( 255, 70, 60, 0 )

local m_pi 	= math.pi
local m_abs = math.abs
local m_rad = math.rad
local m_sin = math.sin
local m_cos = math.cos

local function fnArc( x, y, radius, linewidth, startangle, endangle, aa )
	aa = math.abs( aa )

--	startangle = math.Clamp( startangle, 0, 360 )
--	endangle = math.Clamp( endangle, 0, 360 )

	local arc = {}
	
	local pass = 1
	local inner = {}
	local outer = {}
	
	local diff = math.abs( startangle - endangle )
	local smoothness = math.log( diff, 2 ) * 0.5
	local step = diff * ( 1 / math.pow( aa, smoothness ) )
	
	if ( startangle > endangle ) then
		step = math.abs( step ) * -1
	end

	local offset = 1 / aa
	
	for i = startangle, endangle, step do
		local angle = math.rad( i )
		local aSin, aCos = math.sin( angle ), math.cos( angle )
		
		local r = radius - linewidth
			
		local ox, oy = x + ( aSin * r ), y + ( -aCos * r )
		inner[pass] = {
			x=ox,
			y=oy,
			u=(ox-x)/radius + offset,
			v=(oy-y)/radius + offset,
		}
		
		local ox2, oy2 = x + ( aSin * radius ), y + ( -aCos * radius )
		outer[pass] = {
			x=ox2,
			y=oy2,
			u=(ox2-x)/radius + offset,
			v=(oy2-y)/radius + offset,
		}
		
		pass = pass + 1
	end
	
	for node = 1, pass do
		local p1, p2, p3, p4
		local forward = node + 1
		
		p1 = outer[node]
		p2 = outer[forward]
		p3 = inner[forward]
		p4 = inner[node]

		arc[node] = { p1, p2, p3, p4 }
	end
	
	for k,v in pairs( arc ) do
		surface.DrawPoly( v )
	end
end

local fAdsScale = 0

local iRadSmall, iRadMedium, iRadLarge = 12, 48, 192 -- 24, 32, 48
local iWidth = 4

local fnSight = function( entWeapon, vOrigin, aRotation, fScale )

	if ( !IsValid( entWeapon ) ) then return end

	iState = entWeapon:GetSciFiState()
	
	bAds = ( iState == SCIFI_STATE_ADS )
	
	if ( fAdsScale > 0 ) then
		c_hud_fg.a = 255 * fAdsScale
		
		surface.SetDrawColor( c_hud_fg )
		draw.NoTexture()
		
		local aPunch = entWeapon:GetOwner():GetViewPunchAngles()
		local iPunchPower = math.abs( aPunch.pitch + aPunch.yaw + aPunch.roll ) * 2 + entWeapon:GetSciFiACC()
		
		local iCenter = 256
		
		local iAnchor = iCenter + iRadMedium * fAdsScale + iPunchPower * 0.5
		local iBracket = iAnchor + iRadSmall * fAdsScale + iPunchPower

		surface.DrawCircle( iCenter, iCenter, 1 * fAdsScale, c_hud_fg.r, c_hud_fg.g, c_hud_fg.b )
		surface.DrawCircle( iCenter, iCenter, 4 * fAdsScale, c_hud_fg.r, c_hud_fg.g, c_hud_fg.b )

		surface.DrawLine( iAnchor, iCenter + iRadSmall, iBracket, iCenter + iRadSmall )
		surface.DrawLine( iAnchor, iCenter - iRadSmall, iBracket, iCenter - iRadSmall )
		surface.DrawLine( iBracket, iCenter + iRadSmall, iBracket, iCenter - iRadSmall )
		
		iAnchor = iCenter - iRadMedium * fAdsScale - iPunchPower * 0.5
		iBracket = iAnchor - iRadSmall * fAdsScale - iPunchPower
		
		surface.DrawLine( iBracket, iCenter + iRadSmall, iBracket, iCenter - iRadSmall )
		surface.DrawLine( iAnchor, iCenter + iRadSmall, iBracket, iCenter + iRadSmall )
		surface.DrawLine( iAnchor, iCenter - iRadSmall, iBracket, iCenter - iRadSmall )
	end
	
	if ( !bAds ) && ( fAdsScale > 0 ) then
		fAdsScale = math.Approach( fAdsScale, 0, FrameTime() * 6 )
	end

	if ( bAds ) && ( fAdsScale < 1 ) then
		fAdsScale = math.Approach( fAdsScale, 1, FrameTime() * 6 )
	end
	
end

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector( 1, 1, 1 ), pos = Vector( 4, 1, -0.6 ), angle = Angle( 0, 0, 0 ) },
	["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector( 1, 1, 1 ), pos = Vector( -3.7, -1, 0.6 ), angle = Angle( 0, 0, 0 ) },
	["v_weapon.Deagle_Parent"] = { scale = Vector( 1, 1, 1 ), pos = Vector( 0, 4, 0 ), angle = Angle( 0, 0, 0 ) },
	["v_weapon.Deagle_Slide"] = { scale = Vector( 1, 1, 1 ), pos = Vector( 0, 0, 0 ), angle = Angle( 0, 0, 0 ) }
}

SWEP.VElements = {
	["1"] = { type = SCIFI_SCK_TYPE_MODEL, model = "models/weapons/pn03/w_pistol.mdl", bone = "v_weapon.Deagle_Parent", rel = "", pos = Vector( -0.275, -3.7, -0.8 ), angle = Angle( 92.5, -45, -42 ), size = Vector( 1.1, 1.1, 1.1 ), color = Color(255, 255, 255, 255), surpresslightning = false, submat = { [0] = "dev/hide", [1] = "", [2] = "" }, skin = 0, bodygroup = {} },
	["2"] = { type = SCIFI_SCK_TYPE_MODEL, model = "models/weapons/pn03/w_pistol.mdl", bone = "v_weapon.Deagle_Slide", rel = "", pos = Vector( -0.275, 0.3, -2 ), angle = Angle( 92.5, -45, -42 ), size = Vector( 1.1, 1.1, 1.1 ), color = Color(255, 255, 255, 255), surpresslightning = false,  submat = { [0] = "", [1] = "dev/hide", [2] = "dev/hide" },skin = 0, bodygroup = {} },
	["5"] = { type = SCIFI_SCK_TYPE_MODEL, model = "models/weapons/v_w_vk21.mdl", bone = "v_weapon.Deagle_Parent", rel = "", pos = Vector(0.05, -2.5, 3.5), angle = Angle( -90, 0, -90 ), size = Vector( 1, 1, 1 ), color = Color(255, 255, 255, 255), surpresslightning = false, skin = 0, bodygroup = {[0]=1, [1]=1, [2]=1, [3]=1} },
	["6"] = { type = SCIFI_SCK_TYPE_MODEL, model = "models/hunter/plates/plate1x1.mdl", bone = "v_weapon.Deagle_Slide", rel = "", pos = Vector( 0.06, -1.72, 1 ), angle = Angle( 0, -90, 0 ), size = Vector(0.06, 0.06, 0.001), color = Color(255, 255, 255, 255), surpresslightning = true, material = "models/weapons/vk21/holo", skin = 0, bodygroup = {} },
	-- ["0"] = { type = SCIFI_SCK_TYPE_QUAD, bone = "v_weapon.Deagle_Slide", pos = Vector( 0.052, -1.675, 1 ), angle = Angle( 0, 90, 0 ), size = 0.004, draw_func = fnSight },
	-- ["1"] = { type = SCIFI_SCK_TYPE_QUAD, bone = "v_weapon.Deagle_Parent", pos = Vector( 0.052, -5.675, -12 ), angle = Angle( 0, 90, 0 ), size = 0.004, draw_func = fnSight },
	-- ["3"] = { type = SCIFI_SCK_TYPE_QUAD, bone = "v_weapon.Deagle_Parent", pos = Vector( 0.052, -5.675, -12 ), angle = Angle( 0, 0, 0 ), size = 0.004, draw_func = fnSight }
	-- ["point"] = { type = SCIFI_SCK_TYPE_LASER, color = Color( 255, 10, 30 ), bone = "v_weapon.Deagle_Parent", pos = Vector( 0, -1.6, -8 ), angle = Angle( -90, 0, 0 ), range = 8192, line_size = 0.8, haze_size = 0.1, dot_size = 1 }
}

SWEP.WElements = {
	["5"] = { type = SCIFI_SCK_TYPE_MODEL, model = "models/weapons/v_w_vk21.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.5, 1.4, -2.12), angle = Angle(-3, -4.5, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, submat = {}, skin = 0, bodygroup = {[0]=1, [1]=1, [2]=1, [3]=1} },
	-- ["point"] = { type = SCIFI_SCK_TYPE_LASER, color = Color( 255, 10, 30 ), bone = "ValveBiped.Bip01_R_Hand", pos = Vector( 7.5, 1.75, -2.5 ), angle = Angle( -2, -4.5, 0 ), range = 8192, line_size = 0.8, haze_size = 0.1, dot_size = 1 }
}

local function ToggleSilenced( bState, entTarget )
	if !( entTarget.GetSilenced ) then return end
	
	local self = entTarget

	if ( bState ) then
		self.VElements["5"].bodygroup[2]=0
		self.WElements["5"].bodygroup[2]=0
		self.IhlBodyGroups[2]=0
		
		self.VfxMuzzleParticle = "umbra_muzzle_embers" 
		self.VfxMuzzleRule = 0
	else
		self.VElements["5"].bodygroup[2]=1
		self.WElements["5"].bodygroup[2]=1
		self.IhlBodyGroups[2]=1

		self.VfxMuzzleParticle = "umbra_muzzle"
		self.VfxMuzzleRule = 3
	end
end

function SWEP:SubInit()

end

local dSilent
local bSilent

function SWEP:Think()

	bSilent = self:GetSilenced()

	if ( ( game.SinglePlayer() || ( !game.SinglePlayer() && CLIENT ) ) && self:GetSciFiState() == SCIFI_STATE_ADS && self:Clip1() > 2 ) then
		local fNextPrimaryFire = self:GetNextPrimaryFire() - CurTime()
		
		if ( fNextPrimaryFire > 0 ) then
			local fAnimationScale = math.Clamp( fNextPrimaryFire / 0.325, 0, 1 )
			
			self.AdsPos.z = 1.5 - 1 * fAnimationScale
			self.AdsPos.x = -2.45 + 1 * fAnimationScale
			self.AdsAng.roll = 4 * fAnimationScale
			self.AdsAng.pitch = -6 * fAnimationScale

			local aPunch = self.Owner:GetViewPunchAngles()
			self.Owner:SetViewPunchAngles( aPunch * ( 0.8 + fAnimationScale * 0.2 ) )
		else 
			self.AdsPos.z = 1.5
			self.AdsPos.x = -2.45
			self.AdsAng.roll = 0
			self.AdsAng.pitch = 0
		end
	end
	
	if ( CLIENT ) then
		if ( !game.SinglePlayer() ) then
			if !( bSilent == dSilent ) then
				if ( bSilent ) then
					self.VfxMuzzleParticle = "umbra_muzzle_embers" 
					self.VfxMuzzleRule = 0
				else
					self.VfxMuzzleParticle = "umbra_muzzle"
					self.VfxMuzzleRule = 3
				end
			end
		
			dSilent = bSilent
		end
	
		-- if ( self:GetSciFiState() == SCIFI_STATE_ADS ) then
			-- local vBonePos, aBoneAng = self:GetBonePosition(0)
			-- local tr = self.Owner:GetEyeTrace()
			-- local n = tr.HitPos - vBonePos
			-- n = n:GetNormalized()*32768*tr.Fraction
			-- self.WElements["point"].angle = n:Angle()+Angle( -2, -4.5, 0 )
			
			-- debugoverlay.Line( vBonePos, vBonePos + n:GetNormalized()*32768*tr.Fraction, FrameTime(), Color( 255, 10, 30 ), false )
		-- else
			-- self.WElements["point"].angle = Angle( -2, -4.5, 0 )
		-- end
	end

	self:Ads()
	self:Anims()
	self:SciFiMath()
	self:SciFiMelee()
	
end

local m_holosight = Material( "models/weapons/vk21/holo" )
local m_debug = Material( "dev/rtscreen" )
local SizeX, SizeY = 512, 512
local rtScreen
local nBoneID

function SWEP:AddAcc()

	if !( CLIENT  ) then return end

	if ( !rtScreen ) then
		rtScreen = GetRenderTarget( "_rt_holosight", SizeX, SizeY, false )
	end

	render.PushRenderTarget( rtScreen, 0, 0, SizeX, SizeY  )
	render.Clear( 0, 0, 0, 0 )
	render.OverrideAlphaWriteEnable( true, true )

	cam.Start2D()
	
	fnSight( self, Vector( 0, 0, 0 ), Angle( 0, 0, 0 ), 1 )
	
	cam.End2D()
	
	render.OverrideAlphaWriteEnable( false, false )
	render.PopRenderTarget()

	m_holosight:SetTexture( "$basetexture", rtScreen )
	m_holosight:SetTexture( "$emissiveBlendBaseTexture", rtScreen )
	m_holosight:SetTexture( "$selfillummask", rtScreen )
	-- m_debug:SetTexture( "$basetexture", rtScreen )
	-- render.SetMaterial( m_debug )
	-- render.DrawScreenQuadEx( 64, 64, 64 + SizeX, 64 + SizeY )

end

-- function SWEP:AddWAcc()
	-- if ( !nBoneID ) then
		-- nBoneID = self:LookupBone( "ValveBiped.Bip01_R_Hand" )
	-- end
	
	-- local vBonePos, aBoneRot = self:GetBonePosition( nBoneID )
	
	-- local vOffset = Vector( 8, 1.5, -2.5 )
	-- local aOffset = Angle( 0, 0, 0 )
	
	-- vBonePos = vBonePos + aBoneRot:Forward() * vOffset.x + aBoneRot:Right() * vOffset.y + aBoneRot:Up() * vOffset.z
	
	-- render.SetMaterial( self.mat_laser_haze )
	
	-- render.DrawBeam( vBonePos, vBonePos + aBoneRot:Forward() * 16, 0.1, 0, 1, color_white )

	-- local trEyes = self.Owner:GetEyeTrace()
	
	-- local vNormal = ( trEyes.HitPos - vBonePos ):GetNormalized()
	
	-- render.DrawBeam( trEyes.HitPos, trEyes.HitPos - vNormal * 16, 0.1, 0, 1, color_white )
	
	-- self.Owner:ManipulateBoneAngles( nBoneID, , false )
	
	-- local aBoneOffset = vNormal:Angle()
	-- aBoneOffset:RotateAroundAxis( aBoneOffset:Up(), -90 )
	
	-- self.Owner:ManipulateBoneAngles( 25, aBoneOffset, false )
-- end

function SWEP:OnAds( adsBool )

	if ( adsBool ) then
		self:SetHoldType( "revolver" )
	else
		self:SetHoldType( self.HoldType )
	end

end

local snd_lowammo = Sound( "/weapons/fang/fang_lowammo.wav" )

function SWEP:FireAnimationEvent( pos, ang, event, options )
	
	if ( self.Owner:IsNPC() ) then return end

	local vm = self:GetViewModelEnt() 
	if ( IsValid( vm ) ) then 
		vm:SetPlaybackRate( 1.5 )
	
		if ( !self.Owner:ShouldDrawLocalPlayer() && event == 20 ) then 
			local pOwnerEA = self.Owner:EyeAngles()
			local vmAttach = vm:GetAttachment( "2" )
			local fxOrigin = self:GetProjectileSpawnPos() + pOwnerEA:Forward() * 24
			
			local pOwnerEA = self.Owner:EyeAngles()
			local vmAttach = vm:LookupAttachment( "2" )
			local fxOrigin = self:GetProjectileSpawnPos() + pOwnerEA:Forward() * 24
			
			local effectdata = EffectData()
			effectdata:SetEntity( vm )
			effectdata:SetOrigin( fxOrigin )
			effectdata:SetAttachment( 2 )
			effectdata:SetAngles( pOwnerEA + Angle( -30, -90, 0 ) )
			
			util.Effect( "ShellEject", effectdata )
			
			return true
		end
	end

	if ( CLIENT ) then
		local ammo = self:Clip1()
		local threshold = self.Primary.ClipSize * 0.45
		
		if ( ammo < threshold ) then
			local offset = threshold - ammo
			offset = offset * 2
				
			local iPitchMin, iPitchMax = 95, 105
			iPitchMin, iPitchMax = iPitchMin + offset, iPitchMax + offset

			local pitch = math.random( iPitchMin, iPitchMax )
			local vol = 0.6 + 0.4 * ( offset * 0.1 )
-- print( offset, vol ) 
			self:EmitSound( snd_lowammo, 60 + offset, pitch, vol, CHAN_STATIC )
		end
	end

	if( event == 5001 || event == 5011 || event == 20 ) then
		return true
	end

end

local m_exp, m_clamp = math.exp, math.Clamp
local function GetDamageFalloff( base, exponent, n )

	if ( !n ) then 	
		n = 1
	end

--	local fFallOff = m_exp( -0.69 / exponent ) * n
	local fFallOff = n * ( base ^ exponent )

	fFallOff = m_clamp( fFallOff, 0.001, 1 )
	
	return fFallOff
	
end

function SWEP:PrimaryAttack()

	if ( self.Owner:IsPlayer() ) && ( self.Owner:KeyDown( IN_USE ) && self:GetNextPrimaryFire() < CurTime() ) then
		local bState
		
		if ( self:GetSilenced() ) then 
			bState = false
		
			if ( !game.SinglePlayer() && CLIENT ) || ( game.SinglePlayer() && SERVER ) then
				self:EmitSound( "scifi.fang.silence.off" )
			end
		else
			bState = true
			
			if ( !game.SinglePlayer() && CLIENT ) || ( game.SinglePlayer() && SERVER ) then
				self:EmitSound( "scifi.fang.silence.on" )
			end
		end
		
		if ( SERVER ) then
			net.Start( "SciFiNetWeaponAttachments" )
			net.WriteEntity( self )
			net.WriteBool( bState )
			net.Broadcast()
			
			ToggleSilenced( bState, self )
		end
		
		self:SetSilenced( bState )

		self:SetNextPrimaryFire( CurTime() + 0.2 )
	
		return
	end
	
	if ( !self:CanPrimaryAttack( 0, true ) ) then return end
	
	local pOwnerAV = self.Owner:GetAimVector()
	
	if ( self.FeelGoodEnabled ) then
		pOwnerAV = self:GetFeelGoodVector( pOwnerAV )
	end
	
	self:SetNextPrimaryFire( CurTime() + self.SciFiWorldStats.Primary.FireRate[1].RateDelay )

	local ptru = {}
	ptru.Num = 1
	ptru.Spread = Vector( 0, 0 )
	ptru.Tracer = 0
	--ptru.TracerName = "ca3_tracer_noattach"
	ptru.HullSize = 1
	ptru.Distance = 256
	-- ptru.AmmoType = "pistol"

	local bullet = {}
	bullet.Num = 1
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = pOwnerAV + Vector( 0, 0, self:GetSciFiACC() * 0.0025 )
	bullet.Spread = Vector( .018, .018 ) * ( self:GetSciFiACC() * 0.2 )
	bullet.Tracer = 0
	-- bullet.TracerName = "darksamus_beam"
	bullet.Force = 1
	bullet.HullSize = 0
	bullet.Damage = self.SciFiWorldStats.Primary.DamageAmount * GetConVar( "sfw_damageamp" ):GetFloat()
	-- bullet.AmmoType = "pistol"
	bullet.Callback = function( attacker, tr, dmginfo )
		dmginfo:SetDamageType( DMG_BULLET )
			
		if ( tr.HitGroup ) && ( tr.HitGroup == HITGROUP_HEAD ) then
			dmginfo:ScaleDamage( self.SciFiWorldStats.Primary.CritMul * 0.5 )
		end
		
		local fScale = 1

		if ( SERVER ) && ( self:GetSilenced() ) then
			fScale = GetDamageFalloff( ( 1 - tr.Fraction ), 12, 1 )

			if ( tr.Entity:IsNPC() ) && ( tr.Entity:GetNPCState() == NPC_STATE_IDLE ) then
				fScale = fScale * 3
			end
			
			dmginfo:ScaleDamage( fScale )
		end
		
		-- if ( !tr.Entity:IsWorld() ) then
			-- DoElementalEffect( {
				-- Element = EML_DISSOLVE_SCAR,
				-- Target = tr.Entity,
				-- Attacker = self.Owner,
				-- Inflictor = self,
				-- Range = 4,
				-- Ticks = 1,
				-- DslvMaxMass=500,
				-- Origin = tr.HitPos
			-- } )
		-- end
	
		if !( tr.Entity:IsNPC() || tr.Entity:IsPlayer() ) then
			if ( tr.MatType == MAT_GLASS ) || ( tr.MatType == MAT_WOOD ) then
				ptru.Src = tr.HitPos + tr.Normal * 8
				ptru.Dir = tr.Normal + tr.Normal
				ptru.Damage = bullet.Damage * fScale

				self.Owner:FireBullets( ptru, false )
				ParticleEffect( "umbra_ptru", ptru.Src, ptru.Dir:Angle() )
			end

			if ( ( tr.MatType == MAT_METAL ) || ( tr.MatType == MAT_CONCRETE ) ) then
				local bouncer = ( tr.Normal - tr.HitNormal )
				bouncer = bouncer:Length()
				
				if ( ( bouncer < 1.8 ) ) then
					ptru.Src = tr.HitPos - tr.Normal -- * 16
					ptru.Dir = tr.Normal - 2 * tr.Normal:Dot( tr.HitNormal ) * tr.HitNormal
					
					debugoverlay.Line( ptru.Src, ptru.Src - tr.Normal * 16, 4, color_white, true )
					debugoverlay.Line( ptru.Src, ptru.Src + ptru.Dir * 16, 4, color_white, true )

					self.Owner:FireBullets( ptru, false )
					ParticleEffect( "umbra_ptru", ptru.Src, ptru.Dir:Angle() )
				end
			end
		end
	end
	
	self.Owner:FireBullets( bullet, false )

	-- local entCreator=self:GetOwner()
	
	-- local vOrigin
	-- if(self:GetSciFiState()==SCIFI_STATE_ADS)then
		-- vOrigin=entCreator:GetShootPos()
	-- else
		-- vOrigin=self:GetProjectileSpawnPos()
	-- end

	-- local fw, rt, up = entCreator:GetForward(), entCreator:GetRight(), entCreator:GetUp()
	-- local vSpray = ( rt * math.random( -10, 10 ) + up * math.random( -10, 10 ) ) * 0.001
	
	-- local vDirection = bullet.Dir + vSpray
	-- local aDirection = vDirection:Angle()
	
	-- local x=ents.Create("proj_alyxshot")
	-- x:SetPos(vOrigin)
	-- x:SetAngles(entCreator:EyeAngles())
	-- x:SetOwner(entCreator)
	-- x.PhxMaxVelocity=7200
	-- x.DieTime=CurTime()+0.1
	-- x:Spawn()
	-- x:SetBaseDamage( 10 )
	-- x:SetHBoxMulHead( 2.5 )
	-- x:SetHBoxMulBody( 1.25 )
	-- x.MeteorEnabled=false
		
	-- local phxBullet = x:GetPhysicsObject()
	-- phxBullet:ApplyForceCenter( vDirection * 12000 )
	
	if ( self.Owner:IsPlayer() ) then
		self.Owner:ViewPunch( Angle( math.random( -2.8, -3 ), math.random( 0, 0.1 ), math.random( 0, 0.1 ) ) * ( 0.3 + self:GetSciFiACC() * 0.1 ) )
		self:AddSciFiACC( self.SciFiWorldStats.Recoil )
	end

	self:DoMuzzleEffect()

	if ( self:GetSilenced() ) then
		self:EmitSound( "scifi.talon2.fire.silent" )
	else
		self:EmitSound( "scifi.talon2.fire.default" )
		
		if ( self.Owner:WaterLevel() < 2 ) then
			-- self:EmitSound( "scifi.fang.fire.echo" )
			self:EmitSound( "scifi.talon2.fire.echo" )
		end
	end

	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

	self:TakePrimaryAmmo( 1 )

end

function SWEP:SecondaryAttack()

end

function SWEP:OnReload()

	self:SetHoldType( self.HoldType )
	
end

function SWEP:OnReloadFinish()
	
	if ( CLIENT ) then
		self:EmitSound( "scifi.asa6.reload.bback" )
	end 
	
	self:SendWeaponAnim( ACT_VM_IDLE )

end

function SWEP:DoImpactEffect( tr, nDamageType )

	if ( tr.HitSky ) then return end

	ParticleEffect( "umbra_hit", tr.HitPos, tr.Normal:Angle(), self )

	if ( CLIENT ) then
		local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
			dlight.pos = tr.HitPos
			dlight.r = 255
			dlight.g = 20
			dlight.b = 10
			dlight.brightness = 0.6
			dlight.Decay = 2048
			dlight.Size = 32
			dlight.DieTime = CurTime() + 0.5
		end
	end

end