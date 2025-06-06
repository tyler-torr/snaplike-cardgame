-- board.lua

require "location"

BoardClass = {}

function BoardClass:new()
  local board = {}
  local metadata = {__index = BoardClass}
  setmetatable(board, metadata)
  
  board.locations = {}
  
  for i = 1, NUM_LOCATIONS do
    local locationDistance = (i - 1) * BOARD_X_LOCATION_DISTANCE
    local location = LocationClass:new(i, BOARD_X_START + locationDistance, BOARD_Y_START)
    table.insert(board.locations, location)
  end
  
  return board
end

function BoardClass:update()
  for _, location in ipairs(self.locations) do
    if location.update then
      location:update()
    end
  end
end

function BoardClass:draw()
  for _, location in ipairs(self.locations) do
    location:draw()
  end
end
