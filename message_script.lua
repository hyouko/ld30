
intro_stack = {"I was born on a raft.  I grew up on a raft.  And after that last storm, I'll likely die on a raft.",
	"Unless...",
	"Unless I can find the other members of my flotilla and tie up with them.  Together again, we might stand a chance...",
	"Mouse controls (click+drag):\n[LMB] Move active member\n [RMB] Attach nearby raft\n[LMB+RMB] Release ropes\n\nHow to play:\n-Catch fish to regain health\n-Find other rafts and join forces\n-Avoid enemy boats and sea mines "}

post_message = {}

post_message[intro_stack] = function()
	setup_sandbox()
	gamestate = "Game"
end


	