## InteractablesInterface Class

The InteractablesInterface class is used to collect and interact with multiple [Interactable](interactable.md)s. The [Interactables](interactables.md) script extends this class, and a [Room](room.md)'s [`room_interactables`](room.md#room_interactables) property is also an InteractablesInterface. When executing a [Command](command.md), all the relevant InteractablesInterfaces available to the player are collected into a single InteractablesInterface which is passed to the [Command](command.md)'s `Callable`. It's a very important class!

## Functions

##### get_interactable

> **`get_interactable(interactable_identifier: String) -> Interactable`**

> Returns an [Interactable](interactable.md) registered to this InteractablesInterface with identifier `interactable_identifier`. If no [Interactable](interactable.md) with that identifier is found, returns `null`.

##### get_all_interactables

> **`get_all_interactables() -> Array[Interactable]`**

> Returns an `Array` of all the [Interactable](interactable.md)s registered to this InteractablesInterface.

##### add_interactable

> **`add_interactable(in_interactable: Interactable) -> void`**

> Registers an [Interactable](interactable.md) `in_interactable` to this InteractablesInterface.

##### add_interactables

> **`add_interactables(in_interactables: Array[Interactable]) -> void`**

> Registers all [Interactable](interactable.md)s in `in_interactable` to this InteractablesInterface.

##### attempt_interaction

> **`attempt_interaction(interactable_identifier: String, interaction_identifier: String, ...args: Array) -> Variant`**

> Attempts an interaction with identifier `interaction_identifier` on an [Interactable](interactable.md) with identifier `interactable_identifier` with any given arguments `args`. Arguments can be given as if they were regular arguments to this function; do not give them as an `Array`. If either no [Interactable](interactable.md) `interactable_identifier` is found or that [Interactable](interactable.md) does not have an interaction `interaction_identifier`, `null` will be returned; otherwise, the return value will be the value returned by the interaction.