-- game_manager.lua

require "card"
require "board"
require "player"


GameManagerClass = {}


GAME_TURN = {
  USER = 0,
  ENEMY = 1,
  CALCULATE = 2
}


function GameManagerClass:new()
  local gameManager = {}
  local metadata = {__index = GameManagerClass}
  setmetatable(gameManager, metadata)
  
  gameManager.turn = 1
  gameManager.mana = 1
  gameManager.currentTurn = GAME_TURN.USER
  gameManager.gameOver = false
  
  gameManager.grabber = GrabberClass:new()
  gameManager.board = BoardClass:new()
  
  gameManager.userPlayer = PlayerClass:new("user")
  gameManager.enemyPlayer = PlayerClass:new("enemy")

  for i = 1, STARTING_HAND do
    gameManager.userPlayer:drawCard()
    gameManager.enemyPlayer:drawCard()
  end
  
  -- Buttons
  self.endTurnButton = {
    position = END_TURN_BUTTON.position,
    size = END_TURN_BUTTON.size
  }
  self.restartButton = {
    position = RESTART_BUTTON.position,
    size = RESTART_BUTTON.size
  }
  self.mouseWasDown = false
  
  return gameManager
end

function GameManagerClass:update()
  -- Updates for other Files
  self.grabber:update(self.userPlayer.hand, self.board.locations, self.userPlayer)
  self.board:update()
  self.userPlayer:update()
  self.enemyPlayer:update()
  
  -- Mouse Check
  if love.mouse.isDown(1) and contains(END_TURN_BUTTON, Vector(love.mouse.getX(), love.mouse.getY())) then
    if not self.endedTurn and not self.gameOver then
      self:endTurn()
      self.endedTurn = true
    end
  else
    self.endedTurn = false
  end
  if love.mouse.isDown(1) and contains(RESTART_BUTTON, Vector(love.mouse.getX(), love.mouse.getY())) then
    if self.gameOver then
      self:restartGame()
    end
  end
