package game
import "core:math"
import rl "vendor:raylib"


heightDiffToVecComponent :: proc(heightDiff: f32) -> (f32, f32) {
	// treats heightDiff as degrees. So collision 10 pixels from mid will send of at 10 degrees

	radians := f16(heightDiff * (math.PI / 180.0))

	return f32(math.cos(radians)), f32(math.sin(radians))

}

postCollisionVel :: proc(
	rect: rl.Rectangle,
	circle: rl.Vector2,
	cur_vel: rl.Vector2,
) -> rl.Vector2 {
	rect_mid := rect.y + (rect.height / 2)
	height_diff := rect_mid - circle.y

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

updatePhysics :: proc(state: ^game_state, config: game_config, dt: f32) {
	if rl.CheckCollisionCircleRec(state.pong_pos, config.pong_rad, state.left_paddle) {
		state.pong_vel = postCollisionVel(state.left_paddle, state.pong_pos, state.pong_vel)

		// move ball to prevent double collision
		state.pong_pos.x = state.left_paddle.width + config.pong_rad + 1
	} else if rl.CheckCollisionCircleRec(state.pong_pos, config.pong_rad, state.right_paddle) {
		state.pong_vel = postCollisionVel(state.right_paddle, state.pong_pos, state.pong_vel)

		// move ball to prevent double collision
		state.pong_pos.x = state.right_paddle.x - config.pong_rad - 1
	}

	// pong hits top or bottom edge
	if rl.CheckCollisionCircleLine(
		   state.pong_pos,
		   config.pong_rad,
		   config.top_left,
		   config.top_right,
	   ) ||
	   rl.CheckCollisionCircleLine(
		   state.pong_pos,
		   config.pong_rad,
		   config.bot_left,
		   config.bot_right,
	   ) {
		state.pong_vel.y *= -1
	} else if rl.CheckCollisionCircleLine(
		   state.pong_pos,
		   config.pong_rad,
		   config.top_left,
		   config.bot_left,
	   ) ||
	   rl.CheckCollisionCircleLine(
		   state.pong_pos,
		   config.pong_rad,
		   config.top_right,
		   config.bot_right,
	   ) {
		state.pong_vel.x *= -1
	}

	state.pong_pos += state.pong_vel * dt
}
