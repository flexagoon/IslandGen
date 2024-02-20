using Luxor

const WIDTH = 600
const HEIGHT = 600

include("Utils.jl")
include("Generators.jl")

function draw()
    setantialias(1)
    background("#0978ABFF")
    initnoise()
    island = Island([], Dict(), nothing)
    make_island!(island)
    make_elevation!(island)
    add_tribe!(island)
    for (point, e) in island.elevations
        elevation_color(e) |> setcolor
        paint(point)
    end
    sethue("gray")
    ngon(island.mecca.location, 5, island.mecca.sides; action=:fill)
    for (sat, sides) in island.mecca.satellites
        ngon(sat, 3, sides; action=:fill)
    end
end

@png draw() WIDTH HEIGHT "image.png"
