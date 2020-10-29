pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- scumm-8 game template
-- paul nicholas
cartdata("nlb_batshit_basement")
--- this one is the rooms ----
swear = dget(0) == 2


menuitem(1, "clear+start new", function()
	for i=0,63 do
		dset(i,0)
	end
	load("bb-intro")
end)

-- [debug flags]
 --show_debuginfo = true
-- show_collision = true
-- show_pathfinding = true
 --show_depth = true

-- [game flags]
enable_diag_squeeze = false	-- allow squeeze through diag gap?


-- game verbs (used in room definitions and ui)
verbs = {
	--{verb = verb_ref_name}, text = display_name
	{ { open = "open" }, text = "open" },
	{ { close = "close" }, text = "close" },
	{ { give = "give" }, text = "give" },
	{ { pickup = "pickup" }, text = "pick-up" },
	{ { lookat = "lookat" }, text = "look-at" },
	{ { talkto = "talkto" }, text = "talk-to" },
--	{ { push = "push" }, text = "push" },
--	{ { pull = "pull" }, text = "pull"},
	{ { use = "use" }, text = "use"}
}
-- verb to use when just clicking aroung (e.g. move actor)
verb_default = {
	{ walkto = "walkto" }, text = "walk to"
} 
-- index of the verb to use when clicking items in inventory (e.g. look-at)
verb_default_inventory_index = 5


function reset_ui()
	verb_maincol = 12  -- main color (lt blue)
	verb_hovcol = 7    -- hover color (white)
	verb_shadcol = 1   -- shadow (dk blue)
	verb_defcol = 10   -- default action (yellow)
 ui_cursorspr = 96  -- default cursor sprite
 ui_uparrowspr = 80 -- default up arrow sprite
 ui_dnarrowspr = 112-- default up arrow sprite
 -- default cols to use when animating cursor
 ui_cursor_cols = {7,12,13,13,12,7}
end
-- initial ui setup
reset_ui()


-- 
-- room & object definitions
-- 

-- [ ground floor ]
obj_tuna = {
	data = [[
		name=can of tuna
		state=state_gone
		state_gone=97
		state_open=98
		w=1
		h=1
		z=6
		x=34
		y=27
		classes={class_openable, class_pickupable}
		trans_col=0
		use_with=true
	]],
	verbs = {
		lookat = function(me)
			if me.state == "state_here" then
			say_line("it's a can of tuna? in the fridge for some reason?")
			else
				say_line("a can of tuna")
			end
		end,
		pickup = function(me)
			me.state = "state_gone"
			pickup_obj(me)
			dset(16,2)
		end,
		open = function(me)
			say_line("it doesn't have a pop top. annoying.")
		end,
		give = function(me,noun2)
			if noun2 == cat and obj_tuna.state == "state_open" then
				dset(18,6)
				cutscene(
					1, -- no verbs
					function()
						say_line("maybe this will distract you")
						stop_script(cat.scripts.summon)
						stop_script(cat.scripts.follow)
						stop_actor(cat)
						cat.flip_x = true
						obj_tuna.owner = cat
						put_at(obj_tuna, 110,49, room_curr)
						obj_tuna.state = "state_open"								
						say_line(cat, "*prrrrrrr*")
					end
				)
				
			end
		end,
		use = function(me, noun2)
			if dget(13) < 2 then
				say_line("I know we used to have a can opener...")
			elseif dget(14) < 2 then
				say_line("the can opener won't turn on")
			elseif noun2 == obj_can_opener then
				say_line(me, "*brrrrrrrrr*")
				obj_tuna.state = "state_open"
				dset(16,3)
				start_script(cat.scripts.summon)
			end
		end
	}

}

obj_can_opener = {
	data = [[
		name = broken can opener
		state=state_here
		w=1
		h=1
		x=58
		y=64
		z=30
		state_here=159
		state_gone=143
		state_powered=175
		trans_col=11
		use_with=true
	]],
	verbs = {
		lookat = function()
			say_line("i remember this thing -: it won't turn on for some reason.:we, uh, got drunk and gave it a burial at couch.")
		end,
		use = function(me, noun2)
			if dget(14) < 2 then
				say_line("the can opener won't turn on")
			elseif noun2 == obj_tuna then
				say_line(me, "*brrrrrrrrr*")
				obj_tuna.state = "state_open"
				dset(16,3)
				start_script(cat.scripts.summon)
			end
		end
	}
}

		obj_greg_window_inside = {
			data = [[
				name=greg's window
				x=32
				y=0
				w=1
				h=1
				state=state_open
				state_open=0
				lighting=1
				trans_col=11
				classes={class_door}
			]],
			verbs = {
				walkto = function(me)
					say_line("i can't reach it!")
				end,
				lookat = function()
					say_line("didn't really think that one through, did i...: how am I gonna get out?")
				end,
				open = function()
					say_line("that's as open as it's gonna get:not that it does me any good from down here")	
				end,
				close = function()
					say_line("I think that ship has sailed")
				end
			}
		}

		obj_desk = {
			data = [[
					name=rolltop desk
					x=64
					y=25
					w=4
					h=3
					z=1
					state_closed=128
					state_open=132
					lighting=1
					trans_col=11
					classes={class_openable}
			]],
			verbs = {
				lookat = function(me)
					say_line("this bad boy can fit so many ghosts")
				end,
				open = function(me)
					me.state = "state_open"
					dset(9,2)
				end,
				close = function(me)
					me.state = "state_closed"
					dset(9,1)
				end
			}
		}

		obj_skull = {
			data = [[
				name= tiny skull
				x=78
				y=26
				w=1
				h=1
				state=state_here
				state_here=137
				state_gone=136
				classes={class_pickupable}
				trans_col=11
				z=2
				dependent_on_state=state_open
				use_pos={64,25}
			]],
			dependent_on=obj_desk,
			verbs = {
				lookat = function(me)
					say_line("like a rat or something?")
				end,
				pickup = function(me)
					pickup_obj(me)
					me.state="state_gone"
					say_line("this might be the worst thing I've ever put in my pocket")
					say_line(me, "i'm free at last!!:*poof*")
					me.state="state_here"
					me.owner=nil
					say_line("what th--? fine, whatever")
				end
			}
		}

		obj_book = {
			data = [[
				name=dusty tome
				x=88
				y=10
				state_gone = 82
				state_here = 0
				state = state_here
				w=1
				h=1
				z=4
				classes={class_pickupable, class_usable}
				trans_col=11
				use_pos={88,50}
			]],
			verbs = {
				lookat = function(me)
					say_line("Magickal Crystals of the Pacific Northwest: A Field Guide")
				end,
				pickup = function(me)
					me.state = "state_gone"
					pickup_obj(me)
					dset(5,2)
				end,
				use = function(me)
					say_line("...'asmodite grants its wielder powers of levitation'... 'beelzebite can heal a fever'...:oh hey, greg's crystals are in here!")
					obj_power_crystal.name = "power crystal"
					obj_door_crystal.name = "wayfinding crystal"
					dset(15,2)
				end
			}
		}

		obj_power_crystal = {
			data = [[
				name = crystal
				x = 67
				y = 24
				w=1
				h=1
				z=4
				state=state_here
				state_here= 81
				state_gone = 81
				classes={class_pickupable}
				trans_col=11
				dependent_on_state=state_open
				use_with=true
			]],
			dependent_on = obj_desk,
			verbs = {
				lookat = function(me)
					if dget(15) > 1 then
						say_line("it's a 'crystal of energy flow' according to the book")
					else
						say_line("it's a crystal. blueish? makes my hand all tingly.")
					end
				end,
				use = function(me, noun2)
					if noun2 == obj_can_opener then
						obj_can_opener.state = "state_powered"
						obj_can_opener.name = "working can opener"
						me.state = "state_gone"
						put_at(me,0,0,rm_void)
						dset(14,2)
						dset(13,1)
						dset(6,3)
						print_line("*brrrrrrrrrrr*", main_actor.x+8, main_actor.y,12)
						say_line("haha, can opener go brrr: i mean - hey, it's working now!")
					end
				end,
				pickup = function(me)
					pickup_obj(me)
					me.state = "state_gone"
					dset(6,2)
				end
			}
		}

		obj_magic_door = {		
			data = [[
				name = unsettlingly new door
				w=1
				h=4
				state_open=6
				state_closed = 78
				state_invis = 0
				state = state_invis
				x=8
				y=16
				z=2
				classes = {class_openable}
				use_pos = pos_right
				use_dir = face_left
			]],
			col_replace={4,11},
			verbs = {
				walkto = function(me)
					if me.state == "state_open" then
						load("bb-game2")
					end
				end,
				open = function(me)
					me.state="state_open"
					start_script(me.scripts.anim_portal)
				 end,
				close = function(me)
					me.state= "state_closed"
					stop_script(obj_magic_door.scripts.anim_portal)
				end,
				use = function(me)
					if me.state == "state_open" then
						dset(8,2)
						load("bb-game2")
					else
						me.state = "state_open"
						start_script(me.scripts.anim_portal)
					end
				end,
				lookat = function()
					say_line("ok i *know* there's not normally a door there.")
				end
			},
			scripts = {
				anim_portal = function()
					local cols = {3,10,11,7}
					local idx = 0
					while true do
						obj_magic_door.col_replace = {cols[((idx)%4)+1], cols[((idx+2)%4)+1]}
						idx +=1
						break_time(5)
					end
				end
			}
		}

		obj_door_crystal = {
			data = [[
				name = crystal
				x = 96
				y = 6
				w=1
				h=1
				z=4
				state=state_here
				state_here= 81
				state_gone = 81
				classes={class_pickupable}
				trans_col=11
				use_pos = {96,50}
			]],
			verbs = {
				lookat = function(me)
					say_line(dget(15) > 1 and "it's a 'crystal of wayfinding' according to the book" or "it's a crystal, uh, a yellowy one")
				end,
				pickup = function(me)
					pickup_obj(me)
					me.state = "state_gone"
					dset(7,2)
				end,
				use = function(me)
					shake(true)
					local doory = 6
					local doorx = (main_actor.face_dir == "face_front" 
						or main_actor.face_dir == "face_back") and main_actor.x or (
							main_actor.face_dir == "face_left" and 16 or 169)
					obj_magic_door.z = 2
					obj_magic_door.state_closed = (main_actor.face_dir == "face_front" or main_actor.face_dir == "face_front") and 78 or 79
					obj_magic_door.h = obj_magic_door.state_closed == 78 and 3 or 4
					obj_magic_door.state = "state_closed"
					obj_magic_door.flip_x = main_actor.face_dir == "face_right"
					put_at(obj_magic_door, doorx, doory,rm_greg)
					shake(false)
				end
			}

		}

		obj_coins = {
			data = [[
				name=loose change
				state=state_here
				w=1
				h=1
				x=59
				y=38
				z=60
				trans_col=0
				state_here=179
				state_gone=178
				use_with=true
				]],
			verbs = {
				lookat = function()
					say_line("that's half a load of laundry, right there")
				end,
				give=function(me, noun2)
					if noun2 == obj_ward then
						obj_coins.state = "state_gone"
						put_at(obj_coins, 0,0,rm_void)
						dset(17,2)
						say_line(obj_ward, "hot dog, two whole quarters!:*cough* i mean.:i wilt do thyst bidding now, master")
					end
				end
			}
		}

		obj_sleeping_bag = {
			data = [[
					name= sleeping bag
					x=16	
					y=40
					w=3
					h=3
					z=5
					state=state_here
					state_here=152
					state_gone=136
					trans_col=11
					face_dir=face_right
					use_pos=pos_right
				]],
				verbs = {
					lookat = function(me)
						say_line("a sleeping bag on the floor. not even a pillow?")
					end,
					use = function()
						say_line("what do you think this is, fanfic? absolutely not")
					end
				}
			}
		obj_ward = {
			data = [[
				name= glowing necklace
				x=128	
				y=11
				w=1
				h=1
				z=4
				state=state_here
				state_here=103
				state_gone=102
				trans_col=11
				face_dir=face_right
				use_pos=pos_right
				classes={class_talkable, class_pickupable}
				use_with=true
			]],
			verbs = {
				lookat = function(me)
					if dget(18) < 2 then
						say_line("the cat's sitting on something:...that's glowing...:...and whispering...")
						say_line(obj_ward, "help! help!")
					else
						say_line("it's pretty, in a terrifying kind of way")
						print_line("take a picture, it lasts longer!", obj_ward.x,obj_ward.y - 12,7,1)
					end
				end,
				talkto = function(me)
					if dget(20) > 1 then
						if dget(17) < 2 then
							print_line("for a ~~price~~",obj_ward.x,obj_ward.y - 12,7,1)
						else
							say_line(me,"hey buddy! u ready to banish some "..(swear and "shit" or "stuff").."?")
						end
					else
						say_line(obj_ward, "help! help!")
						while (true) do
							local isCat = dget(18) < 3
							-- build dialog options
								dialog_set({ 
								(not me.greeted and "h-hello?" or ""),
								((me.greeted and not me.explained) and "are you like a trapped soul or something?" or ""),
								(not me.greeted and "sorry, can you speak up?" or ""),
								((me.explained and not me.banish) and "what do you do?" or ""),
								((me.banish and not me.price) and "so you can banish the demon in the living room!" or ""),
								((isCat and me.banish and me.bothered and not me.cats) and "why don't you banish the cat then?" or ""),
								((isCat and me.explained and not me.bothered) and "is the cat bothering you?" or ""),
								((me.price and not me.cost) and "a price? like my soul, or my firstborn or..." or ""),
								("wait, why am I talking to jewelry")
							})
							dialog_start(selected_actor.col, 12)

							-- wait for selection
							while not selected_sentence do break_time() end
							-- chosen options
							dialog_hide()

							cutscene(
								1, -- no verbs
								function()
									say_line(selected_sentence.msg)
									
									if selected_sentence.num == 1 then
										say_line(me, "hiya!:*cough* I mean.: who dareth approachest?!")
										me.greeted = true

									elseif selected_sentence.num == 2 then
										if isCat then 
											say_line(me, "yes, I'm trapped... under this cat!: nah, I'm just a magickal item")
										else
											say_line(me, "nah, I'm just a magickal item")
										end
										me.explained = true
									
									elseif selected_sentence.num == 3 then
										shake(true)	
										say_line(me, "♥🅾️∧⬇️█♥⬆️░🐱!!!")
										me.greeted = true
									
									
									elseif selected_sentence.num == 4 then
										say_line(me, "I make bad things go away!--:*cough* I mean.:I banish souls unto thy abyss!")
										me.banish = true
									elseif selected_sentence.num == 5 then
										say_line(me, "oh sure I'd be happy t--:*cough* yes...:for a PRICE")
										me.price = true
										dset(20,2)
									elseif selected_sentence.num == 7 then
										say_line(me, (swear and "fuck yes" or "YES").." get it off me!!!")
										me.bothered = true
										
									elseif selected_sentence.num == 6 then
										say_line("you... don't understand cats.")
										me.cats = true
									elseif selected_sentence.num == 8 then
										say_line(me, "fifty cents!")
										me.cost = true
									elseif selected_sentence.num == 9 then
										dialog_end()

									end
								end
							)
							shake(false)
							dialog_clear()

						end --dialog loop
					end
				end,
				pickup = function(me)
					if dget(18) < 2 then
						say_line(cat, "*hisssssssss!*")
						say_line("the cat won't let me near it")
					elseif dget(18) == 2 then
						say_line(obj_ward, "eeek! get that awful cat away from me!!!")
					elseif dget(18) > 2 then
						say_line(obj_ward, "...wheeee...")
						pickup_obj(obj_ward, main_actor)
						obj_ward.state = "state_gone"
						dset(19,2)
					end
				end,
				use = function(me, noun2)
				if dget(18) < 2 then
					say_line(cat, "*hisssssssss!*")
					say_line("the cat won't let me near it")
				elseif dget(18) == 2 then
					print_line("no way! not with that cat so close by!",100,30,7,1)
				else
						say_line("ok, uh... abraca-banish!")
				if dget(17) < 2 then
					local x = 130
					local y = 70
					if dget(19) < 2 then 
						x = 130
						y = 20
					end
					print_line("hey! I don't work for free-:*cough* I mean.:I wilst doeth yourn bidding: for a price",x,y,7,1)
					--print_line(msg, x, y, col, align, use_caps, duration)
				else
				if noun2 == obj_sleeping_bag or noun2 == obj_skull or (noun2 == obj_desk and dget(6) > 1) then -- i don't THINK you can soft lock at this point
				say_line(obj_ward, "hasta la vista, baby!")
				put_at(noun2,0,0,rm_void)
			elseif noun2 == cat then
				say_line(obj_ward, "we've been over this. bad idea.")
				else
					say_line(obj_ward, "i dunno, you might need that later")
				end
			end
					end
				end
			}
		}

	rm_greg = {
		data = [[
			map = {0,0,22,7}
		]],
		objects = {
			obj_greg_window_inside,
			obj_desk,
			obj_skull,
			obj_sleeping_bag,
			obj_ward,
			obj_power_crystal,
			obj_book,
			obj_door_crystal,
			obj_magic_door
		},
		enter = function(me)
			if not me.done_intro then
				-- don't do this again
				me.done_intro = true
				-- set which actor the player controls by default
				selected_actor = main_actor
				-- init actor
				put_at(selected_actor, 32, 44, rm_greg)
				-- make camera follow player
				-- (setting now, will be re-instated after cutscene)
				camera_follow(selected_actor)
				
			end
			if dget(18) == 2 then
				put_at(cat, 28,46, rm_greg)
				start_script(cat.scripts.follow)
			end
		end
	}


		

