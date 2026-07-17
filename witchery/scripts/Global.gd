extends Node

var money: int = 0

var potato_fight: bool = false

var player_base_health: int = 10
var player_base_special: int = 5

var player_health: int = 10
var player_special: int = 5


var potato_health: int = 10

var enemy_dict= {}
var enemy_status: bool = true

var enemy_id: String

var potion_brewing: bool = false
var last_player_positon : Vector2

var inventory_status: bool = false
var pause: bool = false

var inventory = {
	"purple_potion": 0,
	"blue_potion": 0,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_player_positon = Vector2(-262.0, 210.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
