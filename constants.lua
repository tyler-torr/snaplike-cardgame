
-- These values are used throughout the rest of the game. Modifying a value here modifies everything else

-- Game Configurations
SCREEN_WIDTH = 600
SCREEN_HEIGHT = 480
BOARD_Y = 25
BOARD_X = 25

-- Offsets
PILE_OFFSET = 13 -- Y Distance between each Card in a Pile
TABLEAU_DISTANCE = 50 -- X Distance between each Tableau Pile on the board
FOUNDATION_DISTANCE = 80 -- Y Distance between each Foundation Pile on the board]
TALON_DISTANCE = 50 -- Y Distance between Deck and Talon

-- Colors
LIGHT_GREEN = {0, 0.7, 0.2, 1}
WHITE = {1, 1, 1, 1}

TRANSPARENT_GRAY = {0.2, 0.2, 0.2, 0.6}

-- Card Properties
CARD_WIDTH = 50
CARD_HEIGHT = 70

-- Sounds
sfx_reset = love.audio.newSource("sounds/reset.ogg", "static")
sfx_draw = love.audio.newSource("sounds/draw.ogg", "static")
sfx_shuffle = love.audio.newSource("sounds/shuffle.ogg", "static")
sfx_win = love.audio.newSource("sounds/win.ogg", "static")