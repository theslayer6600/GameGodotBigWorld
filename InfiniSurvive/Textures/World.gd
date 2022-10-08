extends Node2D

export(Script) var game_save_class #Game Save Code
var chunk_data = [] #The chunks tile data
var world_size = 100 #Size Of The World
var chunk_size = 20 #Size Of Chunks make sure this is dividable by the world size or you can get some weird bugs
var world_type = 0 #Type i am going to use when im developing the game [SOURCE CODE WILL NOT BE UPLOADED IT WILL BE MY OWN PROJECT]
var load_x_min = 0 #From 0
var load_x_max = world_size + chunk_size #Saves how large your world is to save
var load_y_min = 0 #From 0
var load_y_max = world_size + chunk_size #Saves how large your world is to save
var x_gen = 0 #What stage of gen the x axis should generate
var y_gen = 0 #What stage of gen the y axis should generate
onready var generation_iter = world_size/chunk_size #How Many Chunks can fit. [world size]400/[chunk size]100 = 4 
var time = 0 #Time
var debug_time = 0 #Debug Time
var elapsed = 0 #Elapsed Time
var x_minimum = 0 #Positions of generating area
var x_maximun = 0 #Positions of generating area
var y_minimum = 0 #Positions of generating area
var y_maximun = 0 #Positions of generating area

func _ready():
	var dir = Directory.new()
	if dir.dir_exists("res://World_Save/"): #Checks if world is made if is made deletes generator timer
		$Generate_Chunk.queue_free()
	time = OS.get_unix_time()

func _process(delta):
	if Input.is_action_just_pressed("load"): #Click key to load
		load_world()
	if Input.is_action_just_pressed("Check_Cur_Fors"): #Click key to save
		save_world()
	if Input.is_action_just_pressed("Check_Cur_Fors"):
		print("Position_X ",x_minimum," ", x_maximun)
		print("Position_Y ",y_minimum," ", y_maximun)
	#Get The For in [X and Y]
	x_maximun = x_gen * chunk_size + chunk_size
	x_minimum = x_maximun - chunk_size
	y_maximun = y_gen * chunk_size + chunk_size
	y_minimum = y_maximun - chunk_size
	debug_time = OS.get_unix_time()
	elapsed = time - debug_time

func _on_Load_Next_Chunk_timeout():
	print("X_Gen", x_gen)
	print("Y_Gen", y_gen)
	print(elapsed)
	if x_gen >= generation_iter and y_gen < generation_iter: #Itterates through the generation axis
		x_gen = -1
		y_gen += 1
	for x in range(x_minimum, x_maximun): #Generates in this range on x
		for y in range(y_minimum, y_maximun): #Generates in this range on y
			$Tiles.set_cell(x,y,1) #Sets tile to water [no code for generating worlds yet]
	if x_gen < generation_iter: #If is lower than generation itter add one to x
		x_gen += 1
	else:
		$Generate_Chunk.queue_free() #Stop timer that controls what chunks is generated [not the best way to do it but works]

func save_world():
	var new_save = game_save_class.new() #Creates a instance of saving script
	
	chunk_data.clear() #Clears array first so file size doesnt double what it is
	
	for x in range(load_x_min, load_x_max): #Loops through the world and saves
		chunk_data.append([]) #append the x axis to a seperate array in array
		for y in range(load_y_min, load_y_max): #Loops through the world and saves
			chunk_data[x].append($Tiles.get_cell(x,y)) #Appends the tile data on the x axis [easy to acess]
	
	new_save.tiles = chunk_data #Sets the save to chunk data
	
	var dir = Directory.new() #Directory
	if not dir.dir_exists("res://World_Save/"): #Make directory if directiory doesnt exist
		dir.make_dir_recursive("res://World_Save/") #Makes directory
	
	ResourceSaver.save("res://World_Save/World_Data.tres",new_save) #Saves [Gonkee [old] made this code it is good and efficient Youtube: https://www.youtube.com/c/Gonkee]

func load_world():
	var dir = Directory.new()
	if not dir.file_exists("res://World_Save/World_Data.tres"): #Checks if file exists
		return false #If not dont load
	
	var world_save = load("res://World_Save/World_Data.tres") #Loads world save file
	
	for x in range(load_x_min, load_x_max): #For x in map size + 100 load
		for y in range(load_y_min, load_y_max): #For y in map size + 100 load
			$Tiles.set_cell(x,y,world_save.tiles[x][y]) #Sets tiles in map size
