extends Node
@export var monsters: Array[MonsterData] = []  # Array to store all monster instances

var party_members = {}  # Dictionary to store party members

func ready() -> void:
	# Manually adding monsters to the array when the game starts
	var all_members = get_members()
	print("Current Party: ")
	for member in all_members:
		print("Member Name: " + get_member(member).name + ", Level: ", member.level)

	add_monster("Slime", "Chew")
	add_monster("Slime")
	print("Current Party: ")
	all_members = get_members()
	
	for member in all_members:
		print("Member Name: " + member.nickname + ", Level: ", member.level)
	
	
	for key in party_members.keys():
		var member = party_members[key]
		print("Current Party Member Level: ", member.level)
	gain_exp(200)



# Gets all of the party members for their attributes
func get_members() -> Array:
	var members = []
	for key in party_members.keys():
		members.append(party_members[key])
	return members  # Returns an array of all party member objects

# Gets one party member based on the index for attributes
func get_member(index: int) -> MonsterData:
	if index in party_members:  # Check if the index exists in the party_members dictionary
		return party_members[index]
	else:
		print("Member not found at index:", index)
		return null  # Return null if the index does not exist



# Function to add a monster by name (loads from the monsters array)
func add_monster(name: String, nickname: String = name) -> void:
	for monster in monsters:
		#print(monster['name'])
		if monster['name'] == name:  # Check if the monster's name matches
			var new_monster = monster.duplicate()  # Duplicate the monster instance
			new_monster['nickname'] = nickname
			party_members[party_members.size()] = new_monster  # Add to party_members dictionary
			print(nickname, " added to the party.")
			return  # Exit the function after adding the monster

	print("Monster not found: ", name)  # If monster is not found, print an error message


# Function to gain experience for all party members
func gain_exp(amount: int) -> void:
	var party_size = party_members.size()
	
	# Check if there are no party members
	if party_size == 0:
		print("No party members to gain experience.")
		return
	
	# Distribute experience points evenly across party members
	var exp_to_add = amount / party_size
	for key in party_members.keys():
		var monster = party_members[key] as MonsterData
		monster.exp += exp_to_add
		
		# Check if the monster has leveled up
		while monster.exp >= monster.max_exp:
			var base_stats = [
				monster.power, monster.health, monster.defence,
				monster.accuracy, monster.speed, monster.spirit
			]
			monster.exp -= monster.max_exp  # Carry over leftover experience
			monster.level += 1
			monster.max_exp = calculate_next_level_exp(monster.level, monster.level_curve)  # Adjust based on level curve
			for base_stat in base_stats:
				base_stat = calculate_stat_growth(base_stat, monster.level_curve)
			print(monster.nickname, "leveled up to Level", monster.level)
	
	print("Experience distributed:", exp_to_add, "per member.")


func calculate_next_level_exp(level: int, curve: int) -> int:
	match curve:
		0:  # Super Fast
			return level * 10
		1:  # Fast
			return int(level * level * 0.8)
		2:  # Medium
			return int(level * level * 1.2)
		3:  # Slow
			return int(level * level * 1.0 + level * 5)  # Balanced between Fast and Slow
		4:  # Extra Slow
			return int(level * level * 1.5 + level * 10)  # More challenging growth
		_:
			return level * 10  # Default to linear if curve is invalid


func calculate_stat_growth(base_stat: int, level_curve: int) -> int:
	return int(base_stat * 1.07)  # Moderate growth balanced for medium leveling
