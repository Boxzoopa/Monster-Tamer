extends "res://script/character.gd"

@onready var bait_hitbox: Area2D = $bait_Hitbox
@onready var collision_shape: CollisionShape2D = bait_hitbox.get_node("CollisionShape2D")
@export var bait: BaitData
var bait_range = 5
var bait_size_dmg = 1
var bait_dmg = 1

var not_baited = true
var monster = null

func _ready() -> void:
	# Enable or disable bait hitbox initially
	collision_shape.disabled = not_baited

func _physics_process(delta: float) -> void:
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
	
	# Update the collision shape radius dynamically
	collision_shape.shape.radius = (8 * bait_range) + 16
	
	
	input_vector = process_input()
	move()
	
	# Update the bait hitbox based on player input
	if Input.is_action_just_pressed("item_left"):
		not_baited = false
	if Input.is_action_just_released("item_left"):
		not_baited = true
	
	collision_shape.disabled = not_baited

func _on_bait_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Monster"):
		monster = body
		#print("Monster detected!")
		
		# Call tame method on the monster, if it exists
		var damage = bait_dmg * bait.dmg
		
		monster.tame(damage)

func _on_bait_hitbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("Monster"):
		#print("Monster exited!")
		monster = null
