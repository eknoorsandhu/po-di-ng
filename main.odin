package game

import rl "vendor:raylib"

main :: proc() {
    rl.InitWindow(1280, 720, "pong")
    rect_pos := rl.Vector2 {640, 310}
    PIXELS_PER_S: f32 = 500

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLUE)

        if rl.IsKeyDown(.LEFT){
            rect_pos.x -= PIXELS_PER_S*rl.GetFrameTime()
        }

        if rl.IsKeyDown(.RIGHT){
            rect_pos.x += PIXELS_PER_S*rl.GetFrameTime()
        }

        if rl.IsKeyDown(.UP) {
            rect_pos.y -= PIXELS_PER_S*rl.GetFrameTime()
        }

        if rl.IsKeyDown(.DOWN) {
            rect_pos.y += PIXELS_PER_S*rl.GetFrameTime()
        }

        rl.DrawRectangleV(rect_pos, {64, 64}, rl.RED)

        rl.EndDrawing()
    }

    rl.CloseWindow()
}