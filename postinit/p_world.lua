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
      local gongzi = TUNING.DAILY_MONEY
      if v.components.seplayerstatus.coin + gongzi < 0 then
        -- 踢回人间
        v.components.talker:Say("租金不够辣，再不挣钱就要被踢走了！倒计时4分钟")
        v:DoTaskInTime(4*60,function()
          if v.components.seplayerstatus.coin + gongzi < 0 then
            inst:PushEvent("ms_playerdespawnandmigrate",
                  { player = v, portalid = 1, worldid = 10 })
          else 
            v.components.seplayerstatus:DoDeltaCoin(gongzi)
          end
        end)
      else
        v.components.seplayerstatus:DoDeltaCoin(gongzi)
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

if GLOBAL.TheShard:GetShardId()=="1" then
  _G.yeo_first_start = 1
  if _G.OnSimPaused ~= nil then
    local oldOnSimPaused = _G.OnSimPaused
    _G.OnSimPaused = function()
      print("OnSimPaused called")
      local msg=""
      if _G.yeo_first_start==1 then
        msg ="服务器启动完成"
        _G.yeo_first_start=0
      else
        msg = "服务器空了"
      end
      if _G.pending_restart == 1 then
        msg = msg.."，重启中"
        -- TheWorld:PushEvent("ms_save")
        TheSystemService:EnableStorage(true)
        SaveGameIndex:SaveCurrent(Shutdown, true)
      end
      if _G.send_qq_msg then
        _G.send_qq_msg("服务器空了")
      end
      oldOnSimPaused()
    end
  end

  _G.pending_restart = 0
  _G.pendrestart = function ()
    print("Restart Pending")
    _G.pending_restart = 1
  end
end
