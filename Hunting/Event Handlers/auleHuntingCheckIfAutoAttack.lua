function auleHuntingCheckIfAutoAttack()
  -- If we shouldn't automatically attack on room update, or if we're already attacking
  if not aule.hunting.attackOnUpdate or keneanung.bashing.attacking ~= 0 then return end

  -- If the list is empty or
  if #keneanung.bashing.targetList == 0 or #keneanung.bashing.targetList >= 3 then return end

  keneanung.bashing.attackButton()
end
