extends Node2D

@onready var ray_cast_2d_right_foot: RayCast2D = $"RayCast2D - right_foot"
@onready var ray_cast_2d_left_foot: RayCast2D = $"RayCast2D - left_foot"
@onready var direction = 1
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_2d_right: RayCast2D = $"RayCast2D - right"
@onready var ray_cast_2d_left: RayCast2D = $"RayCast2D - left"



const SPEED = 35

func _physics_process(delta: float) -> void:
	position.x += SPEED * delta * direction
	
	if ray_cast_2d_right_foot.is_colliding() == false or ray_cast_2d_right.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = true
		
	if ray_cast_2d_left_foot.is_colliding() == false or ray_cast_2d_left.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = false
		
	
