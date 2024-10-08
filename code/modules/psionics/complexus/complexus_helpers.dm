/datum/psi_complexus/proc/stunned(var/amount)
	var/old_stun = stun
	stun = max(stun, amount)
	if(amount && !old_stun)
		to_chat(owner, SPAN_DANGER("Your concentration has been shattered! You cannot focus your psi power!"))
		ui.update_icon()

/datum/psi_complexus/proc/get_armor(var/armortype)
	if(can_use_passive())
		last_armor_check = world.time
		return round(clamp(clamp(4 * get_rank(), 0, 20) * get_rank() / 2, 0, 100) * (stamina/max_stamina))
	else
		last_armor_check = 0
		return 0

/datum/psi_complexus/proc/set_rank(var/rank, var/defer_update)
	if(get_rank() != rank)
		last_psionic_rank = psionic_rank
		psionic_rank = rank
		if(!defer_update)
			update()

/datum/psi_complexus/proc/get_rank()
	return psionic_rank

/datum/psi_complexus/proc/set_cooldown(var/value)
	next_power_use = world.time + value
	ui.update_icon()

/datum/psi_complexus/proc/can_use_passive()
	return (owner.stat == CONSCIOUS && !suppressed && !stun)

/datum/psi_complexus/proc/can_use(var/incapacitation_flags)
	return (owner.stat == CONSCIOUS && (!incapacitation_flags || !owner.incapacitated(incapacitation_flags)) && !suppressed && !stun && world.time >= next_power_use)

/datum/psi_complexus/proc/spend_power(var/value = 0, var/check_incapacitated)
	. = FALSE
	if(isnull(check_incapacitated))
		check_incapacitated = (INCAPACITATION_STUNNED|INCAPACITATION_KNOCKOUT)
	if(can_use(check_incapacitated))
		value = max(1, Ceiling(value * cost_modifier))
		if(value <= stamina)
			stamina -= value
			ui.update_icon()
			. = TRUE
		else
			backblast(abs(stamina - value))
			stamina = 0
			. = FALSE
		ui.update_icon()

/datum/psi_complexus/proc/hide_auras()
	if(owner.client)
		for(var/thing in SSpsi.all_aura_images)
			owner.client.images -= thing

/datum/psi_complexus/proc/show_auras()
	if(owner.client)
		for(var/image/I in SSpsi.all_aura_images)
			owner.client.images |= I

/datum/psi_complexus/proc/backblast(var/value)

	// Can't backblast if you're controlling your power.
	if(!owner || suppressed)
		return FALSE

	sound_to(owner, sound('sound/effects/psi/power_feedback.ogg'))
	to_chat(owner, SPAN_DANGER("<font size=3>Wild energistic feedback blasts across your psyche!</font>"))
	stunned(value * 2)
	set_cooldown(value * 100)

	if(prob(value*10))
		owner.emote("scream")

	// Your head asplode.
	owner.adjustBrainLoss(value)
	owner.adjustHalLoss(value * 25) //Ouch.
	owner.psi.hide_auras()
	if(ishuman(owner))
		var/mob/living/carbon/human/pop = owner
		if(pop.should_have_organ(BP_BRAIN))
			var/obj/item/organ/internal/brain/sponge = pop.internal_organs_by_name[BP_BRAIN]
			if(sponge && sponge.damage >= sponge.max_damage)
				var/obj/item/organ/external/affecting = pop.get_organ(sponge.parent_organ)
				if(affecting && !affecting.is_stump())
					affecting.droplimb(0, DROPLIMB_BLUNT)
					if(sponge) qdel(sponge)

/datum/psi_complexus/proc/reset()
	aura_color = initial(aura_color)
	max_stamina = initial(max_stamina)
	stamina = min(stamina, max_stamina)
	update()
