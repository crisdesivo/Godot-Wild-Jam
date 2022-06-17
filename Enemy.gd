extends Sprite

class_name Enemy

var player
var maxHP: float
var currentHP: float
var speed: float
var cspeed: float
var flies: bool
var lastHit = 0.0
var lastBoost = 0.0
var alive = true
var rotate = false
var flip = false
var movementType: String
var velocity: Vector2
# var name = "enemy"

func _init(maxHP_: float, speed_: float, flies_: bool, texture_: Texture, scale_: float, rotate_: bool, flip_: bool, movementType_: String):
    name = "enemy"
    add_to_group("enemies")
    self.maxHP = maxHP_
    self.currentHP = maxHP_
    self.speed = speed_
    self.flies = flies_
    self.rotate = rotate_
    self.flip = flip_
    self.movementType = movementType_
    # self.texture = texture
    var hitbox = Area2D.new()
    var collisionShape = CollisionShape2D.new()
    collisionShape.shape = CircleShape2D.new()
    collisionShape.shape.radius = texture_.get_size().x / 2
    hitbox.add_child(collisionShape)
    self.add_child(hitbox)
    texture = texture_
    hitbox.collision_layer = 2
    hitbox.set_collision_mask_bit(0b00000000000000000111, true)
    hitbox.collision_mask = 2

    hitbox.connect("area_entered", self, "collision")
    scale = Vector2(scale_, scale_)
    # var sprite = Sprite.new()
    # add_child(sprite)
    if movementType == "attracted":
        velocity = Vector2(0, 0)


# Called when the node enters the scene tree for the first time.
func _ready():
    player = get_parent().get_parent().get_node("Player")

    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    lastHit += delta
    lastBoost += delta
    if lastBoost >= 1.01:
        speed *= 1.01
        lastBoost = 0
    cspeed = min(speed, cspeed + 4*delta)
    var playerPosition = player.get_global_position()
    var enemyPosition = self.get_global_position()
    var distance = (playerPosition - enemyPosition).normalized()
    if movementType == "homing":
        translate(distance * cspeed * 100 * delta)
    elif movementType == "attracted":
        self.velocity += distance * speed * delta * 2
        var velocityMagnitude = self.velocity.length()
        if velocityMagnitude > speed:
            # self.velocity = speed * self.velocity/velocityMagnitude
            translate(self.velocity * 100 * delta * speed / velocityMagnitude)
        else:
            translate(self.velocity * 100 * delta)
    if rotate:
        rotation_degrees = 90 + atan2(distance.y, distance.x) * 180 / PI
        if flip:
            if distance.x < 0:
                flip_h = false
            else:
                flip_h = true
    # position.x -= 0.5
    # position.y += 0.5

    if lastHit >= 0.1:
        self_modulate = Color(1, 1, 1, 1)

func takeDamage(damage):
    self.currentHP -= damage
    if self.currentHP <= 0 and alive:
        alive = false
        queue_free()
        player.addScore(1)
    else:
        self_modulate = Color(1, 0, 0, 1)
        lastHit = 0.0
        # yield(get_tree().create_timer(0.1), "timeout")
        # self_modulate = Color(1, 1, 1, 1)

func collision(area):
    var bullet = area.get_parent()
    if bullet.is_in_group("bullets"):
        bullet.hit(self)
    elif bullet.is_in_group("enemies"):
        # cspeed = 0
        var distance = bullet.position - self.position
        var minDistance = bullet.texture.get_width()/2.0 + self.texture.get_width()/2.0
        translate(-50*speed*distance/pow(distance.length()-minDistance, 2))
        # print("collision between two enemiess")
        # queue_free()
        # bullet.queue_free()
