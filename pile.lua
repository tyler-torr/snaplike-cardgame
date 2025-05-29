
require "card"

PileClass = {}

PILE_TYPE = {
  TABLEAU = 0,
  FOUNDATION = 1,
  TALON = 2
}

-- Create a pile of cards 
function PileClass:new(xPos, yPos, pileType)
  local pile = {}
  local metadata = {__index = PileClass}
  setmetatable(pile, metadata)
  
  pile.pileType = pileType
  
  pile.cards = {}
  pile.position = Vector(xPos, yPos)
  pile.size = Vector(CARD_WIDTH, CARD_HEIGHT)
  
  return pile
end

function PileClass:update()
  if self.pileType == PILE_TYPE.TALON then
    for i, card in ipairs(self.cards) do
      if i == #self.cards then  -- Only top card grabbable in the Talon
        card.grabbable = true
      else
        card.grabbable = false
      end
    end
  end
end

function PileClass:draw()
  -- Draw background for Foundation Piles
  if self.pileType == PILE_TYPE.FOUNDATION then
    love.graphics.setColor(TRANSPARENT_GRAY)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y)
    love.graphics.setColor(WHITE)
  end

  if #self.cards > 0 then
    if self.pileType == PILE_TYPE.TABLEAU or self.pileType == PILE_TYPE.TALON then
      for i = 1, #self.cards do
        local stackedCard = self.cards[i]
        if stackedCard.state ~= CARD_STATE.GRABBED then
          stackedCard.position = Vector(self.position.x, self.position.y + (i - 1) * PILE_OFFSET)
          stackedCard:draw()
        end
      end

      if self ~= grabber.originPile then
        self:revealCard()
      end

    elseif self.pileType == PILE_TYPE.FOUNDATION then
      -- Only draw the top card at base position for Foundation
      local topCard = self:peek()
      if topCard and topCard.state ~= CARD_STATE.GRABBED then
        topCard.position = Vector(self.position.x - 7, self.position.y - 13)
        topCard:draw()
      end
    end
  end
end




-- === Helper Functions for Piles ===

-- Add Card to a Pile
function PileClass:addCard(card)
  card.position = Vector(self.position.x, self.position.y)
  if self.pileType ~= PILE_TYPE.FOUNDATION then -- Unless a Pile is a Foundation Pile, Piles have offset when overlayed
    card.position.y = self.position.y + (#self.cards * PILE_OFFSET)
  end
  table.insert(self.cards, card)
  self:updateSize()
end

-- Remove Card from a Pile
function PileClass:removeCard(card)
  for i, c in ipairs(self.cards) do
    if c == card then
      self:updateSize()
      return table.remove(self.cards, i)
    end
  end
  self:updateSize()
  return nil
end

-- Clear cards in a Pile
function PileClass:clear()
  self.cards = {}
  self:updateSize()
end


-- Discover the topmost Card in a Pile
function PileClass:peek()
  return self.cards[#self.cards]
end

-- Every pile's top card should always be visible
function PileClass:revealCard()
  local topCard = self:peek()
  if topCard then
    topCard.visible = true
  end
end

-- Update a Pile's size to correctly reflect its visible size on the board
function PileClass:updateSize()
  if self.pileType == PILE_TYPE.TABLEAU then
    local height = CARD_HEIGHT + (PILE_OFFSET * #self.cards)
    self.size = Vector(CARD_WIDTH, height)
  end
  if self.pileType == PILE_TYPE.TALON then
    local height = CARD_HEIGHT + (PILE_OFFSET * math.min(3, #self.cards))
    self.size = Vector(CARD_WIDTH, height)
  end
end


-- === Check if Pile action is legal ===


-- If trying to add Card to Pile, check whether it's a legal action to permit it
function PileClass:isLegalAction(card)
  if self.pileType == PILE_TYPE.TABLEAU then
    return self:isLegalTableau(card)
  elseif self.pileType == PILE_TYPE.FOUNDATION then
    return self:isLegalFoundation(card)
  elseif self.pileType == PILE_TYPE.TALON then -- Cannot add Cards to Talon Pile
    return false
  end
  return false
end

-- Check if placing a Card onto a Tableau Pile is legal
function PileClass:isLegalTableau(card)
  if self.pileType ~= PILE_TYPE.TABLEAU then return false end -- Only checking Tableau logic
  
  if #self.cards == 0 then -- Only Kings can be placed in empty Tableau Piles
    return card.rank == 13
  else -- Card must be (1) opposite suit color and (2) exactly one value below top card's rank
    local topCard = self:peek()
    local isColorValid = card:getColor() ~= topCard:getColor()
    local isRankValid = card.rank == topCard.rank - 1
    
    return isColorValid and isRankValid
  end
end

-- Check if placing a Card onto a Foundation Pile is legal
function PileClass:isLegalFoundation(card)
  if self.pileType ~= PILE_TYPE.FOUNDATION then return false end
  if not card then end
  if card.pile and card.pile:peek() ~= card then return false end  -- Don't accept piles
  
  if #self.cards == 0 then -- Only Aces can be placed in empty Foundation Piles
    local isAce = (tonumber(card.rank) == 1)
    return isAce
  else -- Card must be (1) same suit color and (2) exactly one value above top card's rank
    local topCard = self:peek()
    local isCorrectSuit = card.suit == topCard.suit
    local isNextRank = tonumber(card.rank) == tonumber(topCard.rank) + 1
    return isCorrectSuit and isNextRank
  end
end

function PileClass:checkForMouseOver(mousePos)
  if #self.cards == 0 then return contains(self, mousePos) end
  local topCard = self:peek()
  if topCard then return contains(topCard, mousePos) end
  return false
end