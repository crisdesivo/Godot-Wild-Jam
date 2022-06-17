extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rng = RandomNumberGenerator.new()

# var bulletTexture = load("res://Assets/orb1.png")
var verticalSpeed = 0
var falling = true
var jumpReload = 0.5
var timeJumped = 0
var downAcceleration = 0.05

var fireRateBonus = 0.0
var damageBonus = 0.0
var speedBonus = 0.0
var pierceBonus = 0.0
var spreadBonus = 0.0

var fireBonus = 0
var iceBonus = 0
# var stepRotation = 1*2*3.14/180
# var shootRotationMultiplier = -15
var downGravity = 0.05
var maxLateralSpeed = 3
var currentLateralSpeed = 0
var lateralAcceleration = 0.1
var verticalSpeedConstant = 2
var maxVerticalSpeed = 4
var jumpSpeed = 3
var groundPosition = 563
var ceilingPosition = 120
var score = 0
var maxScore = 0
# onready var orbs = [Orb.new("Crossbow", get_parent(), self), Orb.new("Water Gun", get_parent(), self), Orb.new("Fan", get_parent(), self)]
var orbs = []
var selectedOrb = 0
var changeOrbDelay = 0.1
var changeOrbTime = changeOrbDelay + 1

func _ready():
    maxScore = Variables.maxScore
    get_parent().get_node("GUI/MaxScore").text = "Max Score: " + str(Variables.maxScore)
    for orbName in Variables.initialOrbs:
        orbs.append(Orb.new(orbName, get_parent(), self))
        orbs[0].equip()
    orbs[selectedOrb].select()
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    changeOrbTime += delta
    timeJumped += delta

    # Orb change inputs
    if Input.is_action_pressed("Change Left"):
        if changeOrbTime > changeOrbDelay:
            var index = (selectedOrb - 1) % len(orbs)
            changeOrb(index)
            changeOrbTime = 0
    if Input.is_action_pressed("Change Right"):
        if changeOrbTime > changeOrbDelay:
            var index = (selectedOrb + 1) % len(orbs)
            changeOrb(index)
            changeOrbTime = 0

    # Shooting inputs
    if Input.is_action_pressed("click"):
        orbs[selectedOrb].shoot()
    else:
        var shootDirection = Vector2(0, 0)
        if Input.is_action_pressed("ui_left"):
            shootDirection.x -= 1
            # orbs[selectedOrb].shootDirection(Vector2(-1, 0))
        if Input.is_action_pressed("ui_right"):
            shootDirection.x += 1
            # orbs[selectedOrb].shootDirection(Vector2(1, 0))
        if Input.is_action_pressed("ui_up"):
            shootDirection.y -= 1
            # orbs[selectedOrb].shootDirection(Vector2(0, -1))
        if Input.is_action_pressed("ui_down"):
            shootDirection.y += 1
            # orbs[selectedOrb].shootDirection(Vector2(0, 1))
        if shootDirection.length_squared() > 0:
            orbs[selectedOrb].shootDirection(shootDirection.normalized())

    # Movement inputs
    if Input.is_action_pressed("up"):
        jump()
    if Input.is_action_pressed("down"):
        verticalSpeed = max(0, verticalSpeed)
        verticalSpeed += downAcceleration
    if Input.is_action_pressed("left"):
        currentLateralSpeed = max(-maxLateralSpeed, currentLateralSpeed - lateralAcceleration)
        $Body.flip_h = true
        $Sprite.flip_h = true
        if not falling:
            $Body.play("Run")
    elif Input.is_action_pressed("right"):
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

    # Update velocity and position
    if falling:
        verticalSpeed += downGravity
    else:
        verticalSpeed = 0

    var moveVector = Vector2(currentLateralSpeed, verticalSpeed*verticalSpeedConstant)
    translate(moveVector)

    # Check for collisions
    if falling:
        if self.position.y > groundPosition:
            self.position = Vector2(self.position.x, groundPosition)
            verticalSpeed = 0
            falling = false
            $Body.play("Idle")
        if self.position.y <= ceilingPosition:
            self.position = Vector2(self.position.x, ceilingPosition)
            verticalSpeed = 0

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

# func shoot(direction):
#     # create a new bullet
#     # var bullet = Bullet.new(position, direction, 2, 3, 1, "linear", 0)
#     # get_parent().add_child(bullet)
#     #BulletAttack(parent: Node, position: Vector2, direction: Vector2, bulletMovement: String, bulletsPerShot: int, spreadAngle: float, spreadDistribution: String, damagePerBullet: int, bulletSpeed: float, pierce: int, bulletLifetime: float):

#     BulletAttack.shoot(get_parent(), position, direction, "Linear", 5, 45, "Equidistant", 1, 10, 0, 0.5)

func addScore(points):
    self.score += points
    get_parent().get_node("GUI/Score").text = str(self.score)
    if score > maxScore:
        maxScore = score
        get_parent().get_node("GUI/MaxScore").text = "Max Score: "+str(maxScore)
        Variables.maxScore = maxScore

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

func changeOrb(index: int):
    orbs[selectedOrb].deselect()
    selectedOrb = index
    orbs[selectedOrb].select()
