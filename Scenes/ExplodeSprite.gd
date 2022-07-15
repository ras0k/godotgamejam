extends Particles2D

# https://github.com/PlayWithFurcifer/ExplodeSprite/blob/master/ExplodeSprite.gd

func _ready():
	one_shot = true
	emitting = false

# Sets the particle systems emission shape, the sprite texture and
# the amount of particles and starts the emission.
func initialize(sprite : Texture):
	process_material.set_shader_param("emission_box_extents",
		Vector3(sprite.get_width() / 2.0, sprite.get_height() / 2.0, 1))
	process_material.set_shader_param("sprite", sprite)
	amount = sprite.get_width() * sprite.get_height()
