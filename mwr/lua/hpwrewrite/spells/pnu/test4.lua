local Spell = {}

Spell.LearnTime = 90
Spell.Description = [[
	Particle Beam
]]
Spell.Category = HpwRewrite.CategoryNames.pnu
Spell.ApplyDelay = 0.65
Spell.ForceAnim = { ACT_VM_PRIMARYATTACK_1, ACT_VM_PRIMARYATTACK_2 }
Spell.SpriteColor = Color(0, 170, 255)
Spell.DoSparks = true
Spell.NodeOffset = Vector(1050, -620, 0)
Spell.CanSelfCast = false
Spell.ShouldSay = true
Spell.ForceDelay = 15

local BEAM_DURATION = 3.3
local DAMAGE_PER_TICK = 28
local TICK_INTERVAL = 0.28
local BEAM_RADIUS = 450

--========================--
--      Mikro Cache
--========================--

local CurTime = CurTime
local IsValid = IsValid
local ipairs = ipairs
local random = math.random

local EffectData = EffectData
local util_Effect = util.Effect
local sound_Play = sound.Play
local FindByClass = ents.FindByClass
local GetAllPlayers = player.GetAll

-- ============================================================
-- Sadece oyuncu ve NPC'leri tarayan verimli fonksiyon.
-- ents.FindInSphere HER SEYI (info_player_start, silahlar,
-- viewmodel'ler vs.) donuyordu - biz asa kullandigimiz icin
-- bunlarin hicbirine ihtiyacimiz yok, direkt hedef listesini
-- kucultuyoruz.
-- ============================================================
local function FindTargetsInRadius(pos, radius)
	local targets = { }

	for _, ply in ipairs(GetAllPlayers()) do
		if IsValid(ply) and ply:GetPos():Distance(pos) <= radius then
			targets[#targets + 1] = ply
		end
	end

	for _, npc in ipairs(FindByClass("npc_*")) do
		if IsValid(npc) and npc:GetPos():Distance(pos) <= radius then
			targets[#targets + 1] = npc
		end
	end

	return targets
end

local BEAM_OFFSET = Vector(0,0,2400)
local UP_VECTOR = Vector(0,0,1)
local DAMAGE_FORCE = Vector(0,0,450)

function Spell:OnFire(wand)

	-- Singleplayer'da CallOnClient("PrimaryAttack") uzerinden bu fonksiyon
	-- clientside'da da tetiklenebiliyor, o yuzden bu guard onemli.
	if CLIENT then
		return false
	end

	local owner = wand.Owner
	if not IsValid(owner) then
		return false
	end

	local tr = owner:GetEyeTrace()
	local hitPos = tr.HitPos
	local beamStart = hitPos + BEAM_OFFSET

	local sensor = ents.Create("prop_dynamic")
	if not IsValid(sensor) then
		return false
	end

	sensor:SetModel("models/gibs/gunship_gibs_sensorarray.mdl")
	sensor:SetPos(beamStart)
	sensor:SetAngles(Angle(0, owner:EyeAngles().y - 180, 0))
	sensor:Spawn()
	sensor:Activate()

	sensor:SetMaterial("models/effects/vol_light001")
	sensor:SetNoDraw(false)
	sensor:SetSolid(SOLID_NONE)
	sensor:DrawShadow(false)

	sensor.IsSensorEntPC = true
	sensor.BeamType = 2
	sensor.Owner = owner
	sensor.Caller = owner

	local sensorPos = sensor:GetPos()

	local function CallParticleEffects()

		if not IsValid(sensor) then return end

		local effectdata = EffectData()
		effectdata:SetEntity(sensor)
		effectdata:SetStart(sensorPos)
		effectdata:SetOrigin(hitPos)
		effectdata:SetNormal(UP_VECTOR)

		util_Effect("pc_particle_cannon", effectdata)
		util_Effect("pc_particle_cannon_particle", effectdata)
		util_Effect("pc_particle_cannon_particle2", effectdata)

	end

	CallParticleEffects()
	timer.Simple(0.05, CallParticleEffects)
	timer.Simple(0.15, CallParticleEffects)

	sensor:EmitSound("ambient/levels/citadel/zapper_loop2.wav",90,105)
	sound_Play("ambient/levels/citadel/weapon_disintegrate4.wav",hitPos,85,115)

	local timerName = "mwr_test3_beam_" .. sensor:EntIndex()
	local elapsed = 0

	timer.Create(timerName, TICK_INTERVAL, 0, function()

		-- sensor ya da owner gecersiz olduysa timer'i tamamen durdur
		if not IsValid(sensor) or not IsValid(owner) then
			timer.Remove(timerName)
			if IsValid(sensor) then
				sensor:StopSound("ambient/levels/citadel/zapper_loop2.wav")
				sensor:Remove()
			end
			return
		end

		elapsed = elapsed + TICK_INTERVAL

		if elapsed >= BEAM_DURATION then
			timer.Remove(timerName)
			sensor:StopSound("ambient/levels/citadel/zapper_loop2.wav")
			sensor:Remove()
			return
		end

		local found = FindTargetsInRadius(hitPos, BEAM_RADIUS)

		for _, ent in ipairs(found) do

			-- FindTargetsInRadius zaten sadece oyuncu/NPC dondurdugu icin
			-- ekstra IsPlayer/IsNPC kontrolune gerek yok, sadece IsValid yeterli
			if IsValid(ent) then
				local dmg = DamageInfo()
				dmg:SetDamage(DAMAGE_PER_TICK)
				dmg:SetAttacker(owner)
				dmg:SetInflictor(sensor)
				dmg:SetDamageType(DMG_ENERGYBEAM)
				dmg:SetDamageForce(DAMAGE_FORCE)
				ent:TakeDamageInfo(dmg)

				if random(1,100) <= 30 and not ent:IsOnFire() then
					ent:Ignite(2,50)
				end
			end

		end

	end)

	return false

end

HpwRewrite:AddSpell("Particle Beam", Spell)