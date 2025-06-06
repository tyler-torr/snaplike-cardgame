# Location Card Game
 Card Game coded in lua.
 
 -- Programming Patterns & Design --
 This project seeks to implement fully developed location-based card gameplay.
 This took a while but card gameplay based on locations (just like Marvel Snap, hence the project name) has been implemented. It was fun to do this because I was able to get code snippets made from solitaire, like the cards and the grabbing, and got it to work here with (relative) ease. Making the cards have effects though is an entire other beast which I didn't end up implementing due to time restraints, but I plan to remedy and fix that later!
 
 The main programming pattern the game uses right now is a flyweight pattern, used to quickly handle the 52 cards' creation
 for a deck. Because there's a set, finite amount of cards in the game, I felt like it'd be appropriate when creating the cards to use the flyweight pattern, quickly making copies rather than making a unique Card object every time. This is because the card properties never change, e.g. suits or ranks, so there's no need to make them more complicated than a flyweight.
 
 I also use prototypes in basically every .lua with setmetatables, since it's the closest thing lua has to classes. It helps modulize and share logic between the game; this game would be a lot harder to make without prototypes.
 
 I plan to use observers for when I make the cards get effects when played.
 
 
 -- Peer Feedback --
 Ronan: Ronan helped me (again) with my code by giving feedback and looking through what I had at the end to review what I did right and wrong!
 Josh: Josh and I talked about how to structure and make our code work, and the initial file preparation and function creation was from both of us talking and looking over each other's code to see if we agreed with it. We later showed each other our near final code to see if there was any advice we could give to each other.
 Jason: Jason gave feedback on my code by showing redundant code and pointing out why my grabber function wasn't working (I forgot to call it).
 
 -- Known Issues --
 - Card effects are not currently implemented. Oops!
 - Card text flows off the screen of the cards. It's pretty ugly.
 
 -- Postmortem --
 Getting this working felt like I was putting together a ton of different gears in a box, closing it, and then shaking it to see if any of them would magically click together in place. I made a lot of individual parts first and then slowly jumped around whenever I realized implementation would better fit in another file, or made iterable for a different purpose. This is very noticeable with my board.lua, which literally only exists to group together all three locations, and with hindsight could definitely just be removed entirely. Once the gears did start to click in place, it suddenly becomes a lot easier to get it all working together. Game Manager was weirdly the funnest part of the project; once I got cards, locations, grabbing and players working, all that was left was putting the game logic in place. It was fun to slowly make it feel like it was an actual game.
 
 -- Assets --
 Sound effects are from 'Board Game Pack', made by Kenney. (They are not currently used)
 https://kenney.nl/assets/boardgame-pack