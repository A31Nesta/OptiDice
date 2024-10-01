# OptiDice
3D Physics based Dice app for WearOS. Tested in WearOS 3.5 and WearOS 4

![screenshot1](https://github.com/user-attachments/assets/36b56ee2-e8a0-4eb7-a246-d4d0ed5ff6dc)
![optidiceCoin](https://github.com/A31Nesta/OptiDice/assets/92674974/b328bc8b-cdc1-4da8-8015-1d7efe627b00)


# How to use the app
Just move your wrist, it uses the accelerometer and the gyroscope to roll the dice.

## Freeze dice
Tap the screen once to prevent the dice from moving when you move your wrist, this is useful if you want to show someone the results.
Pro Tip: Tapping can create a little acceleration that can be detected by the dice if they're already on the board, to prevent this you can tap the screen while the dice are in the air

## Add more dice!
Double tapping the screen brings up a menu to add more dice. You can add from D4s to D100s, when you're done just press the ROLL button.  
You can also add coins!

![roll dice](https://github.com/user-attachments/assets/b03cf198-f2ee-42bd-8db4-dfa61dc3103a)


---
# Bonus feature
The dice have 3 different materials (for now) that are selected randomly when you generate the dice.

# Roadmap
- Refactor the code
- Make the config menu not ugly
- Edit the export thing so that the app gets recognized as an actual WearOS app

---
# What is that name?
I just thought "Hey I want to make dice optimized for watches" so from "Optimize" and "Dice" I ended up with OptiDice

## Are the dice really optimized?
Opening the app takes a little while and opening the menu for the first time freezes for a second but the rest of the time the app runs really smoothly. I tested with quite a lot of dice and it worked pretty well (on the Galaxy Watch 4 at least)

Also I created a custom shader for the dice that should improve performance (and graphics), no actual lights or physically based rendering is being done, it's simply Gouraud shading without specular reflections on the vertex shader and an extra "light" being multiplied in the fragment shader when the object is below a certain Y coordinate.
