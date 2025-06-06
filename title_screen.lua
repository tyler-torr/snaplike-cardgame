-- title_screen.lua
TitleScreen = {}

function TitleScreen:draw()
  love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(love.graphics.newFont(32))
  love.graphics.printf("My Card Game", 0, 100, love.graphics.getWidth(), "center")

  self.startButton = {
    x = (love.graphics.getWidth() - 200) / 2,
    y = 250,
    width = 200,
    height = 60
  }

  love.graphics.setColor(0.2, 0.6, 1)
  love.graphics.rectangle("fill", self.startButton.x, self.startButton.y, self.startButton.width, self.startButton.height)

  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(love.graphics.newFont(20))
  love.graphics.printf("Start Game", self.startButton.x, self.startButton.y + 20, self.startButton.width, "center")
end

function TitleScreen:checkClick(x, y)
  local btn = self.startButton
  if x >= btn.x and x <= btn.x + btn.width and y >= btn.y and y <= btn.y + btn.height then
    return true
  end
  return false
end

return TitleScreen
