AddCSLuaFile()
AddCSLuaFile( "base/scifi_base.lua" )
include( "base/scifi_base.lua" )

SWEP.Spawnable = GetConVar( "sfw_showhiddenweapons" ):GetBool()

SWEP.PrintName				= "Ravager"
SWEP.Slot					= 2
SWEP.SlotPos				= 2
SWEP.ItemRank 				= 16

SWEP.ViewModel 				= "models/weapons/cstrike/c_smg_ump45.mdl"
SWEP.WorldModel				= "models/weapons/w_smg_ump45.mdl"
SWEP.HoldType 				= "smg"
SWEP.HoldTypeNPC 			= "smg"

-- SWEP.SciFiSkin				= "vgui/white"
-- SWEP.SciFiWorld 			= "vgui/white"
SWEP.ViewModelFOV 			= 54

SWEP.DeploySpeed 			= 2

SWEP.Primary.ClipSize		= 28
SWEP.Primary.DefaultClip	= 28
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize 	= 50
SWEP.Secondary.DefaultClip 	= 50
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "InferiantCharge"

SWEP.VfxMuzzleParticle 		= "corruptor_muzzle"
SWEP.VfxMuzzleColor 		= Color( 230, 60, 40, 255 )
SWEP.VfxMuzzleBrightness 	= 1
SWEP.VfxMuzzleFOV 			= 160
SWEP.VfxMuzzleFarZ 			= 720
SWEP.VfxMuzzleAttachment 	= "1"
SWEP.VfxHeatParticle 		= "gunsmoke"

SWEP.ReloadTime 			= 1
SWEP.ReloadPlaybackRate 	= 2
SWEP.ReloadRealisticClips 	= false
SWEP.ReloadLegacy 			= false
SWEP.ReloadSND 				= ""
SWEP.DepletedSND			= "Weapon_AR2.Empty"
SWEP.ReloadModels 			= true
SWEP.ReloadGib 				= "models/weapons/v_w_vk21_mag.mdl"
SWEP.ReloadGibParentBone	= "ValveBiped.Bip01_R_Hand"
SWEP.ReloadGibOrigin		= Vector( -6, -1, 8 )
SWEP.ReloadGibDelay 		= 0.5

SWEP.AdsPos 				= Vector (-8.85, 4, 2 )
SWEP.AdsFov					= 38
SWEP.AdsTransitionSpeed		= 36

SWEP.AdsSounds 				= true
SWEP.AdsSoundEnable 		= "scifi.fang.zoomin"
SWEP.AdsSoundDisable		= "scifi.fang.zoomout"

SWEP.DefaultSwayScale		= 2.6
SWEP.DefaultBobScale		= 3

-- SWEP.ViewModelSprintPos 	= Vector( 5, 1.5, 0 )
-- SWEP.ViewModelSprintAng		= Angle( -12.5, 25, -15 )
-- SWEP.ViewModelSwayDirection = Vector( -1, 8, 2 )
-- SWEP.ViewModelSwayStrength 	= Vector( 0.5, 0.15 )

SWEP.ViewModelSprintPos 	= Vector( 5, 2, -2 )
SWEP.ViewModelSprintAng		= Angle( -4, 30, -30 )
SWEP.ViewModelSwayDirection = Vector( -1.75, 7, 3 )
SWEP.ViewModelSwayStrength 	= Vector( 0.5, 0.175 )

SWEP.ViewModelSprintRatio 	= 1
SWEP.ViewModelSprintSway 	= 4
SWEP.SprintAnimSpeed		= 10
SWEP.SprintSwayScale		= 0.4
SWEP.SprintBobScale			= 0.0

SWEP.ViewModelHomePos		= Vector( 0, 1, 0 )
SWEP.ViewModelDuckPos		= Vector( -3, -3, -1 )
SWEP.ViewModelDuckAng		= Angle( 0, 0, -20 )
SWEP.ViewModelMeleePos		= Vector( 16, 4, -7 )
SWEP.ViewModelMeleeAng		= Angle( 30, 70, -20 )
SWEP.ViewModelReloadAnim 	= true
SWEP.ViewModelReloadPos		= Vector( -1, -2, 6 )
-- SWEP.ViewModelReloadAng		= Angle( 40, -12, 14 )
SWEP.ViewModelReloadAng 	= Angle( -20, -5, 5 )
SWEP.ViewModelShift 		= true
SWEP.ViewModelShiftCounter 	= 0.05
SWEP.ViewModelShiftOffset 	= Vector( -0.01, -0.02, -0.1 )
SWEP.ViewModelShiftRotation = Vector( 0.2, 0.6, 1 )
SWEP.ViewModelSafeAnim	 	= true
SWEP.ViewModelSafePos 		= Vector( 2, 0, 0 )
SWEP.ViewModelSafeAng 		= Angle( 0, 30, -40 )

