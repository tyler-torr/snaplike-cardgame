# solitaire
 Solitaire coded in lua.
 
 -- Programming Patterns & Design --
 This project seeks to implement fully developed solitaire gameplay.
 Basic solitaire gameplay is fully implemented, with one annoying issue where the card hitboxes to drag are based on the bottom of 
 the card, rather than the top -- e.g. Clicking a card on the bottom is somewhat precise, especially on the Falcon.
 Other than that, all parts of Solitaire are implemented (Tableau Piles, Foundation Piles, Deck, Falcon, dragging, win condition)
 
 The main programming pattern the game uses right now is a flyweight pattern, used to quickly handle the 52 cards' creation
 for a deck. Because there's a set, finite amount of cards in the game, I felt like it'd be appropriate when creating the cards to use the flyweight pattern, quickly making copies rather than making a unique Card object every time. This is because the card properties never change, e.g. suits or ranks, so there's no need to make them more complicated than a flyweight.
 
 I also use prototypes in basically every .lua with setmetatables, since it's the closest thing lua has to classes. It helps modulize and share logic between the game; this game would be a lot harder to make without prototypes.
 
 
 -- Peer Feedback --
 Ronan Tsoi: Ronan helped a lot during discussion sections, not only given written feedback but also briefly examining and telling me how he implemented pile logic with cards. He also helped me refactor some of my grabbing code. He also helped me figure out how to add more comments and readability to my code, since it initially had very little comments.
 Cal Friedman: Cal was very helpful when reviewing my code and helped me figure out why my grabber code wasn't working in my first iteration (Telling me that the grabber logic didn't actually explicitly check each card in the update).
 Leo Assimes: Leo's code happened to have a lot of similarities in how we structured things, so we got to see each other's code and teach each other little ways to refactor our code. In particular, he helped me figure out why my deck wasn't spawning in.
 Suramya Shakya: Suramya helped me near the end of submission when I needed help figuring out why my pile logic wasn't working.
 Stanley Hung: While not in the class (He's my roommate), he helped playtest my game when it was done and help me with various nitpicks on what to change, e.g. the reset button overlapping with the Talon if you exhausted it and made the pile reach the end.
 
 -- Known Issues --
 - Dragging cards can be a little annoying because the hitbox to grab cards is based bottom-up instead of top-down. Meaning, to grab the first card in a pile, you need to grab a sliver of the card hitbox at the bottom, rather than the entire visible first card.
   - This is because of how I built the Card grabbing system. There's no easy fix to this that wouldn't require me to refactor the grabbing code, so for now, it is what it is.
   - This is especially noticeable on the Talon, where grabbing the topmost card requires some precision to grab a sliver of it.
 - Occasionally, the Foundation Pile allows you to give an entire pile of Cards rather than one Card (which should always be impossible since a pile consists of different suits).
   - This cannot happen consistently, which means the logic error must come from it not being checked every time. It's confusing, since the logic otherwise always works, e.g. never accepting the wrong suit of a Card.
 
 -- Postmortem --
 After refactoring all of the code from the ground up because grabbing wasn't working, I initially had a lot of issues with how the game was working, but eventually it all started to come together and click near the end of development. Card games are one of my favorite genres of games, so it was fun to fully work and create the solitaire logic from the ground up, figuring out where things should go and why. I feel like I've successfully implemented all solitaire features -- at least the ones that I care to create, so no fancy win screen outside of a print for example. The only annoyance is how grabbing has a precise hitbox, something that still haunts me (even after refactoring the grabbing code, it's still wonky!) but I'm willing to call it done.
 
 -- Assets --
 Card sprites are from 'Free Playing Cards Pixelart Asset Pack', made by Elvgames.
 https://elvgames.itch.io/playing-cards-pixelart-asset-pack
 
 Sound effects are from 'Board Game Pack', made by Kenney.
 https://kenney.nl/assets/boardgame-pack