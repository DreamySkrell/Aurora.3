GLOBAL_LIST_EMPTY(sparring_attack_cache)

//Species unarmed attacks
/datum/unarmed_attack
	var/attack_verb = list("attack")	// Empty hand hurt intent verb.
	var/attack_noun = list("fist")
	var/desc = "A simple unarmed attack."
	var/damage = 0						// Extra empty hand attack damage.
	var/armor_penetration = 0
	var/attack_sound = /singleton/sound_category/punch_sound
	var/miss_sound = /singleton/sound_category/punchmiss_sound
	var/shredding = 0 // Calls the old attack_alien() behavior on objects/mobs when on harm intent.
	var/attack_door = 0 // Whether the attack can damage airlocks and how much damage it does
	var/crowbar_door = FALSE
	var/sharp = 0
	var/edge = FALSE

	var/damage_type = DAMAGE_BRUTE
	var/sparring_variant_type = /datum/unarmed_attack/pain_strike

	var/eye_attack_text
	var/eye_attack_text_victim

	var/attack_name = "fist"

/datum/unarmed_attack/proc/get_sparring_variant()
	if(sparring_variant_type)
		if(!GLOB.sparring_attack_cache[sparring_variant_type])
			GLOB.sparring_attack_cache[sparring_variant_type] = new sparring_variant_type()
		return GLOB.sparring_attack_cache[sparring_variant_type]

/datum/unarmed_attack/proc/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)
	if(user.restrained() || user.incapacitated())
		return FALSE

	// Check if they have a functioning hand.
	var/obj/item/organ/external/E = user.organs_by_name[BP_L_HAND]
	if(E && !E.is_stump())
		return TRUE

	E = user.organs_by_name[BP_R_HAND]
	if(E && !E.is_stump())
		return TRUE

	return FALSE

/**
 * Returns the unarmed damage of an attack, aka what damage the attack does if there's no objects involved
 *
 * * attacker - The `/mob` that is performing the attack
 * * target - The target of the attack, aka who is being attacked/damaged
 */
/datum/unarmed_attack/proc/get_unarmed_damage(var/mob/attacker, var/target)
	SHOULD_BE_PURE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	return damage

/datum/unarmed_attack/proc/apply_effects(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/attack_damage,var/zone)

	if(target.stat == DEAD)
		return

	var/stun_chance = rand(0, 100)
	var/armor = target.get_blocked_ratio(zone, DAMAGE_BRUTE, damage_flags(), armor_penetration, damage)
	var/pain_message = TRUE

	if(!target.can_feel_pain())
		pain_message = FALSE

	if(attack_damage >= 5 && armor < 1 && !(target == user) && stun_chance <= attack_damage * 5) // 25% standard chance
		switch(zone) // strong punches can have effects depending on where they hit
			if(BP_HEAD, BP_MOUTH, BP_EYES)
				// Induce blurriness
				if(pain_message)
					target.visible_message(SPAN_DANGER("[target] looks momentarily disoriented."),
											SPAN_DANGER("You see stars."))

				target.apply_effect(attack_damage*2, EYE_BLUR, armor)
			if(BP_L_ARM, BP_L_HAND)
				if (target.l_hand)
					// Disarm left hand
					//Urist McAssistant dropped the macguffin with a scream just sounds odd. Plus it doesn't work with NO_PAIN
					target.visible_message(SPAN_DANGER("\The [target.l_hand] was knocked right out of [target]'s grasp!"))
					target.drop_l_hand()
			if(BP_R_ARM, BP_R_HAND)
				if (target.r_hand)
					// Disarm right hand
					target.visible_message(SPAN_DANGER("\The [target.r_hand] was knocked right out of [target]'s grasp!"))
					target.drop_r_hand()
			if(BP_CHEST)
				if(!target.lying)
					var/turf/T = get_step(get_turf(target), get_dir(get_turf(user), get_turf(target)))
					if(!T.density)
						step(target, get_dir(get_turf(user), get_turf(target)))
						target.visible_message(SPAN_DANGER("[pick("[target] was sent flying backward!", "[target] staggers back from the impact!")]"))
					else
						target.visible_message(SPAN_DANGER("[target] slams into [T]!"))
					if(prob(50))
						target.set_dir(REVERSE_DIR(target.dir))
					target.apply_effect(attack_damage * 0.4, WEAKEN, armor)
			if(BP_GROIN)
				if(pain_message)
					target.visible_message(SPAN_WARNING("[target] looks like [target.get_pronoun("he")] [target.get_pronoun("is")] in pain!"),
											SPAN_WARNING("[(target.gender=="female") ? "Oh god that hurt!" : "Oh no, that REALLY hurt!"]"))

				target.apply_effects(stutter = attack_damage * 2, agony = attack_damage* 3, blocked = (armor * 100))
			if(BP_L_LEG, BP_L_FOOT, BP_R_LEG, BP_R_FOOT)
				if(!target.lying)
					if(pain_message)
						target.visible_message(SPAN_WARNING("[target] gives way slightly."))
					target.apply_effect(attack_damage*3, DAMAGE_PAIN, armor)
	else if(attack_damage >= 5 && !(target == user) && (stun_chance + attack_damage * 5 >= 100) && armor < 1) // Chance to get the usual throwdown as well (25% standard chance)
		if(!target.lying)
			target.visible_message(SPAN_DANGER("[target] [pick("slumps", "falls", "drops")] down to the ground!"))
		else
			target.visible_message(SPAN_DANGER("[target] has been weakened!"))
		target.apply_effect(3, WEAKEN, armor*100)

