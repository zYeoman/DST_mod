local _klaus = {}

function _klaus.run(inst, healthrate, regenrate, abosoprate)

    local change_num = 1

    local function DoSpawnCircle(inst)

        local x0, y0, z0 = inst.Transform:GetWorldPosition()
        local radius = 8 + math.random(0, 4)
        for i = 1, 8 do
            --print("for is working")
            --注意：sin的输入在(-PI,PI)，cos的输入在[-PI,PI]
            local x = x0 + radius * (math.sin(math.rad((359 / 8 * i) - 180)))
            local z = z0 + radius * (math.cos(math.rad((359 / 8 * i) - 180)))
            local y = y0
            --print(x)
            --print(y)
            --print(z)
            --print("working")
            --print(change_num)
            local flag = change_num % 2
            if i % 2 == flag then

                local fire_charge = SpawnPrefab("deer_fire_charge")
                fire_charge.Transform:SetPosition(x, y, z)
                fire_charge:DoTaskInTime(1, function(fire_charge)
                    fire_charge:Remove()
                    local fire_circle = SpawnPrefab("deer_fire_circle")
                    fire_circle.Transform:SetPosition(x, 0, z)
                    fire_circle:DoTaskInTime(5, function(fire_circle)
                        fire_circle:Remove()
                    end)
                end)

            else

                local ice_charge = SpawnPrefab("deer_ice_charge")
                ice_charge.Transform:SetPosition(x, y, z)
                ice_charge:DoTaskInTime(1, function(ice_charge)
                    ice_charge:Remove()
                    local ice_circle = SpawnPrefab("deer_ice_circle")
                    ice_circle.Transform:SetPosition(x, 0, z)
                    ice_circle:DoTaskInTime(5, function(ice_circle)
                        ice_circle:Remove()
                    end)
                end)
            end
        end

    end

    local function OnPeriodicTask(inst)
        inst:DoTaskInTime(1, function(inst)
            DoSpawnCircle(inst)
        end)
        change_num = change_num + 1
    end

    healthrate = healthrate or nil
    regenrate = regenrate or nil
    abosoprate = abosoprate or nil
    inst:DoPeriodicTask(8, OnPeriodicTask)
    inst.components.health:SetAbsorptionAmount(abosoprate)
end
return _klaus