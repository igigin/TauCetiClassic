/obj/item/weapon/folder
	name = "folder"
	desc = "A folder."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "folder"
	w_class = ITEM_SIZE_SMALL

/obj/item/weapon/folder/blue
	desc = "A blue folder."
	icon_state = "folder_blue"

/obj/item/weapon/folder/red
	desc = "A red folder."
	icon_state = "folder_red"

/obj/item/weapon/folder/yellow
	desc = "A yellow folder."
	icon_state = "folder_yellow"

/obj/item/weapon/folder/white
	desc = "A white folder."
	icon_state = "folder_white"

/obj/item/weapon/folder/purple
	desc = "A purple folder."
	icon_state = "folder_purple"

/obj/item/weapon/folder/update_icon()
	cut_overlays()
	if(contents.len)
		add_overlay("folder_paper")
	return

/obj/item/weapon/folder/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/paper) || istype(W, /obj/item/weapon/photo) || istype(W, /obj/item/weapon/paper_bundle))
		user.drop_item()
		W.loc = src
		to_chat(user, "<span class='notice'>You put the [W] into \the [src].</span>")
		update_icon()
	else if(istype(W, /obj/item/weapon/pen))
		var/n_name = sanitize(input(usr, "What would you like to label the folder?", "Folder Labelling", null) as text, MAX_NAME_LEN)
		if((loc == usr && usr.stat == CONSCIOUS))
			name = "folder[(n_name ? text("- '[n_name]'") : null)]"
	return

/obj/item/weapon/folder/attack_self(mob/user)
	var/dat = "<title>[name]</title>"

	for(var/obj/item/weapon/paper/P in src)
		dat += "<A href='?src=\ref[src];remove=\ref[P]'>Remove</A> - <A href='?src=\ref[src];read=\ref[P]'>[sanitize(P.name)]</A><BR>"
	for(var/obj/item/weapon/photo/Ph in src)
		dat += "<A href='?src=\ref[src];remove=\ref[Ph]'>Remove</A> - <A href='?src=\ref[src];look=\ref[Ph]'>[sanitize(Ph.name)]</A><BR>"
	for(var/obj/item/weapon/paper_bundle/Pb in src)
		dat += "<A href='?src=\ref[src];remove=\ref[Pb]'>Remove</A> - <A href='?src=\ref[src];browse=\ref[Pb]'>[sanitize(Pb.name)]</A><BR>"
	user << browse(entity_ja(dat), "window=folder")
	onclose(user, "folder")
	add_fingerprint(usr)
	return

/obj/item/weapon/folder/Topic(href, href_list)
	..()
	if((usr.stat || usr.restrained()))
		return

	if(usr.contents.Find(src))

		if(href_list["remove"])
			var/obj/item/P = locate(href_list["remove"])
			if(P && P.loc == src)
				P.loc = usr.loc
				usr.put_in_hands(P)

		if(href_list["read"])
			var/obj/item/weapon/paper/P = locate(href_list["read"])
			if(P)
				P.show_content(usr)
		if(href_list["look"])
			var/obj/item/weapon/photo/P = locate(href_list["look"])
			if(P)
				P.show(usr)
		if(href_list["browse"])
			var/obj/item/weapon/paper_bundle/P = locate(href_list["browse"])
			if(P)
				P.attack_self(usr)
				onclose(usr, "[P.name]")

		//Update everything
		attack_self(usr)
		update_icon()
	return
