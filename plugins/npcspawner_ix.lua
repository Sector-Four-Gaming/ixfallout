local PLUGIN = PLUGIN
PLUGIN.name = "NPC Spawner"
PLUGIN.author = "Black Tea (NS 1.0), Neon (NS 1.1); ported to helix by Shavargo"
PLUGIN.description = "NPC Spawner."
PLUGIN.spawnpoints = PLUGIN.spawnpoints or {}
PLUGIN.minplayers = 1

ix.config.Add("spawner_enabled", true, "Whether NPC spawners are on or not.", nil, {
	category = "NPC Spawner"
})

ix.config.Add("npc_spawnrate", 120, "How often an npc will be spawned at an npc spawn point.", nil, {
	data = {min = 1, max = 84600},
	category = "NPC Spawner"
})


PLUGIN.spawngroups = {
	["common"] = {
		"npc_wick_mutant_dog",
		"npc_wick_mutant_bloodsucker_adult",
		"npc_wick_mutant_snork",
		"npc_wick_mutant_zombiecit_fast",
		"npc_wick_mutant_zombiecit_slow",
	},
	["uncommon"] = {
		"npc_wick_mutant_dog",
		"npc_wick_mutant_bloodsucker_adult",
		"npc_wick_mutant_snork",
		"npc_wick_mutant_zombiecit_fast",
		"npc_wick_mutant_zombiecit_slow",
	},
}


PLUGIN.maxnpcs = 60
PLUGIN.spawnedNPCs = PLUGIN.spawnedNPCs or {}

if SERVER then
	local spawntime = 1
	function PLUGIN:Think()
		if #player.GetAll() < PLUGIN.minplayers then return end
		if spawntime > CurTime() then return end
		spawntime = CurTime() + ix.config.Get("npc_spawnrate", 90)
		for k, v in ipairs(self.spawnedNPCs) do
			if (!v:IsValid()) then
				table.remove(self.spawnedNPCs, k)
			end
		end

		if #self.spawnedNPCs >= self.maxnpcs then return end


		local v = table.Random(self.spawnpoints)

		if (!ix.config.Get("spawner_enabled", false)) then
			return
		end
		if (!v) then
			return
		end

		local data = {}
		data.start = v[1]
		data.endpos = data.start + Vector(0, 0, 1)
		data.filter = client
		data.mins = Vector(-16, -16, 0)
		data.maxs = Vector(16, 16, 16)

		local idat = table.Random(self.spawngroups[v[2]]) or self.spawngroup["default"]

		--nut.item.spawn(idat, v[1] + Vector( math.Rand(-8,8), math.Rand(-8,8), 20 ), nil, AngleRand())
		local trace = util.TraceHull(data)

		local nearby = false
		local players = player.GetAll()
		--dont want to spawn them in too close to players
		if (players) then
			for k, v in pairs(players) do
				if (v:GetMoveType() == MOVETYPE_NOCLIP) then
					continue
				end
				if v:GetPos():DistToSqr(data.endpos) < 1000 * 1000 then --squared is more efficient
					nearby = true
					break
				end
			end
		end
		if (!nearby and !trace.Entity:IsValid()) then --dont want the npcs to stack on each other or spawn inside something.
			local ent = ents.Create(idat)
			table.insert(self.spawnedNPCs, ent)

			if (ent:IsValid()) then
				ent:SetPos(data.endpos + Vector(0,0,25))
				ent:Spawn()
			end
		end
	end

	function PLUGIN:LoadData()
		self.spawnpoints = self:GetData() or {}
	end

	function PLUGIN:SaveData()
		self:SetData(self.spawnpoints)
	end

else

	netstream.Hook("nut_DisplaySpawnPoints", function(data)
		for k, v in pairs(data) do
			local emitter = ParticleEmitter( v[1] )
			local smoke = emitter:Add( "sprites/glow04_noz", v[1] )
			smoke:SetVelocity( Vector( 0, 0, 1 ) )
			smoke:SetDieTime(10)
			smoke:SetStartAlpha(255)
			smoke:SetEndAlpha(255)
			smoke:SetStartSize(64)
			smoke:SetEndSize(64)
			smoke:SetColor(255,50,50)
			smoke:SetAirResistance(300)
		end
	end)

end

ix.command.Add("npcspawnadd", {
	adminOnly = true,
	syntax = "<string npcgroup>",
	arguments = {ix.type.text},
	OnRun = function(self, client, npcgroup)
		local trace = client:GetEyeTraceNoCursor()
		local hitpos = trace.HitPos + trace.HitNormal * 5
		local spawngroup = npcgroup or "default"
		table.insert(PLUGIN.spawnpoints, { hitpos, spawngroup })
		client:Notify("You added " .. spawngroup .. " npc spawner.")
	end
})

ix.command.Add("npcspawnremove", {
	adminOnly = true,
	OnRun = function(self, client, arguments)
		local trace = client:GetEyeTraceNoCursor()
		local hitpos = trace.HitPos + trace.HitNormal * 5
		local range = arguments[1] or 128
		local mt = 0
		for k, v in pairs( PLUGIN.spawnpoints ) do
			local distance = v[1]:DistToSqr(hitpos)
			if distance <= tonumber(range) * tonumber(range) then
				PLUGIN.spawnpoints[k] = nil
				mt = mt + 1
			end
		end
		client:Notify(mt .. " npc spawners has been removed.")
	end
})

ix.command.Add("npcspawndisplay", {
	adminOnly = true,
	OnRun = function(self, client, arguments)
		if SERVER then
			netstream.Start(client, "nut_DisplaySpawnPoints", PLUGIN.spawnpoints)
			client:Notify("Displayed All Points for 10 secs.")
		end
	end
})

ix.command.Add("npcspawntoggle", {
	adminOnly = true,
	OnRun = function(self, client, arguments)
		if (ix.config.Get("spawner_enabled", false)) then
			ix.config.Set("spawner_enabled", false)
			client:Notify("NPC Spawners have been turned off.")
		else
			ix.config.Set("spawner_enabled", true)
			client:Notify("NPC Spawners have been turned on.")
		end
	end
})

-- NPC Drop Plugin
PLUGIN.npclist = {
	"npc_wick_mutant_dog",
	"npc_wick_mutant_bloodsucker_adult",
	"npc_wick_mutant_snork",
	"npc_wick_mutant_zombiecit_fast",
	"npc_wick_mutant_zombiecit_slow"
}
PLUGIN.droptable = {
	["uncommon"] = {
		"ammo_blaster_small",
		"ammo_blaster_large"
	}
}
-- 
function PLUGIN:OnNPCKilled(entity)
	local class = entity:GetClass()
	for k, v in pairs (PLUGIN.npclist) do
		if class == k then
			for a, b in pairs(PLUGIN.droptable) do
				local rand = math.Rand(0, #a)
				ix.item.Spawn(a[rand], entity:GetPos() + Vector( 0, 0, 8 ))
			end
		end
	end

	if PLUGIN.droptable != nil then
		local class = entity:GetClass()

		for k, v in pairs(PLUGIN.droptable) do
			if v[1] == class then
				local dropchance = v[3] or 100
				if math.Rand( 0, 100 ) > dropchance then return end
				ix.item.Spawn(v[2], entity:GetPos() + Vector( 0, 0, 8 ))
			end
		end
	end

end