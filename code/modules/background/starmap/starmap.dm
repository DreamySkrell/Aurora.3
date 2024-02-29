
/datum/starmap
	var/list/singleton/starmap_system/systems = list()

/datum/starmap/proc/setup()
	var/list/systems_subtypes = GET_SINGLETON_SUBTYPE_LIST(/singleton/starmap_system)
	for (var/system_path in systems_subtypes)
		systems += GET_SINGLETON(system_path)
	systems = systems

/singleton/starmap_system
	///
	var/name = "Some Star System"
	///
	var/desc = null

	///
	var/port_name = "Unspecified Spaceport"
	///
	var/port_desc = null

	/// x position in LY
	var/x = 0
	/// y position in LY
	var/y = 0

	/// Direct distance to Horizon in LY
	var/dist_direct = 0

/singleton/starmap_system/tau_ceti
	name = "Tau Ceti"
	port_name = "Biesel Spaceport"
	x = 0
	y = 0

/singleton/starmap_system/haneunim
	name = "Haneunim"
	port_name = "Aoyama Spaceport"
	x = -5
	y = 15

/singleton/starmap_system/sol
	name = "Sol"
	port_name = "Earth Spaceport"
	x = -10
	y = 0

/singleton/starmap_system/san_colette
	name = "San Colette"
	x = -9
	y = 11

/singleton/starmap_system/e_u_minoris
	name = "EUM"
	x = -14
	y = 23

/singleton/starmap_system/orepit
	name = "Orepit"
	x = 13
	y = 15

/singleton/starmap_system/gadpathur
	name = "Gadpathur"
	x = 22
	y = 13
