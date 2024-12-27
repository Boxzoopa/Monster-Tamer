extends Node

@export var monsters: Array[MonsterData] = []  # Array to store all monster instances
var party_members: Dictionary = {}  # Dictionary to store party members

func ready() -> void:
	# Initialize party and display current members
	add_monster("Slime", "Chewy")
	add_monster("Slime")
	display_party()

	# Distribute some experience as an example
	gain_exp(200)


# Displays all current party members
func display_party() -> void:
	var all_members = get_members()
	Config.debug_msg(str("Current Party:"))
	for member in all_members:
		Config.debug_msg(str("Member Name:", member.nickname, "Level:", member.level))


# Gets all of the party members as an array
func get_members() -> Array:
	var members = []
	for key in party_members.keys():
		members.append(party_members[key])
	return members  # Returns an array of all party member objects


# Gets a party member based on a dictionary key
func get_member(index: int) -> MonsterData:
	if index in party_members:  # Check if the index exists in the party_members dictionary
		return party_members[index]
	else:
		Config.debug_msg(str("Member not found at index:", index))
		return null  # Return null if the index does not exist


# Function to add a monster by name (loads from the monsters array)
func add_monster(name: String, nickname: String = "") -> void:
	for monster in monsters:
		if monster['name'] == name:  # Check if the monster's name matches
			var new_monster = monster.duplicate()  # Duplicate the monster instance
			new_monster['nickname'] = nickname if nickname != "" else name  # Use name if no nickname is given
			party_members[party_members.size()] = new_monster  # Add to party_members dictionary
			Config.debug_msg(str(nickname, "added to the party."))
			return  # Exit the function after adding the monster

	Config.debug_msg(str("Monster not found:", name))  # If monster is not found, print an error message


# Function to gain experience for all party members
func gain_exp(amount: int) -> void:
	var party_size = party_members.size()
	
	# Check if there are no party members
	if party_size == 0:
		Config.debug_msg(str("No party members to gain experience."))
		return
	
	# Distribute experience points evenly across party members
	var exp_to_add = amount / party_size
	for key in party_members.keys():
		var monster = party_members[key] as MonsterData
		monster.exp += exp_to_add
		
		# Check if the monster has leveled up
		while monster.exp >= monster.max_exp:
			monster.exp -= monster.max_exp  # Carry over leftover experience
			monster.level += 1
			monster.max_exp = calculate_next_level_exp(monster.level, monster.level_curve)  # Adjust based on level curve
			update_monster_stats(monster)  # Update stats based on level curve
			Config.debug_msg(str(monster.nickname, "leveled up to Level", monster.level))
	
	Config.debug_msg(str("Experience distributed: ", exp_to_add, "per member."))


# Calculate the experience needed for the next level
func calculate_next_level_exp(level: int, curve: int) -> int:
	match curve:
		0: return level * 10  # Super Fast
		1: return int(level * level * 0.8)  # Fast
		2: return int(level * level * 1.2)  # Medium
		3: return int(level * level * 1.0 + level * 5)  # Slow
		4: return int(level * level * 1.5 + level * 10)  # Extra Slow
		_: return level * 10  # Default


# Update monster stats after leveling up
func update_monster_stats(monster: MonsterData) -> void:
	var base_stats = [
		monster.power, monster.health, monster.defence,
		monster.accuracy, monster.speed, monster.spirit
	]
	for i in range(base_stats.size()):
		base_stats[i] = calculate_stat_growth(base_stats[i], monster.level_curve)


# Calculate stat growth
func calculate_stat_growth(base_stat: int, level_curve: int) -> int:
	return int(base_stat * 1.07)  # Moderate growth
