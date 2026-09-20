extends ColorRect
@onready var buttion_sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D2
@onready var error_sfx: AudioStreamPlayer2D = $"../../AudioStreamPlayer2D2"

var purple_potion: String = "purple_potion"
var blue_potion: String = "blue_potion"
var blue_value: int = 2

@export var inventory: ColorRect
@export var timer: Timer
@export var money: Label
@export var sprout: Label
@export var no_money: Label
@export var announcement: ColorRect
@export var timer_brewed: Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Show the purple potion as the starting brewing option.
	for items in get_children():
		if items.is_in_group("purple_options"):
			items.show()
		elif items.is_in_group("blue_options"):
			items.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.pause == true:
		hide()


# Runs when the player brews the purple potion.
func _purple_brewed() -> void:
	# Adds a purple potion to the player's inventory and informs the player they have
	# successfully brewwed the potion in the form of an announcement.
	if Global.sprout >= 1:
		if Global.sound_effects == true:
			buttion_sfx.play()
			
		Global.sprout -= 1
		sprout.text = str(Global.sprout)
		Global.inventory[purple_potion] += 1
		announcement.show()
		hide()
		timer_brewed.start()
		# For the announcement, only show the items related to successfully brewing
		# to filter out rewards.
		for items in announcement.get_children():
			if items.is_in_group("rewards"):
				items.hide()
			else:
				items.show()
	else:
		if Global.sound_effects == true:
			error_sfx.play()
			
		no_money.show()
		timer.start()


# Runs when the player exits the brewing menu.
func _exit_brewing() -> void:
	Global.potion_brewing = false
	hide()


# Runs when the player clicks the right arrow.
func _purple_to_blue() -> void:
	# If the player clicks the next button, show the options for the blue potion
	for items in get_children():
		if items.is_in_group("purple_options"):
			items.hide()
		elif items.is_in_group("blue_options"):
			items.show()


# Runs when the player brews the blew potion.
func _blue_brewed() -> void:
	# Adds a blue potion to the player's inventory and informs the player they have
	# successfully brewwed the potion in the form as an announcement.
	if Global.sprout >= blue_value:
		if Global.sound_effects == true:
			buttion_sfx.play()
			
		Global.sprout -= blue_value
		sprout.text = str(Global.sprout)
		Global.inventory[blue_potion] += 1
		hide()
		timer_brewed.start()
		announcement.show()
		for items in announcement.get_children():
			if items.is_in_group("rewards"):
				items.hide()
			else:
				items.show()
	else:
		if Global.sound_effects == true:
			error_sfx.play()
			
		no_money.show()
		timer.start()


# Runs when the player clicks on the left arrow.
func _blue_to_pruple() -> void:
	# If the player clicks the backwards button, show the option for the purple potion
	# as that is the option prior to the blue potion.
	for items in get_children():
		if items.is_in_group("purple_options"):
			items.show()
		elif items.is_in_group("blue_options"):
			items.hide()


# Runs after a period of time after the brewing message was shown. 
func _msg_done() -> void:
	announcement.hide()


# Runs after a period of time after the no money message was shown.
func broke_timer() -> void:
	no_money.hide()
