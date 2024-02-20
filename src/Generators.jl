using Statistics

function make_island!(island::Island)
    for r in 0:π/180:2π
        x = (WIDTH / 4) * cos(r)
        y = (HEIGHT / 4) * sin(r)
        x, y = noisify(x, y, 300)
        x, y = noisify(x, y, 35)
        push!(island.border, Point(x, y))
    end
end

function make_elevation!(island::Island)
    bb = BoundingBox(island.border)
    distmap = Dict{Point,AbstractFloat}()
    for x in bb.corner1.x:bb.corner2.x
        for y in bb.corner1.y:bb.corner2.y
            p = Point(x, y)
            if !isinside(p, island.border)
                continue
            end

            distances = []
            for bp in island.border
                push!(distances, √distance(p, bp))
            end
            distmap[p] = minimum(distances)
        end
    end
    max_dist = distmap |> values |> maximum

    for (point, dist) in distmap
        n = noise(0.01point.x, 0.01point.y)
        island.elevations[point] = dist / max_dist * n
    end
end

function add_tribe!(island)
    points = island.elevations |> keys
    sethue("red")
    steepness = 1
    mecca = O
    while steepness > 0.02
        mecca = rand(points)
        bb = box(mecca, 20, 20) |> BoundingBox
        elevations = []
        for x in bb.corner1.x:bb.corner2.x
            for y in bb.corner1.y:bb.corner2.y
                p = Point(x, y)
                if !haskey(island.elevations, p)
                    continue
                end
                push!(elevations, island.elevations[p])
            end
        end
        steepness = std(elevations)
    end
    circle(mecca, 5, :fill)
end
