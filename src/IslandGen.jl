using Luxor

const WIDTH = 600
const HEIGHT = 600

include("Utils.jl")
include("Generators.jl")

function draw()
    setantialias(1)
    background("#0978ABFF")
    initnoise()
    island = Island([], Dict())
    make_island!(island)
    make_elevation!(island)
    for (point, e) in island.elevations
        elevation_color(e) |> setcolor
        paint(point)
    end
    add_tribe!(island)
end

@png draw() WIDTH HEIGHT "image.png"
