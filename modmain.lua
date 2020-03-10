if not GLOBAL.TheNet:GetIsServer() then
    return
end

local fuel_rate = 2878.599999 / GetModConfigData("fuel_rate") --总燃料2878.599999

local function OnStartChanneling(inst, channeler)
    if not inst.components.fueled then
        inst.components.channelable:StopChanneling()
        return inst
    end
    if not inst.components.fueled.consuming then
        inst.components.channelable:StopChanneling()
        return inst
    end
    inst.components.fueled.rate = inst.components.fueled.rate + fuel_rate
    inst.channeler = channeler.components.sanity ~= nil and channeler or nil
    if inst.channeler ~= nil then
        inst.channeler.components.playerlightningtarget:DoStrike()
        inst.channeler.strike_task = inst.channeler:DoPeriodicTask(1,function(inst2)
            inst2.components.playerlightningtarget:DoStrike()
            if inst.components.fueled.rate < fuel_rate then
                inst.components.channelable:StopChanneling()
            end
        end)
    end
end

local function OnStopChanneling(inst, aborted)
    if inst.components.fueled and inst.components.fueled.rate >= fuel_rate then
        inst.components.fueled.rate = inst.components.fueled.rate - fuel_rate
    end
    if inst.channeler ~= nil and inst.channeler:IsValid() and inst.channeler.components.sanity ~= nil then
        if inst.channeler.strike_task ~= nil then
            inst.channeler.strike_task:Cancel()
            inst.channeler.strike_task = nil
        end
    end
end

local function DepletedFunc(inst)
    _depleted(inst)
    OnStopChanneling(inst)
    inst.components.channelable:StopChanneling()
end

local function AddFunc(inst)
    inst:AddComponent("channelable")
    inst.components.channelable:SetChannelingFn(OnStartChanneling, OnStopChanneling)
    if inst.components.fueled then
        _depleted = inst.components.fueled.depleted
        inst.components.fueled.depleted = DepletedFunc
    end
end

AddPrefabPostInit("winona_battery_high", AddFunc)