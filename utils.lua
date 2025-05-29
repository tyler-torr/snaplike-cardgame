
-- Return whether a point is within the bounds of an object
function contains(obj, point)
  if not point then return false end
  return point.x >= obj.position.x and point.x <= obj.position.x + obj.size.x and
         point.y >= obj.position.y and point.y <= obj.position.y + obj.size.y
end