local mercs_groups = {}
mercs_groups = {
	{
		id = "Wesnoth",
		units = {"Fencer", "Horseman", "Heavy Infantryman", "Sergeant"},
	},
	{
		id = "Elves",
		units = {"Elvish Shaman", "Elvish Fighter", "Elvish Archer"},
	},
	{
		id = "Khaganate",
		units = {"Khaganate_Gnoll_Biter", "Khaganate_Vampire", "Khaganate_Serpenthead"},
	},
	{
		id = "Slavs",
		units = {"Slav_Watchman", "Slav_Temsk_Pagan", "Slav_Militia"},
	},
	{
		id = "Tumen",
		units = {"Ogre_Mancatcher", "Ogre_Grunt_steppe", "Ogre_Apprentice"},
	},
	{
		id = "Mandate",
		units = {"Mandate_Jorogumo", "Mandate_Kobold", "Mandate_Vixen_Witch"},
	},
	{
		id = "Orcs",
		units = {"Orcish Assassin", "Orcish Leader", "Wolf Rider"},
	}
}

local function shuffle_from_idioms(x)
	for i = #x, 2, -1 do
		local j = math.random(i)
		x[i], x[j] = x[j], x[i]
	end
end

function wesnoth.wml_actions.get_mercs_types(cfg)
	local variable = cfg.variable or "mercs"
	
	local result = wesnoth.sync.evaluate_single(_"Generating Mercenaries", function()
		shuffle_from_idioms(mercs_groups)
		for i = 1, 4 do
			shuffle_from_idioms(mercs_groups[i].units)
		end
		return {wml.tag.mercs {type11 = mercs_groups[1].units[1],
					type12 = mercs_groups[1].units[2],
					type21 = mercs_groups[2].units[1],
					type22 = mercs_groups[2].units[2],
					type31 = mercs_groups[3].units[1],
					type32 = mercs_groups[3].units[2],
					type41 = mercs_groups[4].units[1],
					type42 = mercs_groups[4].units[2],}}
	end)
	wml.variables[variable] = {type11 = result[1][2].type11,
					type12 = result[1][2].type12,
					type21 = result[1][2].type21,
					type22 = result[1][2].type22,
					type31 = result[1][2].type31,
					type32 = result[1][2].type32,
					type41 = result[1][2].type41,
					type42 = result[1][2].type42,}
end
