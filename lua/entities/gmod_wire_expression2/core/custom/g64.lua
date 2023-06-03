E2Lib.RegisterExtension("g64", true, "Allows interaction with G64 using Expression2")

util.AddNetworkString("G64_E2")

if not g64_e2 then g64_e2 = {} end

local STRING_TO_TRACKID = { ["Star Catch Fanfare"] = 1,
		["Title Theme"] = 2,
		["Bob-Omb Battlefield"] = 3,
		["Inside the Castle Walls"] = 4,
		["Dire, Dire Docks"] = 5,
		["Lethal Lava Land"] = 6,
		["Koopa's Theme"] = 7,
		["Snow Mountain"] = 8,
		["Slider"] = 9,
		["Haunted House"] = 10,
		["Piranha Plant's Lullaby"] = 11,
		["Cave Dungeon"] = 12,
		["Star Select"] = 13,
		["Powerful Mario"] = 14,
		["Metallic Mario"] = 15,
		["Koopa's Message"] = 16,
		["Koopa's Road"] = 17,
		["High Score"] = 18,
		["Merry Go-Round"] = 19,
		["Race Fanfare"] = 20,
		["Star Spawn"] = 21,
		["Stage Boss"] = 22,
		["Koopa Clear"] = 23,
		["Looping Steps"] = 24,
		["Ultimate Koopa"] = 25,
		["Staff Roll"] = 26,
		["Correct Solution"] = 27,
		["Toad's Message"] = 28,
		["Peach's Message"] = 29,
		["Game Start"] = 30,
		["Ultimate Koopa Clear"] = 31,
		["Ending Demo"] = 32,
		["File Select"] = 33,
		["Lakitu"] = 34 }

local CAPS = { wing = true, metal = true, vanish = true }

__e2setcost(5)

-- Music

e2function void g64PlayTrack(number track)
	if track > 0 and track <= 34 then
		net.Start("G64_E2")
			net.WriteString("PlayTrack")
			net.WriteInt(track, 8)
		net.Broadcast()
	end
end

e2function void g64PlayTrack(string track)
	local track = STRING_TO_TRACKID[track]
	if track then
		net.Start("G64_E2")
			net.WriteString("PlayTrack")
			net.WriteInt(STRING_TO_TRACKID[track], 8)
		net.Broadcast()
	end
end

e2function void g64StopAllTracks()
	net.Start("G64_E2")
		net.WriteString("StopTrack")
	net.Broadcast()
end

-- Mario

e2function void g64MakeMario(entity player)
	if player:IsValid() and player:IsPlayer() then
		local mario = ents.Create("g64_mario")
		mario:SetPos(player:GetPos())
		mario:SetOwner(player)
		mario:Spawn()
		mario:Activate()
	end
end

e2function void entity:g64MakeMario()
	if this:IsValid() and this:IsPlayer() then
		local mario = ents.Create("g64_mario")
		mario:SetPos(this:GetPos())
		mario:SetOwner(this)
		mario:Spawn()
		mario:Activate()
	end
end

e2function void g64RemoveMario(entity player)
	if player:IsValid() and player:IsPlayer() and IsValid(player.MarioEnt) then
		player.MarioEnt:Remove()
	end
end

e2function void entity:g64RemoveMario()
	if this:IsValid() and this:IsPlayer() and IsValid(this.MarioEnt) then
		this.MarioEnt:Remove()
	end
end

e2function number entity:g64IsMario()
	return this:IsValid() and this.IsMario and 1 or 0
end

-- Health

e2function number g64MarioHealth(entity player)
	if player:IsValid() and player:IsPlayer() and IsValid(player.MarioEnt) then
		return player:Health()
	end
end

e2function number entity:g64MarioHealth()
	if this:IsValid() and this:IsPlayer() and IsValid(this.MarioEnt) then
		return this:Health()
	end
end

e2function void g64MarioHealth(entity player, number health)
	if player:IsValid() and player:IsPlayer() and IsValid(player.MarioEnt) then
		net.Start("G64_E2")
			net.WriteString("SetHealth")
			net.WriteInt(math.Clamp(health, 0, 8), 8)
		net.Send(player)
		player:SetHealth(health)
	end
