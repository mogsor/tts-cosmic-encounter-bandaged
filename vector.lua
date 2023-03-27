--[[ Types ]]--


---@alias Vector table<number, number, number>


--[[ Modules ]]--


local vector = {}


--[[ Functions ]]--


---Modifies a vector by a given angle and distance.
---@nodiscard
---@param source Vector
---@param angle number
---@param distance number
---@return Vector
vector.shift_vector = function(source, angle, distance)
    while angle >= 360 do angle = angle - 360 end
    while angle <    0 do angle = angle + 360 end
    return {
        source[1] + distance * math.sin(math.rad(angle)),
        source[2],
        source[3] + distance * math.cos(math.rad(angle)),
      }
end


---Gets the angle between the source and target vectors.
---@nodiscard
---@param source Vector
---@param target Vector | nil
---@return number
vector.get_angle = function(source, target)
    if target == nil then target = { 0, 0, 0 } end
    return math.deg(math.atan2(target[1] - source[1], target[3] - source[3]))
end


return vector