/datum/unarmed_attack/proc/show_attack(var/mob/living/carbon/human/user, var/mob/living/target, var/zone, var/attack_damage)
	SHOULD_NOT_SLEEP(TRUE)

	var/affecting = null

	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/human = target
		var/obj/item/organ/organ = human.get_organ(zone)
		affecting = organ?.name

	else if(istype(target, /mob/living/heavy_vehicle))
		var/mob/living/heavy_vehicle/mech = target
		var/obj/item/mech_component/component = mech.zoneToComponent(zone)
		affecting = component?.name


	if(!affecting)
		return

	user.visible_message(SPAN_WARNING("[user] [pick(attack_verb)] [target] in the [affecting]!"))
	playsound(user.loc, attack_sound, 25, 1, -1)

/datum/unarmed_attack/proc/show_attack_simple(var/mob/living/carbon/human/user, var/mob/living/target, var/zone)
	user.visible_message(SPAN_WARNING("[user] [pick(attack_verb)] [target] in the [zone]!"))
	playsound(user.loc, attack_sound, 25, 1, -1)

/datum/unarmed_attack/proc/handle_eye_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target)
	var/obj/item/organ/internal/eyes/eyes = target.get_eyes()
	eyes.take_damage(rand(3,4), 1)

	user.visible_message(SPAN_DANGER("[user] presses [user.get_pronoun("his")] [eye_attack_text] into [target]'s [eyes.name]!"))
	to_chat(target, SPAN_DANGER("You experience[(!target.can_feel_pain())? "" : " immense pain as you feel" ] [eye_attack_text_victim] being pressed into your [eyes.name][(!target.can_feel_pain())? "." : "!"]"))

/datum/unarmed_attack/proc/damage_flags()
	. = 0
	if(sharp)
		. |= DAMAGE_FLAG_SHARP
	if(edge)
		. |= DAMAGE_FLAG_EDGE

/datum/unarmed_attack/bite
	attack_verb = list("bit")
	attack_sound = 'sound/weapons/bite.ogg'
	desc = "Biting down on the opponent with your teeth. Only possible if you aren't wearing a muzzle. Don't try biting their head, it won't work!"
	shredding = 0
	damage = 0
	sharp = 0
	edge = FALSE
	attack_name = "bite"

/datum/unarmed_attack/bite/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)
	if(user.incapacitated())
		return FALSE
	if(user.wear_mask && istype(user.wear_mask, /obj/item/clothing/mask/muzzle))
		return FALSE
	if(user == target && (zone == BP_HEAD || zone == BP_EYES || zone == BP_MOUTH))
		return FALSE
	return TRUE

/datum/unarmed_attack/punch
	attack_verb = list("punched")
	attack_noun = list("fist")
	desc = "A classic, beating the nonsense out of your enemies with your arm clubs. The damage is variable, but it's versatile and you will never* lose them.<br>*Almost Never"
	eye_attack_text = "fingers"
	eye_attack_text_victim = "digits"
	damage = 0
	attack_name = "punch"