end

e2function void entity:g64MarioHealth(number health)
	if this:IsValid() and this:IsPlayer() and IsValid(this.MarioEnt) then
		net.Start("G64_E2")
			net.WriteString("SetHealth")
			net.WriteInt(math.Clamp(health, 0, 8), 8)
		net.Send(this)
		this:SetHealth(health)
	end
end

e2function void g64MarioDamage(entity player, number health)
	if player:IsValid() and player:IsPlayer() and IsValid(player.MarioEnt) then
		net.Start("G64_E2")
			net.WriteString("Damage")
			net.WriteInt(math.Clamp(health, 0, 8), 8)
			net.WriteVector(vector_origin)
		net.Send(player)
	end
end

e2function void entity:g64MarioDamage(number health)
	if this:IsValid() and this:IsPlayer() and IsValid(this.MarioEnt) then
		net.Start("G64_E2")
			net.WriteString("Damage")
			net.WriteInt(math.Clamp(health, 0, 8), 8)
			net.WriteVector(vector_origin)
		net.Send(this)
	end
end

e2function void g64MarioDamage(entity player, number health, vector origin)
	if player:IsValid() and player:IsPlayer() and IsValid(player.MarioEnt) then
		net.Start("G64_E2")
			net.WriteString("Damage")
			net.WriteInt(math.Clamp(health, 0, 8), 8)
			net.WriteVector(origin)
		net.Send(player)
	end
end

e2function void entity:g64MarioDamage(number health, vector origin)
	if this:IsValid() and this:IsPlayer() and IsValid(this.MarioEnt) then
		net.Start("G64_E2")
			net.WriteString("Damage")
			net.WriteInt(math.Clamp(health, 0, 8), 8)
			net.WriteVector(origin)
		net.Send(this)
	end
end

e2function void g64MarioHeal(entity player, number health)
	if player:IsValid() and player:IsPlayer() and IsValid(player.MarioEnt) then
		net.Start("G64_E2")
			net.WriteString("Heal")
			net.WriteInt(math.Clamp(health, -8, 8), 8)
		net.Send(player)
	end
end

e2function void entity:g64MarioHeal(number health)
	if this:IsValid() and this:IsPlayer() and IsValid(this.MarioEnt) then
		net.Start("G64_E2")
			net.WriteString("Heal")
			net.WriteInt(math.Clamp(health, -8, 8), 8)
		net.Send(this)
	end
end

-- Lives

e2function void g64MarioSetLives(entity player, number lives)
	if player:IsValid() and player:IsPlayer() and IsValid(player.MarioEnt) then
		net.Start("G64_E2")
			net.WriteString("SetLives")
			net.WriteInt(lives, 8)
		net.Send(player)
	end
end

e2function void entity:g64MarioSetLives(number lives)
	if this:IsValid() and this:IsPlayer() and IsValid(this.MarioEnt) then
		net.Start("G64_E2")
			net.WriteString("SetLives")
			net.WriteInt(lives, 8)
		net.Send(this)
	end
end

e2function void g64MarioAddLives(entity player, number lives)
	if player:IsValid() and player:IsPlayer() and IsValid(player.MarioEnt) then
		net.Start("G64_E2")
			net.WriteString("AddLives")
			net.WriteInt(lives, 8)
		net.Send(player)
	end
end

e2function void entity:g64MarioAddLives(number lives)
	if this:IsValid() and this:IsPlayer() and IsValid(this.MarioEnt) then
		net.Start("G64_E2")
			net.WriteString("AddLives")
			net.WriteInt(lives, 8)
		net.Send(this)
	end
end

e2function void g64MarioRemoveLives(entity player, number lives)
	if player:IsValid() and player:IsPlayer() and IsValid(player.MarioEnt) then
		net.Start("G64_E2")
			net.WriteString("AddLives")
			net.WriteInt(-lives, 8)
		net.Send(player)
	end
end

