extends Node2D

var orders = []
var orderCount : int = 0
var level : int = 0
@export var order_scene : PackedScene

var ordersFinished := 0
var ordersFailed := 0

var menuMusic = preload("res://asset/sounds/menu_music.mp3")
var monolithBurger = preload("res://asset/sounds/menu_music_voice.mp3")

var dangerBeefSong = preload("res://asset/sounds/danger_beef.mp3")
var hornySoupSong = preload("res://asset/sounds/horny_soup.mp3")

func _ready() -> void : 
	setMainMenu()
	GameEvents.order_finished.connect(_on_order_finished.bind())
	GameEvents.order_failed.connect(_on_order_failed.bind())

func _input(event):
	if event.is_action_pressed("ui_escape"):
		setMainMenu()

func _process(delta):
	if (ordersFailed >= 5):
		Global.GameState = Enum.GameplayState.LOSER	
		
	var endGame = false
	if (Global.GameState == Enum.GameplayState.WINNER) :
		$GetReady.text = "You did it!"
		endGame = true
	elif (Global.GameState == Enum.GameplayState.LOSER) :
		$GetReady.text = "You lost!"
		endGame = true

	if (endGame):		
		$GetReady.visible = true
		$LevelMusic.stop()
		$pantry.visible = false
		
	
func setMainMenu():
	ordersFinished = 0
	ordersFailed = 0
	orderCount = 0
	Global.GameState = Enum.GameplayState.MAINMENU
		
	$LevelMusic.stream = menuMusic
	$LevelMusic.play()
	
	$MonolithBurger.stream = monolithBurger
	$MonolithBurger.play()
	
	$IncomingOrderTimer.stop()
	
	$GetReady.visible = false
	$Level1Button.visible = true
	$Level2Button.visible = true
	$Level3Button.visible = true
	$OrdersFailed.visible = false
	$AboutText.visible = true
	$ColorRect.visible = true
	$Background.visible = true
	$pantry.visible = false
	$Label.visible = false
	$Help.visible = false	
		
func startLevel(levelNumber : int) :
	Global.GameState = Enum.GameplayState.PLAYING
	
	if levelNumber == 1 :
		$LevelMusic.stream = hornySoupSong
	else :	
		$LevelMusic.stream = dangerBeefSong
	
	$LevelMusic.play()
	$MonolithBurger.stop()
	
	$IncomingOrderTimer.start()
	
	$Level1Button.visible = false
	$Level2Button.visible = false
	$Level3Button.visible = false
	$OrdersFailed.visible = true
	$GetReady.visible = true
	$AboutText.visible = false
	$ColorRect.visible = false
	$Background.visible = false
	$pantry.visible = true
	$Label.visible = true
	$Help.visible = true
	
	$GetReady.text = 'Get ready!'
	$Label.text = "Orders completed: " + str(ordersFinished)
	$OrdersFailed.text = "Orders missed: " + str(ordersFailed)
	level = levelNumber

func _on_incoming_order_timer_timeout():
	orderCount += 1
	
	if (ordersFailed >= 5):
		Global.GameState = Enum.GameplayState.LOSER	
	else:	
		$GetReady.visible = false
		
		var order = order_scene.instantiate()
		order.newOrder(orderCount, level)
		order.position.x = 750

		add_child(order)
	
func _on_order_finished() :
	# Add to counter total. 
	$OrderComplete.play()
	ordersFinished += 1
	$Label.text = "Score: " + str(ordersFinished)
	if (ordersFinished == 25):
		$Winner.play()
		Global.GameState = Enum.GameplayState.WINNER
		
func _on_order_failed() :
	ordersFailed += 1
	$OrdersFailed.text = "Orders missed: " + str(ordersFailed)

func _on_level_1_button_button_down():
	startLevel(1)

func _on_level_2_button_button_down():
	startLevel(2)

func _on_level_3_button_button_down():
	startLevel(3)
