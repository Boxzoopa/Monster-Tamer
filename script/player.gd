extends "res://script/character.gd"


@export var bait: BaitData
var bait_range: int = 5
var bait_dmg: int = 1
var not_baited: bool = true
var monster = null

@onready var bait_hitbox: Area2D = $Baitbox
@onready var bait_shape: CollisionShape2D = $Baitbox/CollisionShape2D2

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
	
	bait_shape.disabled = not_baited
	bait_hitbox.damage = (bait.dmg * bait_dmg)

func _physics_process(delta: float) -> void:
	bait_shape.shape.radius = (8 * bait_range) + 16
	controllable_movement()
	
	if Input.is_action_just_pressed("item_left"):
		not_baited = false
	if Input.is_action_just_released("item_left"):
		not_baited = true
	
	bait_shape.disabled = not_baited
	
func _on_bait_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Monster"):
		monster = body
		var damage = bait_dmg * bait.dmg
		#monster.tame(damage)

func _on_bait_hitbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("Monster"):
		monster = null

func _on_hurt_box_area_entered(hitbox: Area2D) -> void:
	if hitbox.is_in_group("Monster"):
		damage(1)
		Config.debug_msg("Player hurt!")
