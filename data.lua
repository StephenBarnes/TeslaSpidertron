local util = require("__core__/lualib/util") -- for deepcopy

local newItem = table.deepcopy(data.raw["item-with-entity-data"]["spidertron"])
newItem.name = "tesla-spidertron"
newItem.place_result = "tesla-spidertron"
newItem.order = newItem.order .. "-1b" -- Put it after the spidertron in lists, but before railgun spidertron if they have that mod too.
newItem.icons = {
	{
		icon = "__base__/graphics/icons/spidertron-tintable.png",
		icon_size = 64,
		icon_mipmaps = 4,
	},
	{
		icon = "__base__/graphics/icons/spidertron-tintable-mask.png",
		icon_size = 64,
		icon_mipmaps = 4,
		tint = {r=0.118, g=0.957, b=0.882, a=0.8}, -- color-picked from the tesla turret sprite.
	},
}

-- Create 2 separate guns, so the Tesla guns shoot from different points on the Spidertron, like they did with the 4 rocket launchers.
-- Decided to not do this, since the distance and orientation offset seem to have no effect at all. Beam still comes from the center.
--[[
local newGuns = {}
for i = 1, 2 do
	local newGun = table.deepcopy(data.raw.gun.teslagun)
	newGun.name = "spidertron-teslagun-"..i
	newGun.hidden = true
	newGun.attack_parameters.projectile_center = {0, 0.3}
	if i == 1 then
		newGun.attack_parameters.projectile_orientation_offset = 0.4
	else
		newGun.attack_parameters.projectile_orientation_offset = -0.4
	end
	newGun.attack_parameters.projectile_creation_distance = -5
	newGun.localised_name = {"item-name.spidertron-teslagun"}
	newGuns[i] = newGun
end]]
local newGun = table.deepcopy(data.raw.gun.teslagun)
newGun.name = "spidertron-teslagun"
newGun.hidden = true
newGun.attack_parameters.projectile_center = {0, 0.3}
newGun.attack_parameters.projectile_orientation_offset = 0
newGun.attack_parameters.projectile_creation_distance = 0

local newSpidertron = table.deepcopy(data.raw["spider-vehicle"]["spidertron"])
newSpidertron.name = "tesla-spidertron"
--newSpidertron.guns = {"spidertron-teslagun-1", "spidertron-teslagun-2"}
newSpidertron.guns = {"spidertron-teslagun", "spidertron-teslagun"}
newSpidertron.chain_shooting_cooldown_modifier = 0.65
	-- Default rocket-launcher spidertron has this at 0.5.
newSpidertron.automatic_weapon_cycling = true
newSpidertron.minable.result = "tesla-spidertron"
newSpidertron.icons = newItem.icons

local newRecipe = table.deepcopy(data.raw["recipe"]["spidertron"])
newRecipe.name = "tesla-spidertron"
-- Use a loop to change rocket turret ingredient to Tesla gun, in case another mod does sth like removing the fish ingredient.
for _, ingredient in pairs(newRecipe.ingredients) do
	if ingredient.name == "rocket-turret" then
		ingredient.name = "teslagun"
		ingredient.amount = 2
	elseif ingredient[1] == "rocket-turret" then
		ingredient[1] = "teslagun"
		ingredient[2] = 2
	end
end
newRecipe.icons = newItem.icons
newRecipe.results = {{type="item", name="tesla-spidertron", amount=1}}

local newTech = table.deepcopy(data.raw["technology"]["spidertron"])
newTech.name = "tesla-spidertron"
newTech.effects = {
	{
		type = "unlock-recipe",
		recipe = "tesla-spidertron"
	}
}
newTech.prerequisites = {"tesla-weapons", "spidertron"}
-- Make it cost the max of the spidertron and tesla weapon techs.
newTech.unit.count = math.max(data.raw.technology.spidertron.unit.count, data.raw.technology["tesla-weapons"].unit.count)
newTech.unit.ingredients = {}
local sciPackAdded = {}
for _, ingredient in pairs(data.raw.technology.spidertron.unit.ingredients) do
	table.insert(newTech.unit.ingredients, ingredient)
	sciPackAdded[ingredient[1]] = true
end
for _, ingredient in pairs(data.raw.technology["tesla-weapons"].unit.ingredients) do
	if not sciPackAdded[ingredient[1]] then
		table.insert(newTech.unit.ingredients, ingredient)
	end
end
newTech.icons = {
	{
		icon = "__base__/graphics/technology/spidertron.png",
		icon_size = 256,
		icon_mipmaps = 4,
	},
	{
		icon = "__space-age__/graphics/technology/tesla-weapons.png",
		icon_size = 256,
		icon_mipmaps = 4,
		scale = 0.3,
		shift = {30, 45},
	}
}

data:extend({
	newItem,
	newGun,
	newSpidertron,
	newRecipe,
	newTech,
})