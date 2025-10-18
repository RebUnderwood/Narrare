# Interactable Class

In Narrāre, objects and people and anything you can interact with in a game are defined as an Interactable. Interactables may have multiple *interactions*, which define the ways an Interactable can be interacted with.

Interactables are identified by an identifier, which is a `String` that is unique to them within their context. The identifier should be the exact string you want the player to interact with this Interactable using. For example, if you want the player to be able to type "open box" then the identifier for that Interactable should be "box".

## Constructing an Interactable

You can construct an Interactable using `Interactable.new(identifier: String)`. Let's make a new Interactable with the identifier 'box':

```gdscript
var box_interactable: Interactable = Interactable.new("box");
```

Great! We now have an Interactable. Let's add some interactions next using [add_interaction](#add_interaction):

```gdscript
box_interactable.add_interaction("look", func () -> String: return "It's a box!");
box_interactable.add_interaction("open", func () -> String: return "There's nothing inside! What a rip-off.")
```

Now we have two ways we can interact with this Interactable: 'look' and 'open'.

Incidentally, these methods can be chained, which results in slightly cleaner code:
```gdscript
var box_interactable: Interactable = Interactable.new("box")\
	.add_interaction("look", func () -> String: return "It's a box!")\
	.add_interaction("open", func () -> String: return "There's nothing inside! What a rip-off.");
```

Now that we have some interactions, we can attempt an interaction with [`attempt_interaction`](#attempt_interaction):

```gdscript
print(box_interactable.attempt_interaction("open", [])); # prints, 'There's nothing inside! What a rip-off.'
```

Note that you will typically not have to use this method; instead, you will usually be working through an [InteractablesInterface](interactablesinterface.md) and should instead use that class' [`attempt_interaction`](interactablesinterface.md#attempt_interaction) method.

## Functions

##### add_interaction

> **`add_interaction(interaction_identifier: String, interaction: Callable) -> Interactable`**

> Adds an interaction to this Interactable. The interaction will be identified by `interaction_identifier`. `interaction` should be a callable; it can take any number of arguments (it is called using [`Callable.callv`](https://docs.godotengine.org/en/stable/classes/class_callable.html#class-callable-method-callv), meaning you don't have to worry about unpacking arguments when called from [`attempt_interaction`](#attempt_interaction)) and can return whatever you want, though typically this will be a `String` which will be output to the player. This method returns `self`, making it chainable.

##### attempt_interaction

> **`attempt_interaction(interaction_identifier: String, args: Array) -> Variant`**

> Attempts to call the interaction with identifier `interaction_identifier` and arguments `args` (it is called using [`Callable.callv`](https://docs.godotengine.org/en/stable/classes/class_callable.html#class-callable-method-callv), meaning you don't have to worry about unpacking args) If the interaction exists within this Interactable, the result of the interaction `Callable` will be returned. If it doesn't exist, `null` is returned.