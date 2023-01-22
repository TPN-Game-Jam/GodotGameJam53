extends Node2D

class_name Order 

@export var _orderNumber : int
@export var toppingList = [ ]
@export var toppingsPlayerAdded = [ ]

var addonToppings = []

var _levelNumber := 0
var orderIncorrect = false

func newOrder(orderNumber : int, levelNumber : int) :
	_levelNumber = levelNumber
	_orderNumber = orderNumber
	toppingList = [] + Global.RequiredToppings
	
	match _levelNumber:
		1:
			addonToppings = Global.AddonToppings_Level1
		2:
			addonToppings = Global.AddonToppings_Level2
		3:
			addonToppings = Global.AddonToppings_Level3
			
	$Label.text = "Order# " + str(_orderNumber)
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	for topping in addonToppings : 
		if rng.randi_range(0, 1)  == 1 :
			toppingList.append(topping)
			
	for topping in toppingList :
		$ItemList.add_item(topping)

	for idx in $ItemList.item_count :
		$ItemList.set_item_selectable(idx, false)
	
func _process(delta):
	if (Global.GameState == Enum.GameplayState.MAINMENU or Global.GameState == Enum.GameplayState.WINNER):
		queue_free()
	
	match _levelNumber:
		1:
			position.x -= .1333	
		2:
			position.x -= .15	
		3:
			position.x -= .2	
	
	if (position.x < -10) :
		GameEvents.emit_signal("order_failed")
		queue_free()	
	
func _input(event):
	#if toppingState == Enum.ToppingState.ON_BURGER:
	if event.is_action_released("ui_touch"):
		for _a in $Area2D.get_overlapping_areas():
			if _a is Topping and _a.toppingState == Enum.ToppingState.ON_PANTRY : 
				_a.Placed()
				var foundInList = false
				$burger.AddTopping(_a.topping)
				for idx in $ItemList.item_count :
					if $ItemList.get_item_text(idx).to_upper() == _a.topping.to_upper() :
						foundInList = true
						if not toppingsPlayerAdded.has(_a.topping.to_upper()):
							toppingsPlayerAdded.append(_a.topping.to_upper())
							$ItemList.set_item_disabled(idx, true)
						
				if not foundInList:
					$WrongOrder.play()
					orderIncorrect = true
					if not toppingsPlayerAdded.has(_a.topping.to_upper()) :
						toppingsPlayerAdded.append(_a.topping.to_upper())
						$ItemList.add_item(_a.topping)
						$ItemList.set_item_custom_bg_color(($ItemList.item_count - 1), Color.RED)
	
		if not orderIncorrect and toppingList.size() == toppingsPlayerAdded.size():
			GameEvents.emit_signal("order_finished")
			queue_free()

func _on_reset_pressed():
	$burger.ResetBurger()
	orderIncorrect = false
	toppingsPlayerAdded = []
	
	# Reset the List of toppings the order wants
	var removeItems = []
	for idx in $ItemList.item_count :
		$ItemList.set_item_disabled(idx, false)
		if not toppingList.has($ItemList.get_item_text(idx).to_upper()) :
			removeItems.append(idx)
	
	# Because $ItemList freaks out
	removeItems.reverse()
	for idx in removeItems:		
		$ItemList.remove_item(idx)		


