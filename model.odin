package game

import rl "vendor:raylib"


// constants
X_VEL: f32 = 2000
Y_VEL: f32 = 2000

WINDOW_W: f32 = 1280
WINDOW_H: f32 = 720
WIN_SCORE :: 7

Screen :: enum {
    start,
    play,
    end
}

game_config :: struct {
    window_h: f32,
    window_w: f32,

    paddle_speed: f32,

    paddle_w: f32,
    paddle_h: f32,

    pong_rad: f32,
}

game_state :: struct {
    pong_pos: rl.Vector2,
    pong_vel: rl.Vector2,

    left_paddle: rl.Rectangle,
    right_paddle: rl.Rectangle,

    left_score: int,
    right_score: int,

    serve_dir: f32,
    screen: Screen,
}

game_input :: struct {
    left: f32,
    right: f32,
    start: bool,
}

defaultConfig :: proc () -> game_config {
    return game_config {
        window_w = WINDOW_W,
        window_h = WINDOW_H,

        paddle_speed = 1700,

        paddle_w = 30,
        paddle_h = 125,

        pong_rad = 12,
    }
}

defaultState :: proc (config: game_config) -> game_state {
    return game_state {
        pong_pos = rl.Vector2{config.window_w / 2, config.window_h / 2},
        pong_vel = rl.Vector2{0, 0},

        left_paddle = rl.Rectangle{0, (config.window_h - config.paddle_h) / 2, config.paddle_w, config.paddle_h},
        right_paddle = rl.Rectangle {
            config.window_w - config.paddle_w,
            (config.window_h - config.paddle_h) / 2,
            config.paddle_w,
            config.paddle_h,
        },
        serve_dir = 1,
    }
}

