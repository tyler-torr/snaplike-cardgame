-- location.lua

require "card"


LocationClass = {}


function LocationClass:new(index, xPos, yPos)
  local location = {}
  local metadata = {__index = LocationClass}
  setmetatable(location, metadata)
  
  location.name = "Location " .. tostring(index)
  location.index = tonumber(index)
  location.slots = {
      user = {false, false, false, false},
      enemy = {false, false, false, false}
  }
  
  print(#location.slots.user)
  
  location:createLocation(xPos, yPos)
  
  return location
end

function LocationClass:update()
  
end

function LocationClass:draw()
  -- Name
  love.graphics.setColor(WHITE)
  love.graphics.printf(self.name, self.x, self.y, self.width, "center")
  
  -- Background
  love.graphics.setColor(TRANSPARENT_GRAY)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
  
  -- Draw a slot within a Location, used for Enemy & User Cards
  local function _drawSlot(slot, card, borderColor)
    love.graphics.setColor(borderColor)
    love.graphics.rectangle("line", slot.x, slot.y, slot.width, slot.height)
    if card then
      card.position.x = slot.x
      card.position.y = slot.y
      card:draw()
    end
  end
  
  -- Enemy Cards
  for i, slot in ipairs(self.visualEnemySlots) do
    _drawSlot(slot, self.slots.enemy[i], TINTED_RED)
  end
  
  -- User Cards
  for i, slot in ipairs(self.visualUserSlots) do
    _drawSlot(slot, self.slots.user[i], TINTED_BLUE)
  end
end



-- Create a Location with 4 slots for the User and the Enemy
function LocationClass:createLocation(xPos, yPos)
  self.x = xPos
  self.y = yPos
  self.width = LOCATION_X_SPACING + CARD_WIDTH
  self.height = ((NUM_SLOTS - 1) * LOCATION_Y_SPACING) + CARD_HEIGHT
  
  -- Used to create the 4 slots in a location
  local function _createSlots(xPos, yPos)
      local slots = {}
      for slot = 1, NUM_SLOTS do
        table.insert(slots, {
            x = xPos,
            y = yPos + (slot - 1) * LOCATION_Y_SPACING,
            width = CARD_WIDTH,
            height = CARD_HEIGHT,
        })
    end
    return slots
  end
  
  local userVisual = _createSlots(xPos, yPos)
  local enemyVisual = _createSlots(xPos + LOCATION_X_SPACING, yPos)

  self.visualUserSlots = userVisual
  self.visualEnemySlots = enemyVisual
end

-- Figure out which Player is winning in a Location
function LocationClass:getWinner()
  local userPower = self:getPlayerPower("user")
  local enemyPower = self:getPlayerPower("enemy")
  
  if userPower > enemyPower then
    return "user", userPower, enemyPower
  elseif enemyPower > userPower then
    return "enemy", userPower, enemyPower
  else
    return "tie", userPower, enemyPower
  end
end

-- Calculate the total Power of a Player's Location
function LocationClass:getPlayerPower(player)
  local total = 0
  for _, card in ipairs(self.slots[player]) do
    if card then total = total + card.power end
  end
  return total
end

-- Check whether the Player has an empty Slot available for a location
function LocationClass:hasEmptySlot(player)
  for _, slot in ipairs(self.slots[player]) do
    if slot == false then return true end
  end
  return false
end

-- Add a Card to a Location
function LocationClass:addCard(player, card, slotIndex)
  if slotIndex then
    -- Validate slotIndex
    if slotIndex < 1 or slotIndex > #self.slots[player] then return false, "Invalid slotIndex" end

    if self.slots[player][slotIndex] == false then
      self.slots[player][slotIndex] = card
      return true, slotIndex
    else
      return false, "OCCUPIED"
    end
  else
    -- No slotIndex specified, find empty Slot if possible
    for i = 1, #self.slots[player] do
      if self.slots[player][i] == false then
        self.slots[player][i] = card
        return true, i
      end
    end
    return false, "FULL LOCATION"
  end
end
