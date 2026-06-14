package game
import "core:math"
import rl "vendor:raylib"


heightDiffToVecComponent :: proc(heightDiff: f32) -> (f32, f32) {
	// treats heightDiff as degrees. So collision 10 pixels from mid will send of at 10 degrees

	radians := heightDiff * (math.PI / 180.0)

	return f32(math.cos(radians)), f32(math.sin(radians))

}

postCollisionVel :: proc(
	rect: rl.Rectangle,
	circle: rl.Vector2,
	cur_vel: rl.Vector2,
) -> rl.Vector2 {
	rect_mid := rect.y + (rect.height / 2)
	height_diff := clamp(circle.y - rect_mid, -60, 60)

	x_dir: f32

	// flip ball dir
	if cur_vel.x < 0 {
		x_dir = 1
	} else {
		x_dir = -1
	}

	if abs(height_diff) < 2.5 {
		// simple reflection
		return rl.Vector2{X_VEL * x_dir, cur_vel.y}
	}

	x_comp, y_comp := heightDiffToVecComponent(height_diff)

	return rl.Vector2{X_VEL * x_comp * x_dir, Y_VEL * y_comp}
}

resetBall :: proc(state: ^game_state, config: game_config, direction: f32) {
	state.pong_pos = rl.Vector2{config.window_w / 2, config.window_h / 2}
	state.pong_vel = rl.Vector2{}
	state.serve_dir = direction

	if state.left_score == WIN_SCORE || state.right_score == WIN_SCORE {
		state.screen = .end
	}
}

updatePhysics :: proc(state: ^game_state, config: game_config, dt: f32) {
	if state.screen != .play { return }

	// small steps so the ball doesn't skip a paddle
	remaining := min(dt, 0.1)
	for remaining > 0 {
		step := min(remaining, 1.0 / 240.0)
		remaining -= step
		state.pong_pos += state.pong_vel * step

		if state.pong_vel.x < 0 &&
		   rl.CheckCollisionCircleRec(state.pong_pos, config.pong_rad, state.left_paddle) {
			state.pong_vel = postCollisionVel(state.left_paddle, state.pong_pos, state.pong_vel)

			// move ball to prevent double collision
			state.pong_pos.x = state.left_paddle.width + config.pong_rad + 1
		} else if state.pong_vel.x > 0 &&
		          rl.CheckCollisionCircleRec(state.pong_pos, config.pong_rad, state.right_paddle) {
			state.pong_vel = postCollisionVel(state.right_paddle, state.pong_pos, state.pong_vel)

			// move ball to prevent double collision
			state.pong_pos.x = state.right_paddle.x - config.pong_rad - 1
		}

		// pong hits top or bottom edge
		if state.pong_pos.y < config.pong_rad {
			state.pong_pos.y = config.pong_rad
			state.pong_vel.y = abs(state.pong_vel.y)
		} else if state.pong_pos.y > config.window_h - config.pong_rad {
			state.pong_pos.y = config.window_h - config.pong_rad
			state.pong_vel.y = -abs(state.pong_vel.y)
		}

		if state.pong_pos.x < -config.pong_rad {
			state.right_score += 1
			resetBall(state, config, -1)
			return
		} else if state.pong_pos.x > config.window_w + config.pong_rad {
			state.left_score += 1
			resetBall(state, config, 1)
			return
		}
	}
}
