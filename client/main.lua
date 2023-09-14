local resultReceived = false
local p = nil

RegisterNUICallback('callback', function(data, cb)
    SetNuiFocus(false, false)
    resultReceived = true
    if data.success then
        p:resolve(true)
    else
        p:resolve(false)
    end
    p = nil
    cb('ok')
end)


local function hacking(cb, dots, time)
    resultReceived = false
    p = promise.new()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open',
        dots = dots,
        time = time
    })
    local result = Citizen.Await(p)
    cb(result)
end

exports("hacking", hacking)

RegisterCommand('ut', function(source, args)
    exports['ol-untangle']:hacking(function(success)
        if success then
            print("success")
		else
			print("fail")
		end
    end, 7, 30) -- amount of does (int), time
end, false)