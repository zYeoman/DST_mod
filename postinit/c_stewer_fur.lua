--
-- c_stewer_fur.lua
-- Copyright (C) 2019 Yongwen Zhuang <zeoman@163.com>
--
-- Distributed under terms of the MIT license.
--
-- 修改炼丹炉使之支持炼制武器
--
--
local function gaussian (mean, variance)
  return  math.sqrt(-2 * variance * math.log(math.random())) *
          math.cos(2 * math.pi * math.random()) + mean
end
local types = {
  ["fire"]=1,       -- 火焰
  ["ice"]=1,        -- 冰霜
  ["lifesteal"]=2,  -- 吸血
  ["shrinker"]=1,   -- 减速
  ["crit"]=2,       -- 暴击
  ["vorpal"]=2,     -- 秒杀
  ["poison"]=2,     -- 剧毒
  ["sharp"]=2,      -- 锋锐
  ["dehealth"]=3,   -- 邪恶
  ["repair"]=4,     -- 再生
  ["grow"]=4,     -- 成长
  ["thorny"]=-1,    -- 带刺
  ["slippery"]=-1,  -- 湿滑
  ["disappear"]=-2, -- 残破
}
local desc = {
  ["fire"]="火焰",
  ["ice"]="冰霜",
  ["lifesteal"]="吸血",
  ["shrinker"]="减速",
  ["crit"]="暴击",
  ["vorpal"]="秒杀",
  ["poison"]="剧毒",
  ["sharp"]="锋锐",
  ["dehealth"]="邪恶",
  ["repair"]="再生",
  ["grow"]="成长",
  ["thorny"]="带刺",
  ["slippery"]="湿滑",
  ["disappear"]="残破",
}

