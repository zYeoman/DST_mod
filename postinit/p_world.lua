--
-- p_world.lua
-- Copyright (C) 2019 Yongwen Zhuang <zeoman@163.com>
--
-- Distributed under terms of the MIT license.
--
-- 添加天劫系统
--

local function punish(inst)
  -- 250级雷劫
  -- 500级火劫
  -- 750级风劫
  -- 1000级陨石劫
  local level = inst.components.oldfish.level
  local function the_punish(fn)
    inst._punish = inst._punish or 1
    inst._punish_task = inst._punish_task or inst:DoPeriodicTask(0.2, function()
      fn()
      inst._punish = inst._punish+1
      if inst:HasTag("playerghost") then
        inst._punish_task:Cancel()
        inst._punish_task = nil
      end
      if inst._punish >= level then
        inst._punish = 1
        inst._punish_task:Cancel()
        inst._punish_task = nil
        inst.components.oldfish.modifier = 1-level/1000
        inst.components.oldfish:DoDelta_level(1)
      end
    end)
  end
  if level == 250 then
    if inst.components.talker then
      inst.components.talker:Say("此乃天雷之灾，天降250道神雷劈我o((⊙﹏⊙))o.")
    end
    the_punish(function()
      local fx
      local x1, y1, z1 = inst.Transform:GetWorldPosition()
      local rad = math.random(2, 30)
      local angle = math.random() * 2 * PI
      local x2, y2, z2 = x1 + rad * math.cos(angle), y1, z1 + rad * math.sin(angle)
      fx = SpawnPrefab("lightning")
      if rad < 5 then
        fx.Transform:SetPosition(x1,y1,z1)
        inst.components.combat:GetAttacked(fx, 8, nil, "electric")
      else
        fx.Transform:SetPosition(x2,y2,z2)
      end
    end)
  elseif level == 500 then
    if inst.components.talker then
      inst.components.talker:Say("此乃阴火之灾，火灭不了啊o((⊙﹏⊙))o.")
    end
    the_punish(function()
      if inst.components.burnable then
        inst.components.burnable:Ignite()
        inst.components.burnable:SetBurnTime(10)
      end
    end)
  elseif level == 750 then
    if inst.components.talker then
      inst.components.talker:Say("此乃赑风之灾，风吹得我喘不过气o((⊙﹏⊙))o.")
    end
    the_punish(function()
      inst.components.health:DoDelta(-1, nil, nil, true)
    end)
  elseif level == 1000 then
    if inst.components.talker then
      inst.components.talker:Say("天道受不了啦，他乱扔石头砸我！o((⊙﹏⊙))o.")
    end
    the_punish(function()
      local pt = inst:GetPosition()
      local theta = math.random() * 2 * PI
      --spread the meteors more once the player is a ghost
      --increase the radius when the play is a ghost, avoiding destroying the player's dropped items.
      local radius = math.random(1, 25)
      local offset = FindWalkableOffset(pt, theta, radius, 12, true)
      if offset ~= nil then
        pt.x = pt.x + offset.x
        pt.z = pt.z + offset.z
      end
      SpawnPrefab("shadowmeteor").Transform:SetPosition(pt.x, 0, pt.z)
    end)
  end
end

AddPrefabPostInit("world", function(inst)
  inst:ListenForEvent("cycleschanged", function(inst, data)
    for k,v in pairs(AllPlayers) do
      if v and v.components.oldfish and v.components.oldfish.level % 250 == 0 then
        v.components.oldfish.modifier = 0
        if math.random() < 0.4 then
          -- 天罚！
          if v.components.talker then
            v.components.talker:Say("好像有什么东西要来了")
          end
          v:DoTaskInTime(math.random(10,180), punish)
        end
      end
    end
  end)
end)
