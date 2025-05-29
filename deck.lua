
require "card"


DeckClass = {}

local suits = {"Hearts", "Diamonds", "Clubs", "Spades"}
local ranks = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13"} -- I know I didn't use A/J/Q/K oops


-- Create a Deck which will have every single Card inserted into it
function DeckClass:new(xPos, yPos)
  local deck = {}
  local metadata = {__index = DeckClass}
  setmetatable(deck, metadata)
  
  deck.position = Vector(xPos, yPos)
  deck.size = Vector(CARD_WIDTH, CARD_HEIGHT)
  
  deck.cards = {}
  deck.talon = PileClass:new(xPos, yPos + TALON_DISTANCE, PILE_TYPE.TALON)
  
  for _, suit in ipairs(suits) do
    for _, rank in ipairs(ranks) do
      table.insert(deck.cards, CardClass:new(suit, rank, false, 0, 0))
    end
  end
  return deck
end

function DeckClass:update()
  
end

function DeckClass:draw()
  if #self.cards > 0 then
    love.graphics.draw(self.cards[#self.cards].imageBack, self.position.x, self.position.y)
  end
  self.talon:draw()
end



-- Shuffle the order of the Cards in the Deck. Typically called only at the start of the game
function DeckClass:shuffle()
  math.randomseed(os.time())
  
  for i = 1, #self.cards do
    local rand = math.random(1, #self.cards)
    self.cards[i], self.cards[rand] = self.cards[rand], self.cards[i]
  end
end

-- When clicking the Deck, draw Cards to add to the Talon. If there are no more Cards, recycle instead
function DeckClass:click()
  if #self.cards > 0 then
    self:drawCardsToTalon(3)  -- Recycle the talon if the deck is empty
    sfx_draw:play()
  else
    self:recycle()  -- Draw 3 cards from the deck to the talon
    sfx_shuffle:play()
  end
end

-- Take out up to 3 Cards from the Deck, and put them into the Talon
function DeckClass:drawCardsToTalon(amount)
  for i = 1, amount do
    if #self.cards > 0 then
      local card = table.remove(self.cards)
      card.visible = true
      self.talon:addCard(card)
    end
  end
end

-- Cycle all Cards from the Talon back into the Deck
function DeckClass:recycle()
  for i = #self.talon.cards, 1, -1 do
    local card = self.talon.cards[i]
    card.visible = false
    table.insert(self.cards, 1, card)
  end
  self.talon.cards = {}
end

function DeckClass:checkForMouseOver(mousePos)
  return contains(self, mousePos)
end