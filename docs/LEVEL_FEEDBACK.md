# Level Feedback
This document serves as my comment and feedback for each level as well as any changes I made to balance the game and make it look prettier. All comments and changes are categorized into five categories:

**[GENERAL]**  
Some general comment and changes I make for your level. 

**[TUTORIAL]**  
Informing you about the usage of TutorialBox if your level needs it. I'll also describe how your level indirectly teaches the player about the mechanic of the game or how the player would approach your level without telling. This is great since learning from experience (such as these indirect tutorial, trial and error, and experimentation) are great way to learn about the game than telling you directly with tutorial box (though we still need it for any mechanic that's not too obvious to know immediately).

**[CHALLENGE]**  
The challenge that the level serves. Does your level have the right amount of challenge? I may change your level to balance its challenge to make it not too easy but not too hard either.

**[GUIDELINE VIOLATION]**  
Any violation in the "Level Design" section of the Guideline (called as **LDG** for "Level Design Guideline" for brevity) your level may have. Violating most of these guidelines aren't a big deal since most of them are just minor annoyance and I can exempt some of these violation if your level is very good.

However, LDG 2, 5, 6, 9, 10 are a big no-no and your level will be modified greatly in order to abide with these rules. LDG 9 in particular will be described in its own category described as below as [SPITEFUL].

**[SPITEFUL]**  
Any violation for LDG 9 specifically. I put this as its own category as any spiteful game design does NOT increase challenge. Rather, it increases the frustration of the player which will make them quit the game too quickly. We want to encourage the player to finish the game, not push them away from the goal.

**Some Note**
- I may refer level as "room" and I'll use the two terms interchangebly.
- Not every level in this docs will have all categories. That's just waste of time.

There will be a bonus section about the old implementation of moving objects at the end of this document.

## Level 1
Name: Let's Begin -> Strike at the Root  
Author: Me 

**[TUTORIAL]**  
This level should teach the player the control of the strike. We should let them experience the mechanic by trying to jump over the second pillar in two ways. I also planned to make the player to perform "Wall Jump" at the eastern wall but I decided to just add some ledge and make the tech optional for platformer enthusiast and speedrunner.

## Level 2
Name: Watch your Step!  
Author: Me

**[TUTORIAL]**  
Teaches about the pit, spike, and launch speed maintenance. This level requires the player to have a decent amount of reaction time when trying to jump over the large pit.

## Level 3
Name: Illusion of Choice  
Author: Azka

**[GENERAL]**  
The level layout is fine, I just add some tiles to make the level look more natural.

**[TUTORIAL]**  
Teaches the player that the bottom pit at the right will always kill you, true to the room name.  

Also, you don't need to strike to the platform even once to complete the level. Is striking even a choice?

## Level 4
Name: Jump of Faith  
Author: Azka

**[GENERAL]**  
The big problem of this level is that it's too similar with the previous level. I ended up just redesign the level to make it true to its original name.

**[CHALLENGE]**  
The player should maintain their height away from the spike with their strike.

## Level 5
Name: Platform of Spikes -> Xylematic Platforming  
Author: Ivan

**[GENERAL]**  
This level was problematic during the playtesting stage due to the single spike at the most top right platform in the level. Fortunately, you remove that spike in your commit so I appreciate that. I just added a collectible, rename the level, and very tiny adjustment as your level is very fine as it is. Though the lower-right portion of the level feels underutilized.

## Level 6
Name: Stairs of Spikes -> Step by Step  
Author: Ivan

**[GENERAL]**  
This level is just so easy I just end up adding more spikes. Maybe I switch this with level 5. Though this level feels quite satisfying if you are trying to speedrun it.

Also, can you be a little bit more creative with the naming? Not just "[Stuff] of Spikes"?

## Level 7
Name: Stairs of Spikes -> Cut to the Chase  
Author: Naufal

**[GENERAL]**  
You forgot to change the level name, don't you? It's a fine level, but I have replace your old moving platform

## Level 8
Name: Shine Bright Like A Diamond -> Like A Diamond  
Author: Naufal

