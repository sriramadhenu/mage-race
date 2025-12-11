# Mage Race #

## Summary ##

**Mage Race is a 2D puzzle-platformer where players embark on a quest as a wizard to restore balance to the magical realm of Valenor. After dark mages stole relics and created evil spells, your role is to battle through treacherous levels spanning forests, ice caverns, and volcanic landscapes to defeat enemies and reclaim artifacts. Master your attacks while navigating through this challenging terrain to become the mage that saves Valenor!**

## Project Resources

[Try our Game!](https://sriramadhenu.itch.io/mage-race)  
[Proposal Document](https://docs.google.com/document/d/1TKdwR71jKnw42CS0OGpTujwn_lJmPJQjXw_Rr52OSoA/edit?usp=sharing)  

## Gameplay Explanation ##

**Controls:**

**Movement:**

* A - Move Left
* D - Move Right
* Space/W - Jump (Hold for increased height, let go for fast-fall)
* Left Shift/Right Shift - Dash (Can be used twice, has a cooldown of 1 second)

**Combat:**

* Left Click/F - Attack (Facing default direction)
* J - Attack Left
* L - Attack Right

* Menu:
* Esc - Pause Menu

**How to Play:**

**Launch the game to see the main menu, then press "Start". Choose between Forest, Ice, and the Lava levels. Each level can be replayed at any time, and the player can switch to a different level by navigating to the pause menu.**

**Health**

**You have 5 hearts everytime you start a level or respawn, which is displayed in the top-left corner. Taking damage from killzones, jumping off the map, or enemy attacks will either remove some or all of your hearts, so be mindful! If you die, you will automatically respawn at the start of the level after a 2-second death animation, with your hearts replenished.**

**Combat**

**Use your attacks to fight enemies from a safe distance, or dare to out-run them! Different enemies have different attack styles - experiment their movement and fighting logic to devise the most effective strategy.**

**Movement Tips**

**As for level navigation, remember to use the dash ability to cover long distances or escape danger. Holding horizontal and vertical movement (W/Space with A/D), as well as timing your dash(es) at the apex of your jump is recommended to cover the most amount of ground. Remember to disable the sticky keys shortcut (5x shift), if you have it enabled.**

**Add it here if you did work that should be factored into your grade but does not fit easily into the proscribed roles! Please include links to resources and descriptions of game-related material that does not fit into roles here.**

# External Code, Ideas, and Structure #

If your project contains code that: 1) your team did not write, and 2) does not fit cleanly into a role, please document it in this section. Please include the author of the code, where to find the code, and note which scripts, folders, or other files that comprise the external contribution. Additionally, include the license for the external code that permits you to use it. You do not need to include the license for code provided by the instruction team.

If you used tutorials or other intellectual guidance to create aspects of your project, include reference to that information as well.

# Team Member Contributions

This section be repeated once for each team member. Each team member should provide their name and GitHub user information.

The general structures is 
```
Team Member 1
  Main Role
    Documentation for main role.
  Sub-Role
    Documentation for Sub-Role
  Other contribtions
    Documentation for contributions to the project outside of the main and sub roles.

Team Member 2
  Main Role
    Documentation for main role.
  Sub-Role
    Documentation for Sub-Role
  Other contribtions
    Documentation for contributions to the project outside of the main and sub roles.
...
```

For each team member, you should include work of your role and sub-role in terms of the content of the course. Please look at the role sections below for specific instructions for each role.

Below is a template for you to highlight items of your work. These provide the evidence needed for your work to be evaluated. Try to have at least four such descriptions. They will be assessed on the quality of the underlying system and how they are linked to course content. 

