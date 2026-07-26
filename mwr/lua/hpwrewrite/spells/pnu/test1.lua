local Spell = { }
Spell.LearnTime = 60                          -- Avada'nin 1200sn'lik ogrenme suresini kisalttim, test icin
Spell.Description = [[
	Ozel test buyumuz.
	Hedefe sabit miktarda hasar verir, oldurmez.
]]
Spell.Category = HpwRewrite.CategoryNames.pnu
Spell.FlyEffect = "hpw_avadaked_main"          -- ayni yesil isik efekti
Spell.ImpactEffect = "hpw_avadaked_impact"
Spell.ApplyDelay = 0.5
Spell.AccuracyDecreaseVal = 0.3
Spell.ForceAnim = { ACT_VM_PRIMARYATTACK_1, ACT_VM_PRIMARYATTACK_2 }
Spell.SpriteColor = Color(60, 255, 160)        -- ayni yesil renk
Spell.Fightable = true
Spell.DoSparks = true

-- ONEMLI: Avada'nin NodeOffset'i ile CAKISMAMASI icin farkli bir konum verdim
-- spell tree'de Avada'nin hemen yanina koydum (x'i biraz kaydirdim)
Spell.NodeOffset = Vector(938, -600, 0)

-- Sabit hasar miktari - istersen bu sayiyi degistir
local DAMAGE_AMOUNT = 25

local mat = Material("cable/hydra")
local mat2 = Material("cable/xbeam")

Spell.FightingEffect = function(nPoints, points)
	render.SetMaterial(mat)
	for i = 1, 3 do
		render.StartBeam(nPoints)
			for k, v in pairs(points) do
				render.AddBeam(v, (k / nPoints) * 60, math.Rand(0, 2), color_white)
			end
		render.EndBeam()
	end

	render.SetMaterial(mat2)
	for i = 1, 2 do
		render.StartBeam(nPoints)
			for k, v in pairs(points) do
				render.AddBeam(v, (k / nPoints) * 10, math.Rand(0, 1), color_white)
			end
		render.EndBeam()
	end

	for k, v in pairs(points) do
		if math.random(1, (1 / RealFrameTime()) * 2) == 1 then HpwRewrite.MakeEffect("hpw_avadaked_impact", v, AngleRand()) end
	end
end

function Spell:Draw(spell)
	self:DrawGlow(spell)
end

function Spell:OnSpellSpawned(wand, spell)
	sound.Play("ambient/wind/wind_snippet2.wav", spell:GetPos(), 75, 255)
	spell:EmitSound("ambient/wind/wind_snippet2.wav", 80, 255)
	wand:PlayCastSound()
end

function Spell:OnRemove(spell)
	if CLIENT then
		local dlight = DynamicLight(spell:EntIndex())
		if dlight then
			dlight.pos = spell:GetPos()
			dlight.r = 80
			dlight.g = 235
			dlight.b = 180
			dlight.brightness = 6
			dlight.Decay = 1000
			dlight.Size = 256
			dlight.DieTime = CurTime() + 1
		end
	end
end

function Spell:OnFire(wand)
	return true
end

-- ============================================================
-- Avada'dan farkli kisim burasi:
-- HpwRewrite.Kill (aninda oldurme) yerine sabit hasar veriyoruz
-- ============================================================
function Spell:OnCollide(spell, data)
	local ent = data.HitEntity

	if IsValid(ent) then
		if ent:IsNPC() or ent:IsPlayer() then
			local dmg = DamageInfo()
			dmg:SetDamage(DAMAGE_AMOUNT)
			dmg:SetAttacker(self.Owner or spell)
			dmg:SetInflictor(spell)
			dmg:SetDamageType(DMG_ENERGYBEAM)
			ent:TakeDamageInfo(dmg)
		elseif ent.HPWRagdolledEnt then
			HpwRewrite.TakeDamage(ent, self.Owner, DAMAGE_AMOUNT, spell:GetFlyDirection() * 10000)
		end
	end
end

HpwRewrite:AddSpell("Test Buyusu 1", Spell)