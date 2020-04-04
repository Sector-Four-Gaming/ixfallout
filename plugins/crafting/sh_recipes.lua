local NEW_RECIPES = {
	--["food_needlegaps_stew"] = {
	--	["name"] = "Food: Needlegaps Stew",
	--	["model"] = "models/neeewpackofprops/food9.mdl",
	--	["desc"] = "Stew some Gren Root, Ground, and Whole Meat for some Needlegaps Stew.",
	--	["requirements"] = {["rawmeat"] = 5, ["groundmeat"] = 2, ["grenroot"] = 2},
	--	["results"] = {["needlestew"] = 1},
	--	["category"] = "Cooking",
	--	["blueprint"] = "needlegapstew",
	--	["crafttable"] = "cooking"
	--},
	["food_corn"] = {
		["name"] = "Corn",
		["model"] = "models/kek1ch/dev_corn.mdl",
		["desc"] = "Cook this canned corn to make it a bit more enjoyable.",
		["requirements"] = {["cannedcorn"] = 1},
		["results"] = {["cookedcorn"] = 1},
		["category"] = "Cooking",
		["crafttable"] = "cooking",
	},
	["food_chili"] = {
		["name"] = "Chili",
		["model"] = "models/kek1ch/dev_chili.mdl",
		["desc"] = "Cook this canned chili to make it a bit more enjoyable.",
		["requirements"] = {["cannedchilibeans"] = 1},
		["results"] = {["cookedchilibeans"] = 1},
		["category"] = "Cooking",
		["crafttable"] = "cooking",
	},
	["food_beans"] = {
		["name"] = "Beans",
		["model"] = "models/kek1ch/dev_beans.mdl",
		["desc"] = "Cook these canned beans to make it a bit more enjoyable.",
		["requirements"] = {["cannedbeans"] = 1},
		["results"] = {["cookedbeans"] = 1},
		["category"] = "Cooking",
		["crafttable"] = "cooking",
	},
	["food_olives"] = {
		["name"] = "Olives",
		["model"] = "models/kek1ch/dev_tomato.mdl",
		["desc"] = "Cook these canned olives to make it a bit more enjoyable.",
		["requirements"] = {["cannedolives"] = 1},
		["results"] = {["cookedolives"] = 1},
		["category"] = "Cooking",
		["crafttable"] = "cooking",
	},
	["food_tomato"] = {
		["name"] = "Tomato",
		["model"] = "models/kek1ch/dev_tomato.mdl",
		["desc"] = "Cook these canned tomatos to make it a bit more enjoyable.",
		["requirements"] = {["cannedtomato"] = 1},
		["results"] = {["cookedtomato"] = 1},
		["category"] = "Cooking",
		["crafttable"] = "cooking",
	},
	["food_tuna"] = {
		["name"] = "Tuna",
		["model"] = "models/kek1ch/dev_conserv.mdl",
		["desc"] = "Cook this canned tuna to make it a bit more enjoyable.",
		["requirements"] = {["cannedtuna"] = 1},
		["results"] = {["cookedtuna"] = 1},
		["category"] = "Cooking",
		["crafttable"] = "cooking",
	},
	["food_tushonka"] = {
		["name"] = "Tushonka",
		["model"] = "models/kek1ch/dev_conserv.mdl",
		["desc"] = "Cook this canned tushonka to make it a bit more enjoyable.",
		["requirements"] = {["cannedtushonka"] = 1},
		["results"] = {["cookedtushonka"] = 1},
		["category"] = "Cooking",
		["crafttable"] = "cooking",
	},
}

for k, v in pairs(NEW_RECIPES) do
	PLUGIN:AddRecipe(v.name, v.model, v.desc, v.requirements, v.results, k, v.skill or nil, v.blueprint or nil, v.guns or nil, v.entity or nil, v.category or "Miscellaneous", v.crafttable or nil, v.flag or nil)
end