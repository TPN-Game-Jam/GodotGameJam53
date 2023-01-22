extends Node2D

func AddTopping(toppingName : String):
	match (toppingName.to_upper()):
		"BUN":
			$bun/ImageOnBurger.visible = true
			$buntop/ImageOnBurger.visible = true
		"BURGER":
			$burger_patty/ImageOnBurger.visible = true
		"CHEESE":
			$cheese/ImageOnBurger.visible = true
		"KETCHUP":
			$ketchup/ImageOnBurger.visible = true
		"LETTUCE":
			$lettuce/ImageOnBurger.visible = true
		"MAYO": 
			$mayo/ImageOnBurger.visible = true
		"MUSTARD": 
			$mustard/ImageOnBurger.visible = true
		"PICKLE": 
			$pickle/ImageOnBurger.visible = true
		"TOMATO":
			$tomato/ImageOnBurger.visible = true

func ResetBurger() -> void :
	$bun/ImageOnBurger.visible = false
	$buntop/ImageOnBurger.visible = false
	$burger_patty/ImageOnBurger.visible = false
	$cheese/ImageOnBurger.visible = false
	$ketchup/ImageOnBurger.visible = false
	$lettuce/ImageOnBurger.visible = false
	$mayo/ImageOnBurger.visible = false
	$mustard/ImageOnBurger.visible = false
	$pickle/ImageOnBurger.visible = false
	$tomato/ImageOnBurger.visible = false
	
