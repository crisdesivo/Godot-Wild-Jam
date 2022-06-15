extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rng = RandomNumberGenerator.new()
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
var maxLateralSpeed = 3
var currentLateralSpeed = 0
var lateralAcceleration = 0.1
var verticalSpeedConstant = 2
var maxVerticalSpeed = 4
var jumpSpeed = 3
var groundPosition = 605
var ceilingPosition = 120
var score = 0
var maxScore = 0
onready var orb = Orb.new("Water Gun", get_parent(), self)


# Called when the node enters the scene tree for the first time.
func _ready():
    # var enemy = Enemy.new(10, 1, false, bulletTexture)
    # enemy.position = Vector2(100, 100)
    # get_parent().add_child(enemy)
    # print(enemy)
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    # timeSinceShot += delta
    # rotate the node 1 degree (in redians)
    # $Sprite.rotate(stepRotation)
    # if space bar is pressed rotate backwards
    if Input.is_action_pressed("click"):
        orb.shoot()
        # if timeSinceShot > reloadTime:
        #     timeSinceShot = 0
        #     var direction = (get_viewport().get_mouse_position() ) - self.position
        #     direction = direction.normalized()
        #     self.shoot(direction)
        #     $Sprite.rotate(shootRotationMultiplier*stepRotation)
        # var enemy = Enemy.new(10, 1, false, bulletTexture)
        # enemy.position = get_viewport().get_mouse_position()
        # get_parent().add_child(enemy)
        
    var moveVector = Vector2()
    if Input.is_action_pressed("ui_left"):
        # if timeSinceShot > reloadTime:
        #     timeSinceShot = 0
        orb.shootDirection(Vector2(-1, 0))
            # $Sprite.rotate(shootRotationMultiplier*stepRotation)
    elif Input.is_action_pressed("ui_right"):
        # if timeSinceShot > reloadTime:
        #     timeSinceShot = 0
        orb.shootDirection(Vector2(1, 0))
            # shoot(Vector2(1, 0))
            # $Sprite.rotate(shootRotationMultiplier*stepRotation)
    elif Input.is_action_pressed("ui_up"):
        # if timeSinceShot > reloadTime:
        #     timeSinceShot = 0
        orb.shootDirection(Vector2(0, -1))
            # shoot(Vector2(0, -1))
            # $Sprite.rotate(shootRotationMultiplier*stepRotation)
    elif Input.is_action_pressed("ui_down"):
        # if timeSinceShot > reloadTime:
        #     timeSinceShot = 0
        orb.shootDirection(Vector2(0, 1))
        #     shoot(Vector2(0, 1))
        #     $Sprite.rotate(shootRotationMultiplier*stepRotation)

    if Input.is_action_pressed("up"):
        jump()
    if Input.is_action_pressed("down"):
        verticalSpeed = max(0, verticalSpeed)
        verticalSpeed += downAcceleration
    if Input.is_action_pressed("left"):
        # moveVector += Vector2(-1, 0)
        currentLateralSpeed = max(-maxLateralSpeed, currentLateralSpeed - lateralAcceleration)
        $Body.flip_h = true
        $Sprite.flip_h = true
        if not falling:
            $Body.play("Run")
    elif Input.is_action_pressed("right"):
        # moveVector += Vector2(1, 0)
        currentLateralSpeed = min(maxLateralSpeed, currentLateralSpeed + lateralAcceleration)
        $Body.flip_h = false
        $Sprite.flip_h = false
        if not falling:
            $Body.play("Run")
    else:
        if falling:
            currentLateralSpeed *= 0.99
            $Body.play("Fall")
        else:
            currentLateralSpeed *= 0.9
            $Body.play("Idle")
    if falling:
        verticalSpeed += downGravity
    else:
        verticalSpeed = 0
    # moveVector.x *= lateralSpeed
    moveVector = Vector2(currentLateralSpeed, verticalSpeed*verticalSpeedConstant)
    translate(moveVector)
    timeJumped += delta
    if falling:
        if self.position.y > groundPosition - $Sprite.texture.get_height()*$Sprite.scale.y:
            self.position = Vector2(self.position.x, groundPosition - $Sprite.texture.get_height()*$Sprite.scale.y)
            verticalSpeed = 0
            falling = false
        if self.position.y <= ceilingPosition:
            self.position = Vector2(self.position.x, ceilingPosition)
            verticalSpeed = 0
            $Body.play("Idle")

func jump():
    if timeJumped > jumpReload:
        $Body.play("Jump")
        if falling:
            var index = rng.randi_range(1, 3)
            if index == 1:
                get_parent().get_node("Float1Sound").play()
            elif index == 2:
                get_parent().get_node("Float2Sound").play()
            elif index == 3:
                get_parent().get_node("Float3Sound").play()

        else:
            get_parent().get_node("JumpSound").play()
        verticalSpeed -= jumpSpeed
        verticalSpeed = max(-maxVerticalSpeed, verticalSpeed)
        print("vertical speed: " + str(verticalSpeed))
        falling = true
        timeJumped = 0

func shoot(direction):
    # create a new bullet
    # var bullet = Bullet.new(position, direction, 2, 3, 1, "linear", 0)
    # get_parent().add_child(bullet)
    #BulletAttack(parent: Node, position: Vector2, direction: Vector2, bulletMovement: String, bulletsPerShot: int, spreadAngle: float, spreadDistribution: String, damagePerBullet: int, bulletSpeed: float, pierce: int, bulletLifetime: float):

    BulletAttack.shoot(get_parent(), position, direction, "Linear", 5, 45, "Equidistant", 1, 10, 0, 0.5)

func addScore(points):
    self.score += points
    get_parent().get_node("Score").text = str(self.score)
    if score > maxScore:
        maxScore = score
        get_parent().get_node("MaxScore").text = "Max Score: "+str(maxScore)

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
