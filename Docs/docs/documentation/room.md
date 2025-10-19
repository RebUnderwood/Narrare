# Room Class

A Room represents a physical area in the game which the player can travel to and/or be in. It does not have to physically be a room—a garden could be a Room, or part of a hallway, or a graveyard. It's just a container meant to represent a defined area in the game world.

You will typically work with Rooms as children of a [Map](map.md) node.

## Exits

A Room has ten defined exits; eight in compass directions, one up and one down. These are represented as variables with the following naming convention: [`exit_<direction>`](#exit_direction). For example, the exit to the southeast is `exit_southeast`. The exit up is `exit_up`. The exist down is `exit_down`. By default, these variables are set to `null`; to make an exit work, the intended direction's variable should beset as a refrence to another Room. For example, if we have two Rooms, LeftRoom and RightRoom, and LeftRoom is located to the west of RightRoom, LeftRoom's `exit_east` variable should be set to RightRoom, and likewise RightRoom's `exit_west` should be set to LeftRoom. This will enable the correct navigation between the two Rooms. These variables are all exports, so they can be easily set in the editor.

## Describing a Room

When looking at a Room or entering one, it is important that the Room be described to the player. In order to do this with some flexibility, multiple variables and functions have been provided to do this.

The primary description of a Room should be housed within the [`look_description`](#look_description) variable. This is the description that should be provided when the player looks at the room, and should include information such as what exits are available and any [Interactables](interactable.md) that may be present.

However, there may be cases where the description needs to change depending on outside factors. In order to achieve this, simply override the Room base class' [`look()`](#look) function to return a different string:

```gdscript
func look() -> String:
	if !Data.screwdriver_taken:
		return "There is an echo in here. There is a [sign] on the wall. Sitting on a table in the corner is a [screwdriver]. A door to the west leads to the Right Room."
	else:
		return "There is an echo in here. There is a [sign] on the wall. An empty table sits in the corner. A door to the west leads to the Right Room.";
```

By default, all the [`look()`](#look) function does is return the [`look_description`](#look_description) variable, so you don't need to accomodate any special logic here.

In addition to the [`look_description`](#look_description) variable, there are also the [`entry_description`](#entry_description) and [`enter_<direction>_text`](#enter_direction_text) variables. Both are used in the Room's [`enter()`](#enter) function.

When navigating into a new Room, the resulting description that is shown to the player comes from calling that room's [`enter()`](#enter) function. [`enter()`](#enter) combines several descriptions (including the one produced by[`look()`](#look)) into one description, which it returns. These descriptions are in the following way:

```plaintext
room_name
enter_<direction>_text entry_description look()
```

[`room_name`](#room_name) is the name of the room, i.e. "Left Room".

[`enter_<direction>_text`](#enter_direction_text) is a `String` corresponding to the direction the Room was entered from. There is an [`enter_<direction>_text`](#enter_direction_text) for each [`exit_<direction>`](#exit_direction): `exit_southeast` corresponds to `enter_southeast_text`, etc. For example, "You leave the Right Room, shutting the door behind you."

[`entry_description`](#entry_description) is something that is described when you are in the Room, i.e. "You are now in the Left Room."

So, with the previous examples, calling [`enter()`](#enter) produces the following description:

```plaintext
Left Room
You leave the Right Room, shutting the door behind you. You are now in the Left Room. There is an echo in here. There is a [sign] on the wall. An empty table sits in the corner. A door to the west leads to the Right Room.
```
---

## Variables

##### exit_<direction\>

> **`exit_<direction>: Room`**

> A set of variables dictating the exits to a Room. There is a corresponding variable for every compass direction as well as up and down. For example, the exit to the southeast is `exit_southeast`. The exit up is `exit_up`. The exist down is `exit_down`. If there is no exit in a given direction, that direction's exit variable should be set to null. Otherwise, it should be set to the Room that is reached by travelling in that direction.

##### enter_<direction\>\_text

> **`enter_<direction>_text: String`**

> A set of variables that can be used to provide additional description when entering a Room from a specific direction. There is an `enter_<direction>_text` for every `exit_<direction>`.

##### entry_description

> **`entry_description: String`**

> Used to provide an additional description when entering a room.

##### look_description

> **`look_description: String`**

> Used to provide a description of the Room.

##### room_name

> **`room_name: String`**

> In the default [`look()`](#look) function, this is returned. Provides a convenient way to set the description of a Room for Rooms whose description does not change.

##### interactables

> **`interactables: Array[String]`**

> An array of [Interactable](interactable.md) identifier strings. These can be defined either in the [Interactables](interactables.md) script or in this Room's [`room_interactables`](#room_interactables) property.

##### room_interactables

> **`room_interactables: InteractablesInterface`**

> Used to hold *room specific* [Interactable](interactable.md)s. These should be [Interactable](interactable.md)s that will never leave this room or be used elsewhere; therefore, they can share identifiers with other [Interactable](interactable.md)s in *other Rooms*. Notably, they will still be overridden by [Interactable](interactable.md)s with the same identifier in the [Interactables](interactables.md) script. For more information on how to interact with this property, see [InteractablesInterface](interactablesinterface.md).

---

## Functions

##### get_room_in_direction

> **`get_room_in_direction(direction: Narrare.Direction) -> Room`**

> Returns the Room in the corresponding exit to `direction`, where `direction` is a [`Narrare.Direction`](narrare_global_script.md#direction). Returns `null` if there is no Room in that exit.

##### look

> **`look() -> String`**

> By default, returns the value of [`look_description`](#look_description), but can be overridden for custom behaviour.

##### enter

> **`enter(from: Room) -> String`**

> BCompiles a description of the player entering the room from [`room_name`](#room_name), [`enter_<direction>_text`](#enter_direction_text), [`entry_description`](#entry_description), and [`look()`](#look). `from` should be the Room that the player was in before entering this one. Note: does not actually change the player's position in the map; see [`Map`](map.md) for information on how to do that.

##### enter_trigger

> **`enter_trigger() -> void`**

> By default, does nothing, but is called when the Room is entered. Override with custom behaviour if needed.

##### exit_trigger

> **`exit_trigger() -> void`**

> By default, does nothing, but is called when the Room is exited. Override with custom behaviour if needed.