local Spell = { }
Spell.LearnTime = 720
Spell.ApplyFireDelay = 0.45
Spell.Category = HpwRewrite.CategoryNames.pnu
Spell.OnlyIfLearned = { "Hillium" }
Spell.AccuracyDecreaseVal = 0.2
Spell.Description = [[
	Healing spores that will
	completely heal yourself
	or anything you're looking at,
	setting health directly
	to maximum.
]]

Spell.ForceAnim = { ACT_VM_PRIMARYATTACK_3 }
Spell.NodeOffset = Vector(-487, 314, 0)
Spell.SpriteColor = Color(0, 255, 0)
Spell.DoSparks = true
Spell.CanSelfCast = true

function Spell:OnFire(wand)
	local owner = wand:GetOwner()
	local ent = wand:HPWGetAimEntity(350)

	-- Hedef yoksa veya kendine kullanıyorsa sahibini iyileştir.
	if not IsValid(ent) or ent == owner then
		ent = owner
	end

	if IsValid(ent) and ent.SetHealth and ent.GetMaxHealth then
		ent:SetHealth(ent:GetMaxHealth())
	end

	sound.Play("hpwrewrite/spells/hillium.wav", wand:GetPos(), 70)
end

HpwRewrite:AddSpell("Hillium Maxima", Spell)