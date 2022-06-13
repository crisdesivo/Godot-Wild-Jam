extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var reloadTime = 0.1
var timeSinceShot = reloadTime
var bulletTexture = load("res://Assets/orb1.png")
var verticalSpeed = 0
var falling = true
var jumpReload = 0.5
var timeJumped = 0


# Called when the node enters the scene tree for the first time.
func _ready():
    # var enemy = Enemy.new(10, 1, false, bulletTexture)
    # enemy.position = Vector2(100, 100)
    # get_parent().add_child(enemy)
    # print(enemy)
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    timeSinceShot += delta
    # rotate the node 1 degree (in redians)
    $Sprite.rotate(1*2*3.14/180)
    # if space bar is pressed rotate backwards
    if Input.is_action_pressed("click"):
        if timeSinceShot > reloadTime:
            timeSinceShot = 0
            var direction = (get_viewport().get_mouse_position() ) - self.position
            direction = direction.normalized()
            self.shoot(direction)
            $Sprite.rotate(-15*2*3.14/180)
        # var enemy = Enemy.new(10, 1, false, bulletTexture)
        # enemy.position = get_viewport().get_mouse_position()
        # get_parent().add_child(enemy)
        
    var moveVector = Vector2()
    if Input.is_action_pressed("up"):
        jump()
    if Input.is_action_pressed("down"):
        verticalSpeed = max(0, verticalSpeed)
        verticalSpeed += 0.05
    if Input.is_action_pressed("left"):
        moveVector += Vector2(-1, 0)
    if Input.is_action_pressed("right"):
        moveVector += Vector2(1, 0)
    if falling:
        verticalSpeed += 0.05
    else:
        verticalSpeed = 0
    moveVector += Vector2(0, verticalSpeed)
    translate(moveVector*10)
    if falling:
        timeJumped += delta
        if self.position.y > get_viewport().size.y - $Sprite.texture.get_height()*$Sprite.scale.y:
            self.position = Vector2(self.position.x, get_viewport().size.y - $Sprite.texture.get_height()*$Sprite.scale.y)
            verticalSpeed = 0
            falling = false
        if self.position.y <= 0:
            self.position = Vector2(self.position.x, 0)
            verticalSpeed = 0

func jump():
    if timeJumped > jumpReload:
        verticalSpeed = -1.5
        falling = true
        timeJumped = 0

func shoot(direction):
    # create a new bullet

    var bullet = Bullet.new(position, direction, 2, 3, 1, "linear", 0)
    get_parent().add_child(bullet)


func _on_RigidBody2D_body_entered(body:Node):
    print(body)
    # pass # Replace with function body.


func _on_RigidBody2D_mouse_entered():
    print("endeter mouse")
    pass # Replace with function body.


func _on_Area2D_body_entered(body:Node):
    print(body)
    # pass # Replace with function body.

func _on_Area2D_area_entered(area:Area2D):
    # print(area.get_parent().damage)
    print(area.get_parent())
    pass # Replace with function body.
