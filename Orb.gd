extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var reloadTime = 0.5
var timeSinceShot = reloadTime
var bulletTexture = load("res://Assets/orb1.png")
var verticalSpeed = 0
var falling = true
var jumpReload = 0.5
var timeJumped = 0
var downAcceleration = 0.05
var stepRotation = 1*2*3.14/180
var shootRotationMultiplier = -15
var downGravity = 0.05
var lateralSpeed = 2
var verticalSpeedConstant = 2
var jumpSpeed = 2


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
    $Sprite.rotate(stepRotation)
    # if space bar is pressed rotate backwards
    if Input.is_action_pressed("click"):
        if timeSinceShot > reloadTime:
            timeSinceShot = 0
            var direction = (get_viewport().get_mouse_position() ) - self.position
            direction = direction.normalized()
            self.shoot(direction)
            $Sprite.rotate(shootRotationMultiplier*stepRotation)
        # var enemy = Enemy.new(10, 1, false, bulletTexture)
        # enemy.position = get_viewport().get_mouse_position()
        # get_parent().add_child(enemy)
        
    var moveVector = Vector2()
    if Input.is_action_pressed("up"):
        jump()
    if Input.is_action_pressed("down"):
        verticalSpeed = max(0, verticalSpeed)
        verticalSpeed += downAcceleration
    if Input.is_action_pressed("left"):
        moveVector += Vector2(-1, 0)
        $Body.flip_h = true
        $Sprite.flip_h = true
        if not falling:
            $Body.play("Run")
    elif Input.is_action_pressed("right"):
        moveVector += Vector2(1, 0)
        $Body.flip_h = false
        $Sprite.flip_h = false
        if not falling:
            $Body.play("Run")
    else:
        if falling:
            $Body.play("Fall")
        else:
            $Body.play("Idle")
    if falling:
        verticalSpeed += downGravity
    else:
        verticalSpeed = 0
    moveVector.x *= lateralSpeed
    moveVector += Vector2(0, verticalSpeed*verticalSpeedConstant)
    translate(moveVector)
    if falling:
        timeJumped += delta
        if self.position.y > get_viewport().size.y - $Sprite.texture.get_height()*$Sprite.scale.y:
            self.position = Vector2(self.position.x, get_viewport().size.y - $Sprite.texture.get_height()*$Sprite.scale.y)
            verticalSpeed = 0
            falling = false
        if self.position.y <= 0:
            self.position = Vector2(self.position.x, 0)
            verticalSpeed = 0
            $Body.play("Idle")

func jump():
    if timeJumped > jumpReload:
        $Body.play("Jump")
        verticalSpeed = -jumpSpeed
        falling = true
        timeJumped = 0

func shoot(direction):
    # create a new bullet
    # var bullet = Bullet.new(position, direction, 2, 3, 1, "linear", 0)
    # get_parent().add_child(bullet)
    #BulletAttack(parent: Node, position: Vector2, direction: Vector2, bulletMovement: String, bulletsPerShot: int, spreadAngle: float, spreadDistribution: String, damagePerBullet: int, bulletSpeed: float, pierce: int, bulletLifetime: float):

    BulletAttack.shoot(get_parent(), position, direction, "Linear", 5, 45, "Equidistant", 1, 10, 0, 0.5)


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


func _on_Body_animation_finished():
    # if animation is jump
    if $Body.animation == "Jump":
        if falling:
            $Body.animation = "Fall"
        else:
            $Body.animation = "Idle"
    pass # Replace with function body.
