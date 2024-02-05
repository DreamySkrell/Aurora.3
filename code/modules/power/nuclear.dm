
/obj/machinery/power/nuclear
	name = "nuclear reactor"
	desc = "You aren't supposed to see this."
	icon = 'icons/obj/power.dmi'
	icon_state = "gsmes"
	density = TRUE
	anchored = TRUE

/obj/machinery/power/nuclear/process()
	var/turf/turf = loc
