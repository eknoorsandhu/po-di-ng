package game

import rl "vendor:raylib"
import "core:fmt"
import "core:net"


main :: proc() {
	config := defaultConfig()

	rl.InitWindow(
		i32(config.window_w),
		i32(config.window_h),
		"pong",
	)
	defer rl.CloseWindow()

	state := defaultState(config)

	fmt.println(state)

	for !rl.WindowShouldClose() {
		dt := rl.GetFrameTime()

		handleInput(&state, config, dt)
		updatePhysics(&state, config, dt)
		drawGame(&state, config)
	}
}

test :: proc() {
	sock, err := net.make_bound_udp_socket(net.IP4_Any, 9000)

	if err != nil {
		fmt.println("no sock for you: ", err)
		return
	}

	buffer: [1000]byte

	for {
		n, client, err := net.recv_udp(sock, buffer[:])

		if err != nil {
			fmt.println("udp err: ", err)
		}

		fmt.println(client.address, ": ", string(buffer[:n]))
	}
}
