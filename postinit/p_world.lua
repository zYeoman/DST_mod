--
-- p_world.lua
-- Copyright (C) 2019 Yongwen Zhuang <zeoman@163.com>
--
-- Distributed under terms of the MIT license.
--
-- 添加天劫系统
-- 添加工资系统

AddPrefabPostInit("world", function(inst)
  local function gongzi(v)
    if v.components.seplayerstatus then
      local cycles1 = TheWorld.state.cycles
      local cycles2 = v.components.age:GetAgeInDays()*20
      if v.components.seplayerstatus.coin <= 1000 then
        v.components.seplayerstatus:DoDeltaCoin(math.max(cycles1, cycles2, 200))
      end
    end
  end
  -- inst:WatchWorldState("cycles", gongzi)
  inst:ListenForEvent("cycleschanged", function(inst, data)
    for k,v in pairs(AllPlayers) do
      gongzi(v)
      if v and v.components.oldfish and v.components.oldfish.level % 250 == 0 then
        if math.random() < 0.6 and v.components.combat.externaldamagetakenmultipliers:Get() > 0 then
          -- 天罚！
          if v.components.talker then
            v.components.talker:Say("好像有什么东西要来了")
          end
          v:DoTaskInTime(math.random(10,180), function() v.components.oldfish:punish() end)
        end
      end
    end
  end)
end)


