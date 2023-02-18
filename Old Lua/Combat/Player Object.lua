local function createPlayerObj()
  return {
    has = {},
    limbs = {
      head = { damage = 0, parrying = false },
      leftarm = { damage = 0, parrying = false },
      leftleg = { damage = 0, parrying = false },
      rightarm = { damage = 0, parrying = false },
      rightleg = { damage = 0, parrying = false },
      torso = { damage = 0, parrying = false },
    },
    name = "",
    resetTimer = nil,
  }
end

Player = {}
Player.__index = Player

function Player.new(name)
  local newChar = createPlayerObj()
  newChar.name = name

  newChar = setmetatable(newChar, Player)

  return newChar
end

function Player:addLimbDamage(limb, amount)

end

function Player:give(what, silent)
  self.has[what] = true
  self:startResetTimer()

  if not silent then
    cecho((" <green>%s<reset>"):format(what))
  end

  if aule.combat.giveCallbacks[what] then
    aule.combat.giveCallbacks[what](self)
  end
end

function Player:reset()
  if self.resetTimer then
    killTimer(self.resetTimer)
  end

  self = Player.new(self.name)
end

function Player:startResetTimer()
  if self.resetTimer then
    killTimer(self.resetTimer)
  end

  self.deleteTimer = tempTimer(20, function() self:reset() end)
end

function Player:take(what, silent)
  self.has[what] = false

  if not silent then
    cecho((" <red>%s<reset>"):format(what))
  end

  self:startResetTimer()

  if aule.combat.takeCallbacks[what] then
    aule.combat.takeCallbacks[what](self)
  end
end
