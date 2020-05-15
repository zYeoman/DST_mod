--
-- c_lootdropper.lua
-- Copyright (C) 2019 Yongwen Zhuang <zyeoman@163.com>
--
-- Distributed under terms of the MIT license.
--
-- 修改掉落在一定时间内消失

AddComponentPostInit("lootdropper", function(LootDropper)
  function LootDropper:SpawnLootPrefab(lootprefab, pt)
    if lootprefab ~= nil then
      local loot = SpawnPrefab(lootprefab)
      if loot ~= nil then
        if loot.components.inventoryitem ~= nil then
          if self.inst.components.inventoryitem ~= nil then
            loot.components.inventoryitem:InheritMoisture(self.inst.components.inventoryitem:GetMoisture(), self.inst.components.inventoryitem:IsWet())
          else
            loot.components.inventoryitem:InheritMoisture(TheWorld.state.wetness, TheWorld.state.iswet)
          end
        end

        -- here? so we can run a full drop loot?
        self:FlingItem(loot, pt)
        loot:ListenForEvent("onpickup", function()
          if loot._disappear then
            loot._disappear:Cancel()
          end
          if loot._disappear_anim then
            loot._disappear_anim:Cancel()
          end
          loot.AnimState:SetMultColour(1,1,1,0)
        end)
        loot:ListenForEvent("onputininventory", function()
          if loot._disappear then
            loot._disappear:Cancel()
          end
          if loot._disappear_anim then
            loot._disappear_anim:Cancel()
          end
          loot.AnimState:SetMultColour(1,1,1,0)
        end)
        local disappear_time = 480
        loot._disappear = loot:DoTaskInTime(disappear_time+40, function()
          loot:Remove()
        end)
        loot._disappear_anim = loot:DoTaskInTime(disappear_time, function()
          for j=1,30,2 do
            for i=10,3,-1 do
              loot:DoTaskInTime(j-i/10, function ()
                loot.AnimState:SetMultColour(i/10,i/10,i/10,i/10)
              end)
              loot:DoTaskInTime(j+i/10, function ()
                loot.AnimState:SetMultColour(i/10,i/10,i/10,i/10)
              end)
            end
          end
          for i=10,3,-1 do
            loot:DoTaskInTime(31-i/10, function ()
              loot.AnimState:SetMultColour(i/10,i/10,i/10,i/10)
            end)
          end
        end)
        return loot
      end
    end
  end
end)
