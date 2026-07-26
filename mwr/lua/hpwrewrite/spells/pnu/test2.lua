local Spell = { }
Spell.LearnTime = 60
Spell.Description = [[
	Test buyusu 2.
	Zeala'nin vortex enerjisini kullanarak hedefe carpar.
]]
Spell.Category = HpwRewrite.CategoryNames.pnu
Spell.FlyEffect = "zeala_nade"                 -- Zeala nade'nin kendi tracer efekti (FxTracer degeri)
Spell.ImpactEffect = nil                       -- carpma efektini kendimiz OnCollide/AfterCollide'da yonetecegiz
Spell.ApplyDelay = 0.5
Spell.AccuracyDecreaseVal = 0.3
Spell.ForceAnim = { ACT_VM_PRIMARYATTACK_1, ACT_VM_PRIMARYATTACK_2 }
Spell.SpriteColor = Color(149, 155, 255)       -- zeala'nin isik rengiyle ayni (mor-mavi)
Spell.DoSparks = true
Spell.ForceDelay = 60                            -- artik asayi degil, SADECE bu buyuyu kilitler (wand.lua guncellendi)

Spell.NodeOffset = Vector(938, -650, 0)        -- Avada ve test1'den farkli, cakismasin

local DAMAGE_AMOUNT = 0                         -- artik kullanilmiyor (tek seferlik hasar yerine surekli hasar var)
local DAMAGE_PER_TICK = 4                       -- vortex icindeyken her tick verilecek hasar miktari
local DAMAGE_TICK_INTERVAL = 0.5                -- kac saniyede bir hasar verilecek
local DAMAGE_RANGE_MULT = 0.6                   -- vortex'in kendi VortexRange'inin yuzde kaci hasar alani olsun
local BURST_DAMAGE = 35                         -- vortex yok olurken verilecek tek seferlik patlama hasari
local BURST_RANGE_MULT = 0.6                    -- patlama hasarinin menzili (VortexRange'in yuzde kaci)

function Spell:Draw(spell)
	self:DrawGlow(spell)
end

function Spell:OnSpellSpawned(wand, spell)
	spell:EmitSound("scifi.spectra.flyby.heavy", 80, 100)
	wand:PlayCastSound()
end

function Spell:OnFire(wand)
	return true
end

-- ============================================================
-- Carpma ani: artik dogrudan hasar VERMIYORUZ
-- Amac hasar degil, vortex'in kendi cekim gucu (AfterCollide'da spawn ediliyor)
-- ============================================================
function Spell:OnCollide(spell, data)
	-- kasitli olarak bos birakildi - hasar mantigi kaldirildi
	-- varsayilan collide davranisina izin ver (spell kaybolsun)
	return false
end

-- ============================================================
-- AfterCollide: gercek Zeala vortex'ini spawn ediyoruz
-- (Zeala nade'nin kendi XPlode fonksiyonundan esinlenildi)
-- ============================================================
function Spell:AfterCollide(spell, data)
	if not SERVER then return end

	local pos = data.HitPos
	if data.HitNormal then
		pos = (data.HitNormal * -72) + data.HitPos
	end

	local owner = self.Owner

	-- Zeala'nin kendisi de FrameTime() kadar gecikme ile spawn ediyor, ayni mantik
	timer.Simple(FrameTime(), function()
		local vortex = ents.Create("sfw_vortex_world")
		if not IsValid(vortex) then
			-- Addon yuklu degilse buraya duser, console'a uyari birak
			ErrorNoHalt("[MWR test2] sfw_vortex_world entity'si bulunamadi - Darken217's SciFi Weapons addon'u yuklu mu kontrol et!\n")
			return
		end

		vortex:SetPos(pos)
		vortex:SetAngles(Angle(0, 0, 0))
		if IsValid(owner) then
			vortex:SetOwner(owner)
		end
		vortex:Spawn()

		-- SADECE bu vortex instance'inin hasarini susturuyoruz.
		-- Global "sfw_damageamp" convar'ina dokunmuyoruz, yani
		-- diger SciFi Weapons silahlari etkilenmiyor.
		-- Cekim gucu (VortexDrag'taki fizik itmesi) bundan etkilenmez,
		-- sadece SubThink/OnRemove icindeki DealAoeDamage cagrilari
		-- artik hicbir sey yapmayacak.
		vortex.DealAoeDamage = function() end
		vortex.DealDirectDamage = function() end

		-- ========================================================
		-- KENDI SUREKLI HASARIMIZ
		-- Vortex'in kendi hasari kapali, bunun yerine kendi kontrol
		-- ettigimiz, dusuk ve ayarlanabilir bir periyodik hasar
		-- veriyoruz. Vortex.LifeTime = 3 saniye oldugu icin, bu sure
		-- boyunca DAMAGE_TICK_INTERVAL'da bir calisip sonra kendini
		-- durduruyor.
		-- ========================================================
		local timerName = "mwr_test2_vortex_dmg_" .. vortex:EntIndex()
		local elapsed = 0
		local lastPos = pos
		local vortexRange = vortex.VortexRange or 384

		timer.Create(timerName, DAMAGE_TICK_INTERVAL, 0, function()
			elapsed = elapsed + DAMAGE_TICK_INTERVAL

			-- vortex hala gecerliyse normal tick hasarini uygula ve konumu guncelle
			if IsValid(vortex) and elapsed < (vortex.LifeTime or 3) then
				lastPos = vortex:GetPos()
				local range = vortexRange * DAMAGE_RANGE_MULT

				for _, ent in pairs(ents.FindInSphere(lastPos, range)) do
					if IsValid(ent) and (ent:IsPlayer() or ent:IsNPC()) then
						local dmg = DamageInfo()
						dmg:SetDamage(DAMAGE_PER_TICK)
						dmg:SetAttacker(IsValid(owner) and owner or vortex)
						dmg:SetInflictor(vortex)
						dmg:SetDamageType(DMG_ENERGYBEAM)
						ent:TakeDamageInfo(dmg)
					end
				end

				return
			end

			-- vortex yok oldu (ya da suresi doldu) - tek seferlik patlama hasari
			timer.Remove(timerName)

			local burstRange = vortexRange * BURST_RANGE_MULT
			for _, ent in pairs(ents.FindInSphere(lastPos, burstRange)) do
				if IsValid(ent) and (ent:IsPlayer() or ent:IsNPC()) then
					local dmg = DamageInfo()
					dmg:SetDamage(BURST_DAMAGE)
					dmg:SetAttacker(IsValid(owner) and owner or game.GetWorld())
					dmg:SetInflictor(game.GetWorld())
					dmg:SetDamageType(DMG_BLAST)
					ent:TakeDamageInfo(dmg)
				end
			end
		end)
	end)
end

HpwRewrite:AddSpell("Test Buyusu 2", Spell)