end
w
function GameManagerClass:draw()
  -- Draw Board
  self.board:draw()
  
  -- Draw Enemy & Player Hands
  self.userPlayer:draw()
  self.enemyPlayer:draw()
  
  -- Draw End Turn Button
  love.graphics.setColor(LIGHT_BLUE)
  love.graphics.rectangle("fill", 
      END_TURN_BUTTON.position.x, 
      END_TURN_BUTTON.position.y, 
      END_TURN_BUTTON.size.x, 
      END_TURN_BUTTON.size.y
  )
  love.graphics.setColor(WHITE)
  love.graphics.printf("End Turn", 
      END_TURN_BUTTON.position.x, 
      END_TURN_BUTTON.position.y + 10, 
      END_TURN_BUTTON.size.x, 
      "center"
  )
  
  -- Draw current mana (for example, user's mana at top-left)
  love.graphics.setColor(LIGHT_BLUE)
  love.graphics.print("Mana: " .. tostring(self.userPlayer.mana), MANA_X, MANA_Y)
  love.graphics.setColor(WHITE)
  love.graphics.print("Your Points: " .. tostring(self.userPlayer.points), MANA_X, MANA_Y + 20)
  love.graphics.print("Enemy Points: " .. tostring(self.enemyPlayer.points), MANA_X, MANA_Y + 40)
  
  -- Check if game is over. If it is, draw Win screen
  if self.gameOver then
    self:win()
  end
end




-- == GAME LOGIC ==


-- When you end your turn, handle the following steps
function GameManagerClass:endTurn()
  self:performEnemyTurn()
  self:revealAllCardsOnBoard()
  self:calculate()
  self:checkWin()
  self:nextRound()
end

-- Enemy plays random cards until they're out of Mana
function GameManagerClass:performEnemyTurn()
  local enemy = self.enemyPlayer
  local board = self.board

  local playedCardThisTurn = false
  repeat
    playedCardThisTurn = false

    for i, card in ipairs(enemy.hand) do
      if card.cost <= enemy.mana then
        -- Pick random location
        local locIndex = love.math.random(#board.locations)
        local location = board.locations[locIndex]

        -- Try to find a free enemy slot
        local slotIndex = nil
        for j, slotCard in ipairs(location.slots.enemy) do
          if slotCard == false or slotCard == nil then
            slotIndex = j
            break
          end
        end

        if slotIndex then
          local success = enemy:playCard(card, location, slotIndex)
          if success then
            playedCardThisTurn = true
            break
          end
        end
      end
    end
  until not playedCardThisTurn
end

-- Add up the Point differences on both sides of each Location
function GameManagerClass:calculate()
  for _, location in ipairs(self.board.locations) do
    local winner, userPower, enemyPower = location:getWinner()
    local powerDiff = math.abs(userPower - enemyPower)

    if winner == "user" then
      self.userPlayer.points = self.userPlayer.points + powerDiff
    elseif winner == "enemy" then
      self.enemyPlayer.points = self.enemyPlayer.points + powerDiff
    end
  end
end


-- Reveal the Cards on the Board, prioritizing the winning Player
function GameManagerClass:revealAllCardsOnBoard()
  -- Helper function to reveal cards for a given side
  local function revealCardsForSide(side)
    for _, location in ipairs(self.board.locations) do
      for _, card in ipairs(location.slots[side]) do
        if card and not card.revealed then
          card.revealed = true
        end
      end
    end
  end

  -- Determine winner based on total points
  local winner = nil
  if self.userPlayer.points > self.enemyPlayer.points then
    winner = "user"
  elseif self.enemyPlayer.points > self.userPlayer.points then
    winner = "enemy"
  else
    -- Tie-breaker: randomly select a winner
    winner = love.math.random(1, 2) == 1 and "user" or "enemy"
    print("[GameManager] Tie-breaker! Randomly chose:", winner)
  end

  -- Reveal cards: winner first
  if winner == "user" then
    revealCardsForSide("user")
    revealCardsForSide("enemy")
  else
    revealCardsForSide("enemy")
    revealCardsForSide("user")
  end

  print("[GameManager] All cards revealed, winner first:", winner)
end




-- Go to the next turn for both Players
function GameManagerClass:nextRound()
  -- Set Mana equal to Turn counter, then make both Players' Mana reset
  self.turn = self.turn + 1
  self.userPlayer.mana = self.turn
  self.enemyPlayer.mana = self.turn
  
  -- Each Player draws a Card from Deck
  self.userPlayer:drawCard()
  self.enemyPlayer:drawCard()
  self.userPlayer:arrangeHand()
  self.enemyPlayer:arrangeHand()
  
  -- Repeat cycle
  self.currentTurn = GAME_TURN.USER
end
  
-- Check if a Player has won the game by exceeding the required amount of Points
function GameManagerClass:checkWin()
  local userPoints = self.userPlayer.points
  local enemyPoints = self.enemyPlayer.points

  if userPoints >= WINNING_POINTS or enemyPoints >= WINNING_POINTS then
    if userPoints > enemyPoints then
      self.winner = "user"
    elseif enemyPoints > userPoints then
      self.winner = "enemy"
    else
      self.winner = "tie"
    end
    self.gameOver = true
  end
end

-- Win Condition. YIPPEEEEE game is over!
function GameManagerClass:win()
  -- Semi-transparent overlay
  love.graphics.setColor(TRANSPARENT_GRAY)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

  -- Message
  local message = ""
  if self.winner == "user" then
    message = "You Win!"
  elseif self.winner == "enemy" then
    message = "Enemy Wins!"
  else
    message = "It's a Tie!"
  end
  love.graphics.setColor(WHITE)
  love.graphics.printf(message, 0, love.graphics.getHeight() / 2 - 50, love.graphics.getWidth(), "center")

  -- Restart Button
  love.graphics.setColor(LIGHT_BLUE)
  love.graphics.rectangle("fill", 
      RESTART_BUTTON.position.x, 
      RESTART_BUTTON.position.y, 
      RESTART_BUTTON.size.x, 
      RESTART_BUTTON.size.y
  )
  love.graphics.setColor(WHITE)
  love.graphics.printf("New Game?", 
      RESTART_BUTTON.position.x, 
      RESTART_BUTTON.position.y + (RESTART_BUTTON.size.y / 2 - 10), 
      RESTART_BUTTON.size.x, 
      "center"
  )
end

-- Restart the game
function GameManagerClass:restartGame()
  print("[GameManager] Restarting game...")
  self.turn = 1
  self.userPlayer = PlayerClass:new("user")
  self.enemyPlayer = PlayerClass:new("enemy")
  self.board = BoardClass:new()
  self.grabber = GrabberClass:new()
  self.currentTurn = GAME_TURN.USER
  self.winner = nil
  self.gameOver = false

  -- Initial hands
  for i = 1, STARTING_HAND do
    self.userPlayer:drawCard()
    self.enemyPlayer:drawCard()
  end
end