/datum/unarmed_attack/punch/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)

	if(!affecting)
		return

	var/organ = affecting.name

	attack_damage = clamp(attack_damage, 1, 5) // We expect damage input of 1 to 5 for this proc. But we leave this check juuust in case.

	if(target == user)
		user.visible_message(SPAN_DANGER("[user] [pick(attack_verb)] [user.get_pronoun("himself")] in the [organ]!"))
		return 0

	if(!target.lying)
		switch(zone)
			if(BP_HEAD, BP_MOUTH, BP_EYES)
				// ----- HEAD ----- //
				switch(attack_damage)
					if(1 to 2)
						user.visible_message(SPAN_DANGER("[user] slapped [target] across [target.get_pronoun("his")] cheek!"))
					if(3 to 4)
						user.visible_message(pick(
							40; SPAN_DANGER("[user] [pick(attack_verb)] [target] in the head!"),
							30; SPAN_DANGER("[user] struck [target] in the head[pick("", " with a closed fist")]!"),
							30; SPAN_DANGER("[user] threw a hook against [target]'s head!")
							))
					if(5)
						user.visible_message(pick(
							30; SPAN_DANGER("[user] gave [target] a resounding [pick("slap", "punch")] to the face!"),
							40; SPAN_DANGER("[user] smashed [user.get_pronoun("his")] [pick(attack_noun)] into [target]'s face!"),
							30; SPAN_DANGER("[user] gave a strong blow against [target]'s jaw!")
							))
			else
				// ----- BODY ----- //
				switch(attack_damage)
					if(1 to 2)	user.visible_message(SPAN_DANGER("[user] threw a glancing punch at [target]'s [organ]!"))
					if(1 to 4)	user.visible_message(SPAN_DANGER("[user] [pick(attack_verb)] [target] in [target.get_pronoun("his")] [organ]!"))
					if(5)
						user.visible_message(pick(
							50; SPAN_DANGER("[user] smashed [user.get_pronoun("his")] [pick(attack_noun)] into [target]'s [organ]!"),
							50; SPAN_DANGER("[user] landed a striking [pick(attack_noun)] on [target]'s [organ]!")
							))
	else
		user.visible_message(SPAN_DANGER("[user] [pick("punched", "threw a punch against", "struck", "slammed their [pick(attack_noun)] into")] [target]'s [organ]!")) //why do we have a separate set of verbs for lying targets?

/datum/unarmed_attack/palm // attacking with a fist generally gives higher DPS, this is for style points
	attack_verb = list("smacked")	// Empty hand hurt intent verb.
	attack_noun = list("palm")
	desc = "Striking your opponent with your palm. Certainly a method to do damage to flesh beneath the skin without risking your knuckles. This method of attack showcases some more restraint, the damage output is more stable, too."
	damage = 2
	attack_name = "palm"

/datum/unarmed_attack/palm/unathi // only one more damage, pretty much just for show
	attack_sound = /singleton/sound_category/punch_bassy_sound
	desc = "Striking your opponent with your palm. A method of dishing out damage without risking your claws or shredding your opponent to ribbons. This method of attack showcases some more restraint, the damage output is more stable, too."
	damage = 3

/datum/unarmed_attack/palm/industrial
	desc = "Striking your opponent with your palm. Certainly a method to do damage to flesh beneath the skin without risking your knuckles. This method of attack showcases some more restraint, but you're still going to lay on the hurt."
	damage = 5

/datum/unarmed_attack/kick
	attack_verb = list("kicked", "kicked", "kicked", "kneed")
	attack_noun = list("kick", "kick", "kick", "knee strike")
	attack_sound = /singleton/sound_category/swing_hit_sound
	desc = "A high risk, pretty low reward move. It could be useful if your shoes has a knife sticking out the front, or if you're a trained martial arts master. Make sure to target the lower parts of the body, or else you won't be able to reach!"
	damage = 0
	attack_name = "kick"

/datum/unarmed_attack/kick/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)
	if(user.legcuffed || user.incapacitated())
		return FALSE

	if(!(zone in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT, BP_GROIN)))
		return FALSE

	var/obj/item/organ/external/E = user.organs_by_name[BP_L_FOOT]
	if(E && !E.is_stump())
		return TRUE

	E = user.organs_by_name[BP_R_FOOT]
	if(E && !E.is_stump())
		return TRUE

	return FALSE

