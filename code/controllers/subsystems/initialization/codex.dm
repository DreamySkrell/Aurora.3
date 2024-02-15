
SUBSYSTEM_DEF(codex)
	name = "Codex"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_CODEX

	/// List of cooking recipes, their result and ingredients.
	var/list/cooking_codex_data = list()

	var/list/chemistry_codex_data = list()
	var/list/chemistry_codex_ignored_reaction_path = list(/datum/chemical_reaction/slime)
	var/list/chemistry_codex_ignored_result_path = list(/singleton/reagent/drink, /singleton/reagent/alcohol)

	/// List of overmap objects (ships, away sites, ruins, planets, etc), and their names, sectors, and the like.
	var/list/overmap_object_data = list()

/datum/controller/subsystem/codex/Initialize()
	generate_cooking_codex()
	generate_chemistry_codex()
	generate_overmap_codex()
	log_subsystem_codex("SScodex: \
		[cooking_codex_data.len] cooking recipes; \
		[chemistry_codex_data.len] chemistry recipes; \
		[2137] overmap objects; \
	")
	return SS_INIT_SUCCESS

/datum/controller/subsystem/codex/proc/generate_cooking_codex()
	var/list/available_recipes = GET_SINGLETON_SUBTYPE_MAP(/singleton/recipe)
	for (var/recipe_path in available_recipes)
		var/singleton/recipe/recipe = GET_SINGLETON(recipe_path)
		var/list/recipe_data = list()

		// result
		var/obj/item/recipe_result = recipe.result
		recipe_data["result"] = initial(recipe_result.name)

		// result image
		var/icon/result_icon = icon(
			icon=initial(recipe_result.icon),
			icon_state=initial(recipe_result.icon_state),
			frame=1,
			)
		recipe_data["result_image"] = icon2base64(result_icon)

		// ingredients
		recipe_data["ingredients"] = list()

		// ingredients, items
		if(recipe.items)
			for(var/ingredient_path in recipe.items)
				var/obj/item/ingredient = ingredient_path
				recipe_data["ingredients"] += initial(ingredient.name)

		// ingredients, fruits
		if(recipe.fruit)
			for(var/fruit_name in recipe.fruit)
				var/count = recipe.fruit[fruit_name]
				recipe_data["ingredients"] += "[count]x [fruit_name]"

		// ingredients, reagents
		if(recipe.reagents)
			for(var/reagent_path in recipe.reagents)
				var/count = recipe.reagents[reagent_path]
				var/singleton/reagent/reagent = GET_SINGLETON(reagent_path)
				recipe_data["ingredients"] += "[count]u [reagent.name]"

		// coating
		if(recipe.coating)
			var/singleton/reagent/reagent = GET_SINGLETON(recipe.coating)
			recipe_data["ingredients"] += "[reagent.name] coating"

		// kitchen appliance
		if(recipe.appliance)
			recipe_data["appliances"] = recipe.get_appliance_names()

		// fin
		recipe_data["ingredients"] = english_list(recipe_data["ingredients"])
		cooking_codex_data += list(recipe_data)

/datum/controller/subsystem/codex/proc/generate_chemistry_codex()
	for(var/chem_path in SSchemistry.chemical_reactions_clean)
		if(chemistry_codex_ignored_reaction_path && is_path_in_list(chem_path, chemistry_codex_ignored_reaction_path))
			continue
		var/datum/chemical_reaction/CR = new chem_path
		if(!CR.result)
			continue
		if(chemistry_codex_ignored_result_path && is_path_in_list(CR.result, chemistry_codex_ignored_result_path))
			continue
		var/singleton/reagent/R = GET_SINGLETON(CR.result)
		var/reactionData = list(id = CR.id)
		reactionData["result"] = list(
			name = R.name,
			description = R.description,
			amount = CR.result_amount
		)

		reactionData["reagents"] = list()
		for(var/reagent in CR.required_reagents)
			var/singleton/reagent/required_reagent = reagent
			reactionData["reagents"] += list(list(
				name = initial(required_reagent.name),
				amount = CR.required_reagents[reagent]
			))

		reactionData["catalysts"] = list()
		for(var/reagent_path in CR.catalysts)
			var/singleton/reagent/required_reagent = reagent_path
			reactionData["catalysts"] += list(list(
				name = initial(required_reagent.name),
				amount = CR.catalysts[reagent_path]
			))

		reactionData["inhibitors"] = list()
		for(var/reagent_path in CR.inhibitors)
			var/singleton/reagent/required_reagent = reagent_path
			var/inhibitor_amount = CR.inhibitors[reagent_path] ? CR.inhibitors[reagent_path] : "Any"
			reactionData["inhibitors"] += list(list(
				name = initial(required_reagent.name),
				amount = inhibitor_amount
			))

		reactionData["temp_min"] = CR.required_temperature_min

		reactionData["temp_max"] = CR.required_temperature_max

		chemistry_codex_data += list(reactionData)

/datum/controller/subsystem/codex/proc/generate_overmap_codex()
	if(!SSatlas.current_map.use_overmap)
		return

	// var/datum/space_sector/current_sector = SSatlas.current_sector

	// ships and away sites
	for(var/site_id in SSmapping.away_sites_templates)
		var/datum/map_template/ruin/away_site/site = SSmapping.away_sites_templates[site_id]
		overmap_object_data += list(list(
			"kind"=(site.ship_cost ? "ship" : "site"),
			"path"="[site.type]",
			"name"=site.name,
			"desc"=site.description,
			"ship_cost"=site.ship_cost,
			"spawn_cost"=site.spawn_cost,
			"spawn_weight"=site.spawn_weight,
			"sectors"=site.sectors,
			"guaranteed"=(site.template_flags&TEMPLATE_FLAG_SPAWN_GUARANTEED),
		))

	// planets
	// sites and ruins have defined `sectors` var to decide where they spawn
	// but planets instead are the other way around - sectors define their planets
	// so have to iterate over sectors to get planets
	var/list/planets = list()
	for(var/sector_id in SSatlas.possible_sectors)
		var/datum/space_sector/sector = SSatlas.possible_sectors[sector_id]
		var/list/planet_paths = sector.possible_exoplanets// + sector.guaranteed_exoplanets
		for(var/planet_path in planet_paths)
			var/obj/effect/overmap/visitable/sector/exoplanet/planet = planet_path
			if(planets["[planet_path]"])
				planets["[planet_path]"]["sectors"]+=sector.name
			else
				planets += list("[planet_path]"=list(
					"kind"="planet",
					"path"="[initial(planet.type)]",
					"name"=initial(planet.name),
					"desc"=initial(planet.desc),
					"sectors"=list(sector.name),
				))
	for(var/planet_path in planets)
		overmap_object_data += list(planets[planet_path])

	// planet/asteroid ruins
	for(var/ruin_id in SSmapping.exoplanet_ruins_templates)
		var/datum/map_template/ruin/exoplanet/ruin = SSmapping.exoplanet_ruins_templates[ruin_id]
		overmap_object_data += list(list(
			"kind"="ruin",
			"path"="[ruin.type]",
			"name"=ruin.name,
			"desc"=ruin.description,
			"ship_cost"=ruin.ship_cost,
			"spawn_cost"=ruin.spawn_cost,
			"spawn_weight"=ruin.spawn_weight,
			"sectors"=ruin.sectors,
			"guaranteed"=(ruin.template_flags&TEMPLATE_FLAG_SPAWN_GUARANTEED),
		))



	overmap_object_data = overmap_object_data
	overmap_object_data = overmap_object_data
	overmap_object_data = overmap_object_data
