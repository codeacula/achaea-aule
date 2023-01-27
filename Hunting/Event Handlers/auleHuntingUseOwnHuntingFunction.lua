aule.hunting.kbash = nil

function auleHuntingUseOwnHuntingFunction()
  aule.hunting.kbash = keneanung.bashing.nextAttack
  keneanung.bashing.nextAttack = aule.hunting.bash
end
