AddCSLuaFile()
AddCSLuaFile( "base/scifi_base.lua" )
include( "base/scifi_base.lua" )

SWEP.Spawnable = GetConVar( "sfw_showhiddenweapons" ):GetBool()

SWEP.PrintName				= "Nanogun"
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

-- SWEP.IhlBodyGroups 		= {[1]=0, [2]=1, [3]=0}

-- SWEP.SciFiSkin 				= "" -- dev/hide"

SWEP.DeploySpeed 			= 2

SWEP.Primary.ClipSize		= 16
SWEP.Primary.DefaultClip	= 16
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.ProjectileOffset 		= Vector( 1.5, -2 )
SWEP.ProjectileOffsetNPC 	= Vector( -1, -1 )

-- SWEP.VfxMuzzleParticle	 	= "umbra_muzzle"
-- SWEP.VfxMuzzleAttachment 	= "1"
-- SWEP.VfxMuzzleAttachment2 	= "Muzzle"
-- SWEP.VfxMuzzleColor 		= Color( 250, 60, 45, 255 )
-- SWEP.VfxMuzzleBrightness 	= 1
-- SWEP.VfxMuzzleFOV 			= 140
-- SWEP.VfxMuzzleFarZ 			= 720
-- SWEP.VfxHeatParticle 		= "gunsmoke"

SWEP.VfxMuzzleParticle	 	= "alyxshot_muzzle"
SWEP.VfxMuzzleAttachment 	= "1"
SWEP.VfxMuzzleColor 		= Color( 80, 250, 220, 255 )
SWEP.VfxMuzzleBrightness 	= 0.4
SWEP.VfxMuzzleFOV 			= 140
SWEP.VfxMuzzleFarZ 			= 520

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

SWEP.AdsPos 				= Vector(-2.42, 8, 1.5)
SWEP.AdsAng 				= Angle( 0, 0, 0 )
SWEP.AdsFov					= 48

SWEP.AdsSounds 				= true
SWEP.AdsSoundEnable 		= "scifi.fang.zoomin"
SWEP.AdsSoundDisable		= "scifi.fang.zoomout"

-- SWEP.DataTables = {
	-- { dType = "Bool", dName = "IsReloading" }
-- }

SWEP.SciFiWorldStats		= {
	Primary = {
		DamageAmount = 12,
		DamageType = DMG_BULLET,
		CritMul = 3,
		FireRate = { 
			{ RateTitle = "semi-auto", RateDelay = 0.325 }
		},
	},
	ClipSize = 16,
	ReloadSpeed = 1.2,
	Recoil = 4,
	-- PerkSet = { SCIFI_PERK_AMMO_PUNCHTHROUGH_LIGHT, SCIFI_PERK_BARREL_STEALTH }
}

SWEP.FeelGoodEnabled = true
SWEP.FeelGoodHullEnabled = true
SWEP.FeelGoodRatio = 0.2
SWEP.FeelGoodHullSize = 10

SWEP.NPCAccuracy 			= 100
SWEP.NPCSkillLevel 			= 0

