
require "pile"


GrabberClass = {}


function GrabberClass:new()
  local grabber = {}
  local metadata = {__index = GrabberClass}
  setmetatable(grabber, metadata)
  
  grabber.cards = {}
  grabber.originPile = nil
  grabber.offset = nil
  
  --grabber.previousMousePos = nil
  grabber.currentMousePos = nil
  grabber.grabPos = nil
  
  return grabber
end

function GrabberClass:update()
  --self.previousMousePos = self.currentMousePos
  self.currentMousePos = Vector(
    love.mouse.getX(), 
    love.mouse.getY()
  )
  
  -- Click
  if love.mouse.isDown(1) and self.grabPos == nil then
    self:grab()
  end
  -- Release
  if not love.mouse.isDown(1) and self.grabPos ~= nil then
    self:release()
  end
end

function GrabberClass:draw()
  for i, card in ipairs(self.cards) do
    card.position = self.currentMousePos - self.offset + Vector(0, (i - 1) * PILE_OFFSET)
    card:draw()
  end
end



-- Grab a Card. If it's from a Pile, grab the entire Pile
function GrabberClass:grab(card)
  if not card then return end
  if not card.grabbable then return end  -- No need to check if the card isn't grabbable (i.e. not top card of Talon)
  
  local pile, index = getPileFrom(card)
  if not pile then return end

  self.cards = {}
  for i = index, #pile.cards do
    table.insert(self.cards, pile.cards[i])
  end

  for i = #pile.cards, index, -1 do
    table.remove(pile.cards, i)
  end

  self.originPile = pile
  self.grabPos = self.currentMousePos
  self.offset = self.currentMousePos - card.position
end

function GrabberClass:release()
  if #self.cards == 0 then return end

  local grabbedCard = self.cards[1]

  for _, pile in ipairs(cardTable) do
    if contains(pile, self.currentMousePos) and pile:isLegalAction(grabbedCard) then
      for _, card in ipairs(self.cards) do
        pile:addCard(card)
      end
      self.originPile:revealCard()
      self.cards = {}
      self.originPile = nil
      return
    end
  end
  
  -- Return to original pile if placed in an incorrect spot
  for _, card in ipairs(self.cards) do
    self.originPile:addCard(card)
  end
  self.cards = {}
  self.originPile = nil
end
