package Camera

import config_pkg "../config"
import rl "vendor:raylib"

init :: proc(camera: ^rl.Camera2D, target: rl.Vector2) {
	camera.offset = {config_pkg.SCREEN_WIDTH / 2, config_pkg.SCREEN_HEIGHT / 2}
	camera.zoom = 1
	camera.target = target
}

update :: proc(camera: ^rl.Camera2D, target: rl.Vector2) {
	camera.target = target
}