local c_hud_bg = Color( 80, 250, 220, 255 )
local c_hud_fg = Color( 30, 255, 230, 255 )

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
	-- ["1"] = { type = SCIFI_SCK_TYPE_MODEL, model = "models/weapons/pn03/w_pistol.mdl", bone = "v_weapon.Deagle_Parent", rel = "", pos = Vector( -0.275, -3.7, -0.8 ), angle = Angle( 92.5, -45, -42 ), size = Vector( 1.1, 1.1, 1.1 ), color = Color(255, 255, 255, 255), surpresslightning = false, submat = { [0] = "dev/hide", [1] = "", [2] = "" }, skin = 0, bodygroup = {} },
	-- ["2"] = { type = SCIFI_SCK_TYPE_MODEL, model = "models/weapons/pn03/w_pistol.mdl", bone = "v_weapon.Deagle_Slide", rel = "", pos = Vector( -0.275, 0.3, -2 ), angle = Angle( 92.5, -45, -42 ), size = Vector( 1.1, 1.1, 1.1 ), color = Color(255, 255, 255, 255), surpresslightning = false,  submat = { [0] = "", [1] = "dev/hide", [2] = "dev/hide" },skin = 0, bodygroup = {} },
	["4"] = { type = SCIFI_SCK_TYPE_MODEL, model = "models/dpfilms/weapons/w_neophron.mdl", bone = "v_weapon.Deagle_Parent", rel = "", pos = Vector(0.055, 0.5, 1), angle = Angle(180, 0, -90), size = Vector(1.103, 1.103, 1.103), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["5"] = { type = SCIFI_SCK_TYPE_MODEL, model = "models/weapons/v_w_vk21.mdl", bone = "v_weapon.Deagle_Parent", rel = "", pos = Vector(0.05, -2.5, 3.5), angle = Angle( -90, 0, -90 ), size = Vector( 1, 1, 1 ), color = Color(255, 255, 255, 255), surpresslightning = false, skin = 0, bodygroup = {[0]=1, [1]=1, [2]=1, [3]=1} },
	["6"] = { type = SCIFI_SCK_TYPE_MODEL, model = "models/hunter/plates/plate1x1.mdl", bone = "v_weapon.Deagle_Slide", rel = "", pos = Vector( 0.04, -1.72, 1 ), angle = Angle( 0, -90, 0 ), size = Vector(0.06, 0.06, 0.001), color = Color(255, 255, 255, 255), surpresslightning = true, material = "models/weapons/vk21/holo", skin = 0, bodygroup = {} },
	-- ["0"] = { type = SCIFI_SCK_TYPE_QUAD, bone = "v_weapon.Deagle_Slide", pos = Vector( 0.052, -1.675, 1 ), angle = Angle( 0, 90, 0 ), size = 0.004, draw_func = fnSight },
	-- ["1"] = { type = SCIFI_SCK_TYPE_QUAD, bone = "v_weapon.Deagle_Parent", pos = Vector( 0.052, -5.675, -12 ), angle = Angle( 0, 90, 0 ), size = 0.004, draw_func = fnSight },
	-- ["3"] = { type = SCIFI_SCK_TYPE_QUAD, bone = "v_weapon.Deagle_Parent", pos = Vector( 0.052, -5.675, -12 ), angle = Angle( 0, 0, 0 ), size = 0.004, draw_func = fnSight }
	-- ["point"] = { type = SCIFI_SCK_TYPE_LASER, color = Color( 255, 10, 30 ), bone = "v_weapon.Deagle_Parent", pos = Vector( 0, -1.6, -8 ), angle = Angle( -90, 0, 0 ), range = 8192, line_size = 0.8, haze_size = 0.1, dot_size = 1 }
}

SWEP.WElements = {
	-- ["4"] = { type = SCIFI_SCK_TYPE_MODEL, model = "models/weapons/w_alyx_gun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 0 ,0), angle = Angle(0, 0, 0), size = Vector(1.103, 1.103, 1.103), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["5"] = { type = SCIFI_SCK_TYPE_MODEL, model = "models/weapons/v_w_vk21.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.5, 1.4, -2.12), angle = Angle(-3, -4.5, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, submat = {}, skin = 0, bodygroup = {[0]=1, [1]=1, [2]=1, [3]=1} },
	-- ["point"] = { type = SCIFI_SCK_TYPE_LASER, color = Color( 255, 10, 30 ), bone = "ValveBiped.Bip01_R_Hand", pos = Vector( 7.5, 1.75, -2.5 ), angle = Angle( -2, -4.5, 0 ), range = 8192, line_size = 0.8, haze_size = 0.1, dot_size = 1 }
}

SWEP.DataTables = {
	{ dType = "Bool", dName = "IsReloading" },
	{ dType = "Bool", dName = "CanBurst" },
	{ dType = "Bool", dName = "BurstMode" },
	{ dType = "Int", dName = "BurstCount" }
}

