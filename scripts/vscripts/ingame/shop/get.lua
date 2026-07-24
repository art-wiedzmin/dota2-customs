--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function Shop:GetEquippedPetKey(ID)
    if not ID or not self.Data[ID] or not self.Data[ID].bag then
        return nil
    end
    local loadout = self.Data[ID].bag.loadout
    if not loadout then
        return nil
    end
    local key = loadout.equipped_pet
    if key == nil or key == "" then
        return nil
    end
    return key
end

function Shop:GetEquippedPetModelPath(ID)
    local key = self:GetEquippedPetKey(ID)
    if not key then
        return nil
    end
    local meta = self.ItemList and self.ItemList[key]
    if meta and meta.modelPath then
        return meta.modelPath
    end
    return nil
end

function Shop:GetPetParticle(item_key)
    if not item_key then
        return nil
    end
    local meta = self.ItemList and self.ItemList[item_key]
    if meta and meta.petParticle and meta.petParticle ~= "" then
        return meta.petParticle
    end
    return nil
end

function Shop:GetEquippedPetParticle(ID)
    local key = self:GetEquippedPetKey(ID)
    if not key then
        return nil
    end
    return self:GetPetParticle(key)
end

--- 局内创建宠物单位名（与 ItemList.previewUnit / npc_units_custom 一致）
function Shop:GetEquippedPetUnitName(ID)
    local key = self:GetEquippedPetKey(ID)
    if not key then
        return "CardPet"
    end
    local meta = self.ItemList and self.ItemList[key]
    if meta and meta.previewUnit and meta.previewUnit ~= "" then
        return meta.previewUnit
    end
    if key == "pet_ti10_rosh" then
        return "CardPetTi10"
    end
    return "CardPet"
end

function Shop:ShouldShowInGamePet(ID)
    local key = self:GetEquippedPetKey(ID)
    if not key then
        return false
    end
    local meta = self.ItemList and self.ItemList[key]
    if meta and meta.slot and meta.slot ~= "pet" then
        return false
    end
    return true
end

function Shop:GetEquippedTitleKey(ID)
    if not ID or not self.Data[ID] or not self.Data[ID].bag then
        return nil
    end
    local loadout = self.Data[ID].bag.loadout
    if not loadout then
        return nil
    end
    local key = loadout.equipped_title
    if key == nil or key == "" then
        return nil
    end
    return key
end

function Shop:ShouldShowInGameTitle(ID)
    local key = self:GetEquippedTitleKey(ID)
    if not key then
        return false
    end
    local meta = self.ItemList and self.ItemList[key]
    if meta and meta.slot and meta.slot ~= "title" then
        return false
    end
    return true
end

function Shop:GetTitleParticle(item_key)
    if not item_key then
        return nil
    end
    local meta = self.ItemList and self.ItemList[item_key]
    if meta and meta.titleParticle and meta.titleParticle ~= "" then
        return meta.titleParticle
    end
    if item_key == "title_clxx" then
        return "particles/clrb/clrb_equip_title_clxx_loop.vpcf"
    end
    if item_key == "title_wrnd" then
        return "particles/clrb/clrb_equip_title_wrnd_loop.vpcf"
    end
    if item_key == "title_whcl" then
        return "particles/clrb/clrb_equip_title_whcl_loop.vpcf"
    end
    if item_key == "title_clxz" then
        return "particles/clrb/clrb_equip_title_clxz_loop.vpcf"
    end
    if item_key == "title_wszs" then
        return "particles/clrb/clrb_equip_title_wszs_loop.vpcf"
    end
    if item_key == "title_hsbh" then
        return "particles/clrb/clrb_equip_title_hsbh_loop.vpcf"
    end
    if item_key == "title_hdlm" then
        return "particles/clrb/clrb_equip_title_hdlm_loop.vpcf"
    end
    if item_key == "title_ysqwh" then
        return "particles/clrb/clrb_equip_title_ysqwh_loop.vpcf"
    end
    if item_key == "title_rzlf" then
        return "particles/clrb/clrb_equip_title_rzlf_loop.vpcf"
    end
    if item_key == "title_clls" then
        return "particles/clrb/clrb_equip_title_clls_loop.vpcf"
    end
    if item_key == "title_cllr" then
        return "particles/clrb/clrb_equip_title_cllr_loop.vpcf"
    end
    if item_key == "title_clzw" then
        return "particles/clrb/clrb_equip_title_clzw_loop.vpcf"
    end
    if item_key == "title_clmy" then
        return "particles/clrb/clrb_equip_title_clmy_loop.vpcf"
    end
    if item_key == "title_clzy" then
        return "particles/clrb/clrb_equip_title_clzy_loop.vpcf"
    end
    if item_key == "title_xxqc" then
        return "particles/clrb/clrb_equip_title_xxqc_loop.vpcf"
    end
    if item_key == "title_rzzl" then
        return "particles/clrb/clrb_equip_title_rzzl_loop.vpcf"
    end
    return nil
