package game

import rl "vendor:raylib"


// constants
X_VEL: f32 = 2000
Y_VEL: f32 = 2000

WINDOW_W: f32 = 1280
WINDOW_H: f32 = 720


game_config :: struct {
    window_h: f32,
    window_w: f32,

    paddle_speed: f32,

    paddle_w: f32,
    paddle_h: f32,

    pong_rad: f32,

    top_left: rl.Vector2,
	top_right: rl.Vector2,
	bot_left: rl.Vector2,
	bot_right: rl.Vector2,
}

game_state :: struct {
    pong_pos: rl.Vector2,
    pong_vel: rl.Vector2,

    left_paddle: rl.Rectangle,
    right_paddle: rl.Rectangle
}

defaultConfig :: proc () -> game_config {
    return game_config {
        window_w = WINDOW_W,
        window_h = WINDOW_H,

        paddle_speed = 1700,

        paddle_w = 30,
        paddle_h = 125,

        pong_rad = 12,

	    top_left = rl.Vector2{0, 0},
        top_right = rl.Vector2{WINDOW_W, 0},
	    bot_left = rl.Vector2{0, WINDOW_H},
	    bot_right = rl.Vector2{WINDOW_W, WINDOW_H}
    }
}

defaultState :: proc (config: game_config) -> game_state {
    return game_state {
        pong_pos = rl.Vector2{640, 310},
        pong_vel = rl.Vector2{0, 0},

        left_paddle = rl.Rectangle{0, WINDOW_H / 2, config.paddle_w, config.paddle_h},
        right_paddle = rl.Rectangle {
            WINDOW_W - config.paddle_w,
            WINDOW_H / 2,
            config.paddle_w,
            config.paddle_h,
        }
    }
}

