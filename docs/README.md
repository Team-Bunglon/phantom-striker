# Notes
1. This is a Godot 4 project. Make sure you use Godot 4 version 4.2.X
2. Last document update: 05/05

# Guidelines
1. Please only use English when involving everything within this repository (commit message, merge request, variables, comments, etc.)
2. Always pull from `main`. Do NOT directly push to `main` branch. See [Merging](#merging).
	- Ignore `staging` branch as it is a temporary branch to test some things out before being pushed to `main`.
3. As an extention to previous rule, always base your branch with the latest commit from `main` before pushing.
4. Only use lowercase name for every created file and directory except markdown files (e.g. `README.md`).
	- Use `snake_case` naming convention.
5. Try to make your changes as minimal and efficient as possible. 
6. Try to finish your task before the set deadline. 
7. If you need to use godot addon or external assets, make sure you have the right license or permission to use. Credit them at the repo's README.
8. If you use an external editor, put any unimportant directories or files that the editor may generate into `.gitignore` (e.g. `.idea` for Intellij IDE).

# Merging
1. Create a new branch from `main`. You can name your branch with anything (Your name, feature name, etc.)
2. After committing your changes, __always do a git pull from `main`__. I recommend setting your pull strategy to `rebase`.
3. Once you have the latest commit from `main` in your branch, push into the new branch.
4. Create a merge request. Any new request will be automatically notified through Discord.

There's no specific guideline for commit message so write what you want as long as you are clear on what you are adding.

# Level Design
1. Try to make your level geometry looks as if it is indeed located inside of a tree, for aesthetic purposes.
2. Make sure that you can beat the level on your own. If you can't beat it, nobody can.
3. Make sure that everything can be planned and performed within a single viewport. In other words, the player should be able to plan on what to do by just looking at the entire level. This is why a level is restricted to the game's viewport and the camera is fixed.
4. Utilize the available level element in the most fluid way possible. In other word, does your level feels fluid and satisfying to play?
5. Any bottomless pit will always kill the player. NO EXCEPTION!
6. The player shouldn't go out of bound from either side of the wall. If there's no tilemap that serves as the wall on either side, add an invisible collision outside of the viewport.
7. The win area should always be on top of the level.
	-  Make sure that there's always one path that leads to the win area.
	- The win area can be in any size. If there's no tilemap that serves as the ceiling, the win area would have the size of the entire width of the viewport.
8. The player character doesn't always need to start at the bottom of the level. You can put him anywhere as long as there's any challege to reach the win area.
9. Don't be spiteful. That is designing a level that feels like you hate your player. The rule of thumb is just don't do what Cat Mario or other "rage game" does. The following is the example, but not limited, to level design that can be considered as "spiteful".
	- Creating a fake win path that kills you instead of proceeding the player to the next level (blind guessing).
	- Hiding hazard behind foreground (let the player see every hazard).
	- Anything that against what the player has been taught indirectly from the previous level (like putting the win area at the bottom. They've learned that they need to avoid any bottomless pit so they'll try to avoid it as well).
10. Do NOT change the player export variable except `looking_left`. Changing it means the player has to relearn how the player control and that's a spiteful game design. Every level MUST have consistent variables for the player. 
11. Please discuss with me first if you need to do something that requires a change of the fundamental mechanic, rule, and flow of the game in your level.
12. Try to not make the player stuck on the level in such a way that they can't complete the level and have to press the restart button (softlock). The more way the player can be softlocked, the more frustrating the game can become. 

### Note
Some of the level might be readjusted by me for any reason from finetuning the difficulty to removing any violating element as previously mention. I may or may not mention this directly at the discord server so look at the commit message if I happen to change your level.

# Level Name
This is more of a "suggestion" than a "rule" to help you come up with a good and creative name for your level name. Feel free to use your own strategy to create a good name. 

1. Always use English unless you have a good, specific reason why the room name cannot be named in English or must be in the used Language.
2. The name should describe the level in one, short sentence. It could be what the level has or what the player must be doing to complete it. 
3. At the some time, make sure the name isn't too generic or too obvious to what's shown in the level. Add some flair or flowery words to it. 
4. Please do not repeat yourself or others too frequently. I've seen repeated instance of the word "spike" in your level name.
5. Referencing other media (Literature, Music, Movie, TV, Other Games, etc.) is encouraged. Make sure the reference comes from a media that aren't too obscure in the general public.

Check out the gameplay of [VVVVVV](https://thelettervsixtim.es) and [Katgon Dungeon](https://team-bunglon.itch.io/katgon-dungeon) whose room names are a great inspiration for the level name.

### Example:
Let's say your level has spikes on the top and the bottom and you are task to use the floating diamonds to navigate across the level. Don't call the level as is (like "Spikes and Diamond"). Rather, think of something creative that your mind comes up with when looking at the level as the whole.

In this case, This level could look like a jaw of a shark, so something like "The Shark's Maw" would work. Of course, you can use pop reference if you like, like some quote from the movie Jaws (e.g. "We need a bigger platform").

### Note
Just like with the level design, I may change any level name if I find something that sounds better and more fitting or if the current name isn't that good or creative.

# Reources
- [OpenGameArt.org](https://opengameart.org/) has a vast library of game assets we can use and this is the recommended place to find assets.
- [Kenney](https://www.kenney.nl/) also has a collection of high-quality, free assets. However, it may clashes with the game's artstyle. 
- [Youtube](https://youtube.com/) may have many free-to-use audio assets available. Make sure the creator is fine with you using their creation. A rule of thumb is that if there's no mention about using their creation for your project in the description, you do not have their permission and you should directly ask them for it.
