local mis = require("ULmiscellaneous")
local StrongHealth = mis.StrongHealth
local GetInstName = mis.GetInstName

local _shadowchesspieces = {}

function _shadowchesspieces.run(inst, healthrate, regenrate, abosoprate)
    -- _shadowchesspieces need to override lootdropper function
    local function lootsetfn(lootdropper)
        local loot = {}

        if lootdropper.inst.level >= 2 then
            for i = 1, math.random(2, 3) do
                table.insert(loot, "nightmarefuel")
            end

            if lootdropper.inst.level >= 3 then
                table.insert(loot, "shadowheart")
                table.insert(loot, "nightmarefuel")
                --TODO: replace with shadow equipment drops
                table.insert(loot, "armor_sanity")
                table.insert(loot, "nightsword")

                table.insert(loot, "yellowgem")
                table.insert(loot, "yellowgem")
                table.insert(loot, "yellowgem")

                table.insert(loot, "greengem")
                table.insert(loot, "greengem")
                table.insert(loot, "greengem")

                table.insert(loot, "orangegem")
                table.insert(loot, "orangegem")
                table.insert(loot, "orangegem")

                table.insert(loot, "yellowstaff")
                table.insert(loot, "opalstaff")

                if IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then
                    table.insert(loot, GetRandomBasicWinterOrnament())
                end
            end
        end
        lootdropper:SetLoot(loot)
    end

    local function strongchesspieces(inst)
        inst:RemoveEventCallback("attacked", strongchesspieces)
        inst:DoTaskInTime((0.5 + math.random() * 0.5), StrongHealth(inst, healthrate, regenrate, abosoprate))

        if inst.components.lootdropper then
            inst.components.lootdropper:SetLootSetupFn(lootsetfn)
        end

        --等级为2时额外生成一个3级暗影
        --如果设置为等级3会多次触发，暂时解决不了
        if inst.level == 2 then
            local x, y, z = inst.Transform:GetWorldPosition()
            local shadow_R = math.random(0, 2)
            local shadow_boss = nil
            print(shadow_R)
            if shadow_R == 0 then
                shadow_boss = SpawnPrefab("shadow_bishop")
            elseif shadow_R == 1 then
                shadow_boss = SpawnPrefab("shadow_knight")
            elseif shadow_R == 2 then
                shadow_boss = SpawnPrefab("shadow_rook")
            end
            --升级到3级
            --这里会触发levelup事件，导致多次触发
            shadow_boss:LevelUp(3)
            StrongHealth(shadow_boss, healthrate, regenrate, abosoprate)

            if shadow_boss.components.lootdropper then
                shadow_boss.components.lootdropper:SetLootSetupFn(lootsetfn)
            end

            local bossname = GetInstName(shadow_boss)
            shadow_boss.Transform:SetPosition(0, 0, 0)

            shadow_boss:DoTaskInTime((0.5 + math.random() * 0.5), function(shadow_boss)
                shadow_boss.SoundEmitter:PlaySound("dontstarve/common/ghost_spawn")
                x, z = x + 2 * (math.random() + 1) * math.random(-1, 1), z + 2 * (math.random() + 1) * math.random(-1, 1)
                shadow_boss.Transform:SetPosition(x, 0, z)
                local fx = SpawnPrefab("statue_transition_2")
                if fx ~= nil then
                    fx.Transform:SetPosition(x, y, z)
                    fx.Transform:SetScale(1, 2, 1)
                end

                fx = SpawnPrefab("statue_transition")
                if fx ~= nil then
                    fx.Transform:SetPosition(x, y, z)
                    fx.Transform:SetScale(1, 1.5, 1)
                end
                TheNet:Announce("新的【 " .. bossname .. " 】前来突袭！")
                --单位：分钟
                local removedelay = 2
                local RemoveSJ = math.floor(60 * removedelay * (math.random() * .5 + .5))
                shadow_boss:DoTaskInTime(RemoveSJ, function(shadow_boss)
                    local fx = SpawnPrefab("statue_transition")
                    if fx ~= nil then
                        fx.Transform:SetPosition(x, 0, z)
                        fx.Transform:SetScale(1, 1.5, 1)
                    end
                    shadow_boss:Remove()
                    TheNet:Announce("前来突袭的【 " .. bossname .. "】已经消失！")
                end)
                local Y_F = math.floor((RemoveSJ - 3) / 60)
                local A_S = RemoveSJ - 3 - Y_F * 60
                local A_F = Y_F > 0 and Y_F .. " 分 " or ""
                shadow_boss:DoTaskInTime(3, function(shadow_boss)
                    TheNet:Announce("前来突袭的【 " .. bossname .. "】将在" .. A_F .. A_S .. " 秒后消失！")
                end)
            end)
        end
    end
    local function delaylevelup(inst)
        inst:ListenForEvent("attacked", strongchesspieces)
    end
    inst:ListenForEvent("levelup", delaylevelup)
end
return _shadowchesspieces