extends ColorRect

var speech = ["Hey you!", 
"Yes, you",
"You're a wandering witch right?",
"Lets just say you dress quite expressively",
"Never mind that, can you help me 
out?",
"If you can't already tell from my clothes, 
I'm actually not from here",
"Perhaps you could say I'm someone from 
the distant future.",
"It doesn't work like that.",
"Ever since I got here, my memories have 
been cloudy,",
"The last thing I can recall was a portal and 
all of my energy being drained out of me",
"I heard that the monsters around here 
drop energy stones when defeated.",
"Maybe you can help me collect some?",
"Please help me collect 5 energy stones
from the potato monsters."
]

var counter: int = 1
var first: bool = false
var second: bool = false
var third: bool = false
var fourth: bool = false

@export var text: Label
@export var button_1: Button
@export var button_2: Button
@export var button_3: Button
@export var button_4: Button
@export var button_5: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text.text = speech[0]
	button_1.hide()
	button_2.hide()
	button_3.hide()
	button_4.hide()
	button_5.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.quest_1_talk == true:
		text.text = speech[12]
		if Input.is_action_just_pressed("next"):
			Global.talking = false
			hide()
	elif Global.quest_1_talk == false and counter == 1:
		button_1.show()
	
	if second == false and first == true and counter < 3 and Input.is_action_just_pressed("next"):
		text.text = speech[counter]
		counter += 1
		print(counter)
		
	elif second == true and third == false and counter < 7 and Input.is_action_just_pressed("next"):
		text.text = speech[counter]
		counter += 1
		print(counter)
		
	elif third == true and counter < 12 and Input.is_action_just_pressed("next"):
		text.text = speech[counter]
		counter += 1
		print(counter)
		
	elif fourth == true and Input.is_action_just_pressed("next"):
		Global.talking = false
		Global.quest_1_talk = true
		hide()
			
		
	if counter == 3:
		button_2.show()
	
	elif counter == 7:
		button_3.show()
		button_4.show()
		
	elif counter == 12:
		button_5.show()

func _first() -> void:
	first = true
	text.text = speech[counter]
	counter += 1
	print(counter)
	button_1.hide()


func _second() -> void:
	second = true
	text.text = speech[counter]
	counter += 1
	print(counter)
	button_2.hide()


func _third() -> void:
	third = true
	counter += 1
	text.text = speech[counter]
	counter += 1
	print(counter)
	button_3.hide()
	button_4.hide()


func _fourth() -> void:
	third = true
	text.text = speech[counter]
	counter += 1
	print(counter)
	button_3.hide()
	button_4.hide()


func _fifth() -> void:
	fourth = true
	text.text = speech[counter]
	counter += 1
	print(counter)
	button_5.hide()
