
// ------------------------- base/parent

ABSTRACT_TYPE(/area/modular_freelancer_ship)
	name = "Base/Parent Area"
	icon_state = "white128a"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/space
	area_flags = AREA_FLAG_RAD_SHIELDED
	color = "#ff00f2"

// ------------------------- main modules

// ----------- fore

/area/modular_freelancer_ship/fore
	color = "#8f2d2d"

/area/modular_freelancer_ship/fore/crew
	name = "Fore, Crew Quarters"

/area/modular_freelancer_ship/fore/guns
	name = "Fore, Ship Guns"
	color = "#a31414"

/area/modular_freelancer_ship/fore/hallway
	name = "Fore, Hallway"
	color = "#884e4e"

/area/modular_freelancer_ship/fore/port
	name = "Fore, Port"

/area/modular_freelancer_ship/fore/starboard
	name = "Fore, Starboard"

// ----------- mid

/area/modular_freelancer_ship/mid
	color = "#3d8f24"

/area/modular_freelancer_ship/mid/hallway
	name = "Mid, Hallway"

/area/modular_freelancer_ship/mid/lounge
	name = "Mid, Hallway, Lounge"

// ----------- shuttles

/area/modular_freelancer_ship/shuttles
	color = "#92882b"

/area/modular_freelancer_ship/shuttles/hallway
	name = "Mid, Hallway"

// ----------- aux

/area/modular_freelancer_ship/aux
	color = "#7b2794"

/area/modular_freelancer_ship/aux/hallway
	name = "Aux, Hallway"

// ----------- aft

/area/modular_freelancer_ship/aft
	color = "#2d4697"

/area/modular_freelancer_ship/aft/hallway
	name = "Aft, Hallway"
	color = "#404f83"

/area/modular_freelancer_ship/aft/cic
	name = "Aft, CIC"
	color = "#1134a5"

/area/modular_freelancer_ship/aft/engineering
	name = "Aft, Engineering"

/area/modular_freelancer_ship/aft/atmos
	name = "Aft, Atmos"

// ------------------------- containers

/area/modular_freelancer_ship/container
	color = "#2c8f92"

/area/modular_freelancer_ship/container/c01
	name = "Shipping Container, 01"

/area/modular_freelancer_ship/container/c02
	name = "Shipping Container, 02"

/area/modular_freelancer_ship/container/c03
	name = "Shipping Container, 03"

/area/modular_freelancer_ship/container/c04
	name = "Shipping Container, 04"

/area/modular_freelancer_ship/container/c05
	name = "Shipping Container, 05"

/area/modular_freelancer_ship/container/c06
	name = "Shipping Container, 06"

/area/modular_freelancer_ship/container/c0A
	name = "Shipping Container, 0A"

/area/modular_freelancer_ship/container/c0B
	name = "Shipping Container, 0B"

// ------------------------- misc

/area/modular_freelancer_ship/misc/maint
	color = "#353535"

/area/modular_freelancer_ship/misc/maint/fore
	name = "Maint, Fore"

/area/modular_freelancer_ship/misc/maint/mid
	name = "Maint, Mid"

/area/modular_freelancer_ship/misc/maint/shuttles
	name = "Maint, Shuttles"

/area/modular_freelancer_ship/misc/maint/aux
	name = "Maint, Aux"

/area/modular_freelancer_ship/misc/maint/aft
	name = "Maint, Aft"
