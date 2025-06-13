-- constants.lua
-- These values are used throughout the rest of the game. Modifying a value here modifies everything else

require "vector"


-- Game Configurations
SCREEN_WIDTH = 1024
SCREEN_HEIGHT = 768

-- Colors
WHITE = {1, 1, 1, 1}
DARK_GRAY = {0.3, 0.3, 0.3, 1}
BLACK = {0, 0, 0, 1}
LIGHT_GREEN = {0, 0.7, 0.2, 1}
LIGHT_BLUE = {0.2, 0.6, 1, 1}
TINTED_RED = {0.6, 0.2, 0.2, 1} -- Enemy Location Border
TINTED_BLUE = {0.2, 0.2, 0.6, 1} -- User Location Border
TRANSPARENT_GRAY = {0.2, 0.2, 0.2, 0.5, 1}
w
-- Card Properties
CARD_WIDTH = 75
CARD_HEIGHT = 105

-- Location Properties
NUM_SLOTS = 4
LOCATION_X_SPACING = 15 + CARD_WIDTH -- X Distance between the two Players' Cards in a Location
LOCATION_Y_SPACING = 5 + CARD_HEIGHT -- Y Distance between each Card

-- Board Properties
NUM_LOCATIONS = 3
BOARD_X_START = 50
BOARD_Y_START = 100
BOARD_X_LOCATION_DISTANCE = 300 -- Distance between each Location on the Board

-- Player Properties
USER_HAND_Y_START = 600
USER_HAND_X_START = 130
ENEMY_HAND_Y_START = 10
ENEMY_HAND_X_START = 50
HAND_X_SPACING = CARD_WIDTH -- X Disstance between each Card in Hand

-- Game Manager Properties
END_TURN_BUTTON = {
  position = Vector(30, 650),
  size = Vector(80, 40)
}
RESTART_BUTTON = {
  position = Vector(390, 400),
  size = Vector(250, 75)
}
MANA_X = 20
MANA_Y = 575

-- Game Rules
DECK_SIZE = 20
WINNING_POINTS = 25
HAND_LIMIT = 7
STARTING_HAND = 3

-- Sounds