function auleSilentlyCheckHarbour()
  if mmp.currentroom < 1 then return true end

  local features = mmp.getRoomMapFeatures(mmp.currentroom)

  if not features then return true end

  for _, feature in ipairs(features) do
    if feature == "harbour" then
      aule.sailing.isCheckingHarbour = true
      send("echo <<Start Capture Harbour>>|harbour ships|echo <<End Capture Harbour>>", false)
    end
  end
end
