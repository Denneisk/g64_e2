
local function g64ClientReceive()
	if not libsm64.IsGlobalInit() then g64utils.GlobalInit() end
	local action = net.ReadString()
	if action == "PlayTrack" then
		PlayTrack(net.ReadInt(8))
	elseif action == "StopTrack" then
		StopAllTracks()
	elseif action == "SetHealth" then
		libsm64.SetMarioHealth(LocalPlayer().MarioEnt.MarioId, net.ReadInt(8)*256)
	elseif action == "Damage" then
		local mario = LocalPlayer().MarioEnt
		libsm64.MarioTakeDamage(mario.MarioId, net.ReadInt(8), 0, net.ReadVector())
	elseif action == "Heal" then
		libsm64.MarioHeal(LocalPlayer().MarioEnt.MarioId, net.ReadInt(8))
	elseif action == "AddLives" then
		local mario = LocalPlayer().MarioEnt
		libsm64.MarioSetLives(mario.MarioId, mario.marioNumLives + net.ReadInt(8))
	elseif action == "SetLives" then
		libsm64.MarioSetLives(LocalPlayer().MarioEnt.MarioId, net.ReadInt(8))
	elseif action == "EnableCap" then
		local cap = net.ReadString()
		if cap == "wing" then
			LocalPlayer().MarioEnt.EnableWingCap = true
		elseif cap == "metal" then
			LocalPlayer().MarioEnt.EnableMetalCap = true
		elseif cap == "vanish" then
			LocalPlayer().MarioEnt.EnableVanishCap = true
		end
	elseif action == "DisableCap" then
		local cap = net.ReadString()
		local mario = LocalPlayer().MarioEnt
		local state = mario.marioFlags
		if cap == "wing" then
			state = bit.band(state, bit.bnot(0x8))
			libsm64.SetMarioState(mario.MarioId, state)
		elseif cap == "metal" then
			state = bit.band(state, bit.bnot(0x4))
			libsm64.SetMarioState(mario.MarioId, state)
		elseif cap == "vanish" then
			state = bit.band(state, bit.bnot(0x2))
			libsm64.SetMarioState(mario.MarioId, state)
		end
	elseif action == "SetColor" then
		local index = net.ReadInt(4)
		local colorAtIndex = LocalPlayer().MarioEnt.colorTable[index]
		if colorAtIndex then
			local color = net.ReadVector()
			colorAtIndex[1] = color.r
			colorAtIndex[2] = color.g
			colorAtIndex[3] = color.b
		end
	end
end
net.Receive("G64_E2", g64ClientReceive)

E2Helper.Descriptions["g64PlayTrack(n)"] = "Plays one of the G64 music tracks for all players. The index is the exact same as you see it in the menu (Lakitu = 34)."
E2Helper.Descriptions["g64PlayTrack(s)"] = "Plays one of the G64 music tracks for all players. The name is the exact same as you see it in the menu."
E2Helper.Descriptions["g64StopAllTracks"] = "Stops all G64 music tracks for all players"
E2Helper.Descriptions["g64MakeMario"] = "Turns a player into Mario"
E2Helper.Descriptions["g64RemoveMario"] = "Turns a player back into normal"
E2Helper.Descriptions["g64MarioHealth"] = "Gets or sets the player's health"
E2Helper.Descriptions["g64MarioDamage"] = "Damages the player for the amount of health"
E2Helper.Descriptions["g64MarioDamage(e:nv)"] = "Damages the player for the amount of health with the damage origin local to the player"
E2Helper.Descriptions["g64MarioDamage(env)"] = "Damages the player for the amount of health with the damage origin local to the player"
E2Helper.Descriptions["g64MarioHeal"] = "Heals the player for a certain amount of health"
E2Helper.Descriptions["g64MarioSetLives"] = "Sets a player's lives"
E2Helper.Descriptions["g64MarioAddLives"] = "Adds to a player's lives"
E2Helper.Descriptions["g64MarioRemoveLives"] = "Removes a player's lives"
E2Helper.Descriptions["g64MarioEnableCap"] = "Give the player the 'wing', 'metal', or 'vanish' cap"
E2Helper.Descriptions["g64MarioDisableCap"] = "Removes the player's 'wing', 'metal', or 'vanish' cap"
E2Helper.Descriptions["g64MarioColor"] = "Temporarily sets the color of the clothing. The indexes are in the same order as seen in the G64 settings"