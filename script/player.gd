extends "res://script/character.gd"

@export var bait: BaitData
var bait_range: int = 5
var bait_dmg: int = 1
var not_baited: bool = true
var throwing_bait: bool = false
var can_throw_bait: bool = true
var throw_bait_timer: float = 0.5  # Time to freeze player while throwing
var throw_timer: float = 0.0

var monster = null

@onready var bait_scene: PackedScene = load("res://scenes/components/projectile_component.tscn")

@export var health: int = 10
@export var def: int = 5

func _ready() -> void:
	defence = def
	max_hp = health
	hp = max_hp
	
	match bait.size:
		Config.Bait_size.SMALL:
			bait_range = 5
			bait_dmg = 1
		Config.Bait_size.MEDIUM:
			bait_range = 3
			bait_dmg = 2
		Config.Bait_size.LARGE:
			bait_range = 1
			bait_dmg = 3

func _physics_process(delta: float) -> void:
	
	# Update the bait hitbox range dynamically
	# Handle throwing bait logic
	if throwing_bait:
		throw_timer -= delta
		if throw_timer <= 0:
			throwing_bait = false
			can_throw_bait = true
	
	
	# If not throwing bait, allow normal movement
	if not throwing_bait:
		controllable_movement()

	# Handle bait throwing
	if Input.is_action_just_pressed("item_left") and can_throw_bait:
		throw_bait()
		throwing_bait = true
		can_throw_bait = false
		throw_timer = throw_bait_timer
	
	Config.player_hp = hp


func throw_bait():
	if bait_scene:
		var bait_piece = bait_scene.instantiate()
		bait_piece.damage = (bait.dmg * bait_dmg)
		get_tree().current_scene.add_child(bait_piece)
		bait_piece.directions = facing_vector  # Use facing_vector for direction
		bait_piece.global_position = self.global_position + (8*facing_vector)


func _on_hurt_box_area_entered(hitbox: Area2D) -> void:
	if hitbox.is_in_group("Hitbox"):
		var dmg = damage(1)
		Config.debug_msg("Player hurt!")
		recieve_kb(hitbox.global_position, dmg)
