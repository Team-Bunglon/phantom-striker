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
- The level list in this document is ordered like in the project as the latest commit.

There will be a bonus section about the old implementation of moving objects at the end of this document.

## Level 1
Name: Let's Begin -> Strike at the Root  
Author: Me 

**[TUTORIAL]**  
This level should teach the player the control of the strike. We should let them experience the mechanic by trying to jump over the second pillar in two ways. I also planned to make the player to perform wall bouncing (or "wall jump") at the eastern wall but I decided to just add some ledge and make the tech optional for platformer enthusiast and speedrunner (but only for this level).

## Level 2
Name: Watch your Step!  
Author: Me

**[TUTORIAL]**  
Teaches about the pit, spike, and launch speed maintenance. This level requires the player to have a decent amount of reaction time when trying to jump over the large pit. It shouldn't be as strict as the later level though.

## Level 3
Name: Jump of Faith  
Author: Azka

**[GENERAL]**  
The big problem of this level is that it's too similar with the other level you work during the creation week of level 1-10. I ended up just redesign the level to make it true to its original name.

**[CHALLENGE]**  
The player should maintain their height away from the spike with their strike.

## Level 4
Name: Illusion of Choice  
Author: Azka

**[GENERAL]**  
The level layout is fine, I just add some tiles to make the level look more natural.

**[TUTORIAL]**  
Teaches the player that the bottom pit at the right will always kill you, true to the level name.  

Also, you don't need to strike to the platform even once to complete the level. Is striking even a choice? Well, I added a shadow collectible as a choice (it will disappear when you strike anywhere, requiring you to restart the level).

## Level 5
Name: Stairs of Spikes -> Step by Step  
Author: Ivan

**[GENERAL]**  
This level is just so easy I just end up adding more spikes. ~~Maybe I switch this with level 5.~~ I have switched this level with the other level. This level feels quite satisfying if you are trying to speedrun it.

Also, can you be a little bit more creative with the naming? Not just "[Stuff] of Spikes"?

## Level 6
Name: Platform of Spikes -> Xylematic Platforming  
Author: Ivan

**[GENERAL]**  
This level was problematic during the playtesting stage due to the following:
- The top-left hole that kills you instead of proceeding for the next level which counts as a spiteful game design. Good thing that you have removed it on your commit.
- The single spike at the most top-right platform in the level. It's incredibly tight that it almost requires pixel-perfect precision to pass through. Fortunately, the spike's hitbox has been adjusted and you also remove that spike so I appreciate that.
- Most other platforms are pointless. There's nothing that incentivize the player to go through all platforms in the level. I've added the gate tiles and its keys which I explain in the next section.

**[TUTORIAL]**  
Remember the "optional" task of the gate tiles and keys? I've made it myself to solve the problem of underutilized space in a level. With three keys on the level, the player should have to go through almost all platforms in the level to open the gate and proceed to the next level.

## Level 7
Name: Diamond And Spike -> Cut to the Chase  
Author: Naufal

**[GENERAL]**  
You forgot to change the level name, don't you? It's a fine level. I just need to replace the old moving objects with a better one.

**[TUTORIAL]**  
Moving platform and hazard are introduced in this level, though they are expected in a platforming game. Seeing this in the game is nothing new for most players.

## Level 8
Name: Shine Bright Like A Diamond -> Like a Diamond  
Author: Naufal

**[GENERAL]**  
The level name reminds me of Like a Dragon/Yakuza series so I simplify the name for that reference.

**[TUTORIAL]**  
The usage of diamond in the original design is pointless as you can still beat the level without even striking the diamond once. This level should teach the player about the black diamond and they should use it in order to beat the level. I've massively designed this level but keep some element.

## Level 9
Name: Diamond and Spike -> Three Lane's a Crowd  
Author: Varo

**[GENERAL]**  
I can't believe you forgot to change the name of the level. Twice!

**[CHALLENGE]**  
This level is quite easy. So I decide to remove all platforms at the top lane (except the top-most platform) and add a black diamond like previously. Unlike the last level, however, you can get to the top-most platform in two ways: 
1. Using the black diamond in the same way as in the previous level. 
2. using the side spike on the opening of the third lane to bounce yourself in between the two spikes on the top platform and diagonally strike there to launch yourself directly into the win zone.

## Level 10
Name: Diamond and Spike -> Tight Maneuver  
Author: Varo

**[CHALLENGE]**  
I like this level design which forces you to be slower and deliberate with your position with such tight spike placement.

**[TUTORIAL]**  
I put a tutorial box here which tells the player that they can slow down by holding shift.

And if you ask about Windows's sticky keys, **it's a Windows user's problem, not our problem as a game dev**. And guess what? Since I'm probably the only one in the team who uses Linux, I don't have this issue at all lol (even if I use Windows, I would have disabled it since a thousand moons ago). Remember that we'll release this game on Windows and Linux and I don't restrict my perspective to Windows exclusively

