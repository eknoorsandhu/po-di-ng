package game

import rl "vendor:raylib"
import "core:fmt"
import "core:os"


main :: proc() {
	config := defaultConfig()
	mode := ""
	if len(os.args) > 1 { mode = os.args[1] }
	if !((mode == "" && len(os.args) == 1) ||
	     (mode == "host" && len(os.args) == 2) ||
	     (mode == "join" && len(os.args) == 3)) {
		fmt.println("usage: poding [host|join <host-ip>]")
		os.exit(1)
	}

	connection: game_connection
	if mode != "" {
		address := ""
		if mode == "join" { address = os.args[2] }
		ok: bool
		connection, ok = openConnection(mode == "host", address)
		if !ok { os.exit(1) }
	}
	defer closeConnection(&connection)

	title: cstring = "pong"
	if mode == "host" { title = "pong - host" }
	if mode == "join" { title = "pong - join" }

	rl.SetConfigFlags({.WINDOW_ALWAYS_RUN})

	rl.InitWindow(
		i32(config.window_w),
		i32(config.window_h),
		title,
	)
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)

	state := defaultState(config)

	for !rl.WindowShouldClose() {
		dt := min(rl.GetFrameTime(), 0.1)

		input := readInput(mode)
		status: cstring = ""
		if mode == "" {
			handleInput(&state, config, dt, input)
			updatePhysics(&state, config, dt)
		} else {
			receiveGame(&connection, &state)
			if connection.connected {
				if connection.host {
					input.right = connection.remote.right
					input.start = input.start || connection.remote.start
					connection.remote.start = false
					handleInput(&state, config, dt, input)
					updatePhysics(&state, config, dt)
				}
				sendGame(&connection, state, input)
			}

			if connection.waiting {
				status = "waiting for the other game on port 9000"
			} else if connection.disconnected {
				status = "disconnected. restart both games"
			} else if connection.host {
				status = "host - connected - W / S"
			} else {
				status = "joined - connected - UP / DOWN"
			}
		}
		drawGame(&state, config, status)
	}
}

