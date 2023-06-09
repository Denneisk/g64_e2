
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
	elseif action == "SetColor" then
		local index = net.ReadInt(4)
		local colorAtIndex = LocalPlayer().MarioEnt.colorTable[index]
		if colorAtIndex then
			local color = net.ReadVector()
			colorAtIndex[1] = color.r
			colorAtIndex[2] = color.g
			colorAtIndex[3] = color.b
		end
	elseif action == "SetPos" then
		local pos = Vector(net.ReadFloat(), net.ReadFloat(), net.ReadFloat())
		local mario = LocalPlayer().MarioEnt
		local spin = net.ReadBool()
		if mario.MarioId then
			libsm64.SetMarioPosition(mario.MarioId, pos)
			if spin ~= false then libsm64.SetMarioAction(mario.MarioId, 0x1924) end
		end
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
	elseif action == "PlaySound" then
		local sound = net.ReadString()
		if sound == "raw" then
			libsm64.PlaySoundGlobal(net.ReadInt(32))
			return
		end
		sound = g64types.SM64SoundTable[sound]
		local index = net.ReadInt(8)
		if sound then
			if istable(sound) then
				if sound[1] == 8 then sound[1] = 3
				elseif sound[1] == 9 then sound[1] = 5 end
			end
			libsm64.PlaySoundGlobal(GetSoundArg(sound) + (index ~= 0 and bit.lshift(index, 16) or 0))
		end
	end
end
net.Receive("G64_E2", g64ClientReceive)

E2Helper.Descriptions["g64PlayTrack(n)"] = "Plays one of the G64 music tracks for all players. The index is the exact same as you see it in the menu (Lakitu = 34)."
E2Helper.Descriptions["g64PlayTrack(s)"] = "Plays one of the G64 music tracks for all players. The name is the exact same as you see it in the menu."
E2Helper.Descriptions["g64StopAllTracks"] = "Stops all G64 music tracks for all players"
E2Helper.Descriptions["g64PlaySound(s)"] = "Plays one of the G64 sounds for all players. You can find a list of sounds in g64/lua/includes/g64_types."
E2Helper.Descriptions["g64PlaySound(sn)"] = "Plays one of the G64 sounds for all players, with the added index for variation. You can find a list of sounds in g64/lua/includes/g64_types."
E2Helper.Descriptions["g64PlaySoundRaw(n)"] = "Plays one of the G64 sounds for all players based on the actual address. You should only use this if you know what you're doing."
E2Helper.Descriptions["g64MakeMario"] = "Turns a player into Mario"
E2Helper.Descriptions["g64RemoveMario"] = "Turns a player back into normal"
E2Helper.Descriptions["g64IsMario"] = "Returns 1 if the player is Mario, otherwise returns 0"
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
E2Helper.Descriptions["g64MarioSetPos"] = "Sets Mario's position"
E2Helper.Descriptions["g64MarioSetPos(e:vn)"] = "Sets Mario's position. If spin is nonzero then Mario will spin as he falls as if he was spawned"
E2Helper.Descriptions["g64MarioGetPos"] = "Gets Mario's position. Note that this may not always be accurate with Mario's position for the player"
E2Helper.Descriptions["g64MarioTeleport"] = "Teleports mario instantly. This should be equivalent to SetPos, but may be more reliable."
E2Helper.Descriptions["g64Spawn1Up"] = "Spawns a 1-Up at the position."
E2Helper.Descriptions["g64SpawnCoin"] = "Spawns a yellow coin at the position."
E2Helper.Descriptions["g64SpawnRedCoin"] = "Spawns a red coin at the position."
E2Helper.Descriptions["g64SpawnBlueCoin"] = "Spawns a blue coin at the position."
E2Helper.Descriptions["g64SpawnCap"] = "Spawns a 'wing', 'metal', or 'vanish' cap at the position."