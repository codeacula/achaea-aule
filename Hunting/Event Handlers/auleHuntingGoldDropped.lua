function auleHuntingGoldDropped()
  -- Don't bother if we don't have the basher
  if not keneanung or not keneanung.bashing then return end

  if keneanung.bashing.configuration.autopickup then
    svo.doaddfree("get gold")
  end
end
