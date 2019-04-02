-- Collision detection taken function from http://love2d.org/wiki/BoundingBox.lua
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function RectangleCollide(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
        x2 < x1+w1 and
        y1 < y2+h2 and
        y2 < y1+h1
end

function PointIsInRectangle(px, py, tlx, tly, brx, bry)
  return px > tlx and
         px < brx and
         py > tly and
         py < bry
end

-- To make a deepcopy of a table
function DeepCopyTable(input)	-- thanks to https://gist.github.com/tylerneylon for providing this function
if type(input) ~= "table" then return input end
    local copy = setmetatable({}, getmetatable(input))
    for i, d in pairs(input) do copy[DeepCopyTable(i)] = DeepCopyTable(d) end
    return copy
end

function VerticesFromSquareAsTwoPoints(data)
    local vertices = {}
      -- tl
    vertices[1] = data.tl.x
    vertices[2] = data.tl.y
      -- tr
    vertices[3] = data.br.x
    vertices[4] = data.tl.y
      -- br
    vertices[5] = data.br.x
    vertices[6] = data.br.y
      --bl
    vertices[7] = data.tl.x
    vertices[8] = data.br.y
    return vertices
end

function ColourEquals(one, two)
  return  one.r == two.r and
          one.g == two.g and
          one.b == two.b and
          one.a == two.a
end

function ColoursToTable(r, g, b, a)
  return {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
end

function RGBAFromColourTable(colour)
  return colour.r, colour.g, colour.b, colour.a
end

-- Appends table b to a, assumes an array like table
-- works as an addition to the table library from lua itself
function table.append(a, b)
  for _, d in ipairs(b) do
    table.insert(a, d)
  end
  return a
end

function table.contains(a, b)
  for _, d in pairs(a) do
    if d == b then
      return true
    end
  end
  return false
end

function table.reverse(input)
  local reversed = {}

  for i=1, #input, 1 do
    reversed[#input-i+1] = input[i]
  end
  return reversed
end

function table.print(input, recursive)
  if type(input) ~= "table" then
    return input
  end
  for i, d in pairs(input) do
    if recursive then
      print(i, table.print(d))
    else
      print(i, d)
    end
  end
end
