extends Sprite

class_name Enemy

var maxHP: float
var currentHP: float
var speed: float
var flies: bool
var lastHit = 0.0
# var name = "enemy"

func _init(maxHP_: float, speed_: int, flies_: bool, texture_: Texture, scale_: float):
    name = "enemy"
    add_to_group("enemies")
    self.maxHP = maxHP_
    self.currentHP = maxHP_
    self.speed = speed_
    self.flies = flies_
    # self.texture = texture
    var hitbox = Area2D.new()
    var collisionShape = CollisionShape2D.new()
    collisionShape.shape = CircleShape2D.new()
    collisionShape.shape.radius = texture_.get_size().x / 2
    hitbox.add_child(collisionShape)
    self.add_child(hitbox)
    texture = texture_
    hitbox.collision_layer = 2
    hitbox.collision_mask = 1
    hitbox.connect("area_entered", self, "collision")
    scale = Vector2(scale_, scale_)
    # var sprite = Sprite.new()
    # add_child(sprite)


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    lastHit += delta
    position.x -= 0.5
    position.y += 0.5

    if lastHit >= 0.1:
        self_modulate = Color(1, 1, 1, 1)

func takeDamage(damage):
    self.currentHP -= damage
    if self.currentHP <= 0:
        queue_free()
    else:
        self_modulate = Color(1, 0, 0, 1)
        lastHit = 0.0
        # yield(get_tree().create_timer(0.1), "timeout")
        # self_modulate = Color(1, 1, 1, 1)

func collision(area):
    var bullet = area.get_parent()
    if bullet.is_in_group("bullets"):
        bullet.hit(self)
