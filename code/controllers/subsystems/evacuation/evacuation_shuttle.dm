#define EVAC_OPT_CALL_SHUTTLE "call_shuttle"
#define EVAC_OPT_RECALL_SHUTTLE "recall_shuttle"

/datum/evacuation_controller/shuttle
	name = "escape shuttle controller"
	evac_waiting =  new(0, new_sound = sound('sound/AI/shuttledock.ogg'))
	evac_called =   new(0, new_sound = sound('sound/AI/shuttlecalled.ogg'))
	evac_recalled = new(0, new_sound = sound('sound/AI/shuttlerecalled.ogg'))

	emergency_prep_additional_delay = 0 MINUTES
	transfer_prep_additional_delay = 0 MINUTES

	evacuation_options = list(
		EVAC_OPT_CALL_SHUTTLE = new /datum/evacuation_option/call_shuttle(),
		EVAC_OPT_RECALL_SHUTTLE = new /datum/evacuation_option/recall_shuttle()
	)

	var/departed = 0
	var/autopilot = 1
	var/datum/shuttle/autodock/ferry/emergency/shuttle // Set in shuttle_emergency.dm
	var/shuttle_launch_time

/datum/evacuation_controller/shuttle/has_evacuated()
	return departed

/datum/evacuation_controller/shuttle/waiting_to_leave()
	return (!autopilot || (shuttle && shuttle.is_launching()))

/datum/evacuation_controller/shuttle/launch_evacuation()

	if(waiting_to_leave())
		return

	for (var/datum/shuttle/autodock/ferry/escape_pod/pod in GLOB.escape_pods)
		if (!pod.arming_controller || pod.arming_controller.armed)
			pod.move_time = evac_transit_delay
			pod.launch(src)

	if(autopilot && shuttle.moving_status == SHUTTLE_IDLE)
		shuttle.launch(src)

	state = EVAC_IN_TRANSIT

	switch(evacuation_type)
		if(TRANSFER_EMERGENCY)
			priority_announcement.Announce(replacetext(replacetext(SSatlas.current_map.emergency_shuttle_leaving_dock, "%dock%", "[SSatlas.current_map.dock_name]"),  "%ETA%", "[round(get_eta()/60,1)] minute\s"))
		if(TRANSFER_JUMP)
			priority_announcement.Announce(replacetext(replacetext(SSatlas.current_map.bluespace_leaving_dock, "%dock%", "[SSatlas.current_map.dock_name]"),  "%ETA%", "[round(get_eta()/60,1)] minute\s"))
		if(TRANSFER_CREW)
			priority_announcement.Announce(replacetext(replacetext(SSatlas.current_map.shuttle_leaving_dock, "%dock%", "[SSatlas.current_map.dock_name]"),  "%ETA%", "[round(get_eta()/60,1)] minute\s"))


/datum/evacuation_controller/shuttle/finish_preparing_evac()
	departed = 1
	evac_launch_time = world.time + evac_launch_delay

	set_force_countdown(SHUTTLE_FORCETIME)

	. = ..()
	// Arm the escape pods.
	if(evacuation_type == TRANSFER_EMERGENCY)
		for (var/datum/shuttle/autodock/ferry/escape_pod/pod in GLOB.escape_pods)
			if (pod.arming_controller)
				pod.arming_controller.arm()

/datum/evacuation_controller/shuttle/call_evacuation(var/mob/user, var/_evac_type, var/forced, var/skip_announce, var/autotransfer)
	if(..())
		autopilot = 1
		shuttle_launch_time = evac_no_return
		evac_ready_time += shuttle.warmup_time*10
		return 1
	return 0

/datum/evacuation_controller/shuttle/cancel_evacuation()
	if(..() && shuttle.moving_status != SHUTTLE_INTRANSIT)
		shuttle_launch_time = null
		shuttle.cancel_launch(src)
		return 1
	return 0

/datum/evacuation_controller/shuttle/get_eta()
	if (shuttle && shuttle.has_arrive_time())
		return (shuttle.arrive_time-world.time)/10
	return ..()

/datum/evacuation_controller/shuttle/get_status_panel_eta()
	if(has_eta() && waiting_to_leave())
		return "Launching..."
	return ..()

// This is largely handled by the emergency shuttle datum.
/datum/evacuation_controller/shuttle/process()
	if(state == EVAC_PREPPING)
		if(!isnull(shuttle_launch_time) && world.time > shuttle_launch_time && shuttle.moving_status == SHUTTLE_IDLE)
			shuttle.launch()
			shuttle_launch_time = null
		return
	else if(state == EVAC_IN_TRANSIT)
		return
	return ..()

/datum/evacuation_controller/shuttle/can_cancel()
	return (shuttle.moving_status == SHUTTLE_IDLE && shuttle.location && ..())

/datum/evacuation_controller/shuttle/proc/shuttle_leaving()
	state = EVAC_IN_TRANSIT

/datum/evacuation_controller/shuttle/proc/shuttle_evacuated()
	state = EVAC_COMPLETE

/datum/evacuation_controller/shuttle/proc/shuttle_preparing()
	state = EVAC_PREPPING

/datum/evacuation_controller/shuttle/proc/get_long_jump_time()
	if (shuttle.location)
		return round(evac_prep_delay/10)/2
	else
		return round(evac_transit_delay/10)

//begins the launch countdown and sets the amount of time left until launch
/datum/evacuation_controller/proc/set_force_countdown(var/seconds)
	if(!wait_for_force)
		wait_for_force = TRUE
		force_time = world.time + seconds*10

/datum/evacuation_controller/proc/stop_force_countdown()
	wait_for_force = TRUE

/datum/evacuation_controller/shuttle/available_evac_options()
	if (!shuttle.location)
		return list()
	if (is_idle())
		return list(evacuation_options[EVAC_OPT_CALL_SHUTTLE])
	else
		return list(evacuation_options[EVAC_OPT_RECALL_SHUTTLE])

/datum/evacuation_option/call_shuttle
	option_text = "Call emergency shuttle"
	option_desc = "call the emergency shuttle"
	option_target = EVAC_OPT_CALL_SHUTTLE
	needs_syscontrol = TRUE
	silicon_allowed = TRUE

/datum/evacuation_option/call_shuttle/execute(mob/user)
	call_shuttle_proc(user)

/datum/evacuation_option/recall_shuttle
	option_text = "Cancel shuttle call"
	option_desc = "recall the emergency shuttle"
	option_target = EVAC_OPT_RECALL_SHUTTLE
	needs_syscontrol = TRUE
	silicon_allowed = FALSE

/datum/evacuation_option/recall_shuttle/execute(mob/user)
	cancel_call_proc(user)

#undef EVAC_OPT_CALL_SHUTTLE
#undef EVAC_OPT_RECALL_SHUTTLE
