-- conf.lua

require "constants"


function love.conf(game)
  game.window.title = "Fight of Titans"
  game.window.width = SCREEN_WIDTH
  game.window.height = SCREEN_HEIGHT
end