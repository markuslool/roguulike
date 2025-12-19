extends CharacterBody3D

@export var speed: float = 5.0

# Вектор передвижения ДЛЯ АНИМАЦИЙ
# Его можно напрямую использовать в AnimationTree
var move_vector: Vector3 = Vector3.ZERO

# Значение меняется на 1 при касании нужных коллайдеров
var touched_value: int = 0

# Список имён коллайдеров
@export var target_collider_names: Array[String] = [
	"TriggerObject",
	"Zone_1",
	"EnemyHitbox"
]


func _physics_process(delta):
	# Ввод
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_dir.y = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")

	# Локальное направление → мировое
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Вектор движения (заготовка для анимаций)
	move_vector = direction * speed

	# Применение движения
	velocity.x = move_vector.x
	velocity.z = move_vector.z

	move_and_slide()

	# Проверка коллизий
	check_collisions()


func check_collisions():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider and collider.name in target_collider_names:
			touched_value = 1