function SWEP:SubInit()

end

local tBullets = {}
local nBulletStepSize = 10
local nBulletLifeTime = 2
local nBulletSpeed = 1200
local nBulletSize = 0.1
-- start, dir, pos, speed, time, dmg, fx

if ( SERVER ) then
	util.AddNetworkString( "BulletManager" )
end

if ( CLIENT ) then
	net.Receive( "BulletManager", function( nLength, entPlayer )
		local iBulletID = net.ReadInt(12)
		local bAlive = net.ReadBool()
		local vPosition = net.ReadVector()
		
		if ( !tBullets[ iBulletID ] ) then	
			tBullets[ iBulletID ] = {}
		end
		
		tBullets[ iBulletID ].alive = bAlive
		tBullets[ iBulletID ].start = vPosition
	end )
end

function SWEP:Think()

	if ( ( game.SinglePlayer() || ( !game.SinglePlayer() && CLIENT ) ) && self:GetSciFiState() == SCIFI_STATE_ADS ) then
		local fNextPrimaryFire = self:GetNextPrimaryFire() - CurTime()

		if ( fNextPrimaryFire > 0 ) then
			local fAnimationScale = math.Clamp( fNextPrimaryFire / 0.325, 0, 1 )

			self.AdsPos.z = 1.5 - 4 * fAnimationScale
			self.AdsPos.x = -2.42 + 1 * fAnimationScale
			self.AdsAng.roll = 14 * fAnimationScale
			self.AdsAng.pitch = -8 * fAnimationScale

			local aPunch = self.Owner:GetViewPunchAngles()
			self.Owner:SetViewPunchAngles( aPunch * ( 0.8 + fAnimationScale * 0.2 ) )
		else 
			self.AdsPos.z = 1.5
			self.AdsPos.x = -2.42
			self.AdsAng.roll = 0
			self.AdsAng.pitch = 0
		end
	end

	if ( self:GetBurstMode() ) && ( SERVER || !game.SinglePlayer() ) then
		local fNextPFire = self:GetNextPrimaryFire()
		
		if ( self:CanBFire() ) && ( fNextPFire < CurTime() && fNextPFire > -1 ) then
			if ( self:GetBurstCount() < 4 && self:GetCanBurst() ) && ( fNextPFire > -1 ) then
				self:Attack()
				
				self:SetCanBurst( true )
				self:SetBurstCount( self:GetBurstCount() + 1 )

				self:SetNextPrimaryFire( CurTime() + 0.065 )
			end
			
			if ( self:GetBurstCount() > 3 ) then
				self:SetNextPrimaryFire( CurTime() + 0.5 )
				self:SetCanBurst( false )
				self:SetBurstCount( 0 )
			end
		end	
	end

	self:Ads()
	self:Anims()
	self:SciFiMath()
	self:SciFiMelee()
	
	-- for i=1, #tBullets do
		-- local Bullet = tBullets[i]
		-- if ( !Bullet ) then return end
		
		-- if ( CLIENT ) then
			-- if ( Bullet.alive ) then
				-- table.remove( tBullets, i )
			-- end
		-- end
		
		-- if ( SERVER ) then
			-- local bAlive = Bullet.lifetime > CurTime()
			-- local nStep = 1 + Bullet.speed * FrameTime()
			-- local vNextStep = Bullet.start + Bullet.dir * nStep

			-- local TraceResult = {}
			-- local Trace = {
				-- start = Bullet.start,
				-- endpos = vNextStep,
				-- mins = Vector( nBulletSize * nStep * 0.5, nBulletSize, nBulletSize ) * -1,
				-- maxs = Vector( nBulletSize * nStep * 0.5, nBulletSize, nBulletSize ),
				-- filter = { self, self:GetOwner() },
				-- mask = MASK_SHOT,
				-- collisiongroup = COLLISION_GROUP_NONE,
				-- ignoreworld = false,
				-- output = TraceResult
			-- }
			
			-- util.TraceLine( Trace )
			-- util.TraceHull( Trace )

			-- local frac = ( Bullet.lifetime - CurTime() ) / nBulletLifeTime
		
			-- debugoverlay.Sphere( TraceResult.HitPos, 2, FrameTime()*2, Color( 255, 0, 0, 255 ), true) 

			-- local color
			-- if ( TraceResult.Hit ) then
				-- color = Vector( 1, 0, 1 )
			-- else
				-- color = Lerp( frac, Vector( 1, 0.5, 0 ), Vector( 0, 0.5, 1 ) )
			-- end
			
			-- debugoverlay.Line( TraceResult.StartPos, TraceResult.HitPos, 1, color:ToColor(), false )
			
			-- tBullets[i].start = vNextStep

			-- if ( TraceResult.Hit ) then
				-- if ( TraceResult.Entity && !TraceResult.HitSky ) then
					-- local entTarget = TraceResult.Entity
					
					-- debugoverlay.Sphere( TraceResult.HitPos, 8, 1, Color( 255, 0, 0, 1 ), true) 

					-- local nHitGroup = TraceResult.HitGroup || 0
					-- local nHBoxBone = TraceResult.HitBoxBone || 0
					
					-- if ( nHitGroup == HITGROUP_HEAD || nHBoxBone == 6 ) then
						-- Bullet.dmg:ScaleDamage( 3 )
					-- end

					-- if ( nHitGroup == HITGROUP_CHEST || nHitGroup == HITGROUP_STOMACHE ) then
						-- Bullet.dmg:ScaleDamage( 2 )
					-- end
					
					-- entTarget:TakeDamageInfo( Bullet.dmg )
				-- end
					
				-- vNextStep = TraceResult.HitPos
				
				-- bAlive = false
			-- end
			
			-- if ( !bAlive ) then
				-- table.remove( tBullets, i )
			-- end
		-- end
	-- end
