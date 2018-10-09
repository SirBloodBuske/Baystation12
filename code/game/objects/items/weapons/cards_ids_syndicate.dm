/obj/item/weapon/card/id/syndicate
	icon_state = "syndicate"
	assignment = "Agent"
	origin_tech = list(TECH_ILLEGAL = 3)
	var/electronic_warfare = 1
	var/mob/registered_user = null

/obj/item/weapon/card/id/syndicate/New(mob/user as mob)
	..()
	access = syndicate_access.Copy()

/obj/item/weapon/card/id/syndicate/station_access/New()
	..() // Same as the normal Syndicate id, only already has all station access
	access |= get_all_station_access()

/obj/item/weapon/card/id/syndicate/Destroy()
	unset_registered_user(registered_user)
	return ..()

/obj/item/weapon/card/id/syndicate/prevent_tracking()
	return electronic_warfare

/obj/item/weapon/card/id/syndicate/afterattack(var/obj/item/weapon/O as obj, mob/user as mob, proximity)
	if(!proximity) return
	if(istype(O, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/I = O
		src.access |= I.access
		if(player_is_antag(user.mind))
			to_chat(user, "<span class='notice'>The microscanner activates as you pass it over the ID, copying its access.</span>")

/obj/item/weapon/card/id/syndicate/attack_self(mob/user as mob)
	// We use the fact that registered_name is not unset should the owner be vaporized, to ensure the id doesn't magically become unlocked.
	if(!registered_user && register_user(user))
		to_chat(user, "<span class='notice'>The microscanner marks you as its owner, preventing others from accessing its internals.</span>")
	if(registered_user == user)
		switch(alert("Would you like edit the ID, or show it?","Show or Edit?", "Edit","Show"))
			if("Edit")
				ui_interact(user)
			if("Show")
				..()
	else
		..()

/obj/item/weapon/card/id/syndicate/proc/register_user(var/mob/user)
	if(!istype(user) || user == registered_user)
		return FALSE
	unset_registered_user()
	registered_user = user
	user.set_id_info(src)
	GLOB.destroyed_event.register(user, src, /obj/item/weapon/card/id/syndicate/proc/unset_registered_user)
	return TRUE

/obj/item/weapon/card/id/syndicate/proc/unset_registered_user(var/mob/user)
	if(!registered_user || (user && user != registered_user))
		return
	GLOB.destroyed_event.unregister(registered_user, src)
	registered_user = null

/obj/item/weapon/card/id/syndicate/CanUseTopic(mob/user)
	if(user != registered_user)
		return STATUS_CLOSE
	return ..()


/var/global/list/id_card_states
/proc/id_card_states()
	if(!id_card_states)
		id_card_states = list()
		for(var/path in typesof(/obj/item/weapon/card/id))
			var/obj/item/weapon/card/id/ID = path
			var/datum/card_state/CS = new()
			CS.icon_state = initial(ID.icon_state)
			CS.item_state = initial(ID.item_state)
			CS.name = initial(ID.name) + " - " + initial(ID.icon_state)
			id_card_states += CS
		id_card_states = dd_sortedObjectList(id_card_states)

	return id_card_states

/datum/card_state
	var/name
	var/icon_state
	var/item_state

/datum/card_state/dd_SortValue()
	return name
