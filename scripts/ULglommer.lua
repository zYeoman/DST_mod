local mis = require("ULmiscellaneous")
local GetInstName = mis.GetInstName
local GetAttacker = mis.GetAttacker

local _glommer = {}

function _glommer.run(inst)
    local function beigongji(inst, data)
        TheNet:Announce("〖 " .. GetInstName(inst) .. " 〗正在惨遭【 " .. GetAttacker(data) .. " 】的攻击")
    end
    --local OldOnSpawnFuel = OnSpawnFuel
    local function OnSpawnFuel(inst, fuel)
        --if OldOnSpawnFuel ~= nil then OldOnSpawnFuel(inst, fuel) end
        inst.sg:GoToState("goo", fuel)
        TheNet:Announce("【 " .. GetInstName(inst) .. " 】正在生产粘液")
    end
    inst:DoTaskInTime(.5, function(inst)
        TheNet:Announce("【 " .. GetInstName(inst) .. " 】出现了，快去领回家！")
    end)

    inst.components.health:StartRegen((math.random() * 2 + .5), .16)

    inst:ListenForEvent("attacked", beigongji)
    inst.components.periodicspawner:SetOnSpawnFn(OnSpawnFuel)
end
return _glommer
