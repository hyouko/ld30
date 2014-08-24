init_stats = {}

levels = {}

levels["tutorial_1"] = {
	message_stack = {"Ugh.  I'm lucky to be alive... but I won't be for long if I don't get some food in me.",
		"There's a fish pen just over there.  Drag me over with the [left mouse button].  I have just enough strength left to haul away the rafts on the boundary with the [right mouse button.]",
		"Goal: \n\n Grab a few fish from the fish pen!"},
	setup_function = function()
		setup_clean_level()
		load_level("tutorial_1")
		cam_x = 0
		cam_y = 0
		harm_raftguys(true, 40)
		
		awake_count, dead_count, fish_count, enemy_count = count_sprite_stats()
		
		init_stats["fish_count"] = fish_count
		
		gamestate = "Game"
	end,
	next_level = "tutorial_2",
	win_loss_function = function()
		awake_count, dead_count, fish_count, enemy_count = count_sprite_stats()
		
		if dead_count == 1 then
			return "Loss"
		elseif fish_count <= 1 then
			return "Win"
		else
			return "Goal: Catch "..(fish_count - 1).." more fish"
		end
	end}

levels["tutorial_2"] = {
	message_stack = {"I've found a few of my friends... but they wound up in the middle of a mine field!",
		"I'll have to ease my way in gently and wake them up with ropes using the [right mouse button].  Might be a good idea to let go afterward by pressing [both mouse buttons]... don't want to cause a chain reaction!",
		"Goal: \n\n Wake up 3 other raft-folk!"},
	setup_function = function()
		setup_clean_level()
		load_level("tutorial_2")
		cam_x = 0
		cam_y = 0
		
		awake_count, dead_count, fish_count, enemy_count = count_sprite_stats()
				
		gamestate = "Game"
	end,
	next_level = "tutorial_3",
	win_loss_function = function()
		awake_count, dead_count, fish_count, enemy_count = count_sprite_stats()
		
		if dead_count == 1 then
			return "Loss"
		elseif awake_count >= 4 then
			return "Win"
		else
			return "Goal: Wake up "..(4 - awake_count).." more raft-folk"
		end
	end}

levels["level_1"] = {
	message_stack = {"I was born on a raft.  I grew up on a raft.  And after that last storm, I'll likely die on a raft.",
	"Unless...",
	"Unless I can find the other members of my flotilla and tie up with them.  Together again, we might stand a chance...",
	"Mouse controls (click+drag):\n[LMB] Move active member\n [RMB] Attach nearby raft\n[LMB+RMB] Release ropes\n\nHow to play:\n-Catch fish to regain health\n-Find other rafts and join forces\n-Avoid enemy boats and sea mines",
	"Goal: \n Save 4 other raft-folk!"},
	setup_function = function()
		setup_clean_level()
		
		load_level("test")
		
		BOAT_MIN_TARGET_RANGE = 300
		BOAT_MAX_TARGET_RANGE = 800
		
		awake_count, dead_count, fish_count, enemy_count = count_sprite_stats()
		
		init_stats["fish_count"] = fish_count
				
		cam_x = 0
		cam_y = 0
		
		gamestate = "Game"
	end,
	next_level = "level_2",
	win_loss_function = function()
		awake_count, dead_count, fish_count, enemy_count = count_sprite_stats()
		
		if dead_count == 2 then
			return "Loss"
		elseif awake_count >= 5 then
			return "Win"
		else
			return "Goal: Wake up "..(5 - awake_count).." more raft-folk"
		end
	end}


	