SWEP.CanLeechFromDark = true

local nDamageBase = 8
local nFireRateDelay = 0.06

SWEP.SciFiWorldStats		= {
	Primary = {
		DamageAmount = nDamageBase,
		DamageComposition = nil,
		DamageBlastRadius = nil,
		DamageAttackRange = nil,
		DamageType = { DMG_BULLET, DMG_SF_DARK },
		CritMul = 1.5,
		StatusChance = nil,
		FireRate = { 
			{ RateTitle = "full-auto", RateDelay = nFireRateDelay }
		},
		ChargeRate = nil
	},
	CoreRechargeRate = nil,
	ClipSize = 28,
	ReloadSpeed = 1.8,
	Recoil = 3
}

SWEP.NPCAccuracy 			= 800
SWEP.NPCSkillLevel 			= 1
SWEP.NPCBulletSpread 		= 1
SWEP.NPCRestMin 			= 0.3
SWEP.NPCRestMax 			= 0.6
SWEP.NPCBurstMin 			= 1
SWEP.NPCBurstMax 			= 1
SWEP.NPCBurstDelay 			= 0.4

SWEP.Wrath = false

SWEP.LastTargetEnabled = true
SWEP.LastTargetName = nil
SWEP.LastTargetTime = 0
SWEP.LastTargetBuff = 1
SWEP.LastTargetInterval = 2

SWEP.FeelGoodEnabled = true
SWEP.FeelGoodRatio = 0.2

function SWEP:GetNPCRestTimes()
	return 0.01, 0.01
end

function SWEP:GetNPCBurstSettings()
	return 3, 3, 0.3
end

if ( CLIENT ) then
	surface.CreateFont( "vk21AmmoCounterFG", {
		font 		= "HalfLife2",
		extended 	= false,
		size 		= 63,
		weight 		= 0,
		blursize 	= 0,
		scanlines 	= 8,
		antialias 	= true,
		underline 	= false,
		italic 		= false,
		strikeout 	= false,
		symbol 		= false,
		rotary 		= false,
		shadow 		= false,
		additive 	= true,
		outline 	= true,
	} )

	surface.CreateFont( "vk21AmmoCounterBG", {
		font 		= "HalfLife2",
		extended 	= false,
		size 		= 63,
		weight 		= 500,
		blursize 	= 24,
		scanlines 	= 8,
		antialias 	= true,
		underline 	= false,
		italic 		= false,
		strikeout 	= false,
		symbol 		= false,
		rotary 		= false,
		shadow 		= false,
		additive 	= true,
		outline 	= false,
	} )
end

local c_hud_bg = Color( 255, 50, 50, 0 )
local c_hud_fg = Color( 255, 70, 60, 0 )
local c_hud_ammo = Color( 255, 70, 60, 255 )

local m_pi 	= math.pi
local m_abs = math.abs
local m_rad = math.rad
local m_sin = math.sin
local m_cos = math.cos

local fAdsScale = 0
local iClipTime = 0
local iClipDelta = 0

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
	
	draw.NoTexture()
	for k,v in pairs( arc ) do
		surface.DrawPoly( v )
	end
end

local iRadSmall, iRadMedium, iRadLarge = 96, 128, 192 -- 24, 32, 48
local iWidth = 4

