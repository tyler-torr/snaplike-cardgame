-- card.lua

require "utils"
require "vector"
require "constants"


CardClass = {}

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2
}


function CardClass:new(name, cost, power, effect, xPos, yPos)
  local card = {}
  local metadata = {__index = CardClass}
  setmetatable(card, metadata)
  
  card.position = Vector(xPos, yPos)
  card.size = Vector(CARD_WIDTH, CARD_HEIGHT)
  card.state = CARD_STATE.IDLE
  card.mouseOver = false
  card.grabbable = true
  
  card.name = name
  card.cost = tonumber(cost)
  card.power = tonumber(power)
  card.effect = effect or " " -- If no effect, leave card blank
  card.revealed = false
  
  return card
end

function CardClass:update()
  
end

function CardClass:draw()
  -- Draw Card back
  if not self.revealed then
    love.graphics.setColor(DARK_GRAY)
    love.graphics.rectangle("fill", self.position.x, self.position.y, CARD_WIDTH, CARD_HEIGHT)
    love.graphics.setColor(WHITE)
    love.graphics.print("Face Down", self.position.x + 10, self.position.y + 60)
  -- If Card is revealed, draw actual Card
  else
    -- Card Border
    love.graphics.setColor(WHITE)
    love.graphics.rectangle("fill", self.position.x, self.position.y, CARD_WIDTH, CARD_HEIGHT)
    love.graphics.setColor(BLACK)
    love.graphics.rectangle("line", self.position.x, self.position.y, CARD_WIDTH, CARD_HEIGHT)
    
    -- Card Info
    love.graphics.print(self.name, self.position.x + 10, self.position.y + 10)
    love.graphics.print(self.cost .. " Cost", self.position.x + 10, self.position.y + 30)
    love.graphics.print(self.power .. " Power", self.position.x + 10, self.position.y + 50)
    love.graphics.print(self.effect, self.position.x + 10, self.position.y + 70)
  end
end



-- Reveal a card
function CardClass:reveal()
  self.revealed = true
end

-- Check whether the mouse is hovering over a Card. If it is, change its state to be recognized as a potential grabbable candidate
function CardClass:checkForMouseOver(mousePos)
  if self.state == CARD_STATE.GRABBED then return false end -- Can't grab a card if already holding one
  
  local isMouseOver = contains(self, mousePos)
  self.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE
  return isMouseOver
end