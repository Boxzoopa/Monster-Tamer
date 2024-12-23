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
			monster.exp -= monster.max_exp  # Carry over leftover experience
			monster.level += 1
			monster.max_exp = int(monster.max_exp * 1.3)  # Increase max_exp by 30%
			print(monster.nickname, "leveled up to Level", monster.level)

	print("Experience distributed:", exp_to_add, "per member.")
