-- StripMine v1.0
-- todo:
-- Add ender storage for fuel allowing for infinitely long trips
-- Add GPS + Rednet for locating and ability to wirelessly controll it.
-- Map it's location on computer

ores = {
    "minecraft:coal_ore",
    "minecraft:deepslate_coal_ore",
    "minecraft:iron_ore",
    "minecraft:deepslate_iron_ore",
    "minecraft:copper_ore",
    "minecraft:deepslate_copper_ore",
    "minecraft:gold_ore",
    "minecraft:deepslate_gold_ore",
    "minecraft:redstone_ore",
    "minecraft:deepslate_redstone_ore",
    "minecraft:emerald_ore",
    "minecraft:deepslate_emerald_ore",
    "minecraft:lapis_ore",
    "minecraft:deepslate_lapis_ore",
    "minecraft:diamond_ore",
    "minecraft:deepslate_diamond_ore",
    "minecraft:nether_gold_ore",
    "minecraft:nether_quartz_ore"
}

function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

function check_block(direction)
    local success, data
    if direction == "up" then
      success, data = turtle.inspectUp()
    elseif direction == "down" then
      success, data = turtle.inspectDown()
    else
      success, data = turtle.inspect()
    end
    if success then
      return data.name
    end
end

function inventory_search(lookingFor)
    for i=1,16 do -- itterate through inventory to get selected block
      turtle.select(i)
      local selectedItem = turtle.getItemDetail()
      if selectedItem then
        selectedItem = selectedItem.name
      end
      if selectedItem == lookingFor then
        return true
      end
    end
end

function fuel_check(distance)
    fuelLevel = turtle.getFuelLevel()
    distance = distance * 2;
    if fuelLevel < distance then
        print('not enough fuel')
        do return end
    end
end

function mine()
    turtle.digUp()
    turtle.digDown()
    turtle.dig()
end

function turn_around()
    turtle.turnLeft()
    turtle.turnLeft()
end

function deposit()
    turtle.digDown()
    inventory_search('enderstorage:ender_chest')
    turtle.placeDown()
    for i = 1, 16, 1 do
        turtle.select(i)
        turtle.dropDown()
    end
    turtle.select(1)
    turtle.digDown()
end

function excevate(lenght)
    length = tonumber(lenght)
    for i=0, length, 1 do
        mine()
        turtle.forward()
        if i % 64 == 0 then -- every 64 distance, it will dig down to put ender chest and drop all of its inventory there
            deposit()
        end
    end
    turn_around() -- once done mining, return back to starting location
    deposit()
    for i=0, length, 1 do
        turtle.forward()
    end
end

--program
print('Strip Mine program')
print()
print()
--check for required items
if not inventory_search('enderstorage:ender_chest') then
    print('Please add ender storage chest')
    do return end -- stop program (weird syntax, find a better way)
end
print("Mine length?")
mineLength = io.read()
fuel_check(mineLength)
excevate(mineLength)
