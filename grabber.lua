-- grabber.lua

require "card"
require "location"
require "player"


GrabberClass = {}


function GrabberClass:new()
  local grabber = {}
  local metadata = {__index = GrabberClass}
  setmetatable(grabber, metadata)
  
  grabber.currentMousePos = nil
  grabber.grabPos = nil
  grabber.heldObject = nil
  
  return grabber
end

function GrabberClass:update(cards, locations, player)
  self.currentMousePos = Vector(
    love.mouse.getX(), 
    love.mouse.getY()
  )
  
  -- Click
  if love.mouse.isDown(1) and self.grabPos == nil then
    self:grab(cards)
  end
  
  -- Release
  if not love.mouse.isDown(1) and self.grabPos ~= nil then
    self:release(locations, player)
  end
  
  -- Update held Card to follow
  if self.heldObject and self.offset then
    self.heldObject.position.x = self.currentMousePos.x - self.offset.x
    self.heldObject.position.y = self.currentMousePos.y - self.offset.y
  end
end


-- Grab a Card
function GrabberClass:grab(cards)
  self.grabPos = self.currentMousePos

  for _, card in ipairs(cards) do
    if card:checkForMouseOver(self.currentMousePos) then
      self.heldObject = card
      card.state = CARD_STATE.GRABBED

      -- Cards won't "snap" to mouse cursor, they are now dragged based on mouse pos
      self.offset = {
        x = self.currentMousePos.x - card.position.x,
        y = self.currentMousePos.y - card.position.y
      }
      
      -- If a Card isn't dragged to a proper location, snap it back to original location
      self.originalCardPosition = {
        x = card.position.x,
        y = card.position.y
      }
      break
    end
  end
end

-- Release a Card
function GrabberClass:release(locations, player)
  if not self.heldObject then self.grabPos = nil return end

  local card = self.heldObject
  local placed = false

  for _, location in ipairs(locations) do
    for i, slot in ipairs(location.visualUserSlots) do
      local slotRect = {
        position = Vector(slot.x, slot.y),
        size = Vector(slot.width, slot.height)
      }

      if contains(slotRect, self.currentMousePos) and location.slots.user[i] == false then
        local success = player:playCard(card, location, i)
        if success then
          placed = true
          break
        end
      end
    end
    if placed then break end
  end

  if not placed and self.originalCardPosition then
    card.position.x = self.originalCardPosition.x
    card.position.y = self.originalCardPosition.y
  end

  card.state = CARD_STATE.IDLE
  self.heldObject = nil
  self.grabPos = nil
end