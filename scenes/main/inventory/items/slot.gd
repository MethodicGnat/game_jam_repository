extends ColorRect


@onready var item_display: TextureRect = $Sprite2D
@onready var count: Label = $Count

func update(item: Item):
	if !item:
		item_display.visible = false
	else:
		item_display.visible = true
		item_display.texture = item.texture
		count.text = str(item.count)
