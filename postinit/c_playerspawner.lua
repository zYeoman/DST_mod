--
-- c_playerspawner.lua
-- Copyright (C) 2020 Yongwen Zhuang <zyeoman@163.com>
--
-- Distributed under terms of the MIT license.
--


local function PlayerSpawnerPostInit(PlayerSpawner, inst) 
  -- 玩家加入游戏 友好提示标语
  local origin = ""
  local function ListenForPlayerJoined(inst, player)
    local msg = '玩家 '..player.name..' 加入了游戏'
    if _G.send_qq_msg and origin~=msg then
      origin = msg
      _G.send_qq_msg(msg)
    end
  end

  --玩家离开游戏 离线自动掉落
  local function ListenForPlayerLeft(inst, player) 
    local msg = '玩家 '..player.name..' 离开了游戏'
    if _G.send_qq_msg and origin~=msg then
      origin = msg
      _G.send_qq_msg(msg)
    end
  end

  inst:ListenForEvent("ms_playerjoined", ListenForPlayerJoined)
  inst:ListenForEvent("ms_playerdespawn", ListenForPlayerLeft) 
end
AddComponentPostInit("playerspawner",PlayerSpawnerPostInit)
