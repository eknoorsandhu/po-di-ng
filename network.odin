package game

import "core:fmt"
import "core:net"


game_packet :: struct {
    state: game_state,
    input: game_input,
}

game_connection :: struct {
    socket: net.TCP_Socket,
    listener: net.TCP_Socket,
    host: bool,
    waiting: bool,
    connected: bool,
    disconnected: bool,

    incoming: game_packet,
    outgoing: game_packet,
    received: int,
    sent: int,
    sending: bool,
    start: bool,
    remote: game_input,
}

openConnection :: proc(host: bool, address: string) -> (game_connection, bool) {
    connection := game_connection{host = host}
    socket: net.TCP_Socket
    err: net.Network_Error

    if host {
        socket, err = net.listen_tcp(net.Endpoint{net.IP4_Any, 9000}, 1)
    } else {
        socket, err = net.dial_tcp(address, 9000, net.TCP_Options{no_delay = true})
    }

    if err != nil {
        fmt.println("no connection for you: ", err)
        return connection, false
    }

    if blocking_err := net.set_blocking(socket, false); blocking_err != nil {
        fmt.println("socket err: ", blocking_err)
        net.close(socket)
        return connection, false
    }

    if host {
        connection.listener = socket
        connection.waiting = true
        fmt.println("waiting on port 9000")
    } else {
        connection.socket = socket
        connection.connected = true
        fmt.println("joined")
    }
    return connection, true
}

closeConnection :: proc(connection: ^game_connection) {
    if connection.waiting {
        net.close(connection.listener)
        connection.waiting = false
    }
    if connection.connected {
        net.close(connection.socket)
        connection.connected = false
    }
}

disconnect :: proc(connection: ^game_connection) {
    closeConnection(connection)
    connection.disconnected = true
    fmt.println("disconnected. restart both games to play again")
}

receiveGame :: proc(connection: ^game_connection, state: ^game_state) {
    if connection.waiting {
        socket, _, err := net.accept_tcp(connection.listener, net.TCP_Options{no_delay = true})
        if err == .Would_Block || err == .Interrupted { return }
        if err != nil {
            fmt.println("accept err: ", err)
            disconnect(connection)
            return
        }
        if blocking_err := net.set_blocking(socket, false); blocking_err != nil {
            fmt.println("socket err: ", blocking_err)
            net.close(socket)
            disconnect(connection)
            return
        }
        net.close(connection.listener)
        connection.waiting = false
        connection.socket = socket
        connection.connected = true
        fmt.println("connected")
    }
    if !connection.connected { return }

    // tcp can split a packet across reads
    buffer := ([^]byte)(&connection.incoming)[:size_of(game_packet)]
    for _ in 0..<8 {
        n, err := net.recv_tcp(connection.socket, buffer[connection.received:])
        connection.received += n
        if err == .Would_Block || err == .Interrupted { return }
        if err != nil || n == 0 {
            disconnect(connection)
            return
        }
        if connection.received == len(buffer) {
            if connection.host {
                connection.remote.right = clamp(connection.incoming.input.right, -1, 1)
                connection.remote.start = connection.remote.start || connection.incoming.input.start
            } else {
                state^ = connection.incoming.state
            }
            connection.received = 0
        }
    }
}

sendGame :: proc(connection: ^game_connection, state: game_state, input: game_input) {
    if !connection.connected { return }
    connection.start = connection.start || input.start

    if !connection.sending {
        connection.outgoing = game_packet{state = state, input = input}
        connection.outgoing.input.start = connection.start
        connection.start = false
        connection.sent = 0
        connection.sending = true
    }

    buffer := ([^]byte)(&connection.outgoing)[:size_of(game_packet)]
    n, err := net.send_tcp(connection.socket, buffer[connection.sent:])
    connection.sent += n
    if err != nil && err != .Would_Block && err != .Interrupted {
        disconnect(connection)
        return
    }
    if connection.sent == len(buffer) {
        connection.sending = false
    }
}
