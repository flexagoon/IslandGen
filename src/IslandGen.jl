using Luxor

const WIDTH = 600
const HEIGHT = 600

include("Utils.jl")
include("Generators.jl")

function generate()
    initnoise()
    island = Island([], Dict(), nothing, nothing)
    make_island!(island)
    make_elevation!(island)
    @chance 1 / 2 add_tribe!(island)
    @chance 1 / 2 add_mecca!(island)
    @chance 1 / 2 add_castaway!(island)
    return island
end

function draw(island)
    setantialias(1)
    background("#0978ABFF")

    for (point, e) in island.elevations
        elevation_color(e) |> setcolor
        paint(point)
    end

    if !isnothing(island.tribe)
        sethue("brown")
        for house in island.tribe.houses
            rot = rand(0:1°:90°)
            ngon(house, 3, 4, rot; action=:fill)
        end

        if !isnothing(island.tribe.mecca)
            sethue("gray")
            ngon(island.tribe.location, 5, island.tribe.mecca.sides; action=:fill)
            for (sat, sides) in island.tribe.mecca.satellites
                ngon(sat, 3, sides; action=:fill)
            end
        end
    end

    if !isnothing(island.castaway)
        nearest_border_point = O
        border_dist = 9999
        for bp in island.border
            dist = distance(island.castaway, bp)
            if dist < border_dist
                nearest_border_point = bp
                border_dist = dist
            end
        end
        rx = (nearest_border_point.x - island.castaway.x) / border_dist
        ang = (island.castaway.y < nearest_border_point.y
               ? acos(rx) - 90°
               : -acos(rx) - 90°)

        setcolor("black")
        text("HELP", island.castaway; halign=:center, valign=:middle, angle=ang)
    end
end

@png generate() |> draw WIDTH HEIGHT "image.png"
