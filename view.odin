package game

import rl "vendor:raylib"

drawGame :: proc(state: ^game_state, config: game_config, status: cstring) {
	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)

	rl.DrawCircleV(state.pong_pos, config.pong_rad, rl.WHITE)
	rl.DrawRectangleRec(state.left_paddle, rl.WHITE)
	rl.DrawRectangleRec(state.right_paddle, rl.WHITE)

	rl.DrawText(rl.TextFormat("%i    %i", i32(state.left_score), i32(state.right_score)), 540, 30, 40, rl.WHITE)
	rl.DrawText(status, 340, 100, 24, rl.GRAY)

	switch state.screen {
	case .start:
		drawStartScreen()
	case .play:
		if state.pong_vel.x == 0 {
			rl.DrawText("space to serve", 480, 430, 30, rl.WHITE)
		}
	case .end:
		winner: cstring = "right wins"
		if state.left_score == WIN_SCORE { winner = "left wins" }
		rl.DrawText(winner, 500, 270, 40, rl.WHITE)
		rl.DrawText("space to play again", 430, 430, 30, rl.WHITE)
	}

	rl.DrawText("W / S                         UP / DOWN", 350, 670, 24, rl.GRAY)
	rl.EndDrawing()
}

drawStartScreen :: proc() {
	rl.DrawText("PO(DI)NG", 480, 250, 50, rl.WHITE)
	rl.DrawText("space to play. first to 7", 380, 430, 30, rl.WHITE)
}
