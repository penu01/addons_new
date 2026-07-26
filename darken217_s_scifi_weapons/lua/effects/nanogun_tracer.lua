AddCSLuaFile()
if ( CLIENT ) then
TRACER_FLAG_USEATTACHMENT	= 0x0002
end
EFFECT.Speed 		= 12000
EFFECT.Length		= 64
EFFECT.Normal 		= Vector( 0, 0, 0 )
EFFECT.ParticleCast = false
EFFECT.Time 		= nil
EFFECT.Color 		= Color( 80, 250, 220, 255 )
EFFECT.PixVis 		= nil

local nSize = Vector( 16, 16 )
local mat_flare = Material( "bloom/halo_static_2" )

function EFFECT:GetTracerOrigin( data )
	if ( CLIENT ) then
		local start = data:GetStart()

		if( bit.band( data:GetFlags(), TRACER_FLAG_USEATTACHMENT ) == TRACER_FLAG_USEATTACHMENT ) then
			local entity = data:GetEntity()
			
			if( !IsValid( entity ) ) then 
				return start 
			end
			
			if( !game.SinglePlayer() && entity:IsEFlagSet( EFL_DORMANT ) ) then 
				return start 
			end
			
			
			if( entity:IsWeapon() && entity:IsCarriedByLocalPlayer() ) then
				local pl = entity:GetOwner()
				if( IsValid( pl ) ) then
					local vm = pl:GetViewModel()
					if( IsValid( vm ) and not LocalPlayer():ShouldDrawLocalPlayer() ) then
						entity = vm
					else 					
						if( entity.WorldModel ) then
							entity:SetModel( entity.WorldModel )
						end
					end
				end
			end

			local attachment = entity:GetAttachment( data:GetAttachment() )
			if( attachment ) then
				start = attachment.Pos
			end

		end
		
		return start
	end
end
local nTime
function EFFECT:Init( data )
-- print( data )
	self.PixVis = util.GetPixelVisibleHandle()
nTime = CurTime() + 1
	-- self.StartPos = self:GetTracerOrigin( data )
	-- self.EndPos = data:GetOrigin()
	-- self.Parent = data:GetEntity()
	
--	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos )

	-- local diff = ( self.EndPos - self.StartPos )
	
	-- self.Normal = diff:GetNormal()
	-- self.StartTime = 0
	
	-- if ( !self.LifeTime ) then
		-- self.LifeTime = ( diff:Length() + self.Length ) / self.Speed
	-- else
		-- self.LifeTime = CurTime() + self.LifeTime
	-- end
	
	self.EffectData = data
	
end

function EFFECT:Render( guh )
-- print( guh )
	-- local endDistance = self.Speed * self.StartTime
	-- local startDistance = endDistance - self.Length
	
	-- startDistance = math.max( 0, startDistance )
	-- endDistance = math.max( 0, endDistance )

	-- local startPos = self.StartPos + self.Normal * startDistance
	-- local endPos = self.StartPos + self.Normal * endDistance
	
end

function EFFECT:Think()
	-- print(self.EffectData)
	if ( !self.ParticleCast ) then
		self.ParticleCast = true
	end
	
	-- if ( !self.Time ) then	
		-- self.Time = self.LifeTime + CurTime()
	-- end

	-- local dlight = DynamicLight( -1 )
	-- if ( dlight ) then
		-- dlight.pos = self.EffectData:GetStart()
		-- dlight.r = self.Color.r
		-- dlight.g = self.Color.g
		-- dlight.b = self.Color.b
		-- dlight.brightness = 1
		-- dlight.Size = 120 + 120
		-- dlight.Decay = 1024
		-- dlight.Style = 1
		-- dlight.DieTime = CurTime() + FrameTime() * 2
	-- end
	
	-- if ( self.PixVis ) then
		-- local nVis = util.PixelVisible( self:GetStart(), nSize, self.PixVis )
		
		-- local cFlare = self.Color
		-- cFlare.a = 100 * nVis
		
		-- render.SetMaterial( mat_flare )
		-- render.DrawSprite( self:GetStart(), nSize.x * nVis, nSize.y * nVis, cFlare )
	-- end
	
	-- if ( self:GetScale() == 0 ) then
		-- return true
	-- end
	
	if ( nTime < CurTime() ) then 
		return false
	end
	
	return true

end