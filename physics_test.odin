package game

import "core:testing"
import rl "vendor:raylib"

@(test)
paddleCollision :: proc(t: ^testing.T) {
    config := defaultConfig()
    state := defaultState(config)
    state.screen = .play
    state.pong_pos = rl.Vector2{100, state.left_paddle.y + 25}
    state.pong_vel = rl.Vector2{-X_VEL, 0}

    updatePhysics(&state, config, 0.05)
    testing.expect(t, state.pong_vel.x > 0)
    testing.expect(t, state.pong_vel.y < 0)
    testing.expect(t, state.right_score == 0)
}

@(test)
wallCollision :: proc(t: ^testing.T) {
    config := defaultConfig()
    state := defaultState(config)
    state.screen = .play
    state.pong_pos.y = config.pong_rad + 1
    state.pong_vel = rl.Vector2{X_VEL, -Y_VEL}

    updatePhysics(&state, config, 0.02)
    testing.expect(t, state.pong_vel.y > 0)
    testing.expect(t, state.pong_pos.y >= config.pong_rad)
    updatePhysics(&state, config, 0.001)
    testing.expect(t, state.pong_vel.y > 0)
}

@(test)
scoreAndRestart :: proc(t: ^testing.T) {
    config := defaultConfig()
    state := defaultState(config)
    state.screen = .play
    state.left_score = WIN_SCORE - 1
    state.pong_pos = rl.Vector2{config.window_w + config.pong_rad - 1, 20}
    state.pong_vel = rl.Vector2{X_VEL, 0}

    updatePhysics(&state, config, 0.02)
    testing.expect(t, state.left_score == WIN_SCORE)
    testing.expect(t, state.screen == .end)
    testing.expect(t, state.pong_vel == rl.Vector2{})
    updatePhysics(&state, config, 0.1)
    testing.expect(t, state.left_score == WIN_SCORE)

    handleInput(&state, config, 0, game_input{start = true})
    testing.expect(t, state.screen == .play)
    testing.expect(t, state.left_score == 0 && state.right_score == 0)
    testing.expect(t, state.pong_vel.x != 0)
}

@(test)
separatePaddles :: proc(t: ^testing.T) {
    config := defaultConfig()
    state := defaultState(config)
    state.screen = .play
    right_y := state.right_paddle.y

    handleInput(&state, config, 1, game_input{left = -1})
    testing.expect(t, state.left_paddle.y == 0)
    testing.expect(t, state.right_paddle.y == right_y)
    handleInput(&state, config, 1, game_input{right = 1})
    testing.expect(t, state.right_paddle.y == config.window_h - config.paddle_h)
    testing.expect(t, state.left_paddle.y == 0)
}