local fnSight = function( entWeapon, vOrigin, aRotation, fScale )

	if ( !IsValid( entWeapon ) ) then return end

	iState = entWeapon:GetSciFiState()
	
	bAds = ( iState == SCIFI_STATE_ADS )
	
	if ( fAdsScale > 0 ) then
		local x, y = 256, 256
		
		c_hud_fg.a = 255 * fAdsScale
		
		surface.SetDrawColor( c_hud_fg )
		draw.NoTexture()
		
		local aPunch = entWeapon:GetOwner():GetViewPunchAngles()
		local iPunchPower = math.abs( aPunch.pitch + aPunch.yaw + aPunch.roll ) * 8
		
		surface.DrawCircle( x, y, 2 + iPunchPower, c_hud_fg.r, c_hud_fg.g, c_hud_fg.b, c_hud_fg.a )
		
		fnArc( x, y, iRadLarge - iRadMedium * fAdsScale + iPunchPower, iWidth * fAdsScale, 90 - 45 * fAdsScale + iPunchPower, 90 + 45 * fAdsScale - iPunchPower, 3 )
		fnArc( x, y, iRadLarge - iRadMedium * fAdsScale + iPunchPower, iWidth * fAdsScale, 270 - 45 * fAdsScale + iPunchPower, 270 + 45 * fAdsScale - iPunchPower, 3 )
		
		if ( entWeapon.LastTargetEnabled ) then
			local fPerkTime = entWeapon:GetPerkTime()
			if ( fPerkTime > CurTime() ) then
				local fDamageBuff = math.Round( entWeapon:GetPerkDamage(), 2 )
				-- draw.SimpleText( fDamageBuff, "vk21AmmoCounterFG", 0, iRadMedium, c_hud_fg, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				-- draw.SimpleText( fDamageBuff, "vk21AmmoCounterBG", 0, iRadMedium, c_hud_fg, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

				local fPerkDecayScale = ( fPerkTime - CurTime() ) / 1
				fnArc( x, y, 48, ( iWidth * 0.5 ) * fAdsScale, 0, 360 * fPerkDecayScale, 3 )
			end
		end

		local iClip = entWeapon:Clip1()
		
		if ( iClipDelta > iClip ) then
			iClipTime = CurTime() + 1
		end
		
		iClipDelta = iClip
		
		if ( iClipTime > CurTime() ) then
			local iClipScale = ( iClipTime - CurTime() ) / 1
			
			c_hud_bg.a = 200 * fAdsScale * iClipScale
			
			surface.SetDrawColor( c_hud_bg )
			fnArc( x, y, iRadSmall - 4 * iClipScale, ( iWidth * 0.5 ) * fAdsScale, 90 + 180 * ( 1 - iClipDelta / entWeapon.Primary.ClipSize ), 270, 3 )
		end
		
		-- if ( iClip < 10 ) then
			-- iClip = "0"..iClip
		-- end
		
		-- draw.SimpleText( iClip, "vk21AmmoCounterFG", x-30, y+iRadLarge, c_hud_fg, 0, 0 )
		-- draw.SimpleText( iClip, "vk21AmmoCounterBG", x-30, y+iRadLarge, c_hud_fg, 0, 0 )
		
		-- local bMode = entWeapon:GetBurstMode()
		-- local sText = "auto"
		
		-- if ( bMode ) then
			-- sText = "burst"
		-- end
		
		-- draw.SimpleText( sText, "CloseCaption_Bold", x-22, y+iRadLarge + 90, c_hud_fg, 0, 0 )
	end
	
	if ( !bAds ) && ( fAdsScale > 0 ) then
		fAdsScale = math.Approach( fAdsScale, 0, FrameTime() * 4 )
		iClipTime = CurTime()
	end

	if ( bAds ) && ( fAdsScale < 1 ) then
		fAdsScale = math.Approach( fAdsScale, 1, FrameTime() * 6 )
	end

	-- debugoverlay.Cross( vOrigin, 4 * fAdsScale, FrameTime() * 2, c_hud_fg, true )
	
end

local fnAmmo = function( entWeapon, vOrigin, aRotation, fScale )

	if ( !IsValid( entWeapon ) ) then return end
		
		if ( entWeapon.LastTargetEnabled ) then
			local fPerkTime = entWeapon:GetPerkTime()
			if ( fPerkTime > CurTime() ) then
				local fDamageBuff = math.Round( entWeapon:GetPerkDamage(), 2 )
				draw.SimpleText( fDamageBuff, "vk21AmmoCounterFG", 0, iRadMedium, c_hud_fg, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				draw.SimpleText( fDamageBuff, "vk21AmmoCounterBG", 0, iRadMedium, c_hud_fg, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			end
		end
	
	-- if ( fAdsScale > 0 ) then
		local iClip = entWeapon:Clip1()
		
		if ( iClip < 10 ) then
			iClip = "0"..iClip
		end
		
		draw.SimpleText( iClip, "vk21AmmoCounterFG", 0, iRadLarge, c_hud_ammo, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		draw.SimpleText( iClip, "vk21AmmoCounterBG", 0, iRadLarge, c_hud_ammo, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		
		local bMode = entWeapon:GetBurstMode()
		local sText = "auto"
		
		if ( bMode ) then
			sText = "burst"
		end
		
		draw.SimpleText( sText, "CloseCaption_Bold", -22, iRadLarge + 90, c_hud_ammo, 0, 0 )
	-- end
	
end

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector( 1, 1, 1 ), pos = Vector( 3.5, -3, -1.1 ), angle = Angle( 0, -10, 2 ) },
	["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector( 1, 1, 1 ), pos = Vector( 0, 0.8, 1 ), angle = Angle( 0, 0, 0 ) },
	["v_weapon.famas"] = { scale = Vector( 1, 1, 1 ), pos = Vector( 0.95, 1, 0.8 ), angle = Angle( 0, 0, 0 ) }
}

SWEP.VElements = {
	["5"] = { type = SCIFI_SCK_TYPE_MODEL, model = "models/weapons/v_w_vk21.mdl", bone = "v_weapon.famas", rel = "", pos = Vector(0.05,0.6, 16), angle = Angle(90, 0, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, submat = { [0] = "", [1] = "", [2] = "", [3] = "" }, skin = 0, bodygroup = {[1]=0, [2]=1, [3]=1} },
	["6"] = { type = SCIFI_SCK_TYPE_MODEL, model = "models/weapons/v_w_vk21_mag.mdl", bone = "v_weapon.magazine", rel = "", pos = Vector(0, -0.7, -0.25), angle = Angle(100,- 90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, submat = {}, skin = 0, bodygroup = {} },
	["7"] = { type = SCIFI_SCK_TYPE_MODEL, model = "models/props_combine/combine_lock01.mdl", bone = "v_weapon.bolt", rel = "", pos = Vector(-0.3, 0.4, -0.75), angle = Angle(180, 0, 0), size = Vector(0.08, 0.1, 0.1), color = Color(120, 120, 120, 255), surpresslightning = false, submat = { [0] = "models/weapons/hwave/bbolt" }, skin = 0, bodygroup = {} },
	-- ["8"] = { type = SCIFI_SCK_TYPE_QUAD, bone = "v_weapon.famas", pos = Vector( 0.065, -4.535, 12 ), angle = Angle( 0, 0, 0 ), size = 0.002, draw_func = fnSight }
	["0"] = { type = SCIFI_SCK_TYPE_MODEL, model = "models/hunter/plates/plate1x1.mdl", bone = "v_weapon.famas", rel = "", pos = Vector( 0.065, -4.535, 14 ), angle = Angle( 0, -90, 0 ), size = Vector(0.0275, 0.0275, 0.001), color = Color(255, 255, 255, 255), surpresslightning = false, submat = { [0] = "models/weapons/vk21/holo" }, skin = 0, bodygroup = {} },
	["8"] = { type = SCIFI_SCK_TYPE_QUAD, bone = "v_weapon.famas", pos = Vector( 0.065, -4.535, 12 ), angle = Angle( 0, 0, 0 ), size = 0.002, draw_func = fnAmmo }
}

SWEP.WElements = {
	["5"] = { type = SCIFI_SCK_TYPE_MODEL, model = "models/weapons/v_w_vk21.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7, 0.8, -3), angle = Angle(-10, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, submat = {}, skin = 0, bodygroup = {[1]=0, [2]=1, [3]=0} },
	-- ["0"] = { type = SCIFI_SCK_TYPE_MODEL, model = "models/hunter/plates/plate1x1.mdl", bone = "v_weapon.famas", rel = "5", pos = Vector( -3, 0.1, 5.1 ), angle = Angle( 90, 0, 0 ), size = Vector(0.03, 0.03, 0.001), color = Color(255, 255, 255, 255), surpresslightning = false, submat = { [0] = "models/weapons/vk21/holo" }, skin = 0, bodygroup = {} }
}

local snd_fire = Sound( "/weapons/asa/hybridammo_fire2.wav" )
-- local snd_fire = Sound( "/weapons/ancient/astra_fire_normal.wav" )
local snd_lowammo = Sound( "/weapons/fang/fang_lowammo.wav" )

SWEP.DataTables = {
	{ dType = "Bool", dName = "IsReloading" },
	{ dType = "Bool", dName = "CanBurst" },
	{ dType = "Bool", dName = "BurstMode" },
	{ dType = "Bool", dName = "Silenced" },
	{ dType = "Int", dName = "BurstCount" },
	{ dType = "Int", dName = "PerkInterval" },
	{ dType = "Float", dName = "PerkTime" },
	{ dType = "Float", dName = "PerkDamage" }
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

if ( SERVER ) then
	util.AddNetworkString( "SciFiNetWeaponAttachments" )
end

net.Receive( "SciFiNetWeaponAttachments", function( nLength, pReceiver )
	local entTarget = net.ReadEntity()

	if ( !IsValid( entTarget ) ) then return end
		
	local bState = net.ReadBool()
	
	ToggleSilenced( bState, entTarget )
end )

function SWEP:SubInit()
	self:SetBurstMode( false )
	self:SetPerkDamage( 1 )
	self:SetPerkTime( 0 )
	self:SetPerkInterval( 0 )
	
	if ( !self.SequenceDurationLegacy ) then
		self.SequenceDurationLegacy = self.SequenceDuration
		
		self.SequenceDuration = function()
			
			local fDuration = self:SequenceDurationLegacy()
			local fPlaybackRate = self:GetPlaybackRate()
			
			return fDuration * math.max( 2 - fPlaybackRate, 0 ) --  * ( 1 / fPlaybackRate )
		end
	end
	
	if ( CLIENT ) then
		self:DrawShadow( false )
		self:DestroyShadow()
	end
end

local m_holosight = Material( "models/weapons/vk21/holo" )
local SizeX, SizeY = 512, 512
local rtScreen

-- function SWEP:AddAcc()
	-- if !( CLIENT  ) then return end

	-- if ( !rtScreen ) then
		-- rtScreen = GetRenderTarget( "_rt_holosight", SizeX, SizeY, false )
	-- end

	-- render.PushRenderTarget( rtScreen, 0, 0, SizeX, SizeY  )
	-- render.Clear( 0, 0, 0, 0 )
	-- render.OverrideAlphaWriteEnable( true, true )

	-- cam.Start2D()
	
	-- fnSight( self, Vector( 0, 0, 0 ), Angle( 0, 0, 0 ), 1 )
	
	-- cam.End2D()
	
	-- render.OverrideAlphaWriteEnable( false, false )
	-- render.PopRenderTarget()
	
	-- if !( fAdsScale > 0 ) then return end

	-- m_holosight:SetTexture( "$basetexture", rtScreen )
	-- m_holosight:SetTexture( "$emissiveBlendBaseTexture", rtScreen )
	-- m_holosight:SetTexture( "$selfillummask", rtScreen )
-- end

local dSilent
local bSilent
local bBurst
local dReloading
local dClip1 = 0

function SWEP:Think()

	bSilent = self:GetSilenced()
	bBurst = self:GetBurstMode()
	
	if ( CLIENT ) then
		local bReloading = self:GetSciFiState() == SCIFI_STATE_RELOADING
		local fNextPFire = self:GetNextPrimaryFire() - CurTime()
		
		-- top-axis offset to fix the CS:S famas' shitty firing animation --
		-- if ( self:GetSciFiState() == SCIFI_STATE_ADS ) && ( !bReloading && fNextPFire > FrameTime() * -1.2 * self.ChargeDeltaFactor && self:Clip1() > 0 ) then
			-- local vmEntity = self.Owner:GetViewModel()
			
			-- if ( IsValid( vmEntity ) ) then
				-- if ( !game.SinglePlayer() ) then
					-- vmEntity:SetPlaybackRate( 2 )
				-- end
				
				-- local seq = vmEntity:GetSequence()

				-- if ( seq < 4 ) then
					-- self.AdsPos.z = 0.7
				-- elseif ( seq == 4 ) then
					-- self.AdsPos.z = 0.7
				-- elseif ( seq > 4 ) then
					-- self.AdsPos.z = 0.85
				-- end
			-- end
		-- else
			-- self.AdsPos.z = 0.315
		-- end
		
		-- if ( bReloading ) && ( !dReloading ) then
			-- self.ViewModelBoneMods["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector( 1, 1, 1 ), pos = Vector( 0, 0, 0 ), angle = Angle( 0, 0, 0 ) }
			-- self.ViewModelBoneMods["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector( 1, 1, 1 ), pos = Vector( 0, 0, 0 ), angle = Angle( 0, 0, 0 ) }
			-- self.ViewModelBoneMods["ValveBiped.Bip01_L_Hand"] = { scale = Vector( 1, 1, 1 ), pos = Vector( 0, 0, 0 ), angle = Angle( 0, 0, 0 ) }
			-- self.ViewModelBoneMods["v_weapon.famas"] = { scale = Vector( 1, 1, 1 ), pos = Vector( 0, 0, 0 ), angle = Angle( 0, 0, 0 ) }
			
			-- self.ViewModelReloadPos	= Vector( -8, -2, -10 )
			-- self.ViewModelReloadAng	= Angle( 45, -12, 14 )
		-- end
		
		-- if ( !bReloading ) && ( dReloading ) then
			-- self.ViewModelBoneMods["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector( 1, 1, 1 ), pos = Vector( 3.5, -3, -1.1 ), angle = Angle( 0, -10, 2 ) }
			-- self.ViewModelBoneMods["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector( 1, 1, 1 ), pos = Vector( 0, 0.8, 1 ), angle = Angle( 0, 0, 0 ) }
			-- self.ViewModelBoneMods["ValveBiped.Bip01_L_Hand"] = { scale = Vector( 1, 1, 1 ), pos = Vector( 0, 0, 0 ), angle = Angle( 0, 0, 0 ) }
			-- self.ViewModelBoneMods["v_weapon.famas"] = { scale = Vector( 1, 1, 1 ), pos = Vector( 0, 1, 0.8 ), angle = Angle( 0, 0, 0 ) }
		-- end
		
		-- if ( bReloading ) then
			-- local fReloadScale = math.Clamp( fNextPFire / self.ReloadTime, 0, 1 )

			-- if ( fReloadScale < 0.5 ) then
				-- fReloadScale = 1 - ( fReloadScale * 2 )
				-- local fReloadScaleAdaptive = math.sin( fReloadScale * 2.5 )
				
				-- self.ViewModelReloadAng.pitch = 45 + 10 * fReloadScale
				-- self.ViewModelReloadAng.yaw = -12 + 4 * fReloadScale
				-- self.ViewModelReloadAng.roll = 12 + 24 * fReloadScaleAdaptive
				-- self.ViewModelReloadPos.x = -8 - 1 * fReloadScale
				-- self.ViewModelReloadPos.z = -10 + 2 * fReloadScaleAdaptive
			-- end
		-- end
		
		dReloading = bReloading
	end

	if ( bBurst ) && ( SERVER || !game.SinglePlayer() ) then
		local fNextPFire = self:GetNextPrimaryFire()
		
		if ( self:CanBFire() ) && ( fNextPFire < CurTime() && fNextPFire > -1 ) then
			if ( self:GetBurstCount() < 3 && self:GetCanBurst() ) && ( fNextPFire > -1 ) then
				self:Attack()
				
				self:SetCanBurst( true )
				self:SetBurstCount( self:GetBurstCount() + 1 )

				self:SetNextPrimaryFire( CurTime() + 0.06 )
			end
			
			if ( self:GetBurstCount() > 2 ) then
				self:SetNextPrimaryFire( CurTime() + 0.15 )
				self:SetCanBurst( false )
				self:SetBurstCount( 0 )
			end
		end	
	end
		
	self:Ads()
	self:Anims()
	self:SciFiMath()
	self:SciFiMelee()
	
end

local tEventBlacklist = { 
	[ 20 ] = true, 
	[ 5001 ] = true, 
	[ 5003 ] = true 
}

function SWEP:FireAnimationEvent( pos, ang, event, options )

	local vm = self:GetViewModelEnt() 
	if ( IsValid( vm ) ) then 
		vm:SetPlaybackRate( 2 )
	end

	if ( CLIENT ) then
		local ammo = self:Clip1()
		local threshold = self.Primary.ClipSize * 0.3
		
		if ( ammo < threshold ) then
			local offset = threshold - ammo
			offset = offset
				
			local iPitchMin, iPitchMax = 83, 87
			iPitchMin, iPitchMax = iPitchMin + offset, iPitchMax + offset

			local pitch = math.random( iPitchMin, iPitchMax )
			local vol = 0.4 + 0.6 * ( offset * 0.08 )
-- print( offset, vol ) 
			self:EmitSound( snd_lowammo, 50 + offset, pitch, vol, CHAN_STATIC )
		end
	end

	if ( tEventBlacklist[ event ] ) then
		return true
	end

end

function SWEP:CanBFire()

	if ( self.Weapon:Clip1() <= 0 ) then
		self:SetBurstCount( 3 )
		return false
	end

	return true
	
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

function SWEP:Attack( pOwnerAV )
	
	if ( !pOwnerAV ) then
		pOwnerAV = self.Owner:GetAimVector()
	end
	
	if ( self.FeelGoodEnabled ) then
		pOwnerAV = self:GetFeelGoodVector( pOwnerAV )
	end
	
	local iDmg = nDamageBase * GetConVar( "sfw_damageamp" ):GetFloat()
	
	local bullet = {}
	bullet.Num = 1
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = pOwnerAV + Vector( 0, 0, self:GetSciFiACC() / 512 )
	bullet.Spread = Vector( .001, .002 ) + Vector( .001, .002 ) * ( self:GetSciFiACC() )
	bullet.Tracer = 1
	bullet.HullSize = 0 -- 0.05
	bullet.Damage = iDmg
	
	if ( self:GetPerkDamage() > 0 ) then
		bullet.TracerName = "corruptor_tracer_nooffset" -- "spr_tracer"
		bullet.Force = 1
		
		bullet.Callback = function( attacker, tr, dmginfo )
			dmginfo:SetDamageType( DMG_SF_DARK )
			dmginfo:SetInflictor( self )
			dmginfo:SetAttacker( self.Owner )
			
			if ( tr.HitGroup ) && ( tr.HitGroup == HITGROUP_HEAD ) then
				dmginfo:ScaleDamage( 0.75 )
			end
			
			local iStatus = math.random( 0, 100 )
			local iThreshold = 60

			if ( iStatus > iThreshold ) then
				local myeml = {}
				myeml.Element = EML_DARK
				myeml.Target = tr.Entity
				myeml.Attacker = attacker || self.Owner
				myeml.Inflictor = self
				myeml.Origin = tr.HitPos
				
				DoElementalEffect( myeml )
			end
		end
		
		self:SetPerkDamage( self:GetPerkDamage() - 1 )
	else 
		bullet.TracerName = "spr_tracer"
		bullet.Force = 1
		
		bullet.Callback = function( attacker, tr, dmginfo )
			dmginfo:SetDamageType( DMG_BULLET )
			dmginfo:SetInflictor( self )
			dmginfo:SetAttacker( self.Owner )
			
			if ( tr.HitGroup ) && ( tr.HitGroup == HITGROUP_HEAD ) then
				dmginfo:ScaleDamage( 0.75 )
			end
		end
	end

	self.Owner:FireBullets( bullet, false )
	
	if ( self.Owner:IsPlayer() ) then
		if ( game.SinglePlayer && SERVER ) || ( CLIENT && IsFirstTimePredicted() ) then
			self.Owner:ViewPunch( Angle( math.random( -30, -40 ), math.random( -5, 5 ), 0 ) * ( 0.002 + self:GetSciFiACC() * 0.001 ) )
		end
		
		if ( self:GetBurstMode() ) then
			self:AddSciFiACC( 3 - self:GetBurstCount() * 0.5 )
		else
			self:AddSciFiACC( 3 )
		end
	end

	self:DoMuzzleEffect()

	local ammo = self:Clip1()
	local iPitchMin, iPitchMax = 98, 102
	
	if ( ammo < 12 ) then
		local offset = 12 - ammo
		
		iPitchMin, iPitchMax = iPitchMin + offset, iPitchMax + offset
	end

	local pitch = math.random( iPitchMin, iPitchMax )

	self:EmitSound( snd_fire, 60, pitch, 1, CHAN_STATIC )
	
	if ( self.Owner:WaterLevel() < 2 ) then
		self:EmitSound( "scifi.fang.fire.echo" )
	end

	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self:TakePrimaryAmmo( 1 )
	
	local vm = self:GetViewModelEnt() 
	if ( IsValid( vm ) ) then 
		vm:SetPlaybackRate( 2 )
	end
	
end

function SWEP:PrimaryAttack()
	
	if ( self.Owner:IsNPC() ) then
		if ( self:GetNextPrimaryFire() > CurTime() ) then return end
		
		timer.Create( "fang_bfire_"..self:EntIndex(), nFireRateDelay, 3, function() 
			if ( !IsValid( self ) || !IsValid( self.Owner ) || !self:CanPrimaryAttack( 0, true ) ) then return end
			
			self:Attack()
		end )
		
		self:SetNextPrimaryFire( CurTime() + 0.6 )
		
		return
	end

	if ( self.Owner:KeyDown( IN_USE ) && self:GetNextPrimaryFire() < CurTime() && self:GetNextSecondaryFire() < CurTime() ) then
		-- self.Owner:GiveAmmo( self:Clip1(), self.Primary.Ammo )
		self:SetPerkDamage( 56 )
		self.Owner:RemoveAmmo( 56, self.Secondary.Ammo )
		-- self:SetClip1( 40 )

		self:SetNextPrimaryFire( CurTime() + 0.4 )
		self:SetNextSecondaryFire( CurTime() + 0.4 )
	
		return
	end

	if ( !self:CanPrimaryAttack( 0, true ) ) then return end
	
	if ( self:GetBurstMode() ) && ( self.Owner:IsPlayer() ) then
		if ( self:GetBurstCount() > 2 ) then return end
		
		self:SetCanBurst( true )
	else
		self:Attack()
	
		self:SetNextPrimaryFire( CurTime() + nFireRateDelay )
	end

end

function SWEP:SecondaryAttack()

	self:SetNextSecondaryFire( CurTime() + 0.4 )
	
	if ( self.Owner:KeyDown( IN_USE ) ) then
		if ( self:GetBurstMode() ) then 
			self:SetBurstMode( false )
		else
			self:SetBurstMode( true )
		end
		
		self:EmitSound( "Weapon_AR2.Empty" )
	end

end

function SWEP:OnReload()

	if ( self:Clip1() > 0 ) then
		self.ReloadTime = 1.2
		self.ReloadPlaybackRate = 1.6
	else
		self.ReloadTime = 1.8
		self.ReloadPlaybackRate = 1.6
	end
	
	if ( CLIENT ) then
		if ( self.Owner:ShouldDrawLocalPlayer() ) then
			self:EmitSound( "scifi.fang.reload.npc" )
		end
	end

end

function SWEP:OnReloadFinish()

	if ( CLIENT ) then
		self:EmitSound( "scifi.fang.reload.finish" )
	end
	
	self:SetSciFiACC( 0 )

	self:SendWeaponAnim( ACT_VM_IDLE )

	self:SetCanBurst( false )
	self:SetBurstCount( 0 )

end

function SWEP:OnSprint( bSprinting )
	
	if ( CLIENT ) then
		if ( bSprinting ) then
			self:EmitSound( "scifi.sprint.holster" )
		else
			self:EmitSound( "scifi.sprint.ready" )
		end
	end
	
end

function SWEP:SubDeploy() 

	self:SetAds( false )

	if ( game.SinglePlayer() && SERVER ) || ( !game.SinglePlayer() ) then
		self:SetSciFiState( SCIFI_STATE_IDLE )
		self:SetMeleeCharge( 0 )
		self:SetSciFiACC( 4 )
		
		self:EmitSound( "scifi.sprint.ready" )
	end
	
	self:ResetAnimationScale()
	
	return true
	
end

function SWEP:Holster( wep )

	if ( CLIENT ) && ( IsValid(self.Owner) ) && ( self.Owner:IsPlayer() ) then
		self:ResetBonePositions()
		self:ResetAnimationScale()
	end
	
	self:SetSciFiState( SCIFI_STATE_IDLE )

	self:EmitSound( "scifi.sprint.holster" )

	self:SetAds( false )

	self:ResetDeployment()

	return true

end

local tImpactSounds = {
	Sound( "/weapons/umbra/corruptor_impact_01.wav" ),
	Sound( "/weapons/umbra/corruptor_impact_02.wav" ),
	Sound( "/weapons/umbra/corruptor_impact_03.wav" ),
	Sound( "/weapons/umbra/corruptor_impact_04.wav" ),
	Sound( "/weapons/umbra/corruptor_impact_05.wav" ),
	Sound( "/weapons/umbra/corruptor_impact_06.wav" ),
}

function SWEP:DoImpactEffect( tr, nDamageType )

	if ( tr.HitSky ) then return true end

	if ( CLIENT ) then
		if ( self:GetPerkDamage() < 1 ) then return end
		
		ParticleEffect( "corruptor_impact", tr.HitPos, Angle( 0, 0, 0 ) )
		
		EmitSound( tImpactSounds[ math.random( 1, 6 ) ], tr.HitPos, tr.Entity:EntIndex(), CHAN_STATIC, 1, 60, 0, math.random( 95, 105 ) )
		
		local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
			dlight.pos = tr.HitPos
			dlight.r = 220
			dlight.g = 90
			dlight.b = 60
			dlight.brightness = 1
			dlight.Decay = 1024
			dlight.Size = 32
			dlight.DieTime = CurTime() + 0.4
		end
	end
	
	return false

end

function SWEP:TranslateActivity( act )

	if ( self.Owner:IsNPC() ) then
		if ( act == ACT_RELOAD ) then
			local iState = self:GetSciFiState()
			local ammo = self:Clip1()
			
			local bReloading = iState == SCIFI_STATE_RELOADING
			
			if ( ammo < self.Primary.ClipSize ) then
				if ( !bReloading ) then
					self:SetSciFiState( SCIFI_STATE_RELOADING )
					self:EmitSound( "scifi.fang.reload.npc" )
				end
			else
				if ( bReloading ) then
					self:SetSciFiState( SCIFI_STATE_IDLE )
				end
			end
		end
		
		if ( act == 2115 || act == 2116 || act == 2117 ) then
			self:NPCShoot_Primary()
		end
		
		if ( self.ActivityTranslateAI[ act ] ) then
			return self.ActivityTranslateAI[ act ]
		end
		
		return -1
	end

	if ( self.ActivityTranslate[ act ] != nil ) then
		return self.ActivityTranslate[ act ]
	end

	return -1

end