extends ReferenceRect

export var offset = 20
var _answers = [];
var _selected = 0 setget , get_selected

func add_answer(answer):
	var answer_node =  create_answer_node(answer)
	_answers.append(answer_node)

func move_selected(amount):
	if is_empty():
		return
	deselect(_selected)
	_selected = (_selected + amount) % _answers.size()
	if _selected < 0:
		_selected += _answers.size()
	select(_selected)
	print(str(_selected))

func get_selected():
	return _selected;

func is_empty():
	return _answers.empty();

func clear_answers():
	for answer in _answers:
		answer.queue_free()
	_answers.clear()
	_selected = 0

# Methods that should be changed if we use something other than simple label
func create_answer_node(answer):
	var label = Label.new()
	add_child(label)
	label.rect_position.y += offset * _answers.size()
	label.text = answer["text"]
	return label
	
func deselect(answer_id):
	var label = _answers[answer_id]
	label.add_color_override("font_color", Color.white)
	
func select(answer_id):
	var label = _answers[answer_id]
	label.add_color_override("font_color", Color.dimgray)
