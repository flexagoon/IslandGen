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
    add_mecca!(island)
    for (point, e) in island.elevations
        elevation_color(e) |> setcolor
        paint(point)
    end
    sethue("brown")
    for house in island.tribe.houses
        rot = rand(0:1°:90°)
        ngon(house, 3, 4, rot; action=:fill)
    end
    sethue("gray")
    ngon(island.tribe.location, 5, island.tribe.mecca.sides; action=:fill)
    for (sat, sides) in island.tribe.mecca.satellites
        ngon(sat, 3, sides; action=:fill)
    end
end

@png draw() WIDTH HEIGHT "image.png"
