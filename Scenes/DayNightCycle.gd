extends CanvasModulate

const _Night_color = Color("122d30")
const _Day_color = Color("ffffff")
const _Time_scale = 0.0001

var time = 2

func _process(delta:float) -> void:
	self.time += delta * _Time_scale
	self.color = _Night_color.linear_interpolate(_Day_color, abs(sin(time)))
