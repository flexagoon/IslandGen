using Luxor

const ° = π / 180

struct Mecca
    sides::Integer
    satellites::Dict{Point,Integer}
end

mutable struct Tribe
    location::Point
    houses::Vector{Point}
    mecca::Union{Mecca,Nothing}
end

mutable struct Island
    border::Vector{Point}
    elevations::Dict{Point,AbstractFloat}
    tribe::Union{Tribe,Nothing}
end

macro chance(chance, action)
    quote
        if rand() < $chance
            $(esc(action))
        end
    end
end

function noisify(x, y, nw)
    ns = 1 / nw
    nx = nw * noise(ns * x, ns * y, 0) - nw / 2
    ny = nw * noise(ns * x, ns * y, 1) - nw / 2
    return x + nx, y + ny
end

paint(p::Point) = box(p, 1, 1, :fill)

Base.iterate(bb::BoundingBox) = (bb.corner1, 1)
function Base.iterate(bb::BoundingBox, i)
    width = bb.corner2.x - bb.corner1.x + 1
    height = bb.corner2.y - bb.corner1.y + 1
    bsize = width * height
    if i ≥ bsize
        return nothing
    end
    y, x = divrem(i, width)
    x += bb.corner1.x
    y += bb.corner1.y
    return (Point(x, y), i + 1)
end

function elevation_color(e)
    if e ≤ 0.1
        "#D3CA9D"
    elseif e ≤ 0.2
        "#DED6A3"
    elseif e ≤ 0.3
        "#E8E1B6"
    elseif e ≤ 0.4
        "#EFEBC0"
    elseif e ≤ 0.5
        "#E1E4B5"
    elseif e ≤ 0.6
        "#D1D7AB"
    elseif e ≤ 0.7
        "#BDCC96"
    elseif e ≤ 0.8
        "#A8C68F"
    else
        "#94BF8B"
    end
end;