**[GENERAL]**  
The level name reminds me of Yakuza/Like A Dragon series so I simplify the name for that reference.

**[TUTORIAL]**  
The usage of diamond in the original design is pointless as you can still beat the level without even striking the diamond once. This level should teach the player about the black diamond and they should use it in order to beat the level. I've massively designed this level but keep some element.

## Level 9
Name: Diamond and Spike -> Three's A Crowd  
Author: Varo

**[GENERAL]**  
I can't believe you forgot to change the name of the level. Twice!

**[CHALLENGE]**  
This level is quite easy. So I decide to remove all platforms at the top "floor" (except the top-most platform) and add a black diamond like previously. Unlike the last level, however, you can get to the top-most platform in two ways: 
1. Using the black diamond in the same way as in the previous level. 
2. using the side spike on the opening of the third "floor" to bounce yourself in between the two spikes on the top platform and diagonally strike there to launch yourself directly into the win zone.

## Level 10
Name: Diamond and Spike -> Tight Maneuver  
Author: Varo

**[CHALLENGE]**  
I like this level design which forces you to be slower and deliberate with your position with such tight spike placement.

**[TUTORIAL]**  
I put a tutorial box here which tells the player that they can slow down by holding shift. If they activate Windows's sticky keys, **it's their problem, not ours**. And guess what? It's only a problem with Windows so everyone in the team BUT me as a Linux user has this problem lol.

## Level 11
Name: Rising Tension  
Author: Me

**[CHALLENGE]**  
I could remove the bottom with a pit but I guess I should give the player a chance to recover back to the starting platform as soon as it regenerates.

**[TUTORIAL]**  
This level introduces Disintegrating platform and Destroyable platform. I let the player figure this out themselves.

## Level 12
Name: On a Prickly Path  
Author: Me

**[GENERAL]**  
If you know where the level name and the collectible's text come from, I'll give you a hug.

**[TUTORIAL]**  
Teach the player about reducing vertical height when launching by holding down the crouch button button before striking.

**[CHALLENGE]**  
The challenge is about the timing of the strike when launching in between the tunnel of spikes.

## Level 13
Name: Deez Nuts -> Red Herring  
Author: Azka

**[GENERAL]**
This level is just isn't up the standard. It's too short, the collectible has no challenge to obtain, and it wastes so much space in the middle. The worst part is that this is the first level I find any violation to LDG.

**[GUIDELINE VIOLATION]**  
LDG No. 5 has been violated by putting the win zone at the bottom. I have to redesigned this level completely by utilizing the wasted space more.

## Level 14
Name: More Nuts -> Think Fast, Spookyhead!  
Author: Azka

**[GENERAL]**  
What's with the nuts here? Are you nuts?

Another level with pointless placement of the collectible. I dig the middle area as an optional area to get it instead. The player can choose to ignore it if they like.

**[SPITEFUL]**  
While I'm not against the idea that the player needs to think fast when they start the level, immediately dropping them off towards the spike without any warning is quite spiteful to me. I added some disintegrating platform to give them a short time to react and *think fast*.

## Level 15
Name: Are You A Challanger? -> Up For A Challenge?  
Author: Ivan

**[GENERAL]**  
The Level Layout is great, but the placement of collectible and the player aren't good. I decide to place the player where the collectible used to be and move the collectible at the end of the level instead. I remove the floor at the bottom left portion of the level with pit since it's just empty and bland to look at initially.

I really like how you place those spikes as a pair and make them look good and spread out well. I tried to do it myself on other level but they tend to not look good on me.

**[GUIDELINE VIOLATION]**  
Technically, my intention with LDG No. 7 is that the win area should always be on the ceilling, but due to my wording where it "should always be on top of the level" and it does stay on the top portion of the level, I won't consider this placement as a violation from now on.

**[CHALLENGE]**  
Also, this is another level that can be finished without striking, so I decide to create a special version of the collectible where it would disappear as soon as you perform a strike, requiring you to restart the level. It's a fun challenge, isn't it?

