// These are objects that destroy themselves and add themselves to the
// decal list of the floor under them. Use them rather than distinct icon_states
// when mapping in interesting floor designs.

/obj/effect/floor_decal
	name = "floor decal"
	icon = 'icons/turf/decals/decals.dmi'
	layer = DECAL_LAYER
	appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
	var/outline = TRUE //whether it applies the tile outline to shading.
	var/supplied_dir
	var/blend_state // cookie cutter template for how the icon is cut for the decal to be applied.
	var/blend_process = ICON_OVERLAY

/obj/effect/floor_decal/LateInitialize()
	var/turf/T = get_turf(src)
	var/list/floor_decals = SSicon_cache.floor_decals
	if(istype(T, /turf/simulated/floor) || istype(T, /turf/unsimulated/floor))
		layer = T.is_plating() ? DECAL_PLATING_LAYER : DECAL_LAYER
		var/cache_key = "[name]-[alpha]-[color]-[dir]-[icon_state]-[layer]-[blend_state ? blend_state : ""]-[blend_process]-[T.icon]-[T.icon_state]-[T.tile_outline ? T.tile_outline : ""]-[T.tile_outline_blend_process]"
		if(!floor_decals[cache_key])
			var/icon/decal_icon
			var/icon/decal_blend_icon
			var/decal_blend_process
			var/color_to_swap = rgb(255, 0, 220, 255)
			if(T.tile_outline && T.tile_outline_alpha && outline) // handles decals getting cut up by gaps in tiles.
				var/icon/tile_outline_icon = icon('icons/turf/decals/blend.dmi', T.tile_outline)
				tile_outline_icon.SwapColor(color_to_swap, rgb(0, 0, 0, T.tile_outline_alpha))
				decal_blend_icon = tile_outline_icon
				decal_blend_process = T.tile_outline_blend_process
				color_to_swap = rgb(0, 0, 0, T.tile_outline_alpha) // how dark you want the cut to be, son?
			if(blend_state && T.icon && T.icon_state) // handles painted corners adapting to the tile it's on.
				decal_icon = new(icon = T.icon, icon_state = "[T.tile_decal_state ? T.tile_decal_state : T.icon_state]") // take the icon of the tile...
				var/icon/blend_state_icon = icon('icons/turf/decals/blend.dmi', blend_state, dir = src.dir) // get the correct cookie cutter...
				decal_blend_icon = blend_state_icon
				decal_blend_process = blend_process
			if(!decal_icon)
				decal_icon = new(icon = src.icon, icon_state = src.icon_state, dir = src.dir)
			if(decal_blend_icon && decal_blend_process)
				decal_icon.Blend(decal_blend_icon, decal_blend_process)
				decal_icon.SwapColor(color_to_swap, rgb(0, 0, 0, 0)) // cut it up, schiesse
			var/image/I = image(icon = decal_icon)
			I.layer = layer
			I.appearance_flags = appearance_flags
			I.color = src.color
			I.alpha = src.alpha
			floor_decals[cache_key] = I
		if(!T.decals) T.decals = list()
		T.decals |= floor_decals[cache_key]
		T.AddOverlays(floor_decals[cache_key])
		if(desc)
			T.desc += "<br>There is \a [src] on it with the following inscription:<br><i>[desc]</i>"

	qdel(src)

/obj/effect/floor_decal/Initialize(mapload, var/newdir, var/newcolour, bypass = FALSE, var/set_icon_state)
	if (bypass && !mapload)
		return ..(mapload)

	if (newdir)
		supplied_dir = newdir

	if(newcolour)
		color = newcolour

	if (supplied_dir)
		set_dir(supplied_dir)

	if(set_icon_state)
		icon_state = set_icon_state

	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/floor_decal/reset
	name = "reset marker"

/obj/effect/floor_decal/reset/Initialize(mapload)
	. = ..(mapload, bypass = TRUE)
	var/turf/T = get_turf(src)
	if(LAZYLEN(T.decals))
		T.decals.Cut()
		T.update_icon()
	qdel(src)

// Splines.

/obj/effect/floor_decal/carpet
	name = "carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "carpet_edges"
	outline = FALSE

/obj/effect/floor_decal/carpet/blue
	name = "carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "carpet_cyan_edges"

/obj/effect/floor_decal/carpet/corners
	name = "carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "carpet_corners"

/obj/effect/floor_decal/asteroid
	name = "random asteroid rubble"
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid0"

