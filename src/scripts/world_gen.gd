extends Node

var noise = OpenSimplexNoise.new()
onready var sed = floor(rand_range(-2147483648, 2147483648))
var max_height = 10

func init(max_height, sed):
	self.max_height = max_height
	self.sed = sed
	noise.seed = sed
	
func check_position ( coords: Vector3 ) -> bool:
	var noise_value = noise.get_noise_2d(coords.x, coords.z) + 1 # 0-2
	var lvl_check = floor((noise_value * max_height) / 2)
	if ( lvl_check >= coords.y ): return true
	else: return false
	
func _ready():
	randomize()
	noise.seed = sed
	noise.octaves = 4
	noise.period = 150.0
	noise.persistence = 20
	pass
