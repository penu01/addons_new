local Spell = { }
Spell.LearnTime = 300
Spell.ApplyFireDelay = 0.45
Spell.Category = HpwRewrite.CategoryNames.pnu
Spell.AccuracyDecreaseVal = 0.2
Spell.Description = [[
	Healing spores that heal
	half of the target's maximum
	health. Cannot exceed max health.

	Hold self-cast key to heal
	yourself.
]]

Spell.ForceAnim = { ACT_VM_PRIMARYATTACK_3 }
Spell.NodeOffset = Vector(-487, 400, 0)         -- Hillium Maxima'nin biraz altinda/oncesinde, cakismasin
Spell.SpriteColor = Color(0, 255, 0)
Spell.DoSparks = true

-- ============================================================
-- Mantik: hedefin GetMaxHealth()'inin YARISI kadar iyilestir.
-- SetHealth + math.min ile sonucu asla MaxHealth'i gecmeyecek
-- sekilde sinirliyoruz.
--
-- Ornek (Max 100): can 18 -> +50 -> 68 -> tekrar +50 -> 118 ama
-- math.min(118, 100) = 100 (sinirlandi)
--
-- Ornek (Max 200): can 18 -> +100 -> 118 -> tekrar +100 -> 218 ama
-- math.min(218, 200) = 200 (sinirlandi)
-- ============================================================
function Spell:OnFire(wand)
	local ent = wand:HPWGetAimEntity(350)

	if IsValid(ent) then
		local maxHealth = ent:GetMaxHealth()
		local healAmount = maxHealth * 0.5

		local newHealth = math.min(ent:Health() + healAmount, maxHealth)  -- Health() düzeltmesi
		ent:SetHealth(newHealth)
	end

	sound.Play("hpwrewrite/spells/hillium.wav", wand:GetPos(), 70)
end

HpwRewrite:AddSpell("Hillium fix ", Spell)