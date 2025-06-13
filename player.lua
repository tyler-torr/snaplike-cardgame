-- player.lua

require "card"


PlayerClass = {}


-- Create either a User Player or the Enemy Player
function PlayerClass:new(name)
  local player = {}
  local metadata = {__index = PlayerClass}
  setmetatable(player, metadata)
  
  player.type = name -- User or Enemy
  
  player.mana = 1
  player.points = 0
  
  player.deck = {}
  player.hand = {}
  
  player:createDeck()
  player:shuffleDeck()
  
  return player
end

function PlayerClass:update()

end

function PlayerClass:draw()
  for _, card in ipairs(self.hand) do
    card:draw()
  end
end


-- === DECK ===


-- Read the Cards from the csv file to make cards and add them to the Deck
function PlayerClass:createDeck()
  local cardData = loadCardsFromCSV("card_data.csv")
  for _, data in ipairs(cardData) do
    local card = CardClass:new(data.name, data.cost, data.power, data.effect, 0, 0)
    table.insert(self.deck, card)
  end
end

-- Shuffle the Deck
function PlayerClass:shuffleDeck()
  for i = #self.deck, 2, -1 do
    local j = love.math.random(i)
    self.deck[i], self.deck[j] = self.deck[j], self.deck[i]
  end
end

-- Draw a Card from the Deck
function PlayerClass:drawCard()
  if #self.hand >= HAND_LIMIT then return false end -- Cannot draw if Hand is full
  if #self.deck == 0 then return false end -- Cannot draw if nothing in Deck
  
  if #self.deck > 0 then
    local card = table.remove(self.deck, 1)
    if self.type == "user" then
      card.revealed = true
    end
    table.insert(self.hand, card)
  end
  
  self:arrangeHand()
end


-- === HAND ===


-- Arrange Cards in Hand to visually be shown at the bottom
function PlayerClass:arrangeHand()
  local x, y = 0, 0
  
  if self.type == "user" then
    x, y = USER_HAND_X_START, USER_HAND_Y_START
  elseif self.type == "enemy" then
    x, y = ENEMY_HAND_X_START, ENEMY_HAND_Y_START
  end
  
  for i, card in ipairs(self.hand) do
    card.position.x = x + (i - 1) * HAND_X_SPACING
    card.position.y = y
  end
end

-- Play a Card from Hand
function PlayerClass:playCard(card, location, slotIndex)
  if not card then return false end -- Must be a Card
  if card.cost > self.mana then return false end -- Must have sufficient Mana to play Card

  local cardIndex = nil
  for i, c in ipairs(self.hand) do
    if c == card then
      cardIndex = i
      break
    end
  end
  local success, actualSlotIndex, errMsg = location:addCard(self.type, card, slotIndex)
  if not success then return false end
  
  -- Make Card hidden until End Turn, subtract Mana cost, remove from Hand
  card.revealed = false
  self.mana = self.mana - card.cost
  table.remove(self.hand, cardIndex)
  self:arrangeHand()

  return true, actualSlotIndex
end
