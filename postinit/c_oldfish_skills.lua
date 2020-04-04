--
-- c_oldfish_skills.lua
-- Copyright (C) 2019 Yongwen Zhuang <zyeoman@163.com>
--
-- Distributed under terms of the MIT license.
--
--
-- 修改诸神黄昏技能

AddPlayerPostInit(function(inst)
    if inst.components.combat == nil then
        return
    end
    local old_start = inst.components.combat.StartAttack
    inst.components.combat.StartAttack = function(self)
        old_start(self)
        if self.target and self.inst.skills_oldfish_moment:value() ~= 0 then
            local weapon = self:GetWeapon()
            local hitrange = weapon and weapon.components.weapon.hitrange or 1
            local distance = math.sqrt(self.inst:GetDistanceSqToInst(self.target))
            if distance > hitrange then
                --   local smoke1 = SpawnPrefab("maxwell_smoke")
                local smoke2 = GLOBAL.SpawnPrefab("explode_firecrackers")
                local sx, sy, sz = self.inst.Transform:GetWorldPosition()
                --   smoke1.Transform:SetPosition(sx, sy, sz)
                local fx, fy, fz = self.target.Transform:GetWorldPosition()
                local q = (distance - hitrange + 0.2) / distance
                local dx = sx - q * (sx - fx)
                local dy = sy - q * (sy - fy)
                local dz = sz - q * (sz - fz)
                inst.Transform:SetPosition(dx, dy, dz)
                smoke2.Transform:SetPosition(dx, dy, dz)
            end
        end
    end
end)