## Level 16 
Name: Are You Fast Enough? -> Cold Feet  
Author: Ivan

**[GENERAL]**  
Another level that can be finished without striking and the placement of the black diamond is entirely pointless. Despite that, I really like the sparcity of the platform in this level.

## Level 17
Name: Run Forest Run! -> Run, Forrest, Run!  
Author: Naufal

**[GENERAL]**  
Finally, a good level name for once, though I haven't watched Forrest Gump. I just added some punctuation for the name.

The same can't be said to the level design. I have no idea what should I make up on this level initially. Considering the level name is about running as fast as you can, I suppose I can turn this level into something about being chased by the moving hazard.

**[CHALLENGE]**  
As a result, this level is very heavy on moving hazard. The first spawner lane has the same speed as the player while the second lane has faster speed which requires the player to launch themselves like they did back in Level 12.

## Level 18
Name: Fus Ro Dah -> Launch Me As Though There Were No Tomorrow  
Author: Naufal

**[GENERAL]**  
This is worse than the previous level in every way and I am even clueless what the original intention of this level is. Did you put the player in the middle by accident?

## Level 19
Name: Up and Down -> What Goes Up Must Go Down  
Author: Varo

**[GENERAL]**  
The level layout is great, but it's not difficult enough. That's all.

## Level 20
Name: Down and Up -> Do Not Stop!  
Author: Varo

**[GENERAL]**  
Honestly, I don't need to touch this level because it's already good, but I ended give it too much overhaul. Oops...

**[CHALLENGE]**  
What I did here is to prevent the player from being stationary (hence the level name). The player needs to keep moving or they'll die.

## Level 21
name: Phloematic Highway
Author: Me

**[GENERAL]**  
This level is painful to make as not only I have to make the proper spawner, I have

**[CHALLENGE]**  
aaa

# Bonus Section
### The problem with the original implementation of moving object

This applies to both `MovingPlatform` and `MovingHazard`. The problems mentioned below can all be summed up in one sentence: *It's extremely restrictive.* All objects must move at 4 directions (+1 direction where it would stay in place) with predefined distance and speed and you almost have no control on its movement for specific level. Here's what I mean by "restrictive":

1. You cannot specify the exact direction and distance the object would go towards. It will only move as much as the `AnimationPlayer` tells them to. Adding more direction or distance requires adding more animation on `AnimationPlayer` and that's just laborious and waste of time.
2. Using `AnimationPlayer` instead of `move_towards()` means it can be difficult to change any of its value (such as distance and speed) for specific level. Changing `AnimationPlayer`'s value directly in the editor means all other moving object in the whole games are affected. You can have export variable to change its value per level but I'm not aware if it's possible in the current version of Godot. Even if it's possible, `move_towards()` is so much easier have its value changed anyway and you don't need to manually animate the object's movement by yourself.
3. Using String instead of Enum is unintuitive. Using Enum as an export variable is so much easier as other devs can simply choose the desired direction from a drop-down menu, rather than typing it out in a text field and hoping it matches the match case in the code without having to look at the code itself.

Not everything in the game needs to be the same (it's different from being consistent). Something like moving objects should have more control than just giving it five exact options of movement.
 
Fortunately, not everything here is a lost. For instance, the foundation of the implementation is good enough for the creation for the better `MovingPlatformPoint` and `MovingHazardPoint` which replace the old implementation of moving objects. I also learn GDScript has switch statement ("match" as they call it) so that's a nice plus.

For the new moving objects, the `direction` parameter now takes the value of a vector. This way, you have an absolute, 360° of freedom of specifying its direction exactly. Not only that, you can also specify its `speed` and `back_and_forth` property (that is whether you want your object to go back to its starting direction or despawn as soon as it reaches its destination). This works great with the spawner object as well.

Implementation like this may come down to me not being specific enough about the object's direction and export variables. I should tell you about its export variable (such as `direction: Vector2` and `speed: float`) exactly and use `move_towards()` in the code base, but I assume too much here. Take this as a learning experience for both of us ^^




