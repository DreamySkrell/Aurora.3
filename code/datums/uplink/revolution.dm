/datum/uplink_item/item/revolution
	category = /datum/uplink_category/revolution

/datum/uplink_item/item/revolution/armory/New()
	name = "Armory Dropper"
	desc = "A device that can be used to drop in an armory-worth of guns. Can only be used outside [SSatlas.current_map.station_short] areas, unless emagged, which is hazardous."
	telecrystal_cost = 25
	path = /obj/item/device/orbital_dropper/armory/syndicate

/datum/uplink_item/item/revolution/implants
	name = "Box of Aggression Implants"
	desc = "A box containing implants that will make their owners increasingly aggressive."
	telecrystal_cost = 2
	bluecrystal_cost = 2
	path = /obj/item/storage/box/aggression

/datum/uplink_item/item/revolution/encryption_keys
	name = "Box of Encryption Keys"
	desc = "A box of encryption keys that gives the user a safe channel to chatter in. Access safe channel with :x."
	telecrystal_cost = 3
	bluecrystal_cost = 3
	path = /obj/item/storage/box/encryption_key

/datum/uplink_item/item/revolution/softsuits
	name = "Crate of Softsuits"
	desc = "A crate containing six softsuits, their helmets, and oxygen tanks. Useful for getting out of a pinch."
	telecrystal_cost = 3
	bluecrystal_cost = 3
	path = /obj/structure/closet/crate/secure/gear_loadout/syndicate_softsuits
