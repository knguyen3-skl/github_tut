extends ColorRect

var purple_potion: String = "purple_potion"
var blue_potion: String = "blue_potion"

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


func _purple_brewed() -> void:
	# Adds a purple potion to the player's inventory and informs the player they have
	# successfully brewwed the potion in the form as an announcement.
	if Global.sprout >= 1:
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
		no_money.show()
		timer.start()


func _exit_brewing() -> void:
	Global.potion_brewing = false
	hide()


func _on_timer_timeout() -> void:
	no_money.hide()


func _purple_to_blue() -> void:
	# If the player clicks the next button, show the options for the blue potion
	for items in get_children():
		if items.is_in_group("purple_options"):
			items.hide()
		elif items.is_in_group("blue_options"):
			items.show()


func _blue_brewed() -> void:
	# Adds a blue potion to the player's inventory and informs the player they have
	# successfully brewwed the potion in the form as an announcement.
	if Global.sprout >= 2:
		Global.sprout -= 2
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
		no_money.show()
		timer.start()


func _blue_to_pruple() -> void:
	# If the player clicks the backwards button, show the option for the purple potion
	# as that is the option prior to the blue potion.
	for items in get_children():
		if items.is_in_group("purple_options"):
			items.show()
		elif items.is_in_group("blue_options"):
			items.hide()


func _msg_done() -> void:
	announcement.hide()
