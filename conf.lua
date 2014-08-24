function love.conf(t)
    t.window.width = 1024
    t.window.height = 768
	t.window.title = "Ludum Dare 30 (Connected Worlds) - Drift"
	
end

scale_factor = 0.5


-- Debug toggles
debug_on = false
rope_debug = false
boat_debug = false

function set_default_constants()
	-- Rope constants
	ROPE_MAX_LENGTH = 400

	-- Bullet constants
	BULLET_LIFESPAN = 0.75
	BULLET_VEL = 20
	BULLET_DAMAGE = 10
	BULLET_IMPACT = 4

	-- Fish constants
	FISH_FOOD_VAL = 25.0
	FISH_SHARE_VAL = 5.0
	FISH_MAX_VEL = 2

	-- Raft constants
	RAFT_DECEL = 0.98
	RAFT_TURN = 0.9
	RAFT_TURN_THRESHOLD = 1.5
	RAFT_MAX_VEL = 8
	RAFT_FIRE_DELAY = 3

	-- Raftguy constants
	FOOD_LOSS_RATE = 0.25
	FOOD_LOSS_MOVE_RATE = 0.5

	-- Boat constants (mostly the same as raft constants...)
	BOAT_DECEL = 0.98
	BOAT_ACCEL = 0.05
	BOAT_TURN = 0.9
	BOAT_TURN_THRESHOLD = 1.5
	BOAT_MAX_VEL = 8
	BOAT_MIN_TARGET_RANGE = 300
	BOAT_MAX_TARGET_RANGE = 4000
	BOAT_FIRE_DELAY = 2
	BOAT_MAX_HEALTH = 50

	SHOW_WAKE = true
	WAKE_LIFESPAN = 1
	WAKE_DELAY = 0.25

	MINE_BOUNCE_VEL = 8
	MINE_DAMAGE = 20
end
