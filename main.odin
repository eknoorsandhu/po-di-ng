package game

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

// constants
X_VEL: f32 = 2000
Y_VEL: f32 = 2000


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

	return rl.Vector2{
		X_VEL * x_comp * x_dir,
		Y_VEL * y_comp,
	}
}


main :: proc() {
	rl.InitWindow(1280, 720, "pong")


	PIXELS_PER_S: f32 = 1700 // amount of pixels obj moves /s

	RECT_W: f32 = 30
	RECT_H: f32 = 125

	PONG_RAD: f32 = 10

	TOP_LEFT := rl.Vector2{0, 0}
	TOP_RIGHT := rl.Vector2{f32(rl.GetScreenWidth()), 0}
	BOT_LEFT := rl.Vector2{0, f32(rl.GetScreenHeight())}
	BOT_RIGHT := rl.Vector2{f32(rl.GetScreenWidth()), f32(rl.GetScreenHeight())}

	// game objects
	pong_pos := rl.Vector2{640, 310}
	left_rect := rl.Rectangle{0, f32(rl.GetScreenHeight() / 2), RECT_W, RECT_H}
	right_rect := rl.Rectangle {
		f32(rl.GetScreenWidth()) - RECT_W,
		f32(rl.GetScreenHeight() / 2),
		RECT_W,
		RECT_H,
	}

	pong_vel: rl.Vector2

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)

		if rl.IsKeyDown(.LEFT) {
			pong_vel.x = -1 * X_VEL
		} else if rl.IsKeyDown(.RIGHT) {
			pong_vel.x = X_VEL
		}

		if rl.IsKeyDown(.UP) {
			left_rect.y -= PIXELS_PER_S * rl.GetFrameTime()
			right_rect.y -= PIXELS_PER_S * rl.GetFrameTime()
		}


		if rl.IsKeyDown(.DOWN) {
			left_rect.y += PIXELS_PER_S * rl.GetFrameTime()
			right_rect.y += PIXELS_PER_S * rl.GetFrameTime()
		}

		if rl.CheckCollisionCircleRec(pong_pos, PONG_RAD, left_rect) {
			pong_vel = postCollisionVel(left_rect, pong_pos, pong_vel)

			// move ball to prevent double collision
			pong_pos.x = left_rect.width + PONG_RAD + 1
		} else if rl.CheckCollisionCircleRec(pong_pos, PONG_RAD, right_rect) {
			pong_vel = postCollisionVel(right_rect, pong_pos, pong_vel)
			
			// move ball to prevent double collision
			pong_pos.x = right_rect.x - PONG_RAD - 1
		}

		// pong hits top or bottom edge
		if rl.CheckCollisionCircleLine(pong_pos, PONG_RAD, TOP_LEFT, TOP_RIGHT) ||
		   rl.CheckCollisionCircleLine(pong_pos, PONG_RAD, BOT_LEFT, BOT_RIGHT) {
			pong_vel.y *= -1
		} else if rl.CheckCollisionCircleLine(pong_pos, PONG_RAD, TOP_LEFT, BOT_LEFT) ||
		   rl.CheckCollisionCircleLine(pong_pos, PONG_RAD, TOP_RIGHT, BOT_RIGHT) {
			pong_vel.x *= -1
		}

		pong_pos += pong_vel * rl.GetFrameTime()

		rl.DrawCircleV(pong_pos, PONG_RAD, rl.WHITE)

		rl.DrawRectangleRec(left_rect, rl.WHITE)

		rl.DrawRectangleRec(right_rect, rl.WHITE)


		rl.EndDrawing()
	}

	rl.CloseWindow()
}
