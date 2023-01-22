extends Area2D

class_name Topping

var lettucePlacedSound = preload("res://asset/sounds/lettuceplaced.wav")
var lettuceSelectedSound = preload("res://asset/sounds/lettucevoice.wav")

var bunPlacedSound = preload("res://asset/sounds/bunplaced.wav")
var bunSelectedSound = preload("res://asset/sounds/bunvoice.wav")

var burgerPlacedSound = preload("res://asset/sounds/burgerplaced.wav")
var burgerSelectedSound = preload("res://asset/sounds/burgervoice.wav")

var wetPlacedSound = preload("res://asset/sounds/wetplaced.wav")
var cheeseSelectedSound = preload("res://asset/sounds/cheesevoice.wav")
var pickleSelectedSound = preload("res://asset/sounds/picklevoice.wav")
var tomatoSelectedSound = preload("res://asset/sounds/tomatovoice.wav")

var squirtPlacedSound = preload("res://asset/sounds/squirt.wav")
var ketchupSelectedSound = preload("res://asset/sounds/ketchupvoice.wav")
var mayoSelectedSound = preload("res://asset/sounds/mayo_voice.wav")
var mustardSelectedSound = preload("res://asset/sounds/mustardvoice.wav")


@export var topping : String = "blank"
@export var toppingEnum: Enum.Topping
@export var toppingState: Enum.ToppingState
@export var image_on_burger : Texture2D
@export var image_on_pantry : Texture2D
@export var placedSound : Resource
@export var selectedSound : Resource

var mousePostion := Vector2.ZERO
var _touch_position := Vector2.ZERO
var _original_position := Vector2.ZERO
var _dragging := false
var onBurgerVisible := false

func _ready():
	_original_position = $ImageOnPantry.position
	if toppingState == Enum.ToppingState.ON_BURGER:
		$ImageOnBurger.texture = image_on_burger
		$ImageOnBurger.visible = false
	else:
		$ImageOnPantry.texture = image_on_pantry
		$Label.text = topping
	
	match (topping.to_upper()):
		"BUN":
			$SelectedSound.stream = bunSelectedSound 
			$PlacedSound.stream = bunPlacedSound
		"BURGER":
			$SelectedSound.stream = burgerSelectedSound 
			$PlacedSound.stream = burgerPlacedSound
		"CHEESE":
			$SelectedSound.stream = cheeseSelectedSound 
			$PlacedSound.stream = wetPlacedSound
		"PICKLE":
			$SelectedSound.stream = pickleSelectedSound 
			$PlacedSound.stream = wetPlacedSound
		"TOMATO":
			$SelectedSound.stream = tomatoSelectedSound 
			$PlacedSound.stream = wetPlacedSound
		"KETCHUP":
			$SelectedSound.stream = ketchupSelectedSound 
			$PlacedSound.stream = squirtPlacedSound
		"LETTUCE":
			$SelectedSound.stream = lettuceSelectedSound 
			$PlacedSound.stream = lettucePlacedSound
		"MAYO": 
			$SelectedSound.stream = mayoSelectedSound 
			$PlacedSound.stream = squirtPlacedSound
		"MUSTARD": 
			$SelectedSound.stream = mustardSelectedSound 
			$PlacedSound.stream = squirtPlacedSound

func Placed() :
	$PlacedSound.play()

func _input(event) -> void:
	if not _dragging:
		return
	
	if event.is_action_released("ui_touch"):
		_dragging = false
		$ImageOnPantry.position = _original_position
		$CollisionShape2D.position = _original_position
	
	if event is InputEventMouseMotion:
		mousePostion = event.position
		$ImageOnPantry.position -= _touch_position - (event.position)
		$CollisionShape2D.position -= _touch_position - (event.position)
		
		_touch_position = event.position

func _process(event) : 	
	if onBurgerVisible:
		$ImageOnBurger.visible = true
	
func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("ui_touch"):
		$SelectedSound.play()
		_dragging = true
		_touch_position = event.position
		
func _on_mouse_entered(topping: Topping):
	if topping == self:
		var _is_moused_over = true


