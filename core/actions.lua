local creature = require("core.creature")
local level = require("level")
local random = require("utils.random")
local special = require("special")


local module = {}

module.move = function(direction_name)
  return function(entity, state)
    entity.direction = direction_name
    if (
      entity.turn_resources.movement > 0 and
      level.move(state.grids[entity.layer], entity, entity.position + Vector[direction_name])
    ) then
      entity.turn_resources.movement = entity.turn_resources.movement - 1

      if entity.animate then
        entity:animate("move")
      end
    end
  end
end

module.hand_attack = function(entity, state, target)
  if entity.turn_resources.actions <= 0
    or not target
    or not target.hp
  then
    return false
  end

  entity.turn_resources.actions = entity.turn_resources.actions - 1

  local attack_roll = random.d(20)
    + creature.get_modifier(entity.abilities.strength)
    + entity.proficiency_bonus

  Log.info(
    entity.name .. " attacks " .. target.name .. "; attack roll: " ..
    attack_roll .. ", armor: " .. target:get_armor()
  )

  if attack_roll < target:get_armor() then
    state:add(special.floating_damage("-", target.position))
    return false
  end

  local damage_roll
  if entity.inventory.main_hand then
    damage_roll = random.d(entity.inventory.main_hand.die_sides)
      + creature.get_modifier(entity.abilities.strength)
      + entity.inventory.main_hand.bonus
  else
    damage_roll = creature.get_modifier(entity.abilities.strength) + 1
  end

  local damage = math.max(0, damage_roll)
  Log.info("damage: " .. damage)
  state:add(special.floating_damage(damage, target.position))

  target.hp = target.hp - damage
  if target.hp <= 0 then
    state:remove(target)
    Log.info(target.name .. " is killed")
  end

  return true
end

return module