-- Tyler Torrella
-- CMPM 121 - Pickup
-- 4-11-25
io.stdout:setvbuf("no")

require "deck"
require "grabber"
require "pile"

local deck

local NUM_TABLEAU_PILES = 7

local NUM_FOUNDATION_PILES = 4
local FOUNDATION_DISTANCE = 80

local resetButton = {
    position = Vector(400, 400),
    size = Vector(100, 40),
    width = 100,
    height = 40,
    label = "Reset"
  }

function love.load()
  love.window.setTitle("Super Epic & Awesome Solitaire (Amazing Edition)")
  love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)
  love.graphics.setBackgroundColor(LIGHT_GREEN)
  

  win = false
  
  grabber = GrabberClass:new()
  cardTable = {}
  
  deck = DeckClass:new(BOARD_X - 20, BOARD_Y + 13)
  deck:shuffle()
  table.insert(cardTable, deck.talon)

  -- Initialize Tableau piles
  for i = 1, NUM_TABLEAU_PILES do
    local pile = PileClass:new(i * TABLEAU_DISTANCE + BOARD_X, BOARD_Y, PILE_TYPE.TABLEAU)
    -- Draw each card in tableau pile (1 card in pile 1, 2 cards in pile 2, etc)
    for j = 1, i do
      local card = table.remove(deck.cards)
      card.visible = (j == i)
      pile:addCard(card)
    end
    table.insert(cardTable, pile)
  end
  
  -- Initialize Foundation piles
  for i = 1, NUM_FOUNDATION_PILES do
    local foundation = PileClass:new(BOARD_X + 450, BOARD_Y + (i - 1) * FOUNDATION_DISTANCE, PILE_TYPE.FOUNDATION)
    table.insert(cardTable, foundation)
  end
  
  -- Initialize Foundation piles
  talon = PileClass:new(BOARD_X - 20, BOARD_Y + 13 + 100)
  table.insert(cardTable, talon)
end

function love.update()
  local mousePos = Vector(love.mouse.getX(), love.mouse.getY())
  
  deck.talon:update()
  grabber:update()
  checkForMouseMoving()
end

function love.draw()
  -- Draw the Tableau Piles
  for _, pile in ipairs(cardTable) do
    pile:draw()
  end

  -- Draw the Deck
  if #deck.cards > 0 then
    deck:draw()
  end
  
  -- Draw any cards grabbed
  grabber:draw()
  
  if win == true then
    love.graphics.setColor(WHITE)
    love.graphics.print("YOU WON!!!!")
    sfx_reset:play()
  end
  
  -- Nearing end of project time so this is a bit rushed.
  love.graphics.setColor(0.2, 0.2, 0.2, 0.9)
  love.graphics.rectangle("fill", resetButton.position.x, resetButton.position.y, resetButton.width, resetButton.height, 8, 8)

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf(resetButton.label, resetButton.position.x, resetButton.position.y + 10, resetButton.width, "center")
end



-- Check if each Foundation pile has 13 cards. If they all do, the player has won
function winCondition()
  for _, pile in ipairs(cardTable) do
    if pile.pileType == PILE_TYPE.FOUNDATION and #pile.cards < 13 then
      return
    end
  end
  win = true
end

-- Check whenever the mouse moves and if the mouse is currently hovering on a card
function checkForMouseMoving()
  if not grabber.currentMousePos then
    return
  end

  for _, pile in ipairs(cardTable) do
    for _, card in ipairs(pile.cards) do
      card:checkForMouseOver(grabber.currentMousePos)
    end
  end
end

-- Check which pile a card belongs to
function getPileFrom(card)
  for _, pile in ipairs(cardTable) do
    for i, c in ipairs(pile.cards) do
      if c == card then
        return pile, i
      end
    end
  end
  return nil, nil
end

-- Whenever the player clicks the mouse button...
function love.mousepressed(x, y, button)
  if button == 1 then
    local mousePos = Vector(x, y)
    grabber.currentMousePos = mousePos
    for _, pile in ipairs(cardTable) do
      for _, card in ipairs(pile.cards) do
        card:checkForMouseOver(grabber.currentMousePos)  -- Update the state based on mouse hover
        if card.state == CARD_STATE.MOUSE_OVER then
          grabber:grab(card)  -- Grab the card if mouse is over it
          return  -- Stop once we grab the card
        end
      end
    end

    -- Check if the click is on the Deck
    if deck:checkForMouseOver(mousePos) then
      deck:click()
    end
    
    -- Check if the click is on the reset button
    if contains(resetButton, mousePos) then
      sfx_reset:play()
      love.load()
    end
  end
end

-- Whenever the player is no longer clicking the mouse button...
function love.mousereleased(x, y, button)
  if button == 1 then
    grabber:release()
  end
end