extends Node

var world_gen = preload("res://src/scenes/world_gen.tscn").instance()
onready var cube_cnt = $cubes
var sed 
	
func hollow_check ():
	for x in range(-10, 11):
		for y in range(0, 11):
			for z in range(-10, 11):
				if world_gen.check_position(Vector3(x, y, z)):
					var nbrs = 0
					for ad in [-1, 1]:
						if world_gen.check_position(Vector3(x + ad, y, z)): nbrs += 1
						if world_gen.check_position(Vector3(x, y + ad, z)): nbrs += 1
						if world_gen.check_position(Vector3(x, y, z + ad)): nbrs += 1
					if nbrs != 6: 
						var corner_array = []
						# The points must be in order..
						corner_array.push_back(Vector3(x - .5, y + .5, z - .5))
						corner_array.push_back(Vector3(x + .5, y + .5, z - .5))
						corner_array.push_back(Vector3(x + .5, y + .5, z + .5))
						corner_array.push_back(Vector3(x - .5, y + .5, z + .5))
						
						var tmpMesh = Mesh.new()
						var vertices = PoolVector3Array()
						var UVs = PoolVector2Array()
						var mat = SpatialMaterial.new()
						var txtr = preload("res://icon.png")
						mat.albedo_texture = txtr
						
						for point in corner_array:
							vertices.push_back(point)
							UVs.push_back(Vector2(point.x, point.z))
						var st = SurfaceTool.new()
						st.begin(Mesh.PRIMITIVE_TRIANGLE_FAN)
						for v in vertices.size():
							
							st.add_uv(UVs[v])
							st.add_vertex(vertices[v])
						st.commit(tmpMesh)
						var m = MeshInstance.new()
						m.mesh = tmpMesh
						m.material_override = mat
#						m.translate(Vector3(x, y, z))
						cube_cnt.add_child(m)

func _ready():
	randomize()
	sed = floor(rand_range(-2147483648, 2147483648))
	world_gen.init(10, sed)
	hollow_check()
	pass
	
func _process(delta):
	if Input.is_action_pressed("ui_left"):
		cube_cnt.rotate(Vector3.UP, -PI/100)
	if Input.is_action_pressed("ui_right"):
		cube_cnt.rotate(Vector3.UP, PI/100)
