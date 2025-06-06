-- Tyler Torrella
-- CMPM 121
-- 6-05-25
io.stdout:setvbuf("no")

require "board"
require "grabber"
require "game_manager"


local currentGameState == "title"

function love.load()
  gameManager = GameManagerClass:new() 
end

function love.update(dt)
  if gameManager.update then
    gameManager:update(dt)
  end
end

function love.draw()
  if currentGameState == "title" then
    TitleScreen:draw()
  elseif currentGameState == "game" then
    gameManager:draw()
  end
end

function love.mousepressed(x, y, button)
  if gameManager.mousepressed then
    gameManager:mousepressed(x, y, button)
  end
end

function love.mousemoved(x, y, dx, dy)
  if gameManager.mousemoved then
    gameManager:mousemoved(x, y, dx, dy)
  end
end

function love.mousereleased(x, y, button)
  if gameManager.mousereleased then
    gameManager:mousereleased(x, y, button)
  end
end
