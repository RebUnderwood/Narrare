# Interactables Script

The Interactables script (Scripts/Interactables.gd) should be used to store any [Interactable](interactable.md)s that need to be accessed across [Room](room.md)s, i.e. [Interactable](interactable.md)s that can be added to the player's inventory (see [Data](data.md)) or [Interactable](interactable.md)s that move between different [Room](room.md)s. For [Room](room.md)-specific [Interactable](interactable.md)s, use that [Room](room.md)'s [`room_interactables`](room.md#room_interactables) property.

The Interactables script extends [InteractableInterface](interactablesinterface.md), so for more detailed information at associated methods, look there.

[Interactable](interactable.md)s within a given [InteractableInterface](interactablesinterface.md) (like the Interactables script) should all be given *unique* identifiers. The identifier should be identical to the name of the object you want the player to use to interact with it, i.e. if you want the player to be able to type "open box" then the identifier for that [Interactable](interactable.md) should be "box".

[Interactable](interactable.md)s in this script will *override* [Interactable](interactable.md)s with the same identifier in a [Room](room.md)'s [`room_interactables`](room.md#room_interactables) property, so consider anything defined here to be a unique object that should not be replicated elsewhere.

## Tutorial

Let's look at how to add [Interactable](interactable.md)s. Let's make a new [Interactable](interactable.md) called 'box' in our Interactables script:

```gdscript
var box_interactable = Interactable.new("box");
```

It doesn't have any interactions, so it's pretty useless right now. Let's add one called 'open':

```gdscript
box_interactable.add_interaction("open", func () -> String: return "There's nothing inside! What a rip-off.")
```

Now, we can register our box to the Interactables script by calling [`add_interactables`](interactablesinterface.md#add_interactables) in the script's `_ready()` function:

```gdscript
func _ready() -> void:
	add_interactables([
		box_interactable,
	]);
```

And that's it! Now we can access that interactable by name from anywhere in the project with [`get_interactable`](interactablesinterface.md#get_interactable) or attempt an interaction with it with [attempt_interaction](interactablesinterface.md#attempt_interaction):

```gdscript
var gotten_box = Interactables.get_interactable("box");

print(Interactables.attempt_interaction("box", "open"));
```