end

function Shop:GetEquippedEffectKey(ID)
    if not ID or not self.Data[ID] or not self.Data[ID].bag then
        return nil
    end
    local loadout = self.Data[ID].bag.loadout
    if not loadout then
        return nil
    end
    local key = loadout.equipped_effect
    if key == nil or key == "" then
        return nil
    end
    return key
end

function Shop:ShouldShowInGameEffect(ID)
    local key = self:GetEquippedEffectKey(ID)
    if not key then
        return false
    end
    local meta = self.ItemList and self.ItemList[key]
    if meta and meta.slot and meta.slot ~= "effect" then
        return false
    end
    return true
end

function Shop:GetEffectParticle(item_key)
    if not item_key then
        return nil
    end
    local meta = self.ItemList and self.ItemList[item_key]
    if meta and meta.effectParticle and meta.effectParticle ~= "" then
        return meta.effectParticle
    end
    if item_key == "effect_tx1" then
        return "particles/econ/courier/courier_trail_lava/courier_trail_lava.vpcf"
    end
    return nil
end

function Shop:GetEquippedAttackEffectKey(ID)
    if not ID or not self.Data[ID] or not self.Data[ID].bag then
        return nil
    end
    local loadout = self.Data[ID].bag.loadout
    if not loadout then
        return nil
    end
    local key = loadout.equipped_attack_effect
    if key == nil or key == "" then
        return nil
    end
    return key
end

function Shop:ShouldShowInGameAttackEffect(ID)
    local key = self:GetEquippedAttackEffectKey(ID)
    if not key then
        return false
    end
    local meta = self.ItemList and self.ItemList[key]
    if meta and meta.slot and meta.slot ~= "attack_effect" then
        return false
    end
    return true
end

function Shop:GetAttackEffectModifierKey(item_key)
    if not item_key then
        return nil
    end
    local meta = self.ItemList and self.ItemList[item_key]
    if meta and meta.attackEffectKey and meta.attackEffectKey ~= "" then
        return meta.attackEffectKey
    end
    if item_key == "attack_lxhs" then
        return "atv2"
    end
    if item_key == "attack_atv3" then
        return "atv1"
    end
    return nil
end

--是否有月卡
function Shop:IsHaveCard(ID)
    if not ID then
        return
    end
    if self.Data[ID].card1 > 0 then
        return true
    end
end

--是否有季卡
function Shop:IsHaveCard2(ID)
    if not ID then
        return
    end
    if self.Data[ID].card2 > 0 then
        return true
    end
end

function Shop:GetCardXpPerLevel()
    if self.CardStaticData and self.CardStaticData.xp_per_level then
        return self.CardStaticData.xp_per_level
    end
    return 500
end

function Shop:GetCardMaxLevel()
    if self.CardStaticData and self.CardStaticData.max_level then
        return self.CardStaticData.max_level
    end
    return 200
end

function Shop:GetCardLevel(card)
    local exp = 0
    if card and card.exp ~= nil then
        exp = tonumber(card.exp) or 0
    end
    if exp < 0 then
        exp = 0
    end
    local xp_per = self:GetCardXpPerLevel()
    if xp_per <= 0 then
        xp_per = 500
    end
    return math.floor(exp / xp_per) + 1
end

-- 距满级还可购买的等级数
function Shop:GetRemainingBuyableLevels(ID)
    if not ID then
        return 0
    end
    local card = self.Data[ID] and self.Data[ID].card
    local cur = self:GetCardLevel(card)
    local max_lv = self:GetCardMaxLevel()
    local rem = max_lv - cur
    if rem < 0 then
        rem = 0
    end
    return rem
end
