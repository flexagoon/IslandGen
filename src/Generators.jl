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
    for p in bb
        if !isinside(p, island.border)
            continue
        end

        distances = []
        for bp in island.border
            push!(distances, √distance(p, bp))
        end
        distmap[p] = minimum(distances)
    end
    max_dist = distmap |> values |> maximum

    for (point, dist) in distmap
        n = noise(0.01point.x, 0.01point.y)
        island.elevations[point] = dist / max_dist * n
    end
end

function add_tribe!(island)
    points = island.elevations |> keys

    steepness = 1
    mecca = O
    while steepness > 0.02
        mecca = rand(points)
        bb = box(mecca, 20, 20) |> BoundingBox
        elevations = []
        for p in bb
            if p ∉ points
                continue
            end
            push!(elevations, island.elevations[p])
        end
        steepness = std(elevations)
    end

    mecca_sides = rand(3:6)

    satellites = Dict{Point,Integer}()
    satellite_count = rand(0:3)
    for _ in 1:satellite_count
        r = rand(0:2π)
        x = mecca.x + 12cos(r) |> round
        y = mecca.y + 12sin(r) |> round
        p = Point(x, y)
        if p ∉ points
            sides = rand(3:mecca_sides)
            satellites[p] = sides
        end
    end

    island.mecca = Mecca(mecca, mecca_sides, satellites)
end