/datum/unarmed_attack/kick/get_unarmed_damage(var/mob/attacker, var/mob/living/carbon/human/target)
	var/obj/item/clothing/shoes = target.shoes
	if(!istype(shoes))
		return damage
	return damage + (shoes ? shoes.force : 0)

/datum/unarmed_attack/kick/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)

	if(!affecting)
		return

	var/organ = affecting.name

	attack_damage = clamp(attack_damage, 1, 5)

	switch(attack_damage)
		if(1 to 2)	user.visible_message(SPAN_DANGER("[user] threw [target] a glancing [pick(attack_noun)] to the [organ]!")) //it's not that they're kicking lightly, it's that the kick didn't quite connect
		if(3 to 4)	user.visible_message(SPAN_DANGER("[user] [pick(attack_verb)] [target] in [target.get_pronoun("his")] [organ]!"))
		if(5)		user.visible_message(SPAN_DANGER("[user] landed a strong [pick(attack_noun)] against [target]'s [organ]!"))

/datum/unarmed_attack/stomp
	attack_verb = null
	attack_noun = list("stomp")
	attack_sound = /singleton/sound_category/swing_hit_sound
	desc = "An incredible tactic for turning a downed opponent into tenderized meat! Stomping is a safe and sound method of dispatching downed enemies, but it only works if they're already lying down."
	damage = 0
	attack_name = "stomp"

/datum/unarmed_attack/stomp/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)
	if(user.legcuffed || user.incapacitated())
		return FALSE
	if(!istype(target))
		return FALSE

	if(!user.lying && (target.lying || (zone in list(BP_L_FOOT, BP_R_FOOT))))
		if(target.grabbed_by == user && target.lying)
			return FALSE
		var/obj/item/organ/external/E = user.organs_by_name[BP_L_FOOT]
		if(E && !E.is_stump())
			return TRUE

		E = user.organs_by_name[BP_R_FOOT]
		if(E && !E.is_stump())
			return TRUE

		return FALSE

/datum/unarmed_attack/stomp/get_unarmed_damage(var/mob/attacker, var/mob/living/carbon/human/target)
	var/obj/item/clothing/shoes = target.shoes
	return damage + (shoes ? shoes.force : 0)

/datum/unarmed_attack/stomp/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)

	if(!affecting)
		return

	var/organ = affecting.name

	var/obj/item/clothing/shoes = user.shoes

	attack_damage = clamp(attack_damage, 1, 5)

	switch(attack_damage)
		if(1 to 4)	user.visible_message(SPAN_DANGER("[pick("[user] stomped on", "[user] slammed [user.get_pronoun("his")] [shoes ? copytext(shoes.name, 1, -1) : "foot"] down onto")] [target]'s [organ]!"))
		if(5)		user.visible_message(SPAN_DANGER("[pick("[user] landed a powerful stomp on", "[user] stomped down hard on", "[user] slammed [user.get_pronoun("his")] [shoes ? copytext(shoes.name, 1, -1) : "foot"] down hard onto")] [target]'s [organ]!")) //Devastated lol. No. We want to say that the stomp was powerful or forceful, not that it /wrought devastation/

/datum/unarmed_attack/pain_strike
	damage_type = DAMAGE_PAIN
	attack_noun = list("tap","light strike")
	attack_verb = list("tapped", "lightly struck")
	desc = "Sparring: A light strike to your opponent. So light, it won't even leave a mark! They WILL feel this, but will suffer no dangerous side effect, unless you punch them into cardiac arrest!"
	damage = 0
	shredding = 0
	sharp = 0
	edge = FALSE
	attack_name = "light hit"

/datum/unarmed_attack/pain_strike/heavy
	attack_noun = list("smack", "heavy strike")
	attack_verb = list("smacked", "strongly struck")
	desc = "Sparring: A heavy strike to your opponent. With poise and precision, no evidence will be left behind! They WILL ABSOLUTELY feel this, but will suffer no dangerous side effect, unless you punch them into cardiac arrest! Show off your might!"
	damage = 4
	attack_name = "heavy hit"
	attack_sound = /singleton/sound_category/punch_bassy_sound
