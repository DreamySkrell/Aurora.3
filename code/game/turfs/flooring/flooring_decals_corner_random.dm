
// ----------------- Randomly colored corner decals
// These decals will have their colors randomized from a defined set of colors.
// Randomisation is maptemplate consistent.

/datum/define/color_sets
	var/set_index_main = 1
	var/set_index_alt = 1

	var/list/sets_security = list(
		list(COLOR_RED_GRAY, COLOR_MAROON),
		list(COLOR_MAROON, COLOR_RED_GRAY),
		list(COLOR_PALE_BLUE_GRAY, COLOR_BLUE_GRAY),
		list(COLOR_CYAN_BLUE, COLOR_BLUE_GRAY),
	)

ABSTRACT_TYPE(/obj/effect/floor_decal/corner/random)
	icon_state = "preview_corner_rainbow"
	var/color_set = null
	var/color_set_index = null

/obj/effect/floor_decal/corner/random/Initialize()
	. = ..()
	dbg_assert(color_set, "Color set should be set")
	dbg_assert(color_set_index, "Color set index should be set")
	color_set = pick_maptemplate_consistent(color_set, get_map_template(src), color_set)
	color = color_set[color_set_index]

ABSTRACT_TYPE(/obj/effect/floor_decal/corner/random/security)
	color_set = /datum/define/color_sets::sets_security

// ----

/obj/effect/floor_decal/corner/random/security/main
	name = "randomly colored corner"
	color_set_index = /datum/define/color_sets::set_index_main

/obj/effect/floor_decal/corner/random/security/main/diagonal
	icon_state = "preview_diagonal_rainbow"
	blend_state = "diagonal"

/obj/effect/floor_decal/corner/random/security/main/full
	icon_state = "preview_threethirds_rainbow"
	blend_state = "threethirds"

/obj/effect/floor_decal/corner/random/security/alt
	name = "randomly colored corner"
	color_set_index = /datum/define/color_sets::set_index_alt

/obj/effect/floor_decal/corner/random/security/alt/diagonal
	icon_state = "preview_diagonal_rainbow"
	blend_state = "diagonal"

/obj/effect/floor_decal/corner/random/security/alt/full
	icon_state = "preview_threethirds_rainbow"
	blend_state = "threethirds"