## Level 11
Name: Rising Tension  
Author: Me

**[CHALLENGE]**  
I could remove the bottom with a pit (and the side wall as well) but I guess I should give the player a chance to recover back to the starting platform as soon as it regenerates.

**[TUTORIAL]**  
This level introduces disintegrating platform and Destroyable platform. I let the player figure these out themselves.

## Level 12
Name: On a Prickly Path  
Author: Me

**[TUTORIAL]**  
This level teaches the player about reducing vertical height when launching by holding down the crouch button button before striking. You only need at least two strikes to pass the spike tunnels as they don't go on for miles. The third tunnel is completely optional but it's worth it just to get the collectible.

**[CHALLENGE]**  
The challenge is about the timing of the strike when launching in between the spike tunnel.

## Level 13
Name: Deez Nuts -> Red Herring  
Author: Azka

**[GENERAL]**  
This level is just isn't up the standard. It's too short, the collectible has no challenge to obtain, and it wastes so much space in the middle. The worst part is that this is the first level that has any violation to LDG.

**[GUIDELINE VIOLATION]**  
LDG No. 5 has been violated by putting the win zone at the bottom. I have to redesigned this level completely by utilizing the wasted space more.

**[TUTORIAL]**  
This level introduces unstrikable tiles and spikes, textured as red tiles and red spikes, which you cannot bounce off. I've made these tiles since alpha build in the debug level but I forgot to tell you to use it.

## Level 14
Name: More Nuts -> Think Fast, Spookyhead!  
Author: Azka

**[GENERAL]**  
What's with the nuts here? Are you nuts?

Another level with pointless placement of the collectible. I dig the middle area as an optional area for the collectible. The player may still need to get the middle platform just to get onto the right platform.

**[SPITEFUL]**  
While I'm not against the idea that the player needs to think fast when they start the level, immediately dropping them off towards the spike without any warning is quite spiteful to me. I added some disintegrating platform to give them a short time to react and *think fast*.

## Level 15
Name: Are You A Challanger? -> Up For a Challenge?  
Author: Ivan

**[GENERAL]**  
The Level Layout is great, but the placement of collectible and the player aren't good. I decide to place the player where the collectible used to be and move the collectible at the end of the level instead. I remove the floor at the bottom left portion of the level with pit since it's just empty and bland to look at initially.

I really like how you place those spikes as a pair and make them look good and spread out well. I tried to do it myself on other level but they tend to not look good on me.

**[(NOT) GUIDELINE VIOLATION]**  
Technically, my intention with LDG No. 7 is that the win area should always be on the ceilling, but due to my wording where it "should always be on top of the level" and it does stay on the top portion of this level, I won't consider this placement as a violation from now on.

**[CHALLENGE]**  
Also, this is another level that can be finished without striking, so the idea of shadow collectible is born thanks to this level. It's a fun challenge, isn't it?

## Level 16
Name: Run Forest Run! -> Run, Forrest, Run!  
Author: Naufal

**[GENERAL]**  
Finally, a good level name for once, though I haven't watched Forrest Gump. I just added some punctuation for the name.

The same can't be said to the level design. I have no idea what should I make up on this level initially. Considering the level name is about running as fast as you can, I suppose I can turn this level into something about being chased by the moving hazard.

**[CHALLENGE]**  
As a result, this level is very heavy on moving hazard. The spawner on the second lane has the same speed as the player while the fourth (top-most) lane has faster speed which requires the player to launch themselves like they did back in Level 12.

## Level 17
Name: Are You Fast Enough? -> Cold Feet  
Author: Ivan

**[GENERAL]**  
Another level that can be finished without striking and the placement of the black diamond is entirely pointless. I remove the black diamond and make it unbeatable without striking. Despite that, I really like the sparcity of the platform in this level.

## Level 18
Name: Fus Ro Dah -> Launch Me As Though There Were No Tomorrow  
Author: Naufal

**[GENERAL]**  
This is worse than the previous level in every way and I am even clueless what the original intention of this level is. Did you put the player in the middle by accident? Seems like it after I contacted you.

**[TUTORIAL]**  
I decide to make this level the introduction of the white diamond, the opposite of black diamond. This may make the Skyrim reference in the original name clearer but I came up with a better name.

## Level 19
Name: Up and Down -> What Goes Up Must Come Down  
Author: Varo

**[GENERAL]**  
The level layout is great, but it's not difficult enough. That's all.

## Level 20
Name: Down and Up -> Come Josephine  
Author: Varo

**[GENERAL]**  
Honestly, I don't need to touch this level because it's already good, but I ended give it too much overhaul. Oops...

**[CHALLENGE]**  
What I did here is to prevent the player from being stationary (or keep flying in the air without a flying machine). The player needs to keep moving or they'll die.

## Level 21
name: Phloematic Highway  
Author: Me

