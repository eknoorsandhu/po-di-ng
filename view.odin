package game

import rl "vendor:raylib"

drawGame :: proc(state: ^game_state, config: game_config) {
	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)

	rl.DrawCircleV(state.pong_pos, config.pong_rad, rl.WHITE)
	rl.DrawRectangleRec(state.left_paddle, rl.WHITE)
	rl.DrawRectangleRec(state.right_paddle, rl.WHITE)

	rl.EndDrawing()
}
