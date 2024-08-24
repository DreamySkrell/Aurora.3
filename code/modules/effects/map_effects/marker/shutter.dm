
/// Large tank marker, used to connect blast doors or shutters to their buttons.
/obj/effect/map_effect/marker/shutter
	name = "shutter marker"
	desc = "See comments/documentation in code."
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "marker_shutter"

	/// Unique tag for these shutters and buttons. Not visible in game and to the player. Do not leave this as null.
	/// THIS MUST BE UNIQUE FOR EVERY SET OF SHUTTER AND BUTTONS. Every marker in a set should have the same `master_tag`.
	/// Different sets, even on different maps, cannot share the same `master_tag`.
	var/master_tag = null

/obj/effect/map_effect/marker/shutter/Initialize(mapload, ...)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/map_effect/marker/shutter/LateInitialize()
	if(!master_tag || !frequency)
		return

	// iterate over components under this marker
	// and actually set them up
	for(var/thing in loc)
		var/obj/machinery/door/blast/door = thing
		if(istype(door))
			door.id = MARKER_LARGE_TANK_TAG_SENSOR
			continue

		var/obj/machinery/button/remote/blast_door/button = thing
		if(istype(button))
			button.id = MARKER_LARGE_TANK_TAG_INJECTOR
			continue
