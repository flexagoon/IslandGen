using Statistics

function make_island!(island::Island)
    for r in 0:1°:360°
        x = (WIDTH / 4) * cos(r)
        y = (HEIGHT / 4) * sin(r)
        x, y = noisify(x, y, 300)
        x, y = noisify(x, y, 35) .|> round
        push!(island.border, Point(x, y))
    end
end

function make_elevation!(island::Island)
    bb = BoundingBox(island.border)
    distmap = Dict{Point,AbstractFloat}()
    for p in bb
        if !isinside(p, island.border; allowonedge=true)
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
    location = O
    while steepness > 0.02
        location = rand(points)
        bb = box(location, 20, 20) |> BoundingBox
        elevations = []
        for p in bb
            if p ∉ points
                continue
            end
            push!(elevations, island.elevations[p])
        end
        steepness = std(elevations)
    end

    houses = Point[]
    house_count = rand(1:5)
    for _ in 1:house_count
        r = rand(0:5°:360°)
        dist = rand(19:22)
        x = location.x + dist * cos(r) |> round
        y = location.y + dist * sin(r) |> round
        p = Point(x, y)
        if p ∈ points
            push!(houses, p)
        end
    end

    island.tribe = Tribe(location, houses, nothing)
end

function add_mecca!(island)
    if isnothing(island.tribe)
        return
    end

    points = island.elevations |> keys
    mecca_sides = rand(3:6)
    satellites = Dict{Point,Integer}()
    satellite_count = rand(0:min(3, length(island.tribe.houses)))
    for _ in 1:satellite_count
        r = rand(0:1°:360°)
        x = island.tribe.location.x + 12cos(r) |> round
        y = island.tribe.location.y + 12sin(r) |> round
        p = Point(x, y)
        if p ∈ points
            sides = rand(3:mecca_sides)
            satellites[p] = sides
        end
    end
    island.tribe.mecca = Mecca(mecca_sides, satellites)
end;
