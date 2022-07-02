extends Node2D

var _current_id = -1; 

var _data = {};
var _status = {};

signal item_changed(item_name, amount)

func _ready():
	$TextBox.hide()
	_data = {
		"start": 0,
		"status": {
			"test_status": false
		},
		"entries" : [
			{
				"text": "This is entry 0",
				"speaker": "Number 0",
				"next": 1
			},
			{
				"text": "And this is entry 1",
				"speaker": get_name(),
				"next": 3
			},
			{
				"text": "And this is 2. It also has a different speaker",
				"speaker": "Number 2",
				"next": -1
			},
			{
				"text": "They can even be out of order. This is 3\nThis also gives 2 \"Berry\" items",
				"speaker": "Number 0",
				"next": 4,
				"items": {
					"Berry": 2
				}
			},
			{
				"text": "Choose your path",
				"speaker": "Path chooser",
				"answers": [
					{
						"conditions": [],
						"text": "Option 1",
						"next": 2
					},
					{
						"conditions": [],
						"text": "Exit Now",
						"next": -1
					},
					{
						"conditions": [],
						"text": "Set Status",
						"next": 5
					},
					{
						"conditions": ["test_status"],
						"text": "Exit Now (but conditioned)",
						"next": -1
					},
					{
						"conditions": [],
						"text": "Exit Now",
						"next": -1
					}
				],
			},
			{
				"text": "This will set `test_status`, allowing to toggle an option that wasn't there before",
				"speaker": "Cond setter",
				"update_status": {
					"test_status": true
				},
				"next": -1
			}
		]
	}
	_status = _data["status"]

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		advance_state()
	if Input.is_action_just_pressed("ui_up"):
		$TextBox/Answers.move_selected(-1)
	if Input.is_action_just_pressed("ui_down"):
		$TextBox/Answers.move_selected(1)

func get_next_id(entry):
	if entry.has("answers"):
		var answer = $TextBox/Answers.get_selected()
		var eligible_answers = get_eligible_answers(entry["answers"])
		$TextBox/Answers.clear_answers()
		return eligible_answers[answer]["next"]
	else:
		return entry["next"]

func check_conditions(answer):
	for item in answer["conditions"]:
		if !_status[item]:
			return false
	return true

func get_eligible_answers(answers):
	var ret = [] + answers
	for answer in answers:
		if !check_conditions(answer):
			ret.erase(answer)
	return ret

func advance_state():
	var entries = _data["entries"];
	if (_current_id < 0):
		_current_id = _data["start"];
		$TextBox.show()
	else:
		_current_id = get_next_id(entries[_current_id])
		if _current_id < 0:
			$TextBox.hide()
			return

	var entry = entries[_current_id];
	update_display(entry)

	if entry.has("update_status"):
		for item in entry["update_status"]:
			_status[item] = entry["update_status"][item]

	if entry.has("items"):
		for item in entry["items"]:
			emit_signal("item_changed", item, entry["items"][item])
			
func update_display(entry):
	$TextBox/Speaker.text = entry["speaker"];
	$TextBox/MainText.text = entry["text"];
	if entry.has("answers"):
		for option in get_eligible_answers(entry["answers"]):
			$TextBox/Answers.add_answer(option)
		$TextBox/Answers.select(0)
