package animation

import rl "vendor:raylib"

Animation :: struct {
	x:             int,
	y:             int,
	frame_current: int,
	frame_width:   int,
	frame_height:  int,
	flipped:       bool,
	num_frames:    int,
	texture:       rl.Texture2D,
	rectangle:     rl.Rectangle,
	frame_time:    f32,
	timer:         f32,
}

init :: proc(
	anim: ^Animation,
	texture: rl.Texture2D,
	x: int,
	y: int,
	frame_width: int,
	frame_height: int,
	num_frames: int,
	frame_time: f32,
) {
	anim.x = x
	anim.y = y
	anim.frame_width = frame_width
	anim.frame_height = frame_height
	anim.num_frames = num_frames
	anim.frame_time = frame_time
	anim.texture = texture
}

update :: proc(anim: ^Animation) {

	//update frame
	anim.timer += rl.GetFrameTime()

	if anim.timer > anim.frame_time {
		anim.frame_current += 1
		anim.timer = 0

		if anim.frame_current >= anim.num_frames {
			anim.frame_current = 0
		}
	}

	anim.rectangle = {
		x      = f32(anim.x + anim.frame_current) * f32(anim.frame_width),
		y      = f32(anim.y * anim.frame_height),
		width  = anim.flipped ? -f32(anim.frame_width) : f32(anim.frame_width),
		height = f32(anim.frame_height),
	}
}

reset :: proc(anim: ^Animation, flipped: bool) {
	anim.timer = 0
	anim.frame_current = 0
	anim.flipped = flipped
}
