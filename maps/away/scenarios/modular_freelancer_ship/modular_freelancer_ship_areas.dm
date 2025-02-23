
// ------------------------- base/parent

ABSTRACT_TYPE(/area/modular_freelancer_ship)
	name = "Base/Parent Area"
	icon_state = "white128a"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/space
	area_flags = AREA_FLAG_RAD_SHIELDED
	holomap_color = "#747474"
	color = "#747474"

// ------------------------- outside

/area/modular_freelancer_ship/maint
	holomap_color = "#494949"
