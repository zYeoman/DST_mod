--
-- c_alchmy_fur.lua
-- Copyright (C) 2019 Yongwen Zhuang <zyeoman@163.com>
--
-- Distributed under terms of the MIT license.
--

local function getspecialdescription(inst, viewer)
  local remainingtime = inst.components.stewer_fur.targettime ~= nil and inst.components.stewer_fur.targettime - GetTime() or 0
  if remainingtime > TUNING.TOTAL_DAY_TIME then
    return "还要炼"..math.floor(remainingtime/TUNING.TOTAL_DAY_TIME).."天"
  else
    return "还要炼"..math.floor(remainingtime).."秒"
  end
end

AddPrefabPostInit("alchmy_fur", function (inst)
  if inst.components.inspectable then
    inst.components.inspectable.getspecialdescription = getspecialdescription
  end
end)


