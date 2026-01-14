# Epic Games Store - Fetch Purchased Games

## Script to Fetch Purchased Games

```js
// JavaScript snippet to fetch all purchased games from Epic Games Store order history
// do this in the browser console (F12) while logged into your Epic Games account
(async () => {
  let allOrders = [];
  let nextToken = "";
  const baseUrl =
    "https://www.epicgames.com/account/v2/payment/ajaxGetOrderHistory?count=10&sortDir=DESC&sortBy=DATE&locale=en-US";

  do {
    const url = nextToken ? `${baseUrl}&nextPageToken=${nextToken}` : baseUrl;
    const res = await fetch(url);
    const data = await res.json();

    allOrders.push(...data.orders);
    nextToken = data.nextPageToken;
    console.log(`Fetched ${allOrders.length} orders...`);
  } while (nextToken);

  // Extract game titles from the saved orders
  const gameTitles = [
    ...new Set(allOrders.flatMap((o) => o.items.map((i) => i.description))),
  ].sort();

  console.log("Full Order History Objects:", allOrders);
  console.log("Unique Games List:", gameTitles);
  console.log(gameTitles.join("\n"));
})();
```

## My Epic Games Purchased Titles

```
112 Operator
3 out of 10: Season Two
911 Operator
A Short Hike
AER Memories of Old
ARK Crystal Isles
ARK ModKit (UE4)
ARK Ragnarok
ARK The Center
ARK Valguero
ARK: Survival Evolved
Adios
Alba - A Wildlife Adventure
Albion Online
Albion Online Free Welcome Gift
Amnesia: A Machine for Pigs
Amnesia: Rebirth
Amnesia: The Bunker
Among the Sleep - Enhanced Edition
Anodyne 2: Return To Dust
Apex Legends™
Apex Legends™: Ash Free Unlock Bundle
Apex Legends™: Conduit Free Unlock Bundle
Apex Legends™: Loba Free Unlock Bundle
Arcade Paradise
Arcadegeddon
Astrea Six Sided Oracles
Astro Duel 2
Backpack Hero
Bear and Breakfast
Behind the Frame: The Finest Scenery
Beholder
Bendy and the Ink Machine
Beyond Blue
Black Book
Blazing Sails
Blood West
Bloodstained: Ritual of the Night
Bloons TD 6
Botanicula
Bouncemasters
Breathedge
Bridge Constructor: The Walking Dead
Brotato
Brothers - A Tale of Two Sons
CHUCHEL
CYGNI - All Guns Blazing
Call of the Sea
Call of the Wild: The Angler™
Carcassonne
Cassette Beasts
Castlevania Anniversary Collection
Cat Quest
Cat Quest II
Cave Story+
Chess Ultra
Chivalry 2
Circus Electrique
Cities: Skylines
City of Brass
City of Gangsters
Control
Creature in the Well
Crying Suns
Crying Suns Demo
Cultist Simulator
Cursed to Golf
DARQ: Complete Edition
DEATH STRANDING
DEATHLOOP
DNF Duel
DREDGE
Dakar Desert Rally
Dark Deity
Dark and Darker
Dark and Darker - Legendary Status
Dead Cells
Dead by Daylight
Deadtime Defenders
Death's Gambit - Afterlife
Deceive Inc.
Defense Grid: The Awakening
Deliver At All Costs
Deliver Us Mars
Deponia: The Complete Journey
Disco Elysium - The Final Cut
Dishonored - Definitive Edition
Dishonored®: Death of the Outsider™
Dodo Peak
Doki Doki Literature Club Plus!
Doodle Devil: Dark Side
Doodle Farm: Breeds and Beasts
Doodle God: Infinite Alchemy Merge
Doodle Kingdom: Medieval
Doodle Mafia: Epic Alchemy
Doors - Paradox
Double Dragon Trilogy
Dragon Age: Inquisition – Game of the Year Edition
Drawful 2
Dungeon of the Endless: Apogee
Duskers
Dying Light Enhanced Edition
EARTHLOCK
Eastern Exorcist
Elite Dangerous
Empyrion - Galactic Survival
Encased
Enter the Gungeon
Epic Cheerleader Pack
Epistory - Typing Chronicles
Escape Academy
Eternal Threads
Europa Universalis IV
Evil Dead: The Game
Evoland 2
Exclusive Outfits Pack
Eximius: Seize the Frontline
F.I.S.T.: Forged In Shadow Torch
F1® Manager 2024
Fall Guys - Fashionably Frosty
Fallout: New Vegas - Ultimate Edition
Fallout® Classic Collection
Farming Simulator 22
Fear the Spotlight
Felix The Reaper
Figment
Figment 2: Creed Valley
Filament
Firestone Free Offer
Firestone Online Idle RPG
First Class Trouble
Five Nights at Freddy's: Into the Pit
Floppy Knights
Football Manager 2024
Freshly Frosted
Frostpunk
GRIME
Gamedec - Definitive Edition
Garden Story
Genshin Impact
Ghostrunner
Ghostrunner 2
Ghostwire: Tokyo
Gigantic: Rampage Edition
Gigapocalypse
God's Trigger
Gods Will Fall
Godzilla Voxel Wars
Golden Light
Gone Home
Grand Theft Auto V: Premium Edition
Gravity Circuit
Guacamelee! 2
Guacamelee! Super Turbo Championship Edition
HITMAN
HOT WHEELS UNLEASHED™
HUMANKIND™ Standard Edition
Happy Game
Hell Let Loose
Hell is Others
Hell is other demons
Hello Neighbor Mod Kit
Hidden Folks
Hob
Hogwarts Legacy
Hollypaw Wrap
Homeworld: Deserts of Kharak
Horizon Chase Turbo
Hyper Scape™
INDUSTRIA
INSIDE
Idle Champions of the Forgotten Realms
InnerSpace
Invincible Presents: Atom Eve
Ironcast
Islets
Jitsu Squad
Jorel’s Brother and The Most Important Game of the Galaxy
Jotunnslayer: Hordes of Hel
Jurassic World Evolution
Jurassic World Evolution 2
Just Cause 4 Standard Edition
KILL KNIGHT
Kamaeru
Kardboard Kings
Ken Follett's The Pillars of the Earth
Kerbal Space Program
Keylocker | Turn Based Cyberpunk Action
Kingdom Come: Deliverance
Kingdom New Lands
LEGO® Star Wars™: The Skywalker Saga
LIMBO
LISA: The Definitive Edition
LOVE
Legion TD 2
Limbo
Loop Hero
Lost Castle
LumbearJack
MORDHAU
MR RACER : Premium
Machinarium
Mages of Mystralia
Maid of Sker
Make Way
Marvel's Guardians of the Galaxy
Marvel's Midnight Suns
Metro 2033 Redux
Metro Last Light Redux
Midnight Ghost Hunt
Mighty Fight Federation
Model Builder: Complete Edition
Monument Valley
Monument Valley 2
Mortal Shell
Moving Out
Murder by Numbers
Mutazione
NBA 2K21
Neko Ghost, Jump!
Never Alone (Kisima Ingitchuna)
Next Up Hero
Nightingale
Ogu and the Secret Forest
Olympics Go! Paris 2024
Orcs Must Die! 3
Orwell: Keeping an Eye on You
Out There - Omega Edition
Out of Line
Outliver: Tribulation
Overcooked! 2
PAYDAY 2
Paladins Epic Pack
Paradise Killer
Pathway
Pilgrims
Pillars of Eternity - Definitive Edition
Pine
Poker Club
Project Winter
Q.U.B.E. ULTIMATE BUNDLE
RAWMEN: Food Fighter Arena 🍜
Recipe for Disaster
Redout 2
Rise of Industry
Rising Storm 2: Vietnam
River City Girls
Riverbond
Road Redemption
Rogue Company Season Four Epic Pack
Rogue Journeyman Bundle
Rogue Legacy
Rumble Club
Rumble Club - Free Game of the Week Bonus
Rumbleverse
SAMURAI SHODOWN NEOGEO COLLECTION
SKALD Against the Black Priory
STAR WARS™ Battlefront™ II: Celebration Edition
STAR WARS™ Knights of the Old Republic™
STAR WARS™ Knights of the Old Republic™ II - The Sith Lords™
STAR WARS™: Squadrons
Sable
Sail Forth
Saints Row Boss Factory
Saints Row IV Re-Elected
Samorost 2
Samorost 3
Santa's Sweatshop
Saturnalia
ScourgeBringer
Scourgebringer
Second Extinction™
Severed Steel
Shadow Tactics - Aiko's Choice
Shadow Tactics: Blades of the Shogun
Shadowrun Collection
Shapez
Shotgun King: The Final Checkmate
Sid Meier’s Civilization® VI
Sid Meier’s Civilization® VI Platinum Edition
Sifu
Skul: The Hero Slayer
Sky Racket
Snakebird Complete
Sniper Ghost Warrior Contracts
Solitairica
Songs of Silence
Sonic Mania
Sorry We're Closed
Soulstice
Spelldrifter
Standard Edition
Strange Horticulture
Stranger Things 3: The Game
Stubbs the Zombie in Rebel Without a Pulse
Sunless Sea
Sunless Skies: Sovereign Edition
Super Meat Boy Forever
Super Meat Boy Forever Mobile
Super Space Club
Surviving the Aftermath
Tacoma
TerraTech
The Battle of Polytopia
The Big Con
The Callisto Protocol
The Darkside Detective
The Dungeon of Naheulbeuk
The Elder Scrolls Online
The Escapists
The Evil Within
The Falconeer: Standard Edition
The Fall
The First Tree
The Forest Quartet
The Jackbox Party Pack 4
The Lord of The Rings: Return to Moria™
The Operator
The Outer Worlds: Spacer's Choice Edition
The Silent Age
The Sims™ 4 The Daring Lifestyle Bundle
The Spirit and the Mouse
The Stanley Parable
The Textorcist: The Story of Ray Bibbia
The Vanishing of Ethan Carter
The World Next Door
There Is No Game: Wrong Dimension
Thief
Ticket To Ride: Classic Edition
Tiny Tina's Assault on Dragon Keep: A Wonderlands One-shot Adventure
Tiny Tina's Wonderlands
Torchlight II
Total War: THREE KINGDOMS
Total War: WARHAMMER
Total War: WARHAMMER - Grombrindal The White Dwarf
Totally Reliable Delivery Service Standard Edition
Touch Type Tale
Town of Salem 2
Trackmania Starter Access
Train Valley 2
Trine Classic Collection
Tunche
Turmoil
Turnip Boy Commits Tax Evasion
Two Point Hospital
Tyranny - Gold Edition
Undying
Universe for Sale
Vampire Survivors
Vampyr
Viewfinder
Wargame: Red Dragon
Wargame: Red Dragon - Russian Roulette [10v10 Map]
Warhammer 40,000: Gladius - Relics of War
Warhammer 40,000: Mechanicus - Standard Edition
Warpips
Watch Dogs Standard Edition
We Were Here Together
Wheels of Aurelia
Wild Card Football
Wildcat Gun Machine
Witch It
Wolfenstein: The New Order
World of Warships
World of Warships — Anniversary Party Favor
World of Warships — Starter Pack: Albany
Zero Hour
Zoeti
[REDACTED]
shapez
theHunter: Call of the Wild™
```
