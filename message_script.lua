init_stats = {}

levels = {}

levels["tutorial_1"] = {
	title = "Breaking and Entering",
	message_stack = {"Ugh.  I'm lucky to be alive... but I won't be for long if I don't get some food in me.",
		"There's a fish pen just over there.  Drag me over with the [left mouse button].  I have just enough strength left to haul away the rafts on the boundary with the [right mouse button.]",
		"Goal: \n\n Grab a few fish from the fish pen!"},
	setup_function = function()
		setup_clean_level()
		load_level("tutorial_1")
		cam_x = 0
		cam_y = 0
		harm_raftguys(true, 40)
		
		awake_count, dead_count, fish_count, enemy_count, area_count = count_sprite_stats()
		
		init_stats["fish_count"] = fish_count
		
		gamestate = "Game"
	end,
	next_level = "tutorial_2",
	win_loss_function = function()
		awake_count, dead_count, fish_count, enemy_count, area_count = count_sprite_stats()
		
		if dead_count == 1 then
			return "Loss"
		elseif fish_count <= 1 then
			return "Win"
		else
			return "Goal: Catch "..(fish_count - 1).." more fish"
		end
	end}

levels["tutorial_2"] = {
	title = "Tiptoe Through the Minefield",
	message_stack = {"I've found a few of my friends... but they wound up in the middle of a minefield!",
		"I'll have to ease my way in gently and wake them up with ropes using the [right mouse button].  Might be a good idea to let go afterward by pressing [both mouse buttons]... I don't want to cause a chain reaction!",
		"Goal: \n\n Wake up 3 other raft-folk!"},
	setup_function = function()
		setup_clean_level()
		load_level("tutorial_2")
		cam_x = 0
		cam_y = 0
		
		awake_count, dead_count, fish_count, enemy_count, area_count = count_sprite_stats()
				
		gamestate = "Game"
	end,
	next_level = "tutorial_3",
	win_loss_function = function()
		awake_count, dead_count, fish_count, enemy_count, area_count = count_sprite_stats()
		
		if dead_count == 1 then
			return "Loss"
		elseif awake_count >= 4 then
			return "Win"
		else
			return "Goal: Wake up "..(4 - awake_count).." more raft-folk"
		end
	end}

levels["tutorial_3"] = {
	title = "Light up the Night",
	message_stack = {"Jackpot!  There are some gunboats up ahead, but they're guarding a real prize - a real, working autogun!",
		"I should find a way around them, grab the autogun with the [right mouse button], and wreak some havoc.",
		"Goal: \n\n Take out the gunboats!"},
	setup_function = function()
		setup_clean_level()
		load_level("tutorial_3")
		cam_x = 0
		cam_y = 0
		
		BOAT_MIN_TARGET_RANGE = 300
		BOAT_MAX_TARGET_RANGE = 700
		
		awake_count, dead_count, fish_count, enemy_count, area_count = count_sprite_stats()
				
		gamestate = "Game"
	end,
	next_level = "level_1",
	win_loss_function = function()
		awake_count, dead_count, fish_count, enemy_count, area_count = count_sprite_stats()
		
		if awake_count == 0 then
			return "Loss"
		elseif enemy_count == 0 then
			return "Win"
		else
			return "Goal: Destroy "..enemy_count.." more gunboats"
		end
	end}

levels["level_1"] = {
	title = "Dire Straits",
	message_stack = {"Salvation is just on the other side of these rocks... or so they say..",
	"Wouldn't mean much if I only made it by myself, though.",
	"Mouse controls (click+drag):\n[LMB] Move active member\n [RMB] Attach nearby raft\n[LMB+RMB] Release ropes\n\nHow to play:\n-Catch fish to regain health\n-Find other rafts and join forces\n-Avoid enemy boats and sea mines",
	"Goal: \n Get 2 raft-folk to the far eastern side (alive)."},
	setup_function = function()
		setup_clean_level()
		load_level("level_1")
		cam_x = 0
		cam_y = 12 * 128
		
		BOAT_MIN_TARGET_RANGE = 300
		BOAT_MAX_TARGET_RANGE = 700
		
		awake_count, dead_count, fish_count, enemy_count, area_count = count_sprite_stats()
				
		gamestate = "Game"
	end,
	next_level = "level_2",
	win_loss_function = function()
		awake_count, dead_count, fish_count, enemy_count, area_count = count_sprite_stats(33 * 128, 0, 40 * 128, 40 * 128)
		
		if awake_count == 0 or dead_count > 2 then
			return "Loss"
		elseif area_count >= 2 then
			return "Win"
		else
			return "Goal: Get "..(2 - area_count).." more raft-folk to the far side"
		end
	end}

