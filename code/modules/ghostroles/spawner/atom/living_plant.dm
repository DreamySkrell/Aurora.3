/datum/ghostspawner/living_plant/New()
	..()
	short_name = "living_plant"
	name = "Living Plant"
	desc = "Join in as a Living Plant. What do plants do?"
	tags = list("Simple Mobs")

	loc_type = GS_LOC_ATOM
	atom_add_message = "A Living Plant has sprung up somewhere on the [station_name(TRUE)]!"

	spawn_mob = /mob/living