-- "the void" (room)
-- a place to put objects/actors when not in a room	
	-- objects

	rm_void = {
		data = [[
			map = {0,0}
		]],
		objects = {
			obj_coins,
			obj_can_opener,
			obj_tuna
		}
	}




-- 
-- active rooms list
-- 
rooms = {
	rm_greg,
	rm_void
}



--
-- actor definitions
-- 

	-- initialize the player's actor object
	main_actor = { 	
		data = [[
			name = humanoid
			w = 1
			h = 4
			idle = { 193, 197, 199, 197 }
			talk = { 218, 219, 220, 219 }
			walk_anim_side = { 196, 197, 198, 197 }
			walk_anim_front = { 194, 193, 195, 193 }
			walk_anim_back = { 200, 199, 201, 199 }
			col = 10
			trans_col = 11
			walk_speed = 0.6
			frame_delay = 5
			classes = {class_actor}
			face_dir = face_front
		]],
		-- sprites for directions (front, left, back, right) - note: right=left-flipped
		inventory = {
		},
		verbs = {
			use = function(me)
				selected_actor = me
				camera_follow(me)
			end
		}
	}

	
	cat = {
		data = [[
				name= cat
				w=2
				h=2
				z=60
				idle = {74,74,74,74}
				walk_anim_side = { 105,107,105,107 }
				walk_anim_front = { 105,107,105,107 }
				walk_anim_back = { 105,107,105,107 }
				col = 8
				trans_col=15
				face_dir=face_front
				use_pos={124,55}
				col=8
				classes={class_actor, class_talkable}
				scale=1
				walk_speed=0.5
				frame_delay=3
			]],
			verbs = {
				lookat = function(me)
					if dget(18) == 2 then
						say_line("the cat's following me now. great.")
					else
					say_line("the "..(swear and "hell" or "heck").."? we're not supposed to have pets!")
					say_line(me, "*hissss*")
					end
				end,
				talkto = function(me)
					if dget == 2 then
						say_line(me, "*mrrrrrow*")
					else
						say_line(me, "*hissss*!!!")
					end
				end,
				pickup = function(me)
					say_line(me, "*hisssssss*!!!")
					say_line("i don't think it wants to be picked up")
				end
			},
			scripts = {
				summon = function(me)
					dset(18,2)
					put_at(cat,main_actor.x+8, main_actor.y +10, room_curr)
					say_line(cat, "*mrrrrrow*")
					start_script(cat.scripts.follow)
				end,
				follow = function(me)
					while true do
						walk_to(cat,main_actor.x+8, main_actor.y +10)
						break_time()
					end
				end
			}

	}



-- 
-- active actors list
-- 
actors = {
	main_actor,
	cat
}



-- 
-- scripts
-- 

-- this script is execute once on game startup
function startup_script()	
	-- set ui colors
	reset_ui()
	music(0)
	get_it(obj_book, 5)
	get_it(obj_power_crystal,6)
	get_it(obj_door_crystal,7)

	if dget(9) > 1 then
		obj_desk.state = "state_open"
	else
		obj_desk.state = "state_closed"
	end
	get_it(obj_skull,10)
	if dget(17) < 2 then
		get_it(obj_coins, 12)
	end
	get_it(obj_can_opener,13)
	if dget(14) > 1 then
		pickup_obj(obj_can_opener, main_actor)
		obj_can_opener.state = "state_powered"
		obj_can_opener.name = "working can opener"
	end
	if dget(15) > 1 then
		obj_power_crystal.name = "power crystal"
		obj_door_crystal.name = "wayfinding crystal"
	end
	if dget(16) == 3 then
		obj_tuna.state = "state_open"
		obj_tuna.name = "opened tuna"
		if dget(18) < 3 then
			pickup_obj(obj_tuna, main_actor)
		end
	end
	if dget(16) == 2 then
		pickup_obj(obj_tuna, main_actor)
		obj_tuna.state = "state_gone"
	end

	if dget(18) == 6 then
		obj_tuna.z = 64
		put_at(obj_tuna, 110,49,rm_greg)
		put_at(cat,116,59, rm_greg)
	elseif dget(18) < 2 then
		put_at(cat, 124,22, rm_greg)
	end
	get_it(obj_ward,19)


	-- set which room to start the game in 
	-- (e.g. could be a "pseudo" room for title screen!)
	change_room(rm_greg, 1) -- iris fade
end

function get_it(obj, num)
	if dget(num) > 1 then
		obj.state = "state_gone"
		pickup_obj(obj,main_actor)
	end
end
-- (end of customisable game content)





























-- ==============================
-- scumm-8 public api functions
-- 
-- (you should not need to modify anything below here!)