end

local m_holosight = Material( "models/weapons/vk21/holo" )
local m_debug = Material( "dev/rtscreen" )
local SizeX, SizeY = 512, 512
local rtScreen

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
			-- local pOwnerEA = self.Owner:EyeAngles()
			-- local vmAttach = vm:GetAttachment( "2" )
			-- local fxOrigin = self:GetProjectileSpawnPos() + pOwnerEA:Forward() * 24
			
			-- local effectdata = EffectData()
			-- effectdata:SetEntity( vm )
			-- effectdata:SetOrigin( fxOrigin )
			-- effectdata:SetAttachment( 2 )
			-- effectdata:SetAngles( pOwnerEA + Angle( -30, -90, 0 ) )
			
			-- util.Effect( "ShellEject", effectdata )
			
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

local nanomgr

function GetProjectileManager()
	if ( !nanomgr || nanomgr == NULL ) then
		nanomgr = ents.Create( "nano_manager" )
		nanomgr:SetPos( Vector( -16384, -16384, -16384 ) )
		nanomgr:Spawn()
	end
		
	return nanomgr
end

function SWEP:Attack()
	
	local pOwnerAV = self.Owner:GetAimVector()
	
	if ( self.FeelGoodEnabled ) then
		pOwnerAV = self:GetFeelGoodVector( pOwnerAV )
	end

	local entCreator=self:GetOwner()
	
	local vOrigin
	if(self:GetSciFiState()==SCIFI_STATE_ADS)then
		vOrigin=entCreator:GetShootPos()
	else
		vOrigin=self:GetProjectileSpawnPos()
	end

	-- local fw, rt, up = entCreator:GetForward(), entCreator:GetRight(), entCreator:GetUp()
	-- local vSpray = ( rt * math.random( -100, 100 ) + up * math.random( -100, 100 ) ) * 0.01 * ( 1 + self:GetSciFiACC() ) * 0.001
	
	-- local vDirection = pOwnerAV + vSpray + Vector( 0, 0, self:GetSciFiACC() * 0.0025 )
	-- vDirection:Normalize()
	
	if ( SERVER ) then
		local aPunch = Angle( self:GetSciFiACC(), 0, 0 )
		if ( self.Owner:IsPlayer() ) then
			aPunch = entCreator:GetViewPunchAngles()
			self.Owner:ViewPunch( Angle( math.random( -280, -300 ), math.random( 10, 15 ), math.random( 5, 10 ) ) * 0.01 * ( 0.3 + self:GetSciFiACC() * 0.1 ) )
			pOwnerAV = entCreator:GetEyeTrace().HitPos - vOrigin
		end
	
		local fw, rt, up = entCreator:GetForward(), entCreator:GetRight(), entCreator:GetUp()
		-- local vSpray = rt * ( aPunch.yaw ) + up * ( -aPunch.pitch  )
		-- local vDirection = pOwnerAV + vSpray * 0.0005
		local vDirection = ( entCreator:EyeAngles() + aPunch ):Forward() --+ self:GetProjectileSpreadVector() * 0.001
		vDirection:Normalize()
	
		if ( self:GetBurstMode() ) then
			local vFeelGood, entTarget = self:GetFeelGoodVector()
			
			for i=0,1+self:GetBurstCount() do 
				local vScatter = rt * math.random( -10, 10 ) + up * math.random( -10, 10 )
				vScatter = vScatter * 0.01
				local x=ents.Create("nano_projectile")
				-- local x = GetProjectileManager():RequestProjectile()
				x:SetOwner(self:GetOwner())
				x:SetInflictor(self)
				x:SetPos(vOrigin)
				x:SetDirection(vDirection+vScatter)
				x:SetSize(2)
				x:SetSpeed(2048)
				x:SetTickRate(60)
				x:SetDieTime(CurTime()+0.5)
				x:SetIsActive(true)
				x.Damage=6
				x:Spawn()
				x:SetTrackingTarget(entTarget)
				x.TrackingFactor=0.334
			end

			self:TakePrimaryAmmo( 2 )
		else
			-- local vFeelGood, entTarget = self:GetFeelGoodVector()
			local x=ents.Create("nano_projectile")
			-- local x = GetProjectileManager():RequestProjectile()
			x:SetOwner(self:GetOwner())
			x:SetInflictor(self)
			x:SetPos(vOrigin)
			x:SetDirection(vDirection)
			x:SetSize(0.1)
			x:SetSpeed(16384)
			x:SetTickRate(60)
			x:SetDieTime(CurTime()+3)
			x:SetIsActive(true)
			x:Spawn()
			-- x:SetTrackingTarget(entTarget)
			-- x.TrackingFactor=0.04
			-- x.Ricochet=2
			
		
			self:TakePrimaryAmmo( 1 )
		end

		self:DoMuzzleEffect()
		
		self:EmitSound( "scifi.talon.fire" )
		
		if ( self.Owner:WaterLevel() < 2 ) then
			self:EmitSound( "scifi.talon2.fire.echo" )
		end

		if ( self:GetBurstCount() == 3 ) then
			self:EmitSound( "scifi.voltshot.echo" )
		end
	end

	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

	self:AddSciFiACC( 4 )

end

function SWEP:CanBFire()

	if ( self.Weapon:Clip1() <= 0 ) then
		self:SetBurstCount( 4 )
		return false
	end

	return true
	
end


function SWEP:PrimaryAttack()

	if ( !self:CanPrimaryAttack( 0, true ) ) then return end
	
	local hOwner = self:GetOwner()
	
	if ( hOwner:IsNPC() ) then
		self:Attack()
		return
	end
	
	if ( self:GetBurstMode() ) then
		if ( self:GetBurstCount() > 2 ) then return end
		
		self:SetCanBurst( true )
	else
		self:Attack()
	
		self:SetNextPrimaryFire( CurTime() + 0.325 )
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
		
		self:EmitSound( "Weapon_Pistol.Empty" )
	end

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