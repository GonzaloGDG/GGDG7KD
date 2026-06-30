extends NinePatchRect

const DETAIL_SCENE = preload("res://UI/DetailScene.tscn")

func update(bt: BuildingScene) -> void:
	self.visible = true
	$NinePatchRect/image.texture = bt.building_type.icon
	$NinePatchRect/Name.text = GameResources.Buildings.keys()[bt.building_type.type]
	$NinePatchRect/WorkersButton/image.texture = bt.building_type.worker_icon
	var workers = bt.workers.size()
	$NinePatchRect/WNumber.text = str(workers) + "/" + str(bt.building_type.max_workers)
	for resource in bt.building_type.resources:
		var detail = DETAIL_SCENE.instantiate()
		for child in $NinePatchRect/GridContainer.get_children():
			child.queue_free()
		$NinePatchRect/GridContainer.add_child(detail)
		detail.setup(resource.icon, bt.building_type.resource_per_worker * workers)
	
