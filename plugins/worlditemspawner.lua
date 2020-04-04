local PLUGIN = PLUGIN
PLUGIN.name = "World Item Spawner"
PLUGIN.author = "Black Tea (NS 1.0), Neon (NS 1.1), ported to ix by verne"
PLUGIN.desc = "World Item Spawner."
PLUGIN.itempoints = PLUGIN.itempoints or {}
PLUGIN.minplayers = 1

PLUGIN.spawngroups = {
	["common"] = {
		{"scavenged_compound_silica"},
		{"scavenged_compound_plastoid"},
		{"scavenged_compound_lacqerous"},
		{"researched_compound_carboplas"},
		{"researched_compound_nylasteel"},
		{"researched_compound_plastifiber"},
		{"scavenged_metal_desh"},
		{"scavenged_metal_bronzium"},
		{"scavenged_metal_phobium"},
		{"fabric_shadowsilk"},
		{"fabric_cyrene_silk"},
		{"fabric_lashaa_silk"},
		{"sliced_power_tube"},
		{"sliced_memory_core"},
		{"sliced_augmentation_chip"},
		{"sliced_cybernetic_interface_jack"},
		{"underworld_terenthium"},
		{"biochemical_compound_green_goo"},
		{"biochemical_compound_genetic_reference"},
		{"biochemical_compound_hallucinogenic_compound"},
		{"biochemical_sample_dielectric_cell_fiber"},
		{"biochemical_sample_microscopic_symbiote"},
		{"medicalsupply_biochemical_bonding_agent"},
		{"medicalsupply_alien_blood_sample"},
		{"medicalsupply_molecular_programmer"},
	},
	["uncommon"] = {
		{"scavenged_compound_fibermesh"},
		{"scavenged_compound_polyplast"},
		{"scavenged_compound_zal_alloy"},
		{"researched_compound_polyfibe"},
		{"researched_compound_flexiglass"},
		{"researched_compound_ceraglass"},
		{"scavenged_metal_bondite"},
		{"scavenged_metal_electrum"},
		{"scavenged_metal_durasteel"},
		{"fabric_shimmersilk"},
		{"fabric_dramassian_silk"},
		{"fabric_killik_silk"},
		{"fabric_septsilk"},
		{"sliced_modification_enhancer"},
		{"sliced_power_capacitor"},
		{"sliced_sonic_imprint_sensor"},
		{"underworld_agrinium"},
		{"underworld_mullinine"},
		{"biochemical_compound_nerve_damaging_chemical"},
		{"biochemical_compound_nutrient_gel"},
		{"biochemical_sample_bioenergy_cell_sample"},
		{"medicalsupply_mechanical_symbiote"},
		{"medicalsupply_neuro_stimulator"},
		{"medicalsupply_bioelectric_toxin"},
		{"medicalsupply_synthetic_blood"},
	},
	["rare"] = {
		{"scavenged_compound_turadium"},
		{"scavenged_compound_molytex"},
		{"researched_compound_phrik"},
		{"researched_compound_laminasteel"},
		{"scavenged_metal_mythra"},
		{"scavenged_metal_farium"},
		{"fabric_rodian_flame_silk"},
		{"fabric_vine_silk"},
		{"fabric_saava_silk"},
		{"fabric_nanosilk"},
		{"sliced_vacierite_memory_core"},
		{"sliced_energy_converter"},
		{"underworld_alusteel"},
		{"underworld_xonolite"},
		{"underworld_krayt_dragon_scales"},
		{"underworld_titanium"},
		{"underworld_neuranium"},
		{"underworld_quadranium"},
		{"underworld_promethium"},
		{"underworld_ciridium"},
		{"underworld_mandalorian_iron"},
		{"biochemical_compound_immunity_cell_culture"},
		{"biochemical_sample_alien_bacteria"},
		{"medicalsupply_miracle_fluid"},
		{"medicalsupply_experimental_serum"},
	},
}

--PLUGIN.spawnchance = 0.5 + (1 * #player.GetAll())
PLUGIN.spawnrate = 1000
PLUGIN.maxitems = 60
PLUGIN.itemsperspawn = 15
PLUGIN.spawneditems = PLUGIN.spawneditems or {}

if SERVER then
	local spawntime = 1

	function PLUGIN:ItemShouldSave(entity)
		return (!entity.generated)
	end

	function PLUGIN:Think()
		if #player.GetAll() < PLUGIN.minplayers then return end
		if spawntime > CurTime() then return end
		spawntime = CurTime() + self.spawnrate + math.random(self.spawnrate/2)
		for k, v in ipairs(self.spawneditems) do
			if (!v:IsValid()) then
				table.remove(self.spawneditems, k)
			end
		end

		if #self.spawneditems >= self.maxitems then return end

		for i = 1, self.itemsperspawn do
			if #self.spawneditems >= self.maxitems then
					table.remove(self.spawneditems)
			return
			end
			for i, j in pairs(self.itempoints) do

				if (!j) then
					return
				end
	
				local data = {}
				data.start = j[1]
				data.endpos = data.start + Vector(0, 0, -64)
				data.filter = client
				data.mins = Vector(-32, -32, 0)
				data.maxs = Vector(32, 32, 32)
				local trace = util.TraceHull(data)

				/*if trace.Entity:IsValid() then
					if !(trace.Entity:GetClass() == "nut_storage") then
						continue
					end
				end*/
			
				local idat = table.Random(self.spawngroups[j[2]] or self.spawngroups["default"])
				if math.random(101) <= (0 + math.sqrt(1.7 * #player.GetAll())) then
					ix.item.Spawn(idat[1], j[1] + Vector( math.Rand(-8,8), math.Rand(-8,8), 20 ), nil, AngleRand(), idat[2] or {})
				end
			end
		end
	end

	function PLUGIN:LoadData()
		self.itempoints = self:GetData() or {}
	end

	function PLUGIN:SaveData()
		self:SetData(self.itempoints)
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
			smoke:SetColor(255,186,50)
			smoke:SetAirResistance(300)
		end
	end)

end

ix.command.Add("itemspawnadd", {
	superAdminOnly = true,
	arguments = {
		ix.type.string,
	},	
	OnRun = function(self, client, text)
		local trace = client:GetEyeTraceNoCursor()
		local hitpos = trace.HitPos + trace.HitNormal*5
		local spawngroup = text or "default"
		table.insert( PLUGIN.itempoints, { hitpos, spawngroup } )
		client:Notify( "You added ".. spawngroup .. " item spawner." )
		PLUGIN:SaveData()
	end
})

ix.command.Add("itemspawnremove", {
	superAdminOnly = true,
	arguments = {
		ix.type.number,
	},
	OnRun = function(self, client, arguments)
		local trace = client:GetEyeTraceNoCursor()
		local hitpos = trace.HitPos + trace.HitNormal*5
		local range = arguments or 128
		local mt = 0
		for k, v in pairs( PLUGIN.itempoints ) do
			local distance = v[1]:Distance( hitpos )
			if distance <= tonumber(range) then
				PLUGIN.itempoints[k] = nil
				mt = mt + 1
			end
		end
		client:Notify( mt .. " item spawners has been removed.")
		PLUGIN:SaveData()
	end
})

ix.command.Add("itemspawndisplay", {
	adminOnly = true,
	OnRun = function(self, client, arguments)
		if SERVER then
			netstream.Start(client, "nut_DisplaySpawnPoints", PLUGIN.itempoints)
			client:Notify( "Displayed All Points for 10 secs." )
		end
	end
})