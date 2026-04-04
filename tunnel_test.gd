extends Node

var peer = NodeTunnelPeer.new()

func _ready():
	multiplayer.multiplayer_peer = peer
	# Connect to the free public relay
	# Note that this **must** be done before hosting/joining
	peer.connect_to_relay("relay.nodetunnel.io", 9998)
	await peer.relay_connected
	print("Connected! Your ID: ", peer.online_id)
