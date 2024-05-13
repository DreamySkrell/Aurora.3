

/turf/simulated/floor/limbo
	name = "fabric of reality"
	icon = 'maps/away/away_site/limbo/limbo.dmi'
	icon_state = "evilwall_1"

/turf/simulated/floor/limbo/Initialize(mapload)
	. = ..()
	icon_state = pick(
		"evilwall_1", "evilwall_2", "evilwall_3", "evilwall_4",
		"evilwall_5", "evilwall_6", "evilwall_7", "evilwall_8",
		"evileye",
	)
	color = pick(
		"#333333", "#444444", "#555555",
		"#666666", "#777777", "#888888",
	)
