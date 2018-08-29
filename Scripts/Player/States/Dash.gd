extends "res://Scripts/State.gd"

const COST = 25
const SPEED = 1250

var can_dash = true

onready var dash_timer = $"../../Timers/Dash"
onready var dash_wait_timer = $"../../Timers/DashWait"

func _on_dash_timer_timeout():
	host.on_animation_finished("")
	dash_wait_timer.start()
	host.set_collision_layer_bit(1, true)

func _on_dash_wait_timer_timeout():
	can_dash = true

func _ready():
	dash_timer.connect("timeout", self, "_on_dash_timer_timeout")
	dash_wait_timer.connect("timeout", self, "_on_dash_wait_timer_timeout")

func enter():
	if host.has_stamina(COST) and can_dash:
		host.change_sprite("Dash")
		host.animations.stop()
		host.velocity.x = -SPEED if host.facing_left else SPEED
		can_dash = false
		dash_timer.start()
		host.alter_stamina(-COST)
		host.play_sound("Dash")
		host.set_collision_layer_bit(1, false)
	else:
		host.change_state("Previous")