hexcnts = {5, 6, 7, 8, 9, 8, 7, 6, 5}
hexorient = {math.rad(0), math.rad(61), math.rad(119), math.rad(180), math.rad(241), math.rad(299)}

function hex_valid(i,j)
  return level and i and j and i >= 1 and i <= 9 and j >= 1 and j <= hexcnts[i] and string.sub(level.tiles[j], i, i) == '.'
end

function hexx(i, j)
  if hex_valid(i, j) then
    return 512 + 74*(i-5)
  else
    return nil
  end
end

function hexy(i, j)
  if hex_valid(i, j) then
    return 352 + j*82 - hexcnts[i]*41
  else
    return nil
  end
end
