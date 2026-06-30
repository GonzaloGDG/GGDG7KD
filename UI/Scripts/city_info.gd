extends NinePatchRect

@onready var option_button: OptionButton = $NinePatchRect/OptionButton

func _ready():
	option_button.clear()
	for tax in GameResources.TaxLevel.keys():
		option_button.add_item(tax, GameResources.TaxLevel[tax])

func update(c: City) -> void:
	self.visible = true
	$NinePatchRect/Population.text = "Population: " + str(c.citizen_manager.get_population())
	$NinePatchRect/Idle.text = "Idle: " + str(c.citizen_manager.get_count_idle_citizens())
	$NinePatchRect/image.texture = c.icon.texture
	$NinePatchRect/Name.text =c.city_name
	option_button.select(c.tax_level) 
	
