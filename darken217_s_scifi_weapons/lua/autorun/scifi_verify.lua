--------------------My first SciFi weapon base--------------------
--		    	SciFi Weapons v18 - by Darken217		 		--
------------------------------------------------------------------
-- Please do NOT use any of my code without further permission! --
------------------------------------------------------------------
-- Purpose: Verify integrity of base components by comparing    --
-- integrity flags 												--
------------------------------------------------------------------
-- Initialized via autorun.										--
------------------------------------------------------------------

SCIFI_INTEGRITY_FLAG_VERIFY = 20241209183701

local fnIntegrityCheck = function()
	local tCheck = {
		[ "initialize" ] = 			{ path = "lua/autorun/scifi_init.lua", 			flag = SCIFI_INTEGRITY_FLAG_INIT, 		cl = true, sv = true },
		[ "precache" ] = 			{ path = "lua/autorun/scifi_precache.lua", 		flag = SCIFI_INTEGRITY_FLAG_PRECACHE, 	cl = true, sv = true },
		[ "verify" ] = 				{ path = "lua/autorun/scifi_verify.lua", 		flag = SCIFI_INTEGRITY_FLAG_VERIFY, 	cl = true, sv = true },
		[ "sounds" ] = 				{ path = "lua/base/scifi_sounds.lua", 			flag = SCIFI_INTEGRITY_FLAG_SOUNDS, 	cl = true, sv = true },
		[ "globals" ] = 			{ path = "lua/base/scifi_globals.lua", 			flag = SCIFI_INTEGRITY_FLAG_GLOBALS, 	cl = true, sv = true },
		[ "hooks" ] = 				{ path = "lua/base/scifi_hooks.lua", 			flag = SCIFI_INTEGRITY_FLAG_HOOKS, 		cl = true, sv = true },
		[ "hud" ] = 				{ path = "lua/base/scifi_hud.lua", 				flag = SCIFI_INTEGRITY_FLAG_HUD, 		cl = true, sv = true },
		[ "elemental" ] = 			{ path = "lua/base/scifi_elementals.lua", 		flag = SCIFI_INTEGRITY_FLAG_ELEMENTALS, cl = true, sv = true },
		[ "render" ] = 				{ path = "lua/base/scifi_render.lua", 			flag = SCIFI_INTEGRITY_FLAG_RENDER, 	cl = true, sv = true },
		[ "base" ] = 				{ path = "lua/base/scifi_base.lua", 			flag = SCIFI_INTEGRITY_FLAG_SWEP, 		cl = true, sv = true },
		[ "damage" ] = 				{ path = "lua/base/scifi_damage.lua", 			flag = SCIFI_INTEGRITY_FLAG_DAMAGE, 	cl = true, sv = true },
		[ "projectile" ] = 			{ path = "lua/base/scifi_projectile.lua", 		flag = SCIFI_INTEGRITY_FLAG_SENT, 		cl = true, sv = true },
		[ "muzzleflash" ] = 		{ path = "lua/effects/sfw_muzzle_generic.lua", 	flag = SCIFI_INTEGRITY_FLAG_FX, 		cl = true, sv = false }
	}

	local bIssues = false
	for k, v in pairs( tCheck ) do
		if ( !v || !v.flag || v.flag != SCIFI_INTEGRITY_FLAG_VERIFY ) then
			if ( CLIENT && v.cl != CLIENT ) || ( SERVER && v.sv != SERVER ) then
				continue
			end
			
			bIssues = true
			MsgC( Color( 220, 20, 40 ), "@SciFiWeapons : !Error; Integrity mismatch ("..v.path.."). Found '"..tostring(v.flag).."', should be '"..SCIFI_INTEGRITY_FLAG_VERIFY.."'.\n" )
			-- RunConsoleCommand( "whereis", v.path )
		end
	end
	
	if ( bIssues ) then
		MsgC( Color( 220, 20, 40 ), "Make sure there are no outdated base components or files overwriting updated content! Use the 'whereis' console command along with the conflict path provided above to find where the wrong file is coming from.\n" )
	
		if ( CLIENT ) then
			-- LocalPlayer():ChatPrint( "SciFi Base detected compatibility issues, check developer console for details." )
			notification.AddLegacy( "SciFi Base detected compatibility issues, check developer console for details.", NOTIFY_ERROR, 15 )
		end
	else
		MsgC( Color( 220, 220, 220 ), "SciFi Weapons sucessfully verified.\n" )
	end
end

-- fnIntegrityCheck()

hook.Add( "InitPostEntity", "ScifiSelfTesting", function()
	-- timer.Simple( 10, function()
		fnIntegrityCheck()
	-- end )
end ) 