local function randomchoice(t)
  local keys = {}
  for key, value in pairs(t) do
    keys[#keys+1] = key --Store keys in another table
  end
  index = keys[math.random(1, #keys)]
  return index, t[index], #keys
end

local function addtype(inst, tps, num)
  if inst.components.weapon == nil then
    return
  end
  inst.components.weapon.types = {}
  local key, value, size = randomchoice(tps)
  if size < num then
    for key, value in pairs(tps) do
      inst.components.weapon.types[key] = value
    end
  else
    local count = 0
    for i=1,num*10 do
      local key, value = randomchoice(tps)
      if inst.components.weapon.types[key] ~= value then
        inst.components.weapon.types[key] = value
        count = count + 1
        if count == num then
          return
        end
      end
    end
  end
end

local function cookcook(inst)
  local a = 960
  local b = 480
  local c = 180
  if inst:Has("minotaurhorn", 1) and inst:Has("bluegem", 1) and inst:Has("foliage", 1) and inst:Has("nitre", 1) then
    return "heat_resistant_pill" , a  --避暑
  elseif inst:Has("minotaurhorn", 1) and inst:Has("redgem", 1) and inst:Has("foliage", 1) and inst:Has("nitre", 1) then
    return "cold_resistant_pill" , a  --避寒丹
  elseif inst:Has("minotaurhorn", 1) and inst:Has("yellowgem", 1) and inst:Has("foliage", 1) and inst:Has("nitre", 1) then
    return "dust_resistant_pill" , a --避尘丹
  elseif inst:Has("heat_resistant_pill", 1) and inst:Has("bluegem", 1) and inst:Has("foliage", 1) and inst:Has("nitre", 1) then
    return "heat_resistant_pill" , b  --避暑重置
  elseif inst:Has("cold_resistant_pill", 1) and inst:Has("redgem", 1) and inst:Has("foliage", 1) and inst:Has("nitre", 1) then
    return "cold_resistant_pill" , b  --避寒重置
  elseif inst:Has("dust_resistant_pill", 1) and inst:Has("yellowgem", 1) and inst:Has("foliage", 1) and inst:Has("nitre", 1) then
    return "dust_resistant_pill" , b --避尘重置
  elseif inst:Has("nitre", 1) and inst:Has("dragonfruit", 1) and inst:Has("honey", 1) and inst:Has("nightmarefuel", 1) then
    return "fly_pill" , c --腾云
  elseif inst:Has("purplegem", 1) and inst:Has("livinglog", 1) and inst:Has("batwing", 1) and inst:Has("nightmarefuel", 1) then
    return "bloodthirsty_pill" , c --嗜血
  elseif inst:Has("gunpowder", 1) and inst:Has("stinger", 1) and inst:Has("durian", 1) and inst:Has("nightmarefuel", 1) then
    return "condensed_pill" , c --凝神
    elseif inst:Has("garlic", 2) and inst:Has("rocks", 1) and inst:Has('boneshard',1) then
        return "armor_pill", 60--壮骨
		
    elseif inst:Has("papyrus", 2) and inst:Has("featherpencil", 1) and inst:Has('petals',1) then
        return "laozi_sp", 10--
		
    elseif inst:Has("armor_bramble", 2) and inst:Has("cactus_flower", 2) then
        return "thorns_pill", c --荆棘甲
  elseif inst:Has("redgem", 1) and inst:Has("goose_feather", 3) then
    return "mk_hualing" , 60 --花翎

  elseif inst:Has("bigpeach", 1) and inst:Has("rocks", 2) and inst:Has("shadowheart", 1) then
    return "mk_huoyuan" , 60 --火猿石心

  elseif inst:Has("bearger_fur", 1) and inst:Has("dragon_scales", 2) and inst:Has("shroom_skin", 1) then
    return "mk_longpi" , 60 --龙皮绸缎

  elseif inst:Has("mk_longpi", 1) and inst:Has("armorruins", 1) and inst:Has("mk_huoyuan", 1) and inst:Has("walrus_tusk", 1) then
    return "golden_armor_mk" , 240 --大圣锁子甲

  elseif inst:Has("golden_armor_mk", 1) and inst:Has("redgem", 1) and inst:Has("bluegem", 1) and inst:Has("purplegem", 1) then
    return "golden_armor_mk" , 120 --重练大圣锁子甲

  elseif inst:Has("mk_hualing", 2) and inst:Has("ruinshat", 1) and inst:Has("orangemooneye", 1) then
    return "golden_hat_mk" , 240 --凤翅紫金冠
  elseif inst:Has("golden_hat_mk", 1) and inst:Has("redgem", 1) and inst:Has("bluegem", 1) and inst:Has("purplegem", 1) then
    return "golden_hat_mk" , 120 --重练凤翅紫金冠

    elseif inst:Has("laozi_sp", 1) and inst:Has("goldnugget", 1) and (inst:Has("orangegem", 1) or inst:Has("orangeamulet",1)) and inst:Has("pill_bottle_gourd", 1) then
        return "purple_gourd", 960 --紫金葫芦
  else
    local i = 0
    local value = 0
    local dmg = 0
    for k = 1, inst.numslots do
      local item = inst:GetItemInSlot(k)
      if item and item.components.weapon then
        for k,v in pairs(item.components.weapon.types or {}) do
          value = value + types[k]*v
        end
        dmg = dmg + item.components.weapon.damage or 0
        i = i+1
      end
    end
    if i < 4 then
      return nil, 1.5
    else
      return "weapon", 1+value*15+dmg/4
    end
  end
  return nil , 1.5
end
local function dobad(inst, self) --over
  self.task = nil
  if self.puff ~= nil then
    self.puff:Cancel()
    self.puff = nil
  end
  self.targettime = nil

  if self.ondobad ~= nil then
    self.ondobad(inst)
  end
  self.done = nil
  if inst.components.container then
    inst.components.container.canbeopened = true
  end
end
local function dostew(inst, self) --over
  self.task = nil
  if self.puff ~= nil then
    self.puff:Cancel()
    self.puff = nil
  end
  self.targettime = nil

  if self.ondonecooking ~= nil then
    self.ondonecooking(inst)
  end
  self.done = true
end
local function dopuff(inst, self)
  local pt = Vector3(inst.Transform:GetWorldPosition())
  local mk_cloudpuff = SpawnPrefab( "mk_cloudpuff" )
  mk_cloudpuff.Transform:SetPosition( pt.x , pt.y + 1, pt.z)
  mk_cloudpuff:DoTaskInTime(3,function() mk_cloudpuff:Remove()end)
  self.puff = inst:DoTaskInTime(math.random(5,8), dopuff, self)
end

AddComponentPostInit("stewer_fur", function(Stewer_Fur)
  function Stewer_Fur:StartCooking()
    if self.targettime == nil and self.inst.components.container ~= nil then
      self.done = nil

      if self.onstartcooking ~= nil then
        self.onstartcooking(self.inst)
      end
      local cooktime = 1
      self.product, cooktime = cookcook(self.inst.components.container) --"kabobs" ,  60 -- cooking.CalculateRecipe(self.inst.prefab, ings)
      self.cooktime = cooktime
      if self.product ~= nil then
        self.percent = nil
        self.targettime = GetTime() + cooktime
        if self.task ~= nil then
          self.task:Cancel()
        end
        self.task = self.inst:DoTaskInTime(cooktime, dostew, self)

        if self.puff ~= nil then
          self.puff:Cancel()
        end
        self.puff = self.inst:DoTaskInTime(math.random(5,8), dopuff, self)
        self.inst.components.container:Close()
        --self.inst.components.container:DestroyContents()
        for k = 1, self.inst.components.container.numslots do
          local item = self.inst.components.container:GetItemInSlot(k)
          if item ~= nil then
            if item:HasTag("mk_pills") then
              self.percent = item.components.fueled and item.components.fueled:GetPercent() or 1
            end
          end
        end
        self.inst.components.container.canbeopened = false

      else
        self.targettime = 1.5
        self.product = nil
        self.percent = nil
        if self.task ~= nil then
          self.task:Cancel()
        end

        if self.puff ~= nil then
          self.puff:Cancel()
        end
        self.task = self.inst:DoTaskInTime(1.5, dobad, self)

        self.inst.components.container:Close()
        self.inst.components.container:DestroyContents()
        self.inst.components.container.canbeopened = false
      end
    end
  end
  function Stewer_Fur:Harvest(harvester)
    if self.inst.ownerlist ~= nil and self.inst.ownerlist.master ~= nil then
      local masterId = self.inst.ownerlist.master
      local guestId = harvester.userid
      if masterId == guestId or (
        _G.TheWorld.guard_authorization ~= nil
        and _G.TheWorld.guard_authorization[masterId] ~= nil
        and _G.TheWorld.guard_authorization[masterId].friends
        and _G.TheWorld.guard_authorization[masterId].friends[guestId]
        ) then
      else
        if harvester.components.talker then
          harvester.components.talker:Say("这是别人的武器，我不能动")
        end
        return
      end
    end
    if self.done then
      if self.onharvest ~= nil then
        self.onharvest(self.inst)
      end

      if self.product ~= nil then
        local loot = nil
        if self.product == "weapon" then
          local weapon_types = {}
          for k = 1, self.inst.components.container.numslots do
            local item = self.inst.components.container:GetItemInSlot(k)
            for k,v in pairs(item and item.components.weapon and item.components.weapon.types or {}) do
              weapon_types[k] = v + (weapon_types[k] or 0)
            end
          end
          if next(weapon_types) == nil then
            local key = randomchoice(types)
            weapon_types[key] = 1
          end
          loot = self.inst.components.container:RemoveItemBySlot(1)
          if loot and loot.components.weapon then
            addtype(loot, weapon_types, math.random(3,5))
            if loot.GetShowItemInfo == nil then
              loot.components.statusinfo:Init()
            end
            local extra_name = ""
            for key, value in pairs(loot.components.weapon.types) do
              extra_name = extra_name .. desc[key] .. ' : +' .. value ..'\n'
            end
            loot.components.statusinfo:SetName(extra_name, "stewer_fur")
            local damage = loot.components.weapon.damage/2
            local origin = loot.components.weapon.externaldamage and loot.components.weapon.externaldamage:CalculateModifierFromSource("stewer") or 0
            local remainingtime = self.targettime ~= nil and self.targettime - GetTime() or 0
            local cooktime = self.cooktime and self.cooktime or (remainingtime + 1)
            -- 神奇的算法。其实就是求和除2，但是不会使伤害降低
            damage = 2*origin - damage
            for i = 2, self.inst.components.container.numslots do
              local item = self.inst.components.container:RemoveItemBySlot(i)
              if item ~= nil then
                damage = damage + item.components.weapon.damage/2
                item:Remove()
              end
            end
            local min = math.min(damage, origin)
            local max = math.max(damage, origin)
            local target = (max-min)*(1-remainingtime/cooktime)*(gaussian(0.8, 0.03))+min
            loot.components.weapon:SetDamage(math.max(target, min), "stewer")
          end
        else
          loot = SpawnPrefab(self.product)
        end
        if loot ~= nil then
          local stacksize =  1
          if stacksize > 1 then
            loot.components.stackable:SetStackSize(stacksize)
          end
          if  self.percent ~= nil and loot.components.fueled ~= nil   then
            loot.components.fueled:SetPercent(self.percent + 0.5)
          end
          if harvester ~= nil and harvester.components.inventory ~= nil then
            harvester.components.inventory:GiveItem(loot, nil, self.inst:GetPosition())
          else
            LaunchAt(loot, self.inst, nil, 1, 1)
          end
        end
        self.inst.components.container:DestroyContents()
        self.product = nil
        self.percent = nil
      end

      if self.task ~= nil then
        self.task:Cancel()
        self.task = nil
      end
      if self.puff ~= nil then
        self.puff:Cancel()
        self.puff = nil
      end
      self.targettime = nil
      self.done = nil

      if self.inst.components.container ~= nil then
        self.inst.components.container.canbeopened = true
      end
      return true
    end
  end
end)
