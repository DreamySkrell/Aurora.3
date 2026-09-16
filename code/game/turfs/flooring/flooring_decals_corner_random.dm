
// ----------------- Randomly colored corner decals
// These decals will have their colors randomized from a defined set of colors.
// Randomisation is maptemplate consistent.

ABSTRACT_TYPE(/obj/effect/floor_decal/corner/random)
	name = "randomly colored corner"
	icon_state = "preview_corner_rainbow"
	var/color_set = null
	var/color_set_index = null

/obj/effect/floor_decal/corner/random/Initialize()
	. = ..()
	dbg_assert(color_set, "Color set should be set")
	dbg_assert(color_set_index, "Color set index should be set")
	color_set = pick_maptemplate_consistent(color_set, get_map_template(src), color_set)
	color = color_set[color_set_index]

// ----

ABSTRACT_TYPE(/obj/effect/floor_decal/corner/random/security)
	color_set = /datum/define/color_sets::sets_security

/obj/effect/floor_decal/corner/random/security/main
	color_set_index = /datum/define/color_sets::set_index_main

/obj/effect/floor_decal/corner/random/security/main/diagonal
	icon_state = "preview_diagonal_rainbow"
	blend_state = "diagonal"

/obj/effect/floor_decal/corner/random/security/main/full
	icon_state = "preview_threethirds_rainbow"
	blend_state = "threethirds"

/obj/effect/floor_decal/corner/random/security/alt
	color_set_index = /datum/define/color_sets::set_index_alt

/obj/effect/floor_decal/corner/random/security/alt/diagonal
	icon_state = "preview_diagonal_rainbow"
	blend_state = "diagonal"

/obj/effect/floor_decal/corner/random/security/alt/full
	icon_state = "preview_threethirds_rainbow"
	blend_state = "threethirds"

// ----

ABSTRACT_TYPE(/obj/effect/floor_decal/corner/random/science)
	color_set = /datum/define/color_sets::sets_science

/obj/effect/floor_decal/corner/random/science/main
	color_set_index = /datum/define/color_sets::set_index_main

/obj/effect/floor_decal/corner/random/science/main/diagonal
	icon_state = "preview_diagonal_rainbow"
	blend_state = "diagonal"

/obj/effect/floor_decal/corner/random/science/main/full
	icon_state = "preview_threethirds_rainbow"
	blend_state = "threethirds"

/obj/effect/floor_decal/corner/random/science/alt
	color_set_index = /datum/define/color_sets::set_index_alt

/obj/effect/floor_decal/corner/random/science/alt/diagonal
	icon_state = "preview_diagonal_rainbow"
	blend_state = "diagonal"

/obj/effect/floor_decal/corner/random/science/alt/full
	icon_state = "preview_threethirds_rainbow"
	blend_state = "threethirds"

// ----

ABSTRACT_TYPE(/obj/effect/floor_decal/corner/random/medical)
	color_set = /datum/define/color_sets::sets_medical

/obj/effect/floor_decal/corner/random/medical/main
	color_set_index = /datum/define/color_sets::set_index_main

/obj/effect/floor_decal/corner/random/medical/main/diagonal
	icon_state = "preview_diagonal_rainbow"
	blend_state = "diagonal"

/obj/effect/floor_decal/corner/random/medical/main/full
	icon_state = "preview_threethirds_rainbow"
	blend_state = "threethirds"

/obj/effect/floor_decal/corner/random/medical/alt
	color_set_index = /datum/define/color_sets::set_index_alt

/obj/effect/floor_decal/corner/random/medical/alt/diagonal
	icon_state = "preview_diagonal_rainbow"
	blend_state = "diagonal"

/obj/effect/floor_decal/corner/random/medical/alt/full
	icon_state = "preview_threethirds_rainbow"
	blend_state = "threethirds"

// ----

ABSTRACT_TYPE(/obj/effect/floor_decal/corner/random/industrial)
	color_set = /datum/define/color_sets::sets_industrial

/obj/effect/floor_decal/corner/random/industrial/main
	color_set_index = /datum/define/color_sets::set_index_main

/obj/effect/floor_decal/corner/random/industrial/main/diagonal
	icon_state = "preview_diagonal_rainbow"
	blend_state = "diagonal"

/obj/effect/floor_decal/corner/random/industrial/main/full
	icon_state = "preview_threethirds_rainbow"
	blend_state = "threethirds"

/obj/effect/floor_decal/corner/random/industrial/alt
	color_set_index = /datum/define/color_sets::set_index_alt

/obj/effect/floor_decal/corner/random/industrial/alt/diagonal
	icon_state = "preview_diagonal_rainbow"
	blend_state = "diagonal"

/obj/effect/floor_decal/corner/random/industrial/alt/full
	icon_state = "preview_threethirds_rainbow"
	blend_state = "threethirds"

// ----

ABSTRACT_TYPE(/obj/effect/floor_decal/corner/random/gray)
	color_set = /datum/define/color_sets::sets_gray

/obj/effect/floor_decal/corner/random/gray/main
	color_set_index = /datum/define/color_sets::set_index_main

/obj/effect/floor_decal/corner/random/gray/main/diagonal
	icon_state = "preview_diagonal_rainbow"
	blend_state = "diagonal"

/obj/effect/floor_decal/corner/random/gray/main/full
	icon_state = "preview_threethirds_rainbow"
	blend_state = "threethirds"

/obj/effect/floor_decal/corner/random/gray/alt
	color_set_index = /datum/define/color_sets::set_index_alt

/obj/effect/floor_decal/corner/random/gray/alt/diagonal
	icon_state = "preview_diagonal_rainbow"
	blend_state = "diagonal"

/obj/effect/floor_decal/corner/random/gray/alt/full
	icon_state = "preview_threethirds_rainbow"
	blend_state = "threethirds"

// ----

ABSTRACT_TYPE(/obj/effect/floor_decal/corner/random/dark_color)
	color_set = /datum/define/color_sets::sets_dark_color

/obj/effect/floor_decal/corner/random/dark_color/main
	color_set_index = /datum/define/color_sets::set_index_main

/obj/effect/floor_decal/corner/random/dark_color/main/diagonal
	icon_state = "preview_diagonal_rainbow"
	blend_state = "diagonal"

/obj/effect/floor_decal/corner/random/dark_color/main/full
	icon_state = "preview_threethirds_rainbow"
	blend_state = "threethirds"

/obj/effect/floor_decal/corner/random/dark_color/alt
	color_set_index = /datum/define/color_sets::set_index_alt

/obj/effect/floor_decal/corner/random/dark_color/alt/diagonal
	icon_state = "preview_diagonal_rainbow"
	blend_state = "diagonal"

/obj/effect/floor_decal/corner/random/dark_color/alt/full
	icon_state = "preview_threethirds_rainbow"
	blend_state = "threethirds"

// ----