e2function void entity:g64MarioRemoveLives(number lives)
	if this:IsValid() and this:IsPlayer() and IsValid(this.MarioEnt) then
		net.Start("G64_E2")
			net.WriteString("AddLives")
			net.WriteInt(-lives, 8)
		net.Send(this)
	end
end

-- Cap

e2function void g64MarioEnableCap(entity player, string cap)
	if player:IsValid() and player:IsPlayer() and IsValid(player.MarioEnt) then
		net.Start("G64_E2")
			net.WriteString("EnableCap")
			net.WriteString(cap:Trim():lower())
		net.Send(player)
	end
end

e2function void entity:g64MarioEnableCap(string cap)
	if this:IsValid() and this:IsPlayer() and IsValid(this.MarioEnt) then
		net.Start("G64_E2")
			net.WriteString("EnableCap")
			net.WriteString(cap:Trim():lower())
		net.Send(this)
	end
end

e2function void g64MarioDisableCap(entity player, string cap)
	if player:IsValid() and player:IsPlayer() and IsValid(player.MarioEnt) then
		net.Start("G64_E2")
			net.WriteString("DisableCap")
			net.WriteString(cap:Trim():lower())
		net.Send(player)
	end
end

e2function void entity:g64MarioDisableCap(string cap)
	if this:IsValid() and this:IsPlayer() and IsValid(this.MarioEnt) then
		net.Start("G64_E2")
			net.WriteString("DisableCap")
			net.WriteString(cap:Trim():lower())
		net.Send(this)
	end
end

-- Color

e2function void g64MarioColor(entity player, number index, vector color)
	if player:IsValid() and player:IsPlayer() and IsValid(player.MarioEnt) then
		net.Start("G64_E2")
			net.WriteString("SetColor")
			net.WriteInt(index, 4)
			net.WriteVector(color)
		net.Send(player)
	end
end

e2function void entity:g64MarioColor(number index, vector color)
	if this:IsValid() and this:IsPlayer() and IsValid(this.MarioEnt) then
		net.Start("G64_E2")
			net.WriteString("SetColor")
			net.WriteInt(index, 4)
			net.WriteVector(color)
		net.Send(this)
	end
end

-- position

e2function void entity:g64MarioSetPos(vector pos)
	if this:IsValid() and this:IsPlayer() and IsValid(this.MarioEnt) then
		net.Start("G64_E2")
			net.WriteString("SetPos")
			net.WriteFloat(pos.x)
			net.WriteFloat(pos.y)
			net.WriteFloat(pos.z)
			net.WriteBool(false)
		net.Send(this)
		WireLib.setPos(this, pos)
		WireLib.setPos(this.MarioEnt, pos)
	end
end

e2function void entity:g64MarioSetPos(vector pos, number spin)
	if this:IsValid() and this:IsPlayer() and IsValid(this.MarioEnt) then
	print("First",spin ~= 0)
		net.Start("G64_E2")
			net.WriteString("SetPos")
			net.WriteFloat(pos.x)
			net.WriteFloat(pos.y)
			net.WriteFloat(pos.z)
			net.WriteBool(spin ~= 0)
		net.Send(this)
		WireLib.setPos(this, pos)
		WireLib.setPos(this.MarioEnt, pos)
	end
end



e2function vector entity:g64MarioGetPos()
	if this:IsValid() and this:IsPlayer() and IsValid(this.MarioEnt) then
		WireLib.setPos(this.MarioEnt, pos)
	end
end

E2Lib.registerEvent("g64MarioRespawned", { { "Player", "e" } })

-- I'm so sorry
if g64_e2.oldrespawn == nil then
	local oldrespawn = net.Receivers["g64_respawnmario"]
	local respawned = false
	local function respawn(len, ply)
		if not respawned then
			respawned = true
			oldrespawn(len, ply)
		
			--Wait for the player to have actually respawned
			timer.Simple(1, function() E2Lib.triggerEvent("g64MarioRespawned", { ply } ) respawned = false end)
		end
	end

	net.Receive("G64_RESPAWNMARIO", respawn)
	g64_e2.oldrespawn = oldrespawn
end