extends Node
class_name AuthorityManager

@rpc("any_peer", "call_local")
func claim_authority(node_path : String):
	var node = get_node(node_path)
	node.set_multiplayer_authority(get_multiplayer_authority())
	print(node, " has been claimed by peer number ", get_multiplayer_authority())
	print("this function happened on peer ", get_multiplayer_authority())

@rpc("any_peer", "call_local")
func release_authority(node_path : String):
	var node = get_node(node_path)
	node.set_multiplayer_authority(1)
	print(node, " is no longer claimed by by peer number ", get_multiplayer_authority())
	print("this function happened on peer ", get_multiplayer_authority())
