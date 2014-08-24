
intro_stack = {"I was born on a raft.  I grew up on a raft.  And after that last storm, I'll likely die on a raft.",
	"Unless...",
	"Unless I can find the other members of my flotilla and tie up with them.  Together again, we might stand a chance...",
	"Mouse controls (click+drag):\n[LMB] Move active member\n [RMB] Attach nearby raft\n[LMB+RMB] Release ropes\n\nHow to play:\n-Catch fish to regain health\n-Find other rafts and join forces\n-Avoid enemy boats and sea mines "}

lvl_1_stack = {"Testing level load implementation, hold on to your hat-like objects!"}

post_message = {}

post_message[intro_stack] = function()
	setup_clean_level()
	setup_sandbox()
	gamestate = "Game"
end

post_message[lvl_1_stack] = function()
	setup_clean_level()
	
	load_level("test")
	
	BOAT_MIN_TARGET_RANGE = 300
	BOAT_MAX_TARGET_RANGE = 800
	
	cam_x = 0
	cam_y = 0
	
	gamestate = "Game"
	
end

	