-- utils.lua


-- Return whether a point is within the bounds of an object
function contains(obj, point)
  if not point then return false end
  return point.x >= obj.position.x and point.x <= obj.position.x + obj.size.x and
         point.y >= obj.position.y and point.y <= obj.position.y + obj.size.y
end

-- Load card data from the CSV file
function loadCardsFromCSV(filePath)
  local cards = {}
  for line in love.filesystem.lines(filePath) do
    local name, cost, power, effect = line:match('^([^,]+),([^,]+),([^,]+),(.+)$')
    if name and cost and power and effect then
      table.insert(cards, {
        name = name,
        cost = tonumber(cost),
        power = tonumber(power),
        effect = effect:gsub('^"(.-)"$', '%1')w
      })
    end
  end
  return cards
end