/obj/effect/floor_decal/asteroid/Initialize()
	. = ..()
	icon_state = "asteroid[rand(0,9)]"

/obj/effect/floor_decal/asteroid_dug
	name = "dug asteroid"
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid_dug_overlay"

/obj/effect/floor_decal/chapel
	name = "chapel"
	icon_state = "chapel"
	outline = FALSE

/obj/effect/floor_decal/ss13
	outline = FALSE

/obj/effect/floor_decal/ss13/l1
	name = "L1"
	icon_state = "L1"

/obj/effect/floor_decal/ss13/l2
	name = "L2"
	icon_state = "L2"

/obj/effect/floor_decal/ss13/l3
	name = "L3"
	icon_state = "L3"

/obj/effect/floor_decal/ss13/l4
	name = "L4"
	icon_state = "L4"

/obj/effect/floor_decal/ss13/l5
	name = "L5"
	icon_state = "L5"

/obj/effect/floor_decal/ss13/l6
	name = "L6"
	icon_state = "L6"

/obj/effect/floor_decal/ss13/l7
	name = "L7"
	icon_state = "L7"

/obj/effect/floor_decal/ss13/l8
	name = "L8"
	icon_state = "L8"

/obj/effect/floor_decal/ss13/l9
	name = "L9"
	icon_state = "L9"

/obj/effect/floor_decal/ss13/l10
	name = "L10"
	icon_state = "L10"

/obj/effect/floor_decal/ss13/l11
	name = "L11"
	icon_state = "L11"

/obj/effect/floor_decal/ss13/l12
	name = "L12"
	icon_state = "L12"

/obj/effect/floor_decal/ss13/l13
	name = "L13"
	icon_state = "L13"

/obj/effect/floor_decal/ss13/l14
	name = "L14"
	icon_state = "L14"

/obj/effect/floor_decal/ss13/odin1
	name = "odin1"
	icon_state = "odin1"

/obj/effect/floor_decal/ss13/odin2
	name = "odin2"
	icon_state = "odin2"

/obj/effect/floor_decal/ss13/odin3
	name = "odin3"
	icon_state = "odin3"

/obj/effect/floor_decal/ss13/odin4
	name = "odin4"
	icon_state = "odin4"

/obj/effect/floor_decal/ss13/odin5
	name = "odin5"
	icon_state = "odin5"

/obj/effect/floor_decal/ss13/odin6
	name = "odin6"
	icon_state = "odin6"

// Medbay floor signs

/obj/effect/floor_decal/sign
	name = "floor sign"
	icon_state = "white_1"
	outline = FALSE

/obj/effect/floor_decal/sign/two
	icon_state = "white_2"

/obj/effect/floor_decal/sign/a
	icon_state = "white_a"

/obj/effect/floor_decal/sign/b
	icon_state = "white_b"

/obj/effect/floor_decal/sign/c
	icon_state = "white_c"

/obj/effect/floor_decal/sign/d
	icon_state = "white_d"

/obj/effect/floor_decal/sign/ex
	icon_state = "white_ex"

/obj/effect/floor_decal/sign/m
	icon_state = "white_m"

/obj/effect/floor_decal/sign/cmo
	icon_state = "white_cmo"

/obj/effect/floor_decal/sign/v
	icon_state = "white_v"

/obj/effect/floor_decal/sign/p
	icon_state = "white_p"

// New signs (New-map)

/obj/effect/floor_decal/sign/gtr
	icon_state = "white_gtr"

/obj/effect/floor_decal/sign/paramedic
	icon_state = "white_emt"

/obj/effect/floor_decal/sign/w
	icon_state = "white_w"

/obj/effect/floor_decal/sign/icu
	icon_state = "white_icu"

/obj/effect/floor_decal/sign/c2
	icon_state = "white_c2"

/obj/effect/floor_decal/sign/srg
	icon_state = "white_srg"

// Concrete Decals
/obj/effect/floor_decal/concrete
	icon_state = "corner_concrete"

/obj/effect/floor_decal/concrete/large
	icon_state = "corner_concrete_large"

/obj/effect/floor_decal/concrete/large/cee
	icon_state = "corner_concrete_large_cee"

/obj/effect/floor_decal/concrete/large/full
	icon_state = "corner_concrete_large_full"

/obj/effect/floor_decal/concrete/square
	icon_state = "corner_concrete_square"

/obj/effect/floor_decal/concrete/gutter
	icon_state = "concrete_gutter"

/obj/effect/floor_decal/concrete/gutter/corner
	icon_state = "concrete_gutter_corner"
