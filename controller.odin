package game
import rl "vendor:raylib"

handleInput :: proc(state: ^game_state, config: game_config, dt: f32){
    if rl.IsKeyDown(.LEFT) {
		state.pong_vel.x = -1 * X_VEL
    } else if rl.IsKeyDown(.RIGHT) {
        state.pong_vel.x = X_VEL
    }

    if rl.IsKeyDown(.UP) {
        state.left_paddle.y -= config.paddle_speed * dt
        state.right_paddle.y -= config.paddle_speed * dt
    }

    if rl.IsKeyDown(.DOWN) {
        state.left_paddle.y += config.paddle_speed * dt
        state.right_paddle.y += config.paddle_speed * dt
    }
}