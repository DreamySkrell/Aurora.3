
SUBSYSTEM_DEF(starmap)
	name = "Starmap"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_STARMAP
	init_stage = INITSTAGE_EARLY

	///
	var/starmap_current_position = list(-5,15)

	///
	var/datum/starmap/starmap

	///
	var/list/starmap_data = list()

/datum/controller/subsystem/starmap/Initialize()
	generate_starmap_data()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/starmap/proc/generate_starmap_data()
	var/list/systems_data = list()
	var/list/systems = GET_SINGLETON_SUBTYPE_MAP(/singleton/starmap_system)
	for (var/system_path in systems)
		var/singleton/starmap_system/system = GET_SINGLETON(system_path)
		var/list/system_data = list()
		system_data["name"] = system.name
		system_data["x"] = system.x
		system_data["y"] = system.y
		systems_data += list(system_data)

	starmap_data["systems"] = systems_data
	starmap_data["x"] = starmap_current_position[0]
	starmap_data["y"] = starmap_current_position[1]