function shake(bp) if bp then
bq=1 end br=bp end function bs(bt) local bu=nil if has_flag(bt.classes,"class_talkable") then
bu="talkto"elseif has_flag(bt.classes,"class_openable") then if bt.state=="state_closed"then
bu="open"else bu="close"end else bu="lookat"end for bv in all(verbs) do bw=get_verb(bv) if bw[2]==bu then bu=bv break end
end return bu end function bx(by,bz,ca) local cb=has_flag(bz.classes,"class_actor") if by=="walkto"then
return elseif by=="pickup"then if cb then
say_line"i don't need them"else say_line"i don't need that"end elseif by=="use"then if cb then
say_line"i can't just *use* someone"end if ca then
if has_flag(ca.classes,class_actor) then
say_line"i can't use that on someone!"else say_line"that doesn't work"end end elseif by=="give"then if cb then
say_line"i don't think i should be giving this away"else say_line"i can't do that"end elseif by=="lookat"then if cb then
say_line"i think it's alive"else say_line"looks pretty ordinary"end elseif by=="open"then if cb then
say_line"they don't seem to open"else say_line"it doesn't seem to open"end elseif by=="close"then if cb then
say_line"they don't seem to close"else say_line"it doesn't seem to close"end elseif by=="push"or by=="pull"then if cb then
say_line"moving them would accomplish nothing"else say_line"it won't budge!"end elseif by=="talkto"then if cb then
say_line"erm... i don't think they want to talk"else say_line"i am not talking to that!"end else say_line"hmm. no."end end function camera_at(cc) cam_x=ce(cc) cf=nil cg=nil end function camera_follow(ch) stop_script(ci) cg=ch cf=nil ci=function() while cg do if cg.in_room==room_curr then
cam_x=ce(cg) end yield() end end start_script(ci,true) if cg.in_room!=room_curr then
change_room(cg.in_room,1) end end function camera_pan_to(cc) cf=ce(cc) cg=nil ci=function() while(true) do if cam_x==cf then
cf=nil return elseif cf>cam_x then cam_x+=0.5 else cam_x-=0.5 end yield() end end start_script(ci,true) end function wait_for_camera() while script_running(ci) do yield() end end function cutscene(type,cj,ck) cl={cm=type,cn=cocreate(cj),co=ck,cp=cg} add(cq,cl) cr=cl break_time() end function dialog_set(cs) for msg in all(cs) do dialog_add(msg) end end function dialog_add(msg) if not ct then ct={cu={},cv=false} end
cw=cx(msg,32) cy=cz(cw) da={num=#ct.cu+1,msg=msg,cw=cw,db=cy} add(ct.cu,da) end function dialog_start(col,dc) ct.col=col ct.dc=dc ct.cv=true selected_sentence=nil end function dialog_hide() ct.cv=false end function dialog_clear() ct.cu={} selected_sentence=nil end function dialog_end() ct=nil end function get_use_pos(bt) local dd=bt.use_pos local x=bt.x local y=bt.y if type(dd)=="table"then
x=dd[1] y=dd[2] elseif dd=="pos_left"then if bt.de then
x-=(bt.w*8+4) y+=1 else x-=2 y+=((bt.h*8)-2) end elseif dd=="pos_right"then x+=(bt.w*8) y+=((bt.h*8)-2) elseif dd=="pos_above"then x+=((bt.w*8)/2)-4 y-=2 elseif dd=="pos_center"then x+=((bt.w*8)/2) y+=((bt.h*8)/2)-4 elseif dd=="pos_infront"or dd==nil then x+=((bt.w*8)/2)-4 y+=(bt.h*8)+2 end return{x=x,y=y} end function do_anim(df,dg,dh) if dg=="face_towards"then
di={"face_front","face_left","face_back","face_right"} if type(dh)=="table"then
dj=atan2(df.x-dh.x,dh.y-df.y) dk=93*(3.1415/180) dj=dk-dj dl=dj*360 dl=dl%360 if dl<0 then dl+=360 end
dh=4-flr(dl/90) dh=di[dh] end face_dir=dm[df.face_dir] dh=dm[dh] while face_dir!=dh do if face_dir<dh then
face_dir+=1 else face_dir-=1 end df.face_dir=di[face_dir] df.flip=(df.face_dir=="face_left") break_time(10) end else df.dn=dg df.dp=1 df.dq=1 end end function open_door(dr,ds) if dr.state=="state_open"then
say_line"it's already open"else dr.state="state_open"if ds then ds.state="state_open"end
end end function close_door(dr,ds) if dr.state=="state_closed"then
say_line"it's already closed"else dr.state="state_closed"if ds then ds.state="state_closed"end
end end function come_out_door(dt,du,dv) if du==nil then
dw("target door does not exist") return end if dt.state=="state_open"then
dx=du.in_room if dx!=room_curr then
change_room(dx,dv) end local dy=get_use_pos(du) put_at(selected_actor,dy.x,dy.y,dx) dz={face_front="face_back",face_left="face_right",face_back="face_front",face_right="face_left"} if du.use_dir then
ea=dz[du.use_dir] else ea=1 end selected_actor.face_dir=ea selected_actor.flip=(selected_actor.face_dir=="face_left") else say_line("the door is closed") end end function fades(eb,bc) if bc==1 then
ec=0 else ec=50 end while true do ec+=bc*2 if ec>50
or ec<0 then return end if eb==1 then
ed=min(ec,32) end yield() end end function change_room(dx,eb) if dx==nil then
dw("room does not exist") return end stop_script(ee) if eb and room_curr then
fades(eb,1) end if room_curr and room_curr.exit then
room_curr.exit(room_curr) end ef={} eg() room_curr=dx if not cg
or cg.in_room!=room_curr then cam_x=0 end stop_talking() if eb then
ee=function() fades(eb,-1) end start_script(ee,true) else ed=0 end if room_curr.enter then
room_curr.enter(room_curr) end end function valid_verb(by,eh) if not eh
or not eh.verbs then return false end if type(by)=="table"then
if eh.verbs[by[1]] then return true end
else if eh.verbs[by] then return true end
end return false end function pickup_obj(bt,ch) ch=ch or selected_actor add(ch.bn,bt) bt.owner=ch del(bt.in_room.objects,bt) end function start_script(ei,ej,ek,el) local cn=cocreate(ei) local scripts=ef if ej then
scripts=em end add(scripts,{ei,cn,ek,el}) end function script_running(ei) for en in all({ef,em}) do for eo,ep in pairs(en) do if ep[1]==ei then
return ep end end end return false end function stop_script(ei) ep=script_running(ei) if ep then
del(ef,ep) del(em,ep) end end function break_time(eq) eq=eq or 1 for x=1,eq do yield() end end function wait_for_message() while er!=nil do yield() end end function say_line(ch,msg,es,et) if type(ch)=="string"then
msg=ch ch=selected_actor end eu=ch.y-(ch.h)*8+4 ev=ch print_line(msg,ch.x,eu,ch.col,1,es,et) end function stop_talking() er,ev=nil,nil end function print_line(msg,x,y,col,ew,es,et) local col=col or 7 local ew=ew or 0 if ew==1 then
ex=min(x-cam_x,127-(x-cam_x)) else ex=127-(x-cam_x) end local ey=max(flr(ex/2),16) local ez=""for fa=1,#msg do local fb=sub(msg,fa,fa) if fb==":"then
ez=sub(msg,fa+1) msg=sub(msg,1,fa-1) break end end local cw=cx(msg,ey) local cy=cz(cw) fc=x-cam_x if ew==1 then
fc-=((cy*4)/2) end fc=max(2,fc) eu=max(18,y) fc=min(fc,127-(cy*4)-1) er={fd=cw,x=fc,y=eu,col=col,ew=ew,fe=et or(#msg)*8,db=cy,es=es} if#ez>0 then
ff=ev wait_for_message() ev=ff print_line(ez,x,y,col,ew,es) end wait_for_message() end function put_at(bt,x,y,fg) if fg then
if not has_flag(bt.classes,"class_actor") then
if bt.in_room then del(bt.in_room.objects,bt) end
add(fg.objects,bt) bt.owner=nil end bt.in_room=fg end bt.x,bt.y=x,y end function stop_actor(ch) ch.fh=0 ch.dn=nil eg() end function walk_to(ch,x,y) local fi=fj(ch) local fk=flr(x/8)+room_curr.map[1] local fl=flr(y/8)+room_curr.map[2] local fm={fk,fl} local fn=fo(fi,fm,{x,y}) ch.fh=1 for fp=1,#fn do fq=fn[fp] local fr=ch.walk_speed*(ch.scale or ch.fs) local ft,fu ft=(fq[1]-room_curr.map[1])*8+4 fu=(fq[2]-room_curr.map[2])*8+4 if fp==#fn then
if x>=ft-4 and x<=ft+4
and y>=fu-4 and y<=fu+4 then ft=x fu=y end end local fv=sqrt((ft-ch.x)^2+(fu-ch.y)^2) local fw=fr*(ft-ch.x)/fv local fx=fr*(fu-ch.y)/fv if ch.fh==0 then
return end if fv>0 then
for fa=0,fv/fr-1 do ch.flip=(fw<0) if abs(fw)<fr/2 then
if fx>0 then
ch.dn=ch.walk_anim_front ch.face_dir="face_front"else ch.dn=ch.walk_anim_back ch.face_dir="face_back"end else ch.dn=ch.walk_anim_side ch.face_dir="face_right"if ch.flip then ch.face_dir="face_left"end
end ch.x+=fw ch.y+=fx yield() end end end ch.fh=2 ch.dn=nil end function wait_for_actor(ch) ch=ch or selected_actor while ch.fh!=2 do yield() end end function proximity(bz,ca) if bz.in_room==ca.in_room then
local fv=sqrt((bz.x-ca.x)^2+(bz.y-ca.y)^2) return fv else return 1000 end end fy=16 cam_x,cf,ci,bq=0,nil,nil,0 fz,ga,gb,gc=63.5,63.5,0,1 gd={{spr=ui_uparrowspr,x=75,y=fy+60},{spr=ui_dnarrowspr,x=75,y=fy+72}} dm={face_front=1,face_left=2,face_back=3,face_right=4} function ge(bt) local gf={} for eo,bv in pairs(bt) do add(gf,eo) end return gf end function get_verb(bt) local by={} local gf=ge(bt[1]) add(by,gf[1]) add(by,bt[1][gf[1]]) add(by,bt.text) return by end function eg() gg=get_verb(verb_default) gh,gi,n,gj,gk=nil,nil,nil,false,""end eg() er=nil ct=nil cr=nil ev=nil em={} ef={} cq={} gl={} ed,ed=0,0 gm=0 function _init() poke(0x5f2d,1) gn() start_script(startup_script,true) end function _update60() go() end function _draw()
	 gp() for i=0,15 do pal(i,128+i,1) end end function go() if selected_actor and selected_actor.cn
and not coresume(selected_actor.cn) then selected_actor.cn=nil end gq(em) if cr then
if cr.cn
and not coresume(cr.cn) then if cr.cm!=3
and cr.cp then camera_follow(cr.cp) selected_actor=cr.cp end del(cq,cr) if#cq>0 then
cr=cq[#cq] else if cr.cm!=2 then
gm=3 end cr=nil end end else gq(ef) end gr() gs() gt,gu=1.5-rnd(3),1.5-rnd(3) gt=flr(gt*bq) gu=flr(gu*bq) if not br then
bq*=0.90 if bq<0.05 then bq=0 end
end end function gp() rectfill(0,0,127,127,0) camera(cam_x+gt,0+gu) clip(0+ed-gt,fy+ed-gu,128-ed*2-gt,64-ed*2) gv() camera(0,0) clip() if show_debuginfo then
print("cpu: "..flr(100*stat(1)).."%",0,fy-16,8) print("mem: "..flr(stat(0)/1024*100).."%",0,fy-8,8) print("x: "..flr(fz+cam_x).." y:"..ga-fy,80,fy-8,8) end gw() if ct
and ct.cv then gx() gy() return end if gm>0 then
gm-=1 return end if not cr then
gz() end if(not cr
or cr.cm==2) and gm==0 then ha() end if not cr then
gy() end end function hb() if stat(34)>0 then
if not hc then
hc=true end else hc=false end end function gr() if er and not hc then
if(btnp(4) or stat(34)==1) then
er.fe=0 hc=true return end end if cr then
if(btnp(5) or stat(34)==2)
and cr.co then cr.cn=cocreate(cr.co) cr.co=nil return end hb() return end if btn(0) then fz-=1 end
if btn(1) then fz+=1 end
if btn(2) then ga-=1 end
if btn(3) then ga+=1 end
if btnp(4) then hd(1) end
if btnp(5) then hd(2) end
he,hf=stat(32)-1,stat(33)-1 if he!=hg then fz=he end
if hf!=hh then ga=hf end
if stat(34)>0 and not hc then
hd(stat(34)) end hg=he hh=hf hb() end fz=mid(0,fz,127) ga=mid(0,ga,127) function hd(hi) local hj=gg if not selected_actor then
return end if ct and ct.cv then
if hk then
selected_sentence=hk end return end if hl then
gg=get_verb(hl) gh=nil gi=nil elseif hm then if hi==1 then
if gh then
gi=hm else gh=hm end if(gg[2]==get_verb(verb_default)[2]
and hm.owner) then gg=get_verb(verbs[verb_default_inventory_index]) end elseif hn then gg=get_verb(hn) gh=hm ge(gh) gz() end elseif ho then if ho==gd[1] then
if selected_actor.hp>0 then
selected_actor.hp-=1 end else if selected_actor.hp+2<flr(#selected_actor.bn/4) then
selected_actor.hp+=1 end end return end if gh!=nil
then if gg[2]=="use"or gg[2]=="give"then
if gi then
elseif gh.use_with and gh.owner==selected_actor then return end end gj=true selected_actor.cn=cocreate(function() if(not gh.owner
and(not has_flag(gh.classes,"class_actor") or gg[2]!="use")) or gi then hq=gi or gh hr=get_use_pos(hq) walk_to(selected_actor,hr.x,hr.y) if selected_actor.fh!=2 then return end
use_dir=hq if hq.use_dir then use_dir=hq.use_dir end
do_anim(selected_actor,"face_towards",use_dir) end if valid_verb(gg,gh) then
start_script(gh.verbs[gg[1]],false,gh,gi) else if has_flag(gh.classes,"class_door") then
if gg[2]=="walkto"then
come_out_door(gh,gh.target_door) elseif gg[2]=="open"then open_door(gh,gh.target_door) elseif gg[2]=="close"then close_door(gh,gh.target_door) end else bx(gg[2],gh,gi) end end eg() end) coresume(selected_actor.cn) elseif ga>fy and ga<fy+64 then gj=true selected_actor.cn=cocreate(function() walk_to(selected_actor,fz+cam_x,ga-fy) eg() end) coresume(selected_actor.cn) end end function gs() if not room_curr then
return end hl,hn,hm,hk,ho=nil,nil,nil,nil,nil if ct
and ct.cv then for en in all(ct.cu) do if hs(en) then
hk=en end end return end ht() for bt in all(room_curr.objects) do if(not bt.classes
or(bt.classes and not has_flag(bt.classes,"class_untouchable"))) and(not bt.dependent_on or bt.dependent_on.state==bt.dependent_on_state) then hu(bt,bt.w*8,bt.h*8,cam_x,hv) else bt.hw=nil end if hs(bt) then
if not hm
or(not bt.z and hm.z<0) or(bt.z and hm.z and bt.z>hm.z) then hm=bt end end hx(bt) end for eo,ch in pairs(actors) do if ch.in_room==room_curr then
hu(ch,ch.w*8,ch.h*8,cam_x,hv) hx(ch) if hs(ch)
and ch!=selected_actor then hm=ch end end end if selected_actor then
for bv in all(verbs) do if hs(bv) then
hl=bv end end for hy in all(gd) do if hs(hy) then
ho=hy end end for eo,bt in pairs(selected_actor.bn) do if hs(bt) then
hm=bt if gg[2]=="pickup"and hm.owner then
gg=nil end end if bt.owner!=selected_actor then
del(selected_actor.bn,bt) end end if gg==nil then
gg=get_verb(verb_default) end if hm then
hn=bs(hm) end end end function ht() gl={} for x=-64,64 do gl[x]={} end end function hx(bt) eu=-1 if bt.hz then
eu=bt.y else eu=bt.y+(bt.h*8) end ia=flr(eu) if bt.z then
ia=bt.z end add(gl[ia],bt) end function gv() if not room_curr then
print("-error-  no current room set",5+cam_x,5+fy,8,0) return end rectfill(0,fy,127,fy+64,room_curr.ib or 0) for z=-64,64 do if z==0 then
ic(room_curr) if room_curr.trans_col then
palt(0,false) palt(room_curr.trans_col,true) end map(room_curr.map[1],room_curr.map[2],0,fy,room_curr.id,room_curr.ie) pal() else ia=gl[z] for bt in all(ia) do if not has_flag(bt.classes,"class_actor") then
if bt.states
or(bt.state and bt[bt.state] and bt[bt.state]>0) and(not bt.dependent_on or bt.dependent_on.state==bt.dependent_on_state) and not bt.owner or bt.draw or bt.dn then ig(bt) end else if bt.in_room==room_curr then
ih(bt) end end end end end end function ic(bt) if bt.col_replace then
fp=bt.col_replace 
	pal(fp[1],fp[2]) 
end if bt.lighting then
ii(bt.lighting) elseif bt.in_room and bt.in_room.lighting then ii(bt.in_room.lighting) end end function ig(bt) local ij=0 ic(bt) if bt.draw then
bt.draw(bt) else if bt.dn then
ik(bt) ij=bt.dn[bt.dp] end il=1 if bt.repeat_x then il=bt.repeat_x end
for h=0,il-1 do if bt.states then
ij=bt.states[bt.state] elseif ij==0 then ij=bt[bt.state] end im(ij,bt.x+(h*(bt.w*8)),bt.y,bt.w,bt.h,bt.trans_col,bt.flip_x,bt.scale) end end pal() end function ih(ch) io=dm[ch.face_dir] if ch.dn
and(ch.fh==1 or type(ch.dn)=="table") then ik(ch) ij=ch.dn[ch.dp] else ij=ch.idle[io] end ic(ch) local ip=(ch.y-room_curr.autodepth_pos[1])/(room_curr.autodepth_pos[2]-room_curr.autodepth_pos[1]) ip=room_curr.autodepth_scale[1]+(room_curr.autodepth_scale[2]-room_curr.autodepth_scale[1])*ip ch.fs=mid(room_curr.autodepth_scale[1],ip,room_curr.autodepth_scale[2]) local scale=ch.scale or ch.fs local iq=(8*ch.h) local ir=(8*ch.w) local is=iq-(iq*scale) local it=ir-(ir*scale) local iu=ch.de+flr(it/2) local iv=ch.hz+is im(ij,iu,iv,ch.w,ch.h,ch.trans_col,ch.flip,false,scale) if ev
and ev==ch and ev.talk then if ch.iw<7 then
im(ch.talk[io],iu+(ch.talk[5] or 0),iv+flr((ch.talk[6] or 8)*scale),(ch.talk[7] or 1),(ch.talk[8] or 1),ch.trans_col,ch.flip,false,scale) end ch.iw+=1 if ch.iw>14 then ch.iw=1 end
end pal() end function gz() ix=""iy=verb_maincol iz=gg[2] if gg then
ix=gg[3] end if gh then
ix=ix.." "..gh.name if iz=="use"and(not gj or gi) then
ix=ix.." with"elseif iz=="give"then ix=ix.." to"end end if gi then
ix=ix.." "..gi.name elseif hm and hm.name!=""and(not gh or(gh!=hm)) and not gj then if hm.owner
and iz==get_verb(verb_default)[2] then ix="look-at"end ix=ix.." "..hm.name end gk=ix if gj then
ix=gk iy=verb_hovcol end print(ja(ix),jb(ix),fy+66,iy) end function gw() if er then
jc=0 for jd in all(er.fd) do je=0 if er.ew==1 then
je=((er.db*4)-(#jd*4))/2 end outline_text(jd,er.x+je,er.y+jc,er.col,0,er.es) jc+=6 end er.fe-=1 if er.fe<=0 then
stop_talking() end end end function ha() fc,eu,jf=0,75,0 for bv in all(verbs) do jg=verb_maincol if hn
and bv==hn then jg=verb_defcol end if bv==hl then jg=verb_hovcol end
bw=get_verb(bv) print(bw[3],fc,eu+fy+1,verb_shadcol) print(bw[3],fc,eu+fy,jg) bv.x=fc bv.y=eu hu(bv,#bw[3]*4,5,0,0) if#bw[3]>jf then jf=#bw[3] end
eu+=8 if eu>=95 then
eu=75 fc+=(jf+1.0)*4 jf=0 end end if selected_actor then
fc,eu=86,76 jh=selected_actor.hp*4 ji=min(jh+8,#selected_actor.bn) for jj=1,8 do rectfill(fc-1,fy+eu-1,fc+8,fy+eu+8,verb_shadcol) bt=selected_actor.bn[jh+jj] if bt then
bt.x,bt.y=fc,eu ig(bt) hu(bt,bt.w*8,bt.h*8,0,0) end fc+=11 if fc>=125 then
eu+=12 fc=86 end jj+=1 end for fa=1,2 do jk=gd[fa] if ho==jk then
pal(7,verb_hovcol) else pal(7,verb_maincol) end pal(5,verb_shadcol) im(jk.spr,jk.x,jk.y,1,1,0) hu(jk,8,7,0,0) pal() end end end function gx() fc,eu=0,70 for en in all(ct.cu) do if en.db>0 then
en.x,en.y=fc,eu hu(en,en.db*4,#en.cw*5,0,0) jg=ct.col if en==hk then jg=ct.dc end
for jd in all(en.cw) do print(ja(jd),fc,eu+fy,jg) eu+=5 end eu+=2 end end end function gy() col=ui_cursor_cols[gc] pal(7,col) spr(ui_cursorspr,fz-4,ga-3,1,1,0) pal() gb+=1 if gb>7 then
gb=1 gc+=1 if gc>#ui_cursor_cols then gc=1 end
end end function im(jl,x,y,w,h,jm,flip_x,jn,scale) set_trans_col(jm,true) jl=jl or 0 local jo=8*(jl%16) local jp=8*flr(jl/16) local jq=8*w local jr=8*h local js=scale or 1 local jt=jq*js local ju=jr*js sspr(jo,jp,jq,jr,x,fy+y,jt,ju,flip_x,jn) end function set_trans_col(jm,bp) palt(0,false) palt(jm,true) if jm and jm>0 then
palt(0,false) end end function gn() for fg in all(rooms) do jv(fg) if(#fg.map>2) then
fg.id=fg.map[3]-fg.map[1]+1 fg.ie=fg.map[4]-fg.map[2]+1 else fg.id=16 fg.ie=8 end fg.autodepth_pos=fg.autodepth_pos or{9,50} fg.autodepth_scale=fg.autodepth_scale or{0.25,1} for bt in all(fg.objects) do jv(bt) bt.in_room=fg bt.h=bt.h or 0 if bt.init then
bt.init(bt) end end end for jw,ch in pairs(actors) do jv(ch) ch.fh=2 ch.dq=1 ch.iw=1 ch.dp=1 ch.bn={} ch.hp=0 end end function gq(scripts) for ep in all(scripts) do if ep[2] and not coresume(ep[2],ep[3],ep[4]) then
del(scripts,ep) ep=nil end end end function ii(jx) if jx then jx=1-jx end
local fq=flr(mid(0,jx,1)*100) local jy={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14} for jz=1,15 do col=jz ka=(fq+(jz*1.46))/22 for eo=1,ka do col=jy[col] end pal(jz,col) end end function ce(cc) if type(cc)=="table"then
cc=cc.x end return mid(0,cc-64,(room_curr.id*8)-128) end function fj(bt) local fk=flr(bt.x/8)+room_curr.map[1] local fl=flr(bt.y/8)+room_curr.map[2] return{fk,fl} end function kb(fk,fl) local kc=mget(fk,fl) local kd=fget(kc,0) return kd end function cx(msg,ey) local cw={} local ke=""local kf=""local fb=""local kg=function(kh) if#kf+#ke>kh then
add(cw,ke) ke=""end ke=ke..kf kf=""end for fa=1,#msg do fb=sub(msg,fa,fa) kf=kf..fb if fb==" "
or#kf>ey-1 then kg(ey) elseif#kf>ey-1 then kf=kf.."-"kg(ey) elseif fb==";"then ke=ke..sub(kf,1,#kf-1) kf=""kg(0) end end kg(ey) if ke!=""then
add(cw,ke) end return cw end function cz(cw) cy=0 for jd in all(cw) do if#jd>cy then cy=#jd end
end return cy end function has_flag(bt,ki) for kj in all(bt) do if kj==ki then
return true end end return false end function hu(bt,w,h,kk,kl) x=bt.x y=bt.y if has_flag(bt.classes,"class_actor") then
bt.de=x-(bt.w*8)/2 bt.hz=y-(bt.h*8)+1 x=bt.de y=bt.hz end bt.hw={x=x,y=y+fy,km=x+w-1,kn=y+h+fy-1,kk=kk,kl=kl} end function fo(ko,kp) local kq,kr,ks,kt,ku={},{},{},nil,nil kv(kq,ko,0) kr[kw(ko)]=nil ks[kw(ko)]=0 while#kq>0 and#kq<1000 do local kx=kq[#kq] del(kq,kq[#kq]) ky=kx[1] if kw(ky)==kw(kp) then
break end local kz={} for x=-1,1 do for y=-1,1 do if x==0 and y==0 then
else local la=ky[1]+x local lb=ky[2]+y if abs(x)!=abs(y) then lc=1 else lc=1.4 end
if la>=room_curr.map[1] and la<=room_curr.map[1]+room_curr.id
and lb>=room_curr.map[2] and lb<=room_curr.map[2]+room_curr.ie and kb(la,lb) and((abs(x)!=abs(y)) or kb(la,ky[2]) or kb(la-x,lb) or enable_diag_squeeze) then add(kz,{la,lb,lc}) end end end end for ld in all(kz) do local le=kw(ld) local lf=ks[kw(ky)]+ld[3] if not ks[le]
or lf<ks[le] then ks[le]=lf local h=max(abs(kp[1]-ld[1]),abs(kp[2]-ld[2])) local lg=lf+h kv(kq,ld,lg) kr[le]=ky if not kt
or h<kt then kt=h ku=le lh=ld end end end end local fn={} ky=kr[kw(kp)] if ky then
add(fn,kp) elseif ku then ky=kr[ku] add(fn,lh) end if ky then
local li=kw(ky) local lj=kw(ko) while li!=lj do add(fn,ky) ky=kr[li] li=kw(ky) end for fa=1,#fn/2 do local lk=fn[fa] local ll=#fn-(fa-1) fn[fa]=fn[ll] fn[ll]=lk end end return fn end function kv(lm,cc,fq) if#lm>=1 then
add(lm,{}) for fa=(#lm),2,-1 do local ld=lm[fa-1] if fq<ld[2] then
lm[fa]={cc,fq} return else lm[fa]=ld end end lm[1]={cc,fq} else add(lm,{cc,fq}) end end function kw(ln) return((ln[1]+1)*16)+ln[2] end function ik(bt) bt.dq+=1 if bt.dq>bt.frame_delay then
bt.dq=1 bt.dp+=1 if bt.dp>#bt.dn then bt.dp=1 end
end end function dw(msg) print_line("-error-;"..msg,5+cam_x,5,8,0) end function jv(bt) local cw=lo(bt.data,"\n") for jd in all(cw) do local pairs=lo(jd,"=") if#pairs==2 then
bt[pairs[1]]=lp(pairs[2]) else printh(" > invalid data: ["..pairs[1].."]") end end end function lo(en,lq) local lr={} local jh=0 local lt=0 for fa=1,#en do local lu=sub(en,fa,fa) if lu==lq then
add(lr,sub(en,jh,lt)) jh=0 lt=0 elseif lu!=" "and lu!="\t"then lt=fa if jh==0 then jh=fa end
end end if jh+lt>0 then
add(lr,sub(en,jh,lt)) end return lr end function lp(lv) local lw=sub(lv,1,1) local lr=nil if lv=="true"then
lr=true elseif lv=="false"then lr=false elseif lx(lw) then if lw=="-"then
lr=sub(lv,2,#lv)*-1 else lr=lv+0 end elseif lw=="{"then local lk=sub(lv,2,#lv-1) lr=lo(lk,",") ly={} for cc in all(lr) do cc=lp(cc) add(ly,cc) end lr=ly else lr=lv end return lr end function lx(fp) for lz=1,13 do if fp==sub("0123456789.-+",lz,lz) then
return true end end end function outline_text(ma,x,y,mb,mc,es) if not es then ma=ja(ma) end
for md=-1,1 do for me=-1,1 do print(ma,x+md,y+me,mc) end end print(ma,x,y,mb) end function jb(en) return 63.5-flr((#en*4)/2) end function mf(en) return 61 end function hs(bt) if not bt.hw
or cr then return false end hw=bt.hw if(fz+hw.kk>hw.km or fz+hw.kk<hw.x)
or(ga>hw.kn or ga<hw.y) then return false else return true end end function ja(en) local lz=""local jd,fp,lm=false,false for fa=1,#en do local hy=sub(en,fa,fa) if hy=="^"then
if fp then lz=lz..hy end
fp=not fp elseif hy=="~"then if lm then lz=lz..hy end
lm,jd=not lm,not jd else if fp==jd and hy>="a"and hy<="z"then
for jz=1,26 do if hy==sub("abcdefghijklmnopqrstuvwxyz",jz,jz) then
hy=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",jz,jz) break end end end lz=lz..hy fp,lm=false,false end end return lz end



__gfx__
00000000000000000000000000000000444444444400000033aaaa3a5555555566666666ddd5ddd50000000055000000101010105555555567777677bbccccbb
0000000000000000000000000000000044444440440000003aabaaaa5555555566666666dd5ddd5d0000000055550000010101015555555567775577bccccccb
00800800000000000000000000000000aaaaaa00aaaa0000aabbbbab5555555566666665d5ddd5dd0000000055555500101010105555555566656556bc7777cb
0008800055555555ddddddddeeeeeeee9999900099990000abb7bbbb55555555655566565ddd5ddd0000000055555555010101015555555577757557bc7777cb
0008800055555555ddddddd5eeeeeeee4444000044444400bb7777b75555555566655656ddd5ddd50000000055555555101010105555555577757777bccccccb
0080080055555555dddddd5deeeeeeee4440000044444400b77377775555555566566566dd5ddd5d0000000055555555010101015555555566656666bbccccbb
0000000055555555ddddd5ddeeeeeeeeaa000000aaaaaaaa773333735555555565666666d5ddd5dd0000000055555555101010105555555567757677bbb45bbb
0000000055555555dddd5dddeeeeeeee9000000099999999733a333355555555556666665ddd5ddd0000000055555555010101015555555555757655bbb45bbb
0000000077777755666666d5bbbbbbeedd5555dd3333333333aaaa3a66666666677776776666666677777777000000551010104499999999884bbbbbbbb45bbb
00000000777755556666dd5dbbbbeeeedd6666dd333333333aabaaaa66666666677776771c1c1c1c77777777000055550101014444444444884bbbbbbbb45bbb
000010007755555566ddd5ddbbeeeeeed666666d33333333aabbbbab6666666666666666c1c1c1c177777677005555551010aaaa00045000884bbbbbbbb45bbb
0000c000555555555ddd5dddeeeeeeee7777777733333333abb7bbbb66666666777677771c1c1c1c77777777555555550101999900045000884bbbbbbbb45bbb
001c7c1055555555ddd5ddd5eeeeeeee7777777733333333bb7777b76666666677767777c1c1c1c177777777555555551044444400045000884bbbbbbbb45bbb
0000c00055555555dd5ddd5deeeeeeee5333555333333333b773777766666666666666661c1c1c1c77777777555555550144444400045000bbbbbbbbbbb45bbb
0000100055555555d5ddd5ddeeeeeeee5555555533333333773333736666666667777677c1c1c1c17777777755555555aaaaaaaa00045000bbbbbbbbbbb45bbb
00000000555555555ddd5dddeeeeeeee5555535533333333733a333366666666677776777c7c7c7c77777777555555559999999900045000bbbbbbbbbbb45bbb
0000000055777777dd666666eebbbbbb666666665555555533aaaa3a777777777777777755555555663333334444444444444445000450008888888999999999
0000000055557777dd5d6666eeeebbbb77777777555533333aabaaaa777777777777777755555555663333334444444444444458000450008888889444444444
0000000055555577d5ddd566eeeeeebb5555558855333333aabbbbab77777777777777775555555566333333aaaaaa4444444588000450008888894888845888
000c0000555555555ddd5dddeeeeeeee5555558853333333abb7bbbb777777777777777755555555663333339999994444445888000450008888948888845888
0000000055555555ddd5ddd5eeeeeeee6666888853333333bb7777b7777777555577777755555555333333334444444444458888000450008889488888845888
0000000055555555dd5ddd5deeeeeeee7777888855333333b7737777777755555555777755555555333333334444444444588888000450008894588888845888
0000000055555555d5ddd5ddeeeeeeee55888888555533337733337377555555555555770000000033333333aa44444445888888999999998944588888845888
00000000555555555ddd5dddeeeeeeee5588888855555555733a3333555555555555555500000000333333339944444458888888555555559484588888845888
0000000055555555dddddddd25555525555555555555555533aaaa3a222222225555555655555555255555556555555533333336633333338884588988845888
0000000055555555dddddddd2222222255555525333355553aabaaaa222222225555556755555552225555557655555533333367763333338884589488845888
0000000055555555dddddddd555525555555525533333355aabbbbab222222225555567755555522222555557765555533333677776333338884594488845888
0000000055555555dddddddd555525555555525533333335abb7bbbb222222225555677755555222222255557776555533336777777633338884944488845888
0000000055555555dddddddd555525555525555533333335bb7777b7222222225556777755552222222225557777655533367777777763338889444488845888
0000000055555555dddddddd222222225525555533333355b7737777222222225567777755522222222222557777765533677777777776338894444488845888
0b03000055555555dddddddd25555525525555553333555577333373222222225677777755222222222222257777776536777777777777638944444499999999
b00030b055555555dddddddd255555255555555555555555733a3333222222226777777752222222222222227777777667777777777777769444444455555555
33333366111111510000000000000000577777777777777777555555555555772555552555555555ff1ff1f111111fff67777677d00000004444444444444444
33333366111115550000000000000000700000077000000770700000000007079f22222255555555f1011010000001ff57777677d50000004ffffff44ffffff4
33333366111119a90000000000000000700000077000000770070000000070079f5eeeee55555555100000100010001f05666666d51000004f4444944f444494
33333366dddddd9d0000000000000000700000077000000770006000000600079f5cccc555557777180800000100000155767777d51000004f4444944f444494
33333333111111110000000000000000700000077000000770006000000600079f55999955775755100000000100000105767777d51000004f4444944f444494
33333333111111660000000000000000700000077000000770006000000600079f58888857555575f10011100101000155666666d51000004f4444944f444494
33333333111111660000000000000000700000077000000770006000000600079fdddddd75555577ff1100011110001f05777677d51000004f4444944f444494
33333333dddddd660000000000000000777777777777777777776000000677774444444477777757ff101000000011ff57777677d51000004f4444944f444494
00077000bbbbbbbbbbbbbbbb0000000070000067760000077006600000066007bbbbbbbb25555525fff111111111ffff44444444d51000004f4444944f444494
00755700bbbbbbbbb2dddddb0000000070000607706000077060600000060607bbcdbb6522222222ffffffffffffffff4ffffff4d51000004f9999944f444494
07500570bbbbbbbbb2daaadb0000000070000507705000077050600000060507b3cd826555552555ffffffffffffffff4f444494d5100000444444444f449994
77700777bbbbbbbbb2dddddb000a0a0070000007700000077000600000060007b3cd826555552555ffffffffffffffff4f444494d5100000444444444f994444
00700700bbbbbbbbb2dddddb00aaa00070000007700000077005000000005007b3cd826555552555ffffffffffffffff4f444494d510000049a4444444444444
00700700b677bbbbb2daaadb00aa9a0070000007700000077050000000000507b3cd826522222222ffffffffffffffff6f444496d51000004994444444444444
007777007a66ebbbb2dddddb00a99a0077777777777777777500000000000077b3cd8265ffffffffffffffffffffffffd644446dd51000004444444449a44444
00555500b6eebbbbb27777bb00444400555555555555555555555555555555554444444444444444ffffffffffffffffdd4444ddd51000004ffffff449944444
000700000000000000000000677776777000070055555555bb666bbbbbbbbbbb77777777f1fffffffffffffff1ffffffffffffffd51000004f44449444444444
000700000666666000000000677776777077770011111111b6bbb6bb555b5bbbdddddddd101fffffff1ff1ff101fffffff1ff1ffd51000004f4444944444fff4
0007000065555556000000006666666670070000111111116bbbb6bb666666bb66666666101fffffff01101f101fffffff01101fd51000004f4444944fff4494
7770777076666661055555507776777770777000111111116bbb6bbbbbbbc7cb77776777f101fffff1000001f101fffff1000001d51000004f4444944f444494
000700007cccccc15f9f9f95777677777070000055555555b6666cccbbbc7a7c666d6d66f101111111008081f101111111008081d51000004f4444944f444494
000700007cccccc175555551666666667007000011111111bbbbca9cbbb73337666d6d66ff10000000000001ff10000000000001d51111114f4444944f444494
00070000055555507cccccc1677776777777000711111111bbbbc9acbbbc7a7c666d6d66ff1000000000001fff1000000000001fd55555554ffffff44f444494
000000000000000005555550677776775555775711111111bbbbccccbbbbc7cb666d6d66fff10000000011fffff10000000011ffdddddddd444444444f444494
00777700bbb2eeee2bbbbbbb677776776dd6dd6d11111111444d66666666d444666d6d66fff100000001fffffff100000001ffffbbbbbbbb4f4444944f444494
00755700bbb2eeee2bbbbbbb677776776666666611111111444d66666666d444666d6d66fff100111001fffffff100111001ffffb66bbbbb4f4444944f444994
00700700bbbb2222bbbbbbbb66666666d6dd6dd611111111444d66666666d444666d6d66fff101fff101ffffffff101ff101ffff666bbbbb4f4444944f499444
77700777bbbbbbbbbbbbbbbb77767777d6dd6dd6dddddddd444d66666666d444666d6d66fff101fff101fffffff101fff1001fff676bbbbb4f4444944f944444
57500575bbbbbbbbbbbbbbbb777677776666666611111111444d66666666d444666d6d66fff101fff101ffffff1001ffff101fff676bbbbb4f44449444444400
05700750bbbbbbbbbbbbbbbb666666666dd6dd6d66111111444d66666666d444666d6d66fff101fff101ffffff101fffff1001ff66bbbbbb4f44449444440000
00577500bbbbbbbbbbbbbbbb677776776dd6dd6d66111111444dddddddddd444dddd6dddffff1fffff1fffffff111ffffff11fffbbbbbbbb4f44449444000000
00055000bbbbbbbbbbbbbbbb677776776666666666dddddd444444444444444466666666ffffffffffffffffffffffffffffffffbbbbbbbb4f44449400000000
bbbbffffffffffffffffffffffbbbbbbbbbb4444444444444444444444bbbbbbbb77777bbbbb677600000000bbbbbb777777777700000000bbbbbbbbb555555b
bbbf4444444444444444444444fbbbbbbbbf9555555555555555555559fbbbbbb7667677bbbfbb7700000000bbbbb7cccccccccc00000000bbbbbbbbbb60655b
bbf44ffffffffffffffffffff44fbbbbbbf595555555555555555555595fbbbbf7777667bbbf777b00000000bbbb7ccccccccccc0000000099999999b60506bb
bf44444444444444444444444444fbbbbf55955555555555555555555955fbbbfbbb7777bbbbbbbb00000000bbbb76666666cccc0000000098888884b60006bb
b94ffffffffffffffffffffffff49bbbb9559999999999999999999999559bbbbf77777bbbbbbbbb00000000bbb7666555556ccc0000000098888884b60006bb
b9444444444444444444444444449bbbb9599444444444444444444449959bbbbbb777bbbbbbbbbb00000000bbb7666555556ccc0000000094444444b60006bb
b9444444444444444444444444449bbbb9944444444444444444444444499bbbbbbbbbbbbbbbbbbb00000000bbb7665555556ccc00000000bbbbbbbbb60006bb
999999999999999999999999999999bb99ffffffffffffffffffffffffff99bbbbbbbbbbbbbbbbbb00000000bbb7666555556ccc00000000bbbbbbbbbb666bbb
bb94444449bbbbbbbbbb94444449bbbbbb94444449bbbbbbbbbb94444449bbbbbbbbbbbbbbbc999bbbbbbbbbbbbbbbbb65555ccc00000000fff76fffffffffff
bb94ffff49bbbbbbbbbb94ffff49bbbbbb94ffff49bbbbbbbbbb94ffff49bbbbbbbbbbbbbbcc111999bbbbbbbbbbbbbb55555ccc00000000fff76ffff666677f
bb94944949bbbbbbbbbb94944949bbbbbb94944949bbbbbbbbbb94944949bbbbbbbbbbbbbcc1111999bbbbbbbbbbbbbb55555ccc00000000fbbbbccf75555557
bb94999949bbbbbbbbbb94999949bbbbbb94999949bbbbbbbbbb94999949bbbbbbbbbbbbccc1111999bbbbbbbbbbbbbb55555ccc00000000bbbcccc8d776666d
bb94444449bbbbbbbbbb94444449bbbbbb94444449bbbbbbbbbb94444449bbbbbbbbbbbbcccc111999bbbbbbbbbbbbbb55555ccc00000000fccccc8ff676650f
bb94444449bbbbbbbbbb94444449bbbbbb94444449bbbbbbbbbb94444449bbbbbbbbbbbcccccc11991bbbbbbbbbbbbbb55555ccc00000000fccc888ff676650f
bb94ffff49bbbbbbbbbb94ffff49bbbbbb94ffff49bbbbbbbbbb94ffff49bbbbbbbbbbccc6ccc19911bbbbbbbbbbbbbb5555cccc00000000fff00ffff676650f
bb94944949bbbbbbbbbb94944949bbbbbb94944949bbbbbbbbbb94944949bbbbbbbbbbccc66611991bbbbbbbbbbbbbbb55cccccc00000000fff00fffff7665ff
bb94999949bbbbbbbbbb94999949bbbbbb94999949bbbbbbbbbb94999949bbbbbbbbbcccccc61991bbbbbbbbbbbbbbbbccccccccbbbbbbbbfff76fffa555555a
bb94444449bbbbbbbbbb94444449bbbbbb94444449bbbbbbbbbb94444449bbbbbbbbbccccccc1911bbbbbbbbbbbbbbbbccccccccbbbbbbbbfff76fffaa90955a
bb99999999bbbbbbbbbb99999999bbbbbb99999999bbbbbbbbbb99999999bbbbbbbbc66ccccc991bbbbbbbbbbbbbbbbbcccccccc99999999f8888bbfa90509ab
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbccc66ccc9911bbbbbbbbbbbbbbbbbcccccccc98888884888bbbbca90009ab
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccc6cc9911bbbbbbbbbbbbbbbbbbcccccccc98888884fbbbbbcfa90009ab
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccc911bbbbbbbbbbbbbbbbbbbccccc00094444444fbbbcccfa90009ab
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbc6ccccc911bbbbbbbbbbbbbbbbbbbbcccc0555bbbbbbbbfff00fffa90009ab
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcc66ccc911bbbbbbbbbbbbbbbbbbbbbccc05555bbbbbbbbfff00fffba999abb
bbbbbbbbbbbbbbbb00077700bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccc911bbbbbbbbbbbbbbbbbbbbbbcc0555550066560bfff76fffcccccccc
bbbbbbbbbbbbbbbb00766650bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbc6ccc911bbbbbbbbbbbbbbbbbbbbbbbcc05555500660500fff76fffc000000c
bbbbbbbbbbbbbbbb00766650bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbccccc911bbbbbbbbbbbbbbbbbbbbbbbb7705555500666500fcccc88fc0c00c0c
bbbbbbbbbbbbbbbb07766650bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccc911bbbbbbbbbbbbbbbbbbbbbbbbbbbb5555500000500ccc8888bc00cc00c
bbbbbbbbbbbbbbbb76655500bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcc6911bbbbbbbbbbbbbbbbbbbbbbbbbbbbb5555507777570f88888bfc00cc00c
bbbbbbbbbbbbbbbb76665000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcc611bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb555507775770f888bbbfc0c00c0c
bbbbbbbbbbbbbbbb76665000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbccc1bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb55507757770fff00fffc000000c
bbbbbbbbbbbbbbbb05550000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb55588880fff00fffcccccccc
00077777bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000
007cccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000
007cccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb9bbbbbbbbbbbbbbb00000000
07666666b88888ebb88888ebb88888ebbbe888ebbbe888ebbbe888ebbeee88ebbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb4994449bbe44444b00000000
766655558882888e8882888e8882888ebe88888ebe88888ebe88888eee88888ebbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb44444449e444244400000000
76665555828222888282228882822288e8882228e8882228e8882228e8888888bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb44444444422242400000000
7665555528fff22828fff22828fff2288882fff28882fff28882fff2e8888888bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbfffff44422fff8200000000
766655552fffff282fffff282fffff288882fff28882fff28882fff288888888bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbffffff442fffff200000000
766666551111111811111118111111188881111288811112888111128888888f8888888f8888888f11111118888111128888888fb17f17f4b111111100000000
75565555ff11f118ff11f118ff11f118228ff11f228ff11f228ff11f8888222f8888222f8888222fff11f118228ff11f8888222fbfffffffb11f11ff00000000
75656555ffff4ffbffff4ffbffff4ffb22fffffb22fffffb22fffffbb82222fbb82222fbb82222fbffff4ffb22fffffbb82222fbbff9ffffbff4ffff00000000
755555551ffffffb1ffffffb1ffffffbb2fffffbb2fffffbb2fffffbbf2222fbbf2222fbbf2222fb1ffffffbb2fffffbbf2222fbbffffffbbffffff100000000
75555555bff55fbbbff55fbbbff55fbbbbffff5bbbffff5bbbffff5bbbffffbbbbffffbbbbffffbbbff55fbbbbfff55bbbffffbbbbf55ffbbbf55ffb00000000
75555555bbffffbbbbffffbbbbffffbbbbfffbbbbbfffbbbbbfffbbbbbffffbbbbffffbbbbffffbbbbf55fbbbbfff55bbbffffbbbbffffbbbbffffbb00000000
75555555b887788bb887788bb887788bbbee8bbbbb8ee8bbbbee8bbbb887788bb826628bb826628bbbffffbbbbbbfffbb887788bb0ffff0bb887788b00000000
7555555c887777888887788b88777788b288e7bbbb288ebbb288e7bb887777888877777888777788bbbbbbbbbbbbbbbb88777788000ff0008877778800000000
75555ccc887777888277772882777728b288e7bbbb288ebbb288e7bb8877778882777728827777280000000000000000b17f17f4010000108877778800000000
755ccccc887777888277772882777728b288e7bbbb288ebbb288e7bb8877778882777728827777280000000000000000bfffffff010000108877778800000000
7ccccccc887777888827772882777288b288e7bbbb288ebbb288e7bb8877778888277728827772880000000000000000bff9ffff010000108877778800000000
7ccccccc887777888827772882777288b288e7bbbb288ebbb288e7bb8877778888277728827772880000000000000000bffffffb010000108877778800000000
7cc99ccc88555588be2555ebbd55528bb2ee55bbbb8ee5bbb2ee55bbe255552eb825558bb855528b0000000000000000bff55ffb010000108855558800000000
7cccccccfeccccefbfeccc2bb2cccefbbbffccbbbb1ffcbbbbffccbbfeccccefbfeccc2bb2cccefb0000000000000000bbf55ffbfe0000effeccccef00000000
7cccccccbfccccfbbffcccebbecccffbbbfeccbbbb1fecbbbbfeccbbbfccccfbbffcccebbecccffb0000000000000000b0ffff0bbf0000fbbfccccfb00000000
7cccccccbbcc1cbbbbcc1cbbbbcc1cbbbb2cccbbbb1cccbbbb2cccbbbbc1ccbbbbc1ccbbbbc1ccbb0000000000000000000ff000bb0100bbbbc1ccbb00000000
7cccccccbbcc1cbbbbcc1cbbbbcc1cbbbbccccbbbb1cccbbbb1cccbbbbc1ccbbbbc1ccbbbbc1ccbb00000000bb2111bb22811112bb0100bbbbc1ccbb00000000
07ccccccbbcc1cbbbbcc1cbbbbcc1cbbbbccccbbbb1cccbbbb1cccbbbbc1ccbbbbc1ccbbbbc1ccbb00000000b1ccdcbb228ff11fbb0100bbbbc1ccbb00000000
00777777bbcc1cbbbbcc1cbbbbcc1cbbbbccc1bbbb1cccbbbb1ccccbbbc1ccbbbbc1ccbbbbc1ccbb00000000b1ccdcbb22fffffbbb0100bbbbc1ccbb00000000
00000000bbcc1cbbbbcc1cbbbbcc1cbbbbccc1bbbb1cccbbbb11cccbbbc1ccbbbbc1ccbbbbc1ccbb00000000b1ccdcbbb2fffffbbb0100bbbbc1ccbb00000000
00000000bbcc1cbbbbcc1cbbbbcc1cbbbcccc11bbb1cccbbb111cccbbbc1ccbbbbc1c6bbbb61ccbb00000000b1ccdcbbbbffff5bbb0100bbbbc1ccbb00000000
00000000bbcc1cbbbbcc1cbbbb6c66bb6ccc111bbb1cccbbb111cc66bbc1ccbbbbc1661bb166ccbb00000000b1dddcbbbbfffbbbbb0100bbbbc1ccbb00000000
00000000bb6666bbbb11611bb11611bb1666111bbb6666bbb1116611bb6666bbbb66511bb11566bb00000000bbff11bbb8ddcbbbbb0100bbbb6666bb00000000
00000000b115511bbbbb511bb116bbbbb1115555bb5111bbb55511bbb115511bbb11bbbbbbbb11bb00000000bbfe11bbb1ccdcbbb005500bb115511b00000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
777777777777777777777777cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcb
777777777777777777777777bcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbc
777777777777777777777777cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcb
777777777777777777777777bcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbc
777777777777777777777777cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcb
777777777777777777777777bcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbc
777777777777777777777777cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcb
777777777777777777777777bcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbc
777777777777777777777777cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcb
777777777777777777777777bcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbc
777777777777777777777777cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcb
777777777777777777777777bcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbc
777777777777777777777777cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcb
777777777777777777777777bcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbc
777777777777777777777777cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcb
777777777777777777777777bcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbc
777777774444444477777777cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcb
777777774ffffff477777777bcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbc
777777774f44449477777777cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcb
777777774f44449477777777bcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbc
777777774f44449477777777cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcb
777777774f44449477777777bcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbc
777777774f44449477777777cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcb
777777774f44449477777777bcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbc
777777774f4444947777777799999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
777777774f4444947777777722222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
777777774f4499947777777744444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
777777774f99444477777777fff444449fff4fffffff4fffffff4fffffff4fffffff4fffffff4fffffff4fffffff4fffffff4fffffff4fffffff4fffffff4fff
77777777444444447777777744444044494949444449494444494944444949444449494444494944444949444449494444494944444949444449494444494944
77777777444444447777777744404000044949444449494444494944444949444449494444494944444949444449494444494944444949444449494444494944
7777777749a44444777777774404ffff004949444449494444494944444949444449494444494944444949444449494444494944444949444449494444494944
777777774994444477777777440f9ff9f04949444449494444494944444949444449494444494944444949444449494444494944444949444449494444494944
777777774444444477777777440f5ff5f04949444449494444494944444949444449494444494944444949444449494444494944444949444449494444494944
777777774444fff477777777444ffffff44949444449494444494944444949444449494444494944444949444449494444494944444949444449494444494944
777777774fff449477777777444ff44ff44949444449494444494944444949444449494444494944444949444449494444494944444949444449494444494944
777777774f444494777777774446ffff644949444449494444494944444949444449494444494944444949444449494444494944444949444449494444494944
777777774f444494777777774449fddf444949444449494444494944444949444449494444494944444949444449494444494944444949444449494444494944
777777774f4444947777777744494ff4444949444449494444494944444949444449494444494944444949444449494444494944444949444449494444494944
777777774f44449477777777999dc55cd99949999999499999994999999949999999499999994999999949999999499999994999999949999999499999994999
777777774f4444947777777744dcc55ccd4444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
777777774f4444947777772222c1c66c1c2222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
777777774f4449947777222222c1c55c1c22222222222222222222222c2222222222222222222222222222222222222222222222222222222222222222222222
777777774f4994447722222222c1c55c1c22222222222222222222222c2222222222222222222222222222222222222222222222222222222222222222222222
777777774f9444442222222222c1c55c1c22222222222222222222222c2222222222222222222222222222222222222222222222222222222222222222222222
77777777444444222222222222d1cddc1d22222222222222222222ccc2ccc2222222222222222222222222222222222222222222222222222222222222222222
77777777444422222222222222fe1111ef22222222222222222222222c2222222222222222222222222222222222222222222222222222222222222222222222
777777774422222222222222222f1111f222222222222222222222222c2222222222222222222222222222222222222222222222222222222222222222222222
777777772222222222222222222211212222222222222222222222222c2222222222222222222222222222222222222222222222222222222222222222222222
77777722222222222222222222221121222222222222222222222222222222223333333333333333333333333333333333333333333333333333333322222222
77772222222222222222222222221121222222222222222222222222222233333333333333333333333333333333333333333333333333333333333333332222
77222222222222222222222222221121222222222222276222222222223333333333333333333333333333333333333333333333333333333333333333333322
22222222222222222222222222221121222222222222276222222222233333333333333333333333333333333333333333333333333333333333333333333332
2222222222222222222222222222112122222222222bbbb772222222233333333333333333333333333333333333333333333333333333333333333333333332
222222222222222222222222222211212222222222bbb77778222222223333333333333333333333333333333333333333333333333333333333333333333322
2222222222222222222222222222cccc222222222227777782222222222233333333333333333333333333333333333333333333333333333333333333332222
22222222222222222222222222277667722222222227778882222222222222223333333333333333333333333333333333333333333333333333333322222222
22222222222222222222222222222222222222222222200222222222222222222222222222222222222222222222222222222222222222222222222222222222
22222222222222222222222222222222222222222222200222222222222222222222222222222222222222222222222222222222222222222222222222222222
22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000c0c0ccc0c000c0c00000ccc00cc0000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000c0c0c0c0c000cc0000000c00c0c0000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000ccc0ccc0c000c0c000000c00c0c0000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000ccc0c0c0ccc0c0c000000c00cc00000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0cc0ccc0ccc0cc0000000000ccc0ccc00cc0c0c00000c0c0ccc00000ccc0c0c00cc0c0c000000000000001111111111011111111110111111111101111111111
c1c0c1c0c110c1c000000000c1c01c10c110c0c00000c0c0c1c00000c1c0c0c0c110c0c0000000cc000001111111111011111111110111111111101111111111
c0c0ccc0cc00c0c000000000ccc00c00c000cc10ccc0c0c0ccc00000ccc0c0c0ccc0ccc000000c11c00001111111111011111111110111111111101111111111
c0c0c110c100c0c000000000c1100c00c000c1c01110c0c0c1100000c110c0c011c0c1c00000c1001c0001111111111011111111110111111111101111111111
cc10c000ccc0c0c000000000c000ccc01cc0c0c000001cc0c0000000c0001cc0cc10c0c0000ccc00ccc001111111111011111111110111111111101111111111
11001000111010100000000010001110011010100000011010000000100001101100101000000c00c00001111111111011111111110111111111101111111111
00000000000000000000000000000000000000000000000000000000000000000000000000000c00c00001111111111011111111110111111111101111111111
00000000000000000000000000000000000000000000000000000000000000000000000000000cccc00001111111111011111111110111111111101111111111
0cc0c0000cc00cc0ccc00000c0000cc00cc0c0c00000ccc0ccc00000ccc0c0c0c000c00000000111100001111111111011111111110111111111101111111111
c110c000c1c0c110c1100000c000c1c0c1c0c0c00000c1c01c100000c1c0c0c0c000c00000000000000001111111111011111111110111111111101111111111
c000c000c0c0ccc0cc000000c000c0c0c0c0cc10ccc0ccc00c000000ccc0c0c0c000c00000000000000000000000000000000000000000000000000000000000
c000c000c0c011c0c1000000c000c0c0c0c0c1c01110c1c00c000000c110c0c0c000c00000000000000000000000000000000000000000000000000000000000
1cc0ccc0cc10cc10ccc00000ccc0cc10cc10c0c00000c0c00c000000c0001cc0ccc0ccc000000000000001111111111011111111110111111111101111111111
01101110110011001110000011101100110010100000101001000000100001101110111000000cccc00001111111111011111111110111111111101111111111
00000000000000000000000000000000000000000000000000000000000000000000000000000c11c00001111111111011111111110111111111101111111111
00000000000000000000000000000000000000000000000000000000000000000000000000000c00c00001111111111011111111110111111111101111111111
0cc0ccc0c0c0ccc000000000ccc0ccc0c000c0c00000ccc00cc00000c0c00cc0ccc00000000ccc00ccc001111111111011111111110111111111101111111111
c1101c10c0c0c110000000001c10c1c0c000c0c000001c10c1c00000c0c0c110c11000000001c1001c1001111111111011111111110111111111101111111111
c0000c00c0c0cc00000000000c00ccc0c000cc10ccc00c00c0c00000c0c0ccc0cc00000000001c00c10001111111111011111111110111111111101111111111
c0c00c00ccc0c100000000000c00c1c0c000c1c011100c00c0c00000c0c011c0c1000000000001cc100001111111111011111111110111111111101111111111
ccc0ccc01c10ccc0000000000c00c0c0ccc0c0c000000c00cc1000001cc0cc10ccc0000000000011000001111111111011111111110111111111101111111111
11101110010011100000000001001010111010100000010011000000011011001110000000000000000001111111111011111111110111111111101111111111
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__gff__
0001010101010100000100010000000000010101010101000000000101000000000101010101010101010101000000000001010000010101000000000000000001010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
3434343364573333333333333333333333333333343434373737565737373737373717171745654444650034444534344445340065080808080808080817171707070717171717171717171717070707171717080808080808080808081717170707071717171717171717171707070717171708080808080808080808171717
3434343333333333333359485933335959593359343434373737373737373737373717171765656565650034545534345455340065080808080808080817171707070717171717171717171717070707171717080808080808080808081717170707071717171717171717171707070717171708080808080808080808171717
3434343333333333333333333333333333333333343434180e184b4c18181818181817001745654545650034343434343434340065080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017
3434343333333333333333333333333333333333343434666766676667666718181817001755655455650034343434343434340065080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017
3434343333333333333333333333333333333333343434767776777677767718181817001765656565653034004534410075343065080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017
34343937373737373737373737373737373737373a343409090909090909090909092202171515151515151515151540142a151515323232323232323222021707011131313131313131313131210107170212323232323232323232322202170701113131313131313131313121010717021232323232323232323232220217
3439373737373737373737373737373737373737373a34090909090909090909090909092231313131313131313131313131313131323232323232323232322211313131313131313131313131313121123232323232323232323232323232221131313131313131313131313131312112323232323232323232323232323222
393737373737373737373737373737373737373737373a090909090909090909090909090931313131313131313131313131313131323232323232323232323231313131313131313131313131313131323232323232323232323232323232323131313131313131313131313131313132323232323232323232323232323232
1717170808080808080808080817171707070717171717171717171717070707171717080808080808080808081717170707071717171717171717171707070717171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707
1717170808080808080808080817171707070717171717171717171717070707171717080808080808080808081717170707071717171717171717171707070717171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707
1700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
1700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
1700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
1702123232323232323232323222021707011131313131313131313131210107170212323232323232323232322202170701113131313131313131313121010717021232323232323232323232220217070111313131313131313131312101071702123232323232323232323222021707011131313131313131313131210107
1232323232323232323232323232322211313131313131313131313131313121123232323232323232323232323232221131313131313131313131313131312112323232323232323232323232323222113131313131313131313131313131211232323232323232323232323232322211313131313131313131313131313121
3232323232323232323232323232323231313131313131313131313131313131323232323232323232323232323232323131313131313131313131313131313132323232323232323232323232323232313131313131313131313131313131313232323232323232323232323232323231313131313131313131313131313131
0707071717171717171717171707070717171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707171717080808080808080808081717170707071717171717171717171707070717171708080808080808080808171717
0707071717171717171717171707070717171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707171717080808080808080808081717170707071717171717171717171707070717171708080808080808080808171717
0700071717171717171717171707000717001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017
0700071717171717171717171707000717001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017
0700071717171717171717171707000717001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017
0701113131313131313131313121010717021232323232323232323232220217070111313131313131313131312101071702123232323232323232323222021707011131313131313131313131210107170212323232323232323232322202170701113131313131313131313121010717021232323232323232323232220217
113131313131313131313131313131211232323232323232323232323232322211313131313131494a313131313131211232323232323232323232323232322211313131313131313131313131313121123232323232323232323232323232221131313131313131313131313131312112323232323232323232323232323222
313131313131313131313131313131313232323232323232323232323232323231313131313131595a313131313131313232323232323232323232323232323231313131313131313131313131313131323232323232323232323232323232323131313131313131313131313131313132323232323232323232323232323232
17171708080808080808080808171717070707171717171717171717170707070707071a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a070707000000000000000017171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707
17171708080808080808080808171717070707171717171717171717170707070707071a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a070707000000000000000017171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707
17001708080808080808080808170017070007171717171717171717170700070700071a1a1a1a1a1a1a1a1a1a1a1a1a4e001a1a1a070007000000000000000017001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
1700170808080808080808080817001707000717171717171717171717070007070007686868686868686868686868685e00686868070007000000000000000017001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
1700170808080808080808080817001707000717171717171717171717070007070007787878787878787878787878786e00787878070007000000000000000017001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
1702123232323232323232323222021707011131313131313131313131210107070111313131313131313131313131313131313131210107000000000000000017021232323232323232323232220217070111313131313131313131312101071702123232323232323232323222021707011131313131313131313131210107
1232323232323232323232323232322211313131313131313131313131313121113131313131312515151515151515353131313131313121000000000000000012323232323232323232323232323222113131313131313131313131313131211232323232323232323232323232322211313131313131313131313131313121
3232323232323232323232323232323231313131313131313131313131313131313131313131313131313131313131313131313131313131000000000000000032323232323232323232323232323232313131313131313131313131313131313232323232323232323232323232323231313131313131313131313131313131
__sfx__
0001000012051100510d0510b05109051070510504104031020310101100011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
012c00001886300000188630000018863000001886300000188630000018863000001886300000188630000018863000001886300000188630000018863000001886300000188630000018863000001886300000
01010000386303263032630306302c6302863023630216301d63019630146300a630016301e6001d6001a6001960015600126000f6000c6000a60007600046000260000600066000660005600046000460004600
010100000c1600c1610c1610c1610c1610c1610c1610c1610c1610c1610c1610c1610c1610c1610c1510c1510c1510c1510c1510c1510c1410c1410c1410c1310c1310c1310c1210c1210c1210c1110c1110c111
013f00002405224052240522405224052240522405224052240522405224052240522405224052240522405224052240522405224052240522405224052240522405224052240522405224052240522405224052
010500001855018541185511854118551185411855118541185511854118551185411855118541185511854118551185411855118541185511854118551185411855118541185511854118551185411855118541
01020000180501805018040180401803018020180201801018010150001500024000210001e0001c0001a000170001400011000070000a0000500004000020000100000000000000000000000000000000000000
012c000023d4223d4223d4225d4223d4223d4223d4225d4223d4225d4227d4225d4223d4222d4223d4227d4228d4228d4228d4228d4227d4227d4227d4227d4228d4227d4225d4223d4227d4225d4223d4223d42
011c000010d5310d5310d5310d5310d5310d5310d5310d5310d5310d5310d5310d5310d5310d5310d5310d5309d5309d5309d5309d5309d5309d5309d5309d5309d5309d5309d5309d5309d5309d5309d5309d53
001c000017d5317d5317d5317d5317d5317d5317d5317d5317d5317d5317d5317d5017d5317d5317d5317d5310d5310d5310d5310d5310d5310d5310d5310d5310d5310d5310d5310d5310d5310d5310d5310d53
011c000013d5313d5313d5315d5313d5313d5313d5315d5313d5315d5313d5315d5013d5013d5313d530bd530cd530cd530cd530cd530cd530cd530cd530cd530cd530cd530cd530cd530cd530cd530cd530cd53
001c00001cd531cd531cd531cd531cd531cd531cd531cd531cd531cd531cd531cd531cd531cd531cd531cd5315d5315d5315d5315d5315d5315d5315d5315d5315d5315d5315d5315d5315d5315d5315d5315d53
011c00000ed530ed530ed530ed530ed530ed530ed530ed530ed530ed530ed530ed530ed530ed530ed530ed530bd530bd530bd530bd530bd530bd530bd530bd530bd530bd530bd530bd530bd530bd530bd530bd53
011c000015d5315d5315d5315d5315d5315d5315d5315d5315d5315d5315d5315d5015d5315d5315d5315d5312d5312d5312d5312d5312d5312d5312d5312d5312d5312d5312d5312d5312d5312d5312d5312d53
011c000012d5312d5312d5313d5312d5312d5312d5313d5312d5313d5312d5313d5012d5312d5310d5310d530ed530ed530ed530ed530ed530ed530ed530ed530ed530ed530ed530ed530ed530ed530ed530ed53
011c00001ad531ad531ad531ad531ad531ad531ad531ad531ad531ad531ad531ad531ad531ad531ad531ad5317d5317d5317d5317d5317d5317d5317d5317d5317d5317d5317d5317d5317d5317d5317d5317d53
011c00000cd530cd530cd530cd530cd530cd530cd530cd530cd530cd530cd530cd500cd530cd530cd530cd530cd530cd530cd530cd530cd530cd530cd530cd530cd530cd530cd530cd530cd530cd530cd530cd53
011c000013d5313d5313d5313d5313d5313d5313d5313d5313d5313d5313d5313d5013d5313d5315d5315d5317d5317d5317d5317d5015d5315d5315d5315d5313d5013d5313d5313d5312d5312d5312d5312d53
011c000010d5310d5310d5310d5310d5310d5310d5310d5310d5310d5310d5310d5010d5310d5310d5310d5310d5310d5310d5310d5310d5310d5310d5310d5310d5310d5310d5310d5310d5310d5310d5310d53
011c000018d5318d5318d5318d5318d5318d5318d5318d5318d5318d5318d5318d5018d5318d5318d5318d5318d5318d5318d5318d5318d5318d5318d5318d5318d5318d5318d5318d5318d5318d5318d5318d53
010e0000188500000010d500000018a500000010d5000000188500000010d500000018a500000010d5000000188500000010d500000018a500000010d5000000188500000010d500000018a500000010d5000000
010e002010b500000017b500000013b500000010b50000001cb50000001cb500000015b500000018b500000010b500000017b500000013b500000010b500000015b500000015b500000013b500000012b5000000
010e0000000000000017d5000000000000000017d5000000000000000018d5000000000000000018d5000000000000000017d5000000000000000017d5000000000000000018d5000000000000000018d5000000
010e0000000000000010c3010c511cc511cc5110c5110c511cc511cc511cc511cc511cc511cc5110c5110c511fc511fc511ec511ec511cc511cc511ac511ac511cc511cc511cc511cc511cc511cc511cc311cc10
010e000018c3118c5117c5117c5115c5115c5113c5113c5117c5117c5117c5117c5017c5117c5111c5111c5110c5110c5110c5110c5110c5110c5110c5110c5110c5110c5110c5110c5110c5110c4110c3110c11
010e000018850000000cd500000018a50000000cd50000000b850000000bd500000018a50000000bd500000018850000000cd500000018a50000000cd500000018850000000fd500000018a50000000fd5000000
010e0000000000000010d5000000000000000010d500000000000000000ed500000000000000000ed5000000000000000010d5000000000000000010d5000000000000000012d5000000000000000012d5000000
010e002018b500000018b500000018b500000018b500000017b500000017b500000017b500000017b500000018b500000018b500000018b500000018b50000001bb50000001bb50000001bb50000001bb5000000
010e00002de200000030e20000002fe20000002de20000002fe20000002be200000028e200000000000000002de200000030e20000002fe20000002de200000033e200000033e200000034e200000033e2000000
010e00000000018c5118c5118c5117c5117c5113c5113c5117c5117c5117c5117c5117c5015c5111c5111c5110c5110c5110c5110c5110c5110c5110c5110c5110c5110c5110c5110c5110c5110c410000000000
010e000000000000002fe232fe232fe23000002de232de232de23000002be23000002be23000002fe230000000000000002fe232fe232fe23000002de232de232de23000002be230000030e23000002fe2300000
010e000000000000002fe232fe232fe23000002de232de232de23000002be23000002be230000032e230000018c3118c5117c5117c5113c5113c5111c5111c5110c5110c5110c5010c5110c4110c2110c1100000
010e00002dd4021d4030d4024d402fd4023d402dd4021d402fd4023d402bd401fd4328d401cd4300000000002dd4021d4330d4024d432fd4023d432dd4021d4333d4027d4333d4027d4334d4028d4333d4027d43
010e002018b500000018b500000018b500000018b500000018b500000018b500000018b500000018b500000012b500000012b500000012b500000012b500000012b500000012b500000012b500000012b5000000
010e002015b500000015b500000015b500000015b500000015b500000015b500000015b500000015b500000017b500000017b500000017b500000017b500000017b500000017b500000017b500000017b5000000
010e002013b500000013b500000013b500000013b500000013b500000013b500000013b500000013b500000017b500000017b500000017b500000017b500000017b500000017b500000018b500000017b5000000
010e002013b500000013b500000013b500000013b500000013b500000013b500000013b500000012b500000010b500000010b500000010b500000010b500000010b500000010b500000010b500000010b5000000
010e000015d5015d5015d5015d5015d5015d5017d5017d5015d5015d5015d5015d5013d5013d5013d5013d5017d5017d5017d5017d5017d5017d5018d5018d5017d5017d5017d5017d5013d5013d5013d5013d50
010e00001ad501ad501ad501ad501ad501ad5018d5018d5017d5017d5017d5017d5015d5015d5015d5015d5017d5017d5017d5017d5017d5017d5017d5017d5010d5010d5010d5010d5010d5010d5010d5010d50
010e002018b500000018b500000018b500000018b500000018b500000018b500000018b500000018b500000012b500000012b500000012b500000012b500000012b500000012b500000012b500000012b5000000
010e002013b500000013b500000013b500000013b500000013b500000012b500000013b500000015b500000017b500000017b500000017b500000017b500000017b500000017b500000017b500000013b5000000
010e000013d5013d5013d5013d5013d5013d5012d5012d5013d5013d5013d5013d5015d5015d5015d5015d5012d5012d5012d5012d5012d5012d5012d5012d5012d5012d5012d5012d5013d5013d5012d5012d50
010e000010d5010d5010d5010d5010d5010d500ed500ed5010d5010d5010d5010d5015d5015d5015d5015d5017d5017d5018d5018d5017d5017d5015d5015d5017d5017d5017d5017d5017d5017d5017d5017d50
010e000013d5013d5013d5013d5013d5013d5012d5012d5010d5010d5010d5010d5012d5012d5012d5012d5013d5013d5013d5013d5012d5012d5012d5012d5010d5010d5010d5010d5010d5010d5010d5010d50
010e002013b500000013b500000013b500000013b500000013b500000012b500000013b500000015b500000013b500000013b500000012b500000012b500000010b500000010b500000010b500000010b5000000
010e002010b500000017b500000013b500000017b500000010b500000017b500000013b500000017b500000010b500000017b500000013b500000017b500000010b500000017b500000013b500000017b5000000
010e0000000000000017d5000000000000000017d5000000000000000017d5000000000000000017d5000000000000000017d5000000000000000017d5000000000000000017d5000000000000000017d5000000
010e002015b50000001cb500000018b50000001cb500000015b50000001cb500000018b50000001cb500000015b50000001cb500000018b50000001cb500000015b50000001cb500000018b50000001cb5000000
010e0000000000000018d5000000000000000018d5000000000000000018d5000000000000000018d5000000000000000018d5000000000000000018d5000000000000000018d5000000000000000018d5000000
010e000018850000000ed500000018a50000000ed500000018850000000ed500000018a50000000ed500000018850000000ed500000018a50000000ed500000018850000000ed500000018a50000000ed5000000
010e00200eb500000015b500000012b500000015b50000000eb500000015b500000012b500000015b50000000eb500000015b500000012b500000015b50000000eb500000015b500000012b500000015b5000000
010e0000000000000015d5000000000000000015d5000000000000000015d5000000000000000015d5000000000000000015d5000000000000000015d5000000000000000015d5000000000000000015d5000000
010e000018850000000bd500000018a50000000bd500000018850000000bd500000018a50000000bd500000018850000000bd500000018a50000000bd500000018850000000bd500000018a50000000bd5000000
010e00200bb500000012b50000000eb500000012b50000000bb500000012b50000000eb500000012b50000000bb500000012b50000000eb500000012b50000000bb500000012b50000000eb500000012b5000000
010e0000000000000012d5000000000000000012d5000000000000000012d5000000000000000012d5000000000000000012d5000000000000000012d5000000000000000012d5000000000000000012d5000000
010e0000000000000012d5000000000000000012d5000000000000000012d5000000000000000012d500000000000000000fd500000000000000000fd500000000000000000fd500000000000000000fd5000000
010e00200bb500000012b50000000eb500000012b50000000bb500000012b50000000eb500000012b50000000bb500000012b50000000fb500000012b50000000bb500000012b50000000fb500000012b5000000
011c000012d5312d5312d5313d5312d5312d5312d5313d5312d5313d5312d5313d5012d5312d5310d5310d530ed530ed530ed530ed530ed530ed530ed530ed530fd530fd530fd530fd530fd530fd530fd530fd53
010e00001cc301cc511cc511cc511cc511cc511ec511ec511cc511cc511cc511cc501cc511cc511ec511ec511cc511cc511ec511ec511cc511cc511ec511ec511cc511cc511cc511cc511cc511cc4117c3117c11
010e000018c3118c5118c5118c5118c5118c5118c5118c5118c5118c5118c5118c5018c5118c5118c5118c5118c5118c5118c5118c5118c5118c5118c5118c5118c5118c5118c5118c5118c5118c4118c3118c11
010e00001ac311ac511ac511ac511ac511ac511cc511cc511ac511ac511ac511ac501ac511ac511cc511cc511ac511ac511cc511cc511ac511ac511cc511cc511ac511ac511ac511ac5118c5118c4118c3118c11
010e000017c3117c5117c5117c5117c5117c5117c5117c5117c5117c5117c5117c5017c5117c5117c5117c5117c5117c5117c5117c5117c5117c5117c5117c5117c5117c5117c5117c5117c5117c4117c3117c11
012c000017b5017b5317b5317b5316b5016b5316b5316b5314b5014b5314b5314b5312b5012b5312b5312b5310b5010b5310b5310b530fb500fb530fb530fb5310b5010b5310b5314b5012b5012b5312b5312b53
012c000017b5017b5317b5317b5316b5016b5316b5316b5314b5014b5314b5314b5312b5012b5312b5312b5310b5010b5310b5310b530fb500fb530fb530fb5310b5010b5312b5012b5317b5012b5017b5017b50
__music__
01 08090a0b
00 0c0d0e0f
00 08090a0b
00 0c0d390f
02 10111213
01 14151644
00 14151644
00 14151617
00 14151618
00 14151617
00 14151618
00 191a1b1c
00 1415161d
00 1415161e
00 1415161f
00 1415161e
00 1415161f
00 191a1b20
00 1415161d
00 14221625
00 14241626
00 14271629
00 1428162a
00 14221625
00 14241626
00 14281629
00 142c162b
00 142d2e3a
00 142f303b
00 3132333c
00 3435363d
00 142d2e3a
00 142f303b
00 3132333c
00 3438373d
00 191a1b20
02 191a1b20
01 01073e44
01 01073f44