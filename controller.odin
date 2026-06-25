package game
import rl "vendor:raylib"

readInput :: proc(mode: string) -> game_input {
    input: game_input
    if !rl.IsWindowFocused() { return input }
    if mode != "join" {
        if rl.IsKeyDown(.W) { input.left -= 1 }
        if rl.IsKeyDown(.S) { input.left += 1 }
    }
    if mode != "host" {
        if rl.IsKeyDown(.UP) { input.right -= 1 }
        if rl.IsKeyDown(.DOWN) { input.right += 1 }
    }
    input.start = rl.IsKeyPressed(.SPACE)
    return input
}

handleInput :: proc(state: ^game_state, config: game_config, dt: f32, input: game_input) {
    if input.start {
        if state.screen != .play {
            state^ = defaultState(config)
            state.screen = .play
        }

        if state.pong_vel.x == 0 {
            state.pong_vel = rl.Vector2{X_VEL * state.serve_dir, Y_VEL * 0.3}
        }
    }

    if state.screen != .play { return }

    state.left_paddle.y = clamp(
        state.left_paddle.y + input.left * config.paddle_speed * dt,
        0, config.window_h - config.paddle_h,
    )
    state.right_paddle.y = clamp(
        state.right_paddle.y + input.right * config.paddle_speed * dt,
        0, config.window_h - config.paddle_h,
    )
}