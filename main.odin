package game

import rl "vendor:raylib"


main :: proc() {
	config := defaultConfig()

	rl.InitWindow(
		i32(config.window_w),
		i32(config.window_h),
		"pong",
	)
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)

	state := defaultState(config)

	for !rl.WindowShouldClose() {
		dt := min(rl.GetFrameTime(), 0.1)

		input := readInput()
		handleInput(&state, config, dt, input)
		updatePhysics(&state, config, dt)
		drawGame(&state, config)
	}
}

