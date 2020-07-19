--
-- networking_say.lua
-- Copyright (C) 2020 Yongwen Zhuang <zyeoman@163.com>
--
-- Distributed under terms of the MIT license.
--
--
-- 聊天命令

local fns = {}
fns['ch'] = function (inst, chenghao)
  if chenghao ~= nil and chenghao ~= "" then
    if inst.components.seplayerstatus and inst.components.seplayerstatus.coin >= 100000 then
      inst.components.seplayerstatus:DoDeltaCoin(-100000)
      if inst.components.oldfish then
        inst.components.oldfish:SetName(chenghao, "custom")
      end
    end
    return false
  end
  return true
end
fns['称号'] = fns['ch']

fns['levelup'] = function(inst, _)
  if inst.components.inventory and inst.components.oldfish then
    local hasPart, count = inst.components.inventory:Has("oldfish_part_gem", 4)
    local totalcount = count
    while inst.oldfish_level:value()%250~=0 and hasPart and count > 4 do
      local exp_plus = 100 * inst.oldfish_level:value() * math.exp(-1 * inst.oldfish_level:value() / 900)
      inst.components.oldfish:DoDelta_exp(exp_plus)
      count = count - 4
    end
    inst.components.inventory:ConsumeByName("oldfish_part_gem", totalcount-count)
    return false
  end
  return true
end
fns['升级']=fns['levelup']

fns['wings'] = function (inst, chibang)
  if inst.components.seplayerstatus and inst.components.seplayerstatus.coin >= 100000 then
    inst.components.seplayerstatus:DoDeltaCoin(-100000)
    local wings = {"cbdz0","cbdz1","cbdz2","cbdz3","cbdz4","cbdz5","cbdz6","cbdz7","cbdz8"}
    local wing = SpawnPrefab(wings[math.random(#wings)])
    if inst.components.inventory and wing then
      inst.components.inventory:Equip(wing)
    end
    return false
  end
  return true
end
fns['翅膀'] = fns['wings']

fns['hutch'] = function(inst, _)
  -- hutch_fishbowl
  if inst.components.seplayerstatus and inst.components.seplayerstatus.coin >= 100000 then
    inst.components.seplayerstatus:DoDeltaCoin(-100000)
    local hutch_fishbowl = SpawnPrefab("hutch_fishbowl")
    if inst.components.inventory and hutch_fishbowl then
      inst.components.inventory:GiveItem(hutch_fishbowl)
    end
    return false
  end
  return true
end
fns['哈奇'] = fns['hutch']
fns['给我一只哈奇'] = fns['hutch']

fns['tp'] = function(inst, dest)
  if dest == nil or dest == "" then
    -- 回城到路灯位置
    for k,v in pairs(GLOBAL.Ents) do
      if v.prefab == "fyjiedeng" then
        if v.ownerlist and v.ownerlist.master == userid and v.ownerlist.jiahu then
          if inst.Physics ~= nil then
            inst.Physics:Teleport(v.Transform:GetWorldPosition())
          else
            inst.Transform:SetPosition(v.Transform:GetWorldPosition())
          end
          break
        end
      end
    end
  else
    -- 回城到具体木牌位置
    -- 比较麻烦，决定不搞了
    local num = tonumber(dest) or 0
    num = math.min(99, num)
    if inst.components.seplayerstatus and inst.components.seplayerstatus.coin >= 100*num then
      inst.components.seplayerstatus:DoDeltaCoin(-100*num)
      for i=1,num do
        local rtytp = SpawnPrefab("rtytp")
        if inst.components.inventory and rtytp then
          inst.components.inventory:GiveItem(rtytp)
        else
          break
        end
      end
    end
  end
  return true
end
fns['回城'] = fns['tp']

fns['bind'] = function(inst, _, name)
  local function bind(equip)
    if equip then
      if equip.GetShowItemInfo == nil then
        equip.components.statusinfo:Init()
      end
      if equip.onlyownerid == nil then
        equip.onlyownerid = userid
        equip.components.statusinfo:SetName("所有者："..name.."\n", "bind")
      else
        equip.onlyownerid = nil
        equip.components.statusinfo:SetName("", "bind")
      end
    end
  end
  -- 这里使用天涯百宝箱「天涯神杖」的权限设定。
  if inst.components.inventory then
    for idx,val in pairs(EQUIPSLOTS) do
      local equip = inst.components.inventory:GetEquippedItem(val)
      bind(equip)
    end
  end
end
fns['绑定'] = fns['bind']


local function Id2Player(id)
  local player = nil
  for k,v in pairs(GLOBAL.AllPlayers) do
    if v.userid == id then
      player = v
    end
  end
  return player
end


local OldNetworking_Say = GLOBAL.Networking_Say
GLOBAL.Networking_Say = function(guid, userid, name, prefab, message, colour, whisper, isemote)
  local inst = Id2Player(userid)
  if inst == nil then
    return OldNetworking_Say(guid, userid, name, prefab, message, colour, whisper, isemote)
  end
  local showoldsay = true
  if string.len(message)>1 and string.sub(message,1,1) == "#" then
    local commands = {}
    for command in string.gmatch(string.sub(message,2,string.len(message)), "%S+") do
      table.insert(commands, string.lower(command))
    end
    showoldsay = false
    if commands[1]~=nil and fns[commands[1]]~=nil then
      showoldsay = fns[commands[1]](inst, commands[2], name)
    end
  end
  if showoldsay then
    return OldNetworking_Say(guid, userid, name, prefab, message, colour, whisper, isemote)
  end
end

