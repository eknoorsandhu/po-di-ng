# PO(DI)NG

https://www.youtube.com/watch?v=BFxndyX0GhM

pong in odin + raylib

## run

install odin, then:

```sh
odin run .
```

W / S for the left paddle, up / down for the right.
space to start and serve after a point. first to 7 wins.
space again to play another game, esc to quit.

## two windows

build once:

```sh
odin build .
```

then on the host:

```sh
./poding host
```

on the other laptop (replace the ip with the host's wifi ip):

```sh
./poding join 192.168.1.10
```

start the host first. host uses W / S, joining player uses up / down.
space works in either window to start, serve or play again.
the host does the physics and sends the ball, paddles and score over tcp.

both laptops need to be on the same network. allow tcp port 9000 through the
host's firewall. guest wifi with client isolation won't work.
for two windows on one laptop use `./poding join 127.0.0.1` and switch focus.

use the same build for both (same os/architecture). no accounts, lobby or anything.
if one game closes, restart both to connect again.

## tests

```sh
odin test .
```