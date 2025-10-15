extends DataBase

# === DATA ===
# Use this file to store information to be used across your game.
# Things like event flags, a player's name, anything you need to 
# keep track of your game state. They should be made variables.
# This script is a global and variables can be accessed using 
# Data.your_variable .
#
# IMPORTANT: Everything in this file needs to be able to be 
# converted into JSON via JSON.stringify(). This is because 
# the contents of this script are converted into a dictionary 
# and stored in a json file when Narrare.save() is called.

# === Put your data here ===
var player_name: String = "Stranger";
var lamp_on: bool = false;
var lamp_unscrewed: bool = false;
var screwdriver_taken: bool = false;
