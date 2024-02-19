run:
    julia --project=. src/IslandGen.jl

show:
    flatpak run org.wezfurlong.wezterm imgcat image.png --width 90%

alias gen := generate
generate: run show
