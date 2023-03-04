function auleCombatAddNamesAsSuggestions()
  for _, person in pairs(db:fetch(ndb.db.people)) do
    addCmdLineSuggestion(person.name)
  end
end