*Short Description* - Long description of your work item that includes how it is relevant to topics discussed in class. [link to evidence in your repository](https://github.com/dr-jam/ECS189L/edit/project-description/ProjectDocumentTemplate.md)

Here is an example:  
*Procedural Terrain* - The game's background consists of procedurally generated terrain produced with Perlin noise. The game can modify this terrain at run-time via a call to its script methods. The intent is to allow the player to modify the terrain. This system is based on the component design pattern and the procedural content generation portions of the course. [The PCG terrain generation script](https://github.com/dr-jam/CameraControlExercise/blob/513b927e87fc686fe627bf7d4ff6ff841cf34e9f/Obscura/Assets/Scripts/TerrainGenerator.cs#L6).

You should replay any **bold text** with your relevant information. Liberally use the template when necessary and appropriate.

Add addition contributions int he Other Contributions section.

## Jacob Parker (DevBlocky)

**Main Role: AI/Behavior**

This game includes three enemies, a unique one for each level: The forest level has the orc, the ice level has the skeleton archer, and the lava level has the slime. The orc and skeleton archer enemies are implemented as state machines, which is one of the methods brought up in class for NPCs. These enemies were changed to the state machine behavior after the playtest because of feedback from people saying the enemies were too easy. You can find them implemented [here (orc_enemy.gd)](https://github.com/sriramadhenu/mage-race/blob/main/scripts/enemies/orc_enemy.gd) and [here (skeleton_enemy.gd)](https://github.com/sriramadhenu/mage-race/blob/main/scripts/enemies/skeleton_enemy.gd). For the skeleton archer, it also needed an arrow scene and a way to target the player (really the player's position). You can find the arrow implemented [here](https://github.com/sriramadhenu/mage-race/blob/main/scripts/projectiles/arrow.gd). Since the lava level is focused on platforming, the slime enemy just acts as an annoyance to the player by knocking them off platforms and damaging them if they get too close. The slime is simply implemented as a crawling enemy, it will rotate around a platform clockwise. You can find the slime implemented [here](https://github.com/sriramadhenu/mage-race/blob/main/scripts/enemies/slime_enemy.gd).

**Sub Role: Game Feel**

After feedback from the playtest, looking at the game feel slides, and consulting the team, we implemented many game feel improvements to our game. One of the areas we focused on was movement, specifically the jump. We implemented the ability to [cancel your jump](https://github.com/sriramadhenu/mage-race/blob/19eeb69c0e38be01fc40b611866efbef297cca0c/scripts/player/player.gd#L48-L49) (i.e. if you stop holding space, you start falling immediately) as well as [faster gravity when falling](https://github.com/sriramadhenu/mage-race/blob/19eeb69c0e38be01fc40b611866efbef297cca0c/scripts/character.gd#L108-L111). Preventing the player from [dashing through enemies](https://github.com/sriramadhenu/mage-race/blob/19eeb69c0e38be01fc40b611866efbef297cca0c/scripts/player/player.gd#L193-L202) was also implemented. Finally, the ice spell was improved so that it [followed the player while forming](https://github.com/sriramadhenu/mage-race/blob/19eeb69c0e38be01fc40b611866efbef297cca0c/scripts/player/player.gd#L104-L119) and only left the player's scene when fired.

**Other Contributions**

Since I was already working on projectiles, I implemented the [ice spell](https://github.com/sriramadhenu/mage-race/blob/main/scripts/projectiles/ice_spell.gd) that the player uses in the game. I also imported and setup the animation sprites for each of the characters (player and enemies).


## Sri Krishanu Ramadhenu (sriramadhenu)

**Main Role: Game Logic**

My main work was on the player, health, and level/respawn systems. I wired the player’s damage and knockback into a shared character health system so that taking damage reduces hearts, [emits a health-changed signal](https://github.com/sriramadhenu/mage-race/blob/799b07b00b38df7b2a8baa0cb287d3e943c158c7/scenes/ui/hud/hud.gd#L26-L30), and can trigger death and respawn [link (minus the _on_prevent_dash_zone_body_entered function)](https://github.com/sriramadhenu/mage-race/blob/116efa511dc15851b5f8b1537c40f7056614a5ad/scripts/player/player.gd#L164-L209). The [game manager](https://github.com/sriramadhenu/mage-race/blob/58be39db4ee792ece815b2e8c7f2b71eb4bd0a59/scripts/managers/game_manager.gd#L1-L74) keeps track of what level the player is currently on (or the pause/main menu), and makes changes to the entire system accordingly. The [level manager](https://github.com/sriramadhenu/mage-race/blob/58be39db4ee792ece815b2e8c7f2b71eb4bd0a59/scripts/managers/level_manager.gd#L1-L34) keeps track of the level that is being displayed and changes the scene accordingly.

**Sub Role: Build and Release Management**

For this role, I made a clear [workflow](https://github.com/sriramadhenu/mage-race/blob/main/README.md) for my teammates in the README.md. I was in charge of checking out feature branches pushed by my teammates and making sure things worked as they intended. If so, I then merged the develop build with their feature branch, taking care of conflicts when they occured, and tested once again to ensure the combined build ran without issues. Finally, if everything worked, I pushed the changes to the develop branch. Therefore, the develop branch contained a playable version with updated work from every role each week.

Here is the list of commits I (SaltyGamer829) made to develop (Not sure why it addresses me by my old github username, as my new one is actually sriramadhenu):
[Develop branch commit history](https://github.com/sriramadhenu/mage-race/commits/develop)

This role required me to communicate with my teammates a lot about work that has been committed, as well as changes that need to be made in each role before I can merge to develop. Oftentimes, I tried to look into these changes myself, so I will list the most important contributions/additions in the next section. All in all, I learned a lot about version control and team collaboration.

**Other Contributions**

I created the final obstacle in the forest level, adding a collision shape to a button that removed a purple barrier with a fading animation when the player contacted the button (the animation took me too long to figure out, I'm not a visuals person). [button file](https://github.com/sriramadhenu/mage-race/blob/116efa511dc15851b5f8b1537c40f7056614a5ad/scenes/levels/green_button.gd#L1-L17). [wall file](https://github.com/sriramadhenu/mage-race/blob/116efa511dc15851b5f8b1537c40f7056614a5ad/scenes/levels/purple_wall.gd#L1-L10).

I also modified the player controls to implement [directional shooting](https://github.com/sriramadhenu/mage-race/blob/116efa511dc15851b5f8b1537c40f7056614a5ad/project.godot#L61-L76), [paused movement while attacking (grounded)](https://github.com/sriramadhenu/mage-race/blob/116efa511dc15851b5f8b1537c40f7056614a5ad/scripts/player/player.gd#L50-L63), [and mechanics that didn't allow dashing and shooting simultaneously].

I added [killzones](https://github.com/sriramadhenu/mage-race/blob/116efa511dc15851b5f8b1537c40f7056614a5ad/scripts/killzone.gd#L1-L16) to each level, so if the player jumped off the map and came in contact with this zone below the map, they would lose all their health.

Similarly, I added [spikes](https://github.com/sriramadhenu/mage-race/blob/58be39db4ee792ece815b2e8c7f2b71eb4bd0a59/scenes/levels/ice_spikes.gd#L1-L16) that hurt the player and caused knockback in the ice level.


## Frank Wem Guang Zhu (Frank-111)

**Main Role: Level and World Designer**

As the level and world designer for the game, my primary goal was to craft the magical realm of Valenor. We created three levels with three separate themes (Lava, Forest, and Ice). Each level uses different tilesets corresponding to its theme. I created the three base layouts for the levels, made adjustments to the layout as the project progressed, and helped gather assets. I also created most of the object scenes to be placed within the levels and positioned them accordingly.

Our group separated the work into different branches to minimize conflicts when merging into the main or development branches. Here are the branches I worked on and my commits:
[Base-level-layout](https://github.com/sriramadhenu/mage-race/commits/Base-layout-levels)
[level-improvment](https://github.com/sriramadhenu/mage-race/commits/level-improvement)

**Sub Role: Tutorial Design**

For this role, I created a "How to Play" option that can be accessed from the main menu scene. It describes the basic movement and combat controls, helping players understand how to overcome obstacles in each level. The "How to Play" scene also includes a back button that returns the player to the main menu when pressed.
[BackButton](https://github.com/sriramadhenu/mage-race/blob/ee99234c252524eace5437f33d643e3682d93cd3/scenes/ui/how_to_play.gd#L6)
[How to Play menu](https://github.com/sriramadhenu/mage-race/blob/ee99234c252524eace5437f33d643e3682d93cd3/scenes/levels/main_menu.gd#L15)

**Other Contributions**

I implemented the [pushable block](https://github.com/sriramadhenu/mage-race/blob/ee99234c252524eace5437f33d643e3682d93cd3/scripts/character.gd#L81)
 in the forest level, allowing the player to progress through the level by moving obstacles. 

I also implemented the code for the [destructible objects](https://github.com/sriramadhenu/mage-race/blob/ee99234c252524eace5437f33d643e3682d93cd3/scenes/levels/destructible_wall.gd#L1). These destructible walls are designed to be destroyed using the player's spell attack.


## Sarayu Mummidi (sarayumummidi)

**Main Role: Movement/Physics**
For this project, I implemented the movement and physics system that all the characters in the game rely on. I created an abstract Character class [character.gd](https://github.com/sriramadhenu/mage-race/blob/main/scripts/character.gd) that defines the shared behavior such as gravity, jumping, changing directions, horizontal movement, and terminal velocity. This character class acts the foundation for the other characters we created such as player (user) and enemies. I also worked on the player movement commands [player.gd](https://github.com/sriramadhenu/mage-race/blob/develop/scripts/player/player.gd/#L16-L102) which consists of moving, idle, jumping, and dashing. I created a comamnd list to ensure the commands are run in order. As we didn't have a sprite for the dashing, I also created a function to create the illusion of the player moving super fast [white ghost effect](https://github.com/sriramadhenu/mage-race/blob/develop/scripts/player/player.gd/#L87-L101). This improved the dashing game feel. The dash was more complex movements I built as it included a dash timer, maintained the vertical velocity of the player, and displayed ghost afterimages during the dash [dash_command.gd](https://github.com/sriramadhenu/mage-race/blob/develop/scripts/commands/player/dash_command.gd). Overall, I learned a lot from contributing to the backbone of the character movement logic in this project.

**Sub Role: Audios**
As my secondary role, I implemented the audio system for the entire project. This included researching and finding free audio assets that matched our metroidvania fantasy theme. This required extensive searching to find sound effects that were high-quality, cohesive, and consistent with the other audios. I implemented audio for UI clicks, player actions (walk, jump, dash, spells), and enemy attacks (shoot, sword) by writing [command callback functions](https://github.com/sriramadhenu/mage-race/blob/main/scripts/player/player.gd/#L147-L157) that triggered the right sound at the right moment. I made sure to sync the sound effect to when the action was occuring to create the best game feel. I also selected and integrated the background music for the menu, level_select, and how_to_play pages as well as the in-game areas. The choice of background music was intentionally different for the initial UI pages and in-game areas to make more immersive for the players during gameplay and more magical/theme-like during menus. For the in-game background music, I added a global music system which was autoloaded so that if we decided to add more levels or make the game progress level by level, the music wouldn't abruptly cut off, resulting in a more enjoyable game experience. 

**Other Contributions**
I worked on the level select interface. I worked on building the level_loader.tscn scene and integrating the user flow logic. [level_loader.tscn](https://github.com/sriramadhenu/mage-race/blob/main/scenes/ui/level_loader.tscn)
