aule.hunting = aule.hunting or {}
aule.hunting.afterAttackHelpers = {}
aule.hunting.attackOnUpdate = false
aule.hunting.beforeAttackHelpers = {}
aule.hunting.buttons = aule.hunting.buttons or {}

function aule.hunting.bash()
  for _, func in ipairs(aule.hunting.beforeAttackHelpers) do
    func()
  end

  aule.hunting.kbash()

  for _, func in ipairs(aule.hunting.afterAttackHelpers) do
    func()
  end
end

function aule.hunting.registerAfterAttackHelper(func)
  aule.hunting.afterAttackHelpers[#aule.hunting.afterAttackHelpers + 1] = func
end

function aule.hunting.registerBeforeAttackHelper(func)
  aule.hunting.beforeAttackHelpers[#aule.hunting.beforeAttackHelpers + 1] = func
end
