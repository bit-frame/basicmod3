local MessagingService = game:GetService("MessagingService")

--// Default Configuration //
local channelId = "BasicMod3"


--// MainModule //

local v3 = {}

function v3.begin(channel)
	channelId = channel
	local success, connection = pcall(function()
		return MessagingService:SubscribeAsync(channelId, v3.onRequest)
	end)

	if success then
		print("[BasicMod3] Connected to channelId: " .. channelId)
	else
		warn("[BasicMod3] Failed to connect to channelId: " .. tostring(connection))
	end
end

function v3.onRequest(message)
	local success, data = pcall(function()
		return game:GetService("HttpService"):JSONDecode(message.Data)
	end)

	if success then
		print("Message received and decoded:")
		for key, value in pairs(data) do
			print(key .. ": " .. tostring(value))
		end
		
		if data.cmd == "kick" then
			local target = game.Players:FindFirstChild(data.target)
			if target then
				local reason = data.reason
				local kick = v3.kick(target.Name, reason)
				if kick then
					print("[BasicMod3] Successfully kicked "..target.Name..". "..reason)
				else
					warn("[BasicMod3] Failed to kick "..target.Name)
				end
			end
		end
	else
		warn("Failed to decode message: " .. tostring(message.Data))
	end
end

function v3.kick(target, reason)
	local plr = game.Players:FindFirstChild(target)
	if plr then
		plr:Kick(reason)
		return true
	else
		return false
	end
end

return v3
