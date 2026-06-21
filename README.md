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

then in two terminals on the same laptop:

```sh
./poding host
```

```sh
./poding join
```

start the host first. it waits for the second game on 127.0.0.1:9000 (tcp).
same controls, just keep either game window focused. both paddles work from
either window since we're sharing a keyboard anyway. the host does the physics
and sends the ball, paddles and score to the other game.

use the same build for both. no accounts, lobby or anything.
if one game closes, restart both to connect again.

## tests

```sh
odin test .
```