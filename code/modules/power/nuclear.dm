
// --------------------- core

/obj/machinery/power/nuclear
	name = "nuclear reactor"
	desc = "You aren't supposed to see this."
	icon = 'icons/obj/power.dmi'
	icon_state = "gsmes"
	density = TRUE
	anchored = TRUE
	///
	/// (miniature fusion reactor has max unsafe output 0.8 MW)
	var/internal_heat_max_gain = 1 MEGAWATTS
	/// Stored thermal energy in the reactor, to transfer to the air.
	var/internal_heat = 0 KILOWATTS
	///
	var/melting_point = 2 MEGAWATTS
	/// Control rod height, 0.0 being lowest, 1.0 being highest.
	/// Lower height means less reactivity and heat, higher means more.
	var/control_rod_height = 0.0

/obj/machinery/power/nuclear/process()
	// adjust internal heat
	internal_heat += internal_heat_max_gain * control_rod_height

	// get current turf
	var/turf/turf = get_turf(src)

	// air vars
	var/datum/gas_mixture/air_environment = null
	var/datum/gas_mixture/air_manipulated = null

	// get air
	air_environment = turf.return_air()
	air_manipulated = air_environment.remove(0.25 * air_environment.total_moles)

	// calculate how much heat to add
	var/heat_transfer = internal_heat * 0.9
	internal_heat -= heat_transfer

	// add heat
	air_manipulated.add_thermal_energy(heat_transfer)

	// put air back in
	air_environment.merge(air_manipulated)
