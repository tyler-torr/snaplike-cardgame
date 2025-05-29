
require "utils"
require "vector"
require "constants"


CardClass = {}

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2
}


function CardClass:new(suit, rank, visible, xPos, yPos)
  local imagePath = "cards/" .. suit .. " " .. tostring(rank) .. ".png"
  
  local card = {}
  local metadata = {__index = CardClass}
  setmetatable(card, metadata)
  
  card.position = Vector(xPos, yPos)
  card.size = Vector(CARD_WIDTH, CARD_HEIGHT)
  card.state = CARD_STATE.IDLE
  card.mouseOver = false
  card.grabbable = true
  
  card.suit = suit
  card.rank = tonumber(rank)
  card.visible = visible or false
  
  card.image = love.graphics.newImage(imagePath)
  card.imageBack = love.graphics.newImage("cards/Card Back.png")
  return card
end

function CardClass:update()
  
end

function CardClass:draw()
  if self.visible then
    love.graphics.draw(self.image, self.position.x, self.position.y)
  else
    love.graphics.draw(self.imageBack, self.position.x, self.position.y)
  end
end



-- Check whether the mouse is hovering over a Card. If it is, change its state to be recognized as a potential grabbable candidate
function CardClass:checkForMouseOver(mousePos)
  if self.state == CARD_STATE.GRABBED then return end -- Can't grab a card if already holding one
  if not self.visible then return end -- Can't grab a card if it's face down
  
  local isMouseOver = contains(self, mousePos)
  self.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE
end

-- Return red or black
function CardClass:getColor()
  if (self.suit == "Hearts" or self.suit == "Diamonds") then
    return "red"
  elseif (self.suit == "Clubs" or self.suit == "Spades") then
    return "black"
  else -- How would this happen??
    return "ERROR"
  end
end