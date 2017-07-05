--MODULE FOR AUDIO STUFF--

local funcs = {}

function funcs.update_sfx_volume(volume)
  for _,sfx in pairs(SFX) do
    sfx:setVolume(volume)
  end
end

function funcs.update_bgm_volume(volume)
  for _,bgm in pairs(BGM) do
    sfx:setVolume(volume)
  end
end

return funcs