levels["level_2"] = {
	title = "Prison break!",
	message_stack = {"Nobody should have to live in this floating prison.  Not even the guards.",
	"I want to get in and out quiet-like... the game will be up if I take out too many guards.  One or two wouldn't hurt though.",
	"Goal: \n Save 6 other raft-folk!"},
	setup_function = function()
		setup_clean_level()
		
		load_level("level_2")
		
		BOAT_MIN_TARGET_RANGE = 300
		BOAT_MAX_TARGET_RANGE = 700
						
		cam_x = 0
		cam_y = 0
		
		gamestate = "Game"
	end,
	next_level = "level_3",
	win_loss_function = function()
		awake_count, dead_count, fish_count, enemy_count, area_count = count_sprite_stats()
		
		if dead_count >= 4 or enemy_count <= 7 or awake_count == 0 then
			return "Loss"
		elseif awake_count >= 7 then
			return "Win"
		else
			return "Goal: Wake up "..(7 - awake_count).." more raft-folk; avoid the guards"
		end
	end}

levels["level_3"] = {
	title = ". . . Tower defense?",
	message_stack = {"Seems we pissed them off... now they're coming for us.  Man the guns!",
	"Goal: \n Destroy all the attacking gunboats!"},
	setup_function = function()
		setup_clean_level()
		
		load_level("level_3")
		
		-- 1st outer wave
		for i = 0, 8 do
			rad = math.random() * math.pi * 2
			sprites = addBoat(sprites, (128 * 30) + math.cos(rad) * 128 * 50, (128 * 30) + math.sin(rad) * 128 * 50)
			
		end
		
		-- Final wave
		for i = 0, 16 do
			rad = math.random() * math.pi * 2
			sprites = addBoat(sprites, (128 * 30) + math.cos(rad) * 128 * 80, (128 * 30) + math.sin(rad) * 128 * 100)
			
		end
		
		BOAT_MIN_TARGET_RANGE = 300
		BOAT_MAX_TARGET_RANGE = 40000
		BOAT_MAX_VEL = 1
		BOAT_TURN_THRESHOLD = 0.8
				
		cam_x = 18 * 128
		cam_y = 18 * 128
		scale_factor = 0.5
		
		gamestate = "Game"
	end,
	next_level = "end",
	win_loss_function = function()
		awake_count, dead_count, fish_count, enemy_count, area_count = count_sprite_stats()
		
		if awake_count == 0 then
			return "Loss"
		elseif enemy_count == 0 then
			return "Win"
		else
			return "Goal: Destroy "..(enemy_count).." more gunboats"
		end
	end}

levels["end"] = {
	title = "A friend for the end",
	message_stack = {"The last wave scattered us to the four winds again.",
		"They got me good; I'm pretty well done for.",
		"At the least . . . \n\n it'd be nice to see someone else before I go.",
	"Goal: \n Find someone else out there in the blue."},
	setup_function = function()
		setup_clean_level()
		
		sprites = addRaft(sprites, 200, 200)
		sprites = addRaftguy(sprites, sprites)
		
		sprites.food = 40
		sprites.state = "Active"
		
		for i = 0, 150 do
			sprites = addRaft(sprites, math.random(-5000, 5000), math.random(-5000, 5000))
			
		end
		
		for i = 0, 50 do
			sprites = addFish(sprites, math.random(-5000, 10000), math.random(-5000, 5000))
			sprites = addMine(sprites, math.random(-5000, 10000), math.random(-5000, 5000))
		end
		
		rad = math.random() * math.pi * 2
		sprites = addRaft(sprites, math.cos(rad) * 4500, math.sin(rad) * 4500)
		
		sprites = addRaftguy(sprites, sprites)
		
		cam_x = 0
		cam_y = 0
		scale_factor = 0.75
		
		gamestate = "Game"
	end,
	next_level = "end",
	win_loss_function = function()
		awake_count, dead_count, fish_count, enemy_count, area_count = count_sprite_stats()
		
		if awake_count == 0 then
			return "Loss"
		elseif dead_count == 1 and awake_count == 1 then
			fin_timer = ticks
			return "Fin"
		else
			return "Goal: Find someone."
		end
	end}


	