**[GENERAL]**  
This level is painful to make as not only I have to make the proper spawner, I have to lay out individual moving objects in between the spawner's position and its destination so they appear on the start of the level. I've created a funciton to do that automatically in the spawner object but I decide to not touch this level anymore.

**[CHALLENGE]**  
The challenge is to hop onto the fast-moving platform like in Frogger or Doodle Jump.

## Level 22
Name: Slithereen  
Author: Me

**[CHALLENGE]**  
This level should take the meaning of "precision platforming" on the GDD to its fullest. The path of spikes is quite tight and you need to stop your launch momentum in the air while at the same time avoiding the spikes.

## Level 23
Name: The Pit  
Author: Varo

**[GENERAL]**  
I really can't come up with a better level name for this one so I decide to keep it.

I like the split path the player can take here, but having collectible on the west side can cause the player to complety ignore that side as collectible is optional by its nature. It's not your mistake, however, as the gate tiles aren't implemented when you initially designed this level. Don't worry, I kept the general layout of this level.

## Level 24
Name: Careful Now  
Author: Varo

**[GENERAL]**  
The name and the level design blends together incredibly well here, but I guess I should take it to the next level. I just need to replace the old moving hazard and add some red spikes here and there and it's perfect. I'm not sure if "Careful Now" is some sort of a reference or as a warning to the player.

I also went a bit more creative of how I place the gate tiles such as using it as the platform you use to reach the key and hide some element behind the gate's tilemap.

**[CHALLENGE]**  
I also make this level feasable without striking as originally you really only need to strike once. And thus, the shadow collectible is back (for the last time).

## Level 25
Name: Weee! -> Weeeeee!  
Author: Ivan

**[GENERAL]**  
Solid level layout.

**[CHALLENGE]**  
With the level name like that, I expect you should go as fast as possible to beat this level. And guess what? It's pretty fun to launch yourself accross the room and avoid obsticle. 

## Level 26
Name: Slow and steady.. -> You Can Do It!  
Author: Ivan 

**[GENERAL]**  
Between you and Varo, I can't decide which one of you are the greatest at level designing. I don't know what else I need to say other than I added a collectible on a very difficult spike path on the top-left.

## Level 27
Name: The Floor Is Spike -> Four Walls  
Author: Azka

**[GENERAL]**  
Honestly, I expect that every single level up until this point has "spike" in its name. Thankfully, this is the last instance of that.

What's disappointing is that the next level is copied from this level with little modification. I think it should go without saying but copying a previous room and modify it a little isn't a good level design principal. This level is just so low in my standard that I decide to redo this level last.

**[CHALLENGE]**  
The player needs to go all the quadrant in order to collect all the keys and touch the trigger box that will activate a moving platform on the right side **with only once chance of activating it**. After unlocking the gate and activating the trigger, there are two ways to get into the one-shot platform in time:
1. Going through the upper quadrant using the left white diamond that's hidden behind the gate tiles.
2. Standing at the bottom platform on the lower quadrant.

## Level 28
Name: The Floor Is Abyss  
Author: Azka

**[GENERAL]**  
You know what, I'll keep the room name [because](https://www.youtube.com/watch?v=ngF_lKu3lm8).

As I said before, this level layout is copied from the last level, just modified a bit. Though I'll keep the general layout of this level this time.

**[CHALLENGE]**  
This level is about destroying those destroyable platform in a correct order not only to pass the pillar but also to perform a wall bounce from.

## Level 29
Name: Panic Room! -> Panic Room  
Author: Naufal

**[GENERAL]**  
This level feels unfinished. A big chunk of the level is wasted on the giant block on the left side. And what's a thing that makes you panic in this room? The moving hazard that'll kill you at the start if you don't move for a second? I may as well call it spiteful, but it's not that bad tbh.

I'll hollow out the wasted block and add something to make you feel like you are panicking: The rising moving hazard from the bottom. You better move fast or the line of moving hazard will cut your run short.

I've also done a little bit of creativity with the camera as we haven't done much it with since the beginning. I've put a secret passage with a collectible accessible from jumping at the hole directly on top of the gate tile and the camera will move a bit so that you can see the passage. You won't be able to move the camera back down but the moving hazard should block your path to the starting point of the level at the time of you reaching the gate tile.

Fun fact: "Panic Room" is also a name of a room in VVVVVV. Maybe you got the name from that?

## Level 30
Name: Gotta Go Fast! -> The Final Trial  
Author: Naufal

**[GENERAL]**  
This looks even unfinished. Though I'm not really disappointed with this because I understand you may be busy with other assignment. The "branches" you add in the level looks great and that gives me an idea of how the final level should look like.

**[CHALLENGE]**  
The challege for the last level should be special. And that is the fact that this is the only level that spans accross two screens: the bottom and the top (with the camera moves between the two screens according to the player's position). This may shock the player at first but there's nothing stopping you from going to the top section as soon as the level starts and see how different this level is.


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
