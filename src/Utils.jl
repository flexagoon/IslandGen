using Luxor

struct Island
    border::Vector{Point}
    elevations::Dict{Point,AbstractFloat}
end

function noisify(x, y, nw)
    ns = 1 / nw
    nx = nw * noise(ns * x, ns * y, 0) - nw / 2
    ny = nw * noise(ns * x, ns * y, 1) - nw / 2
    return x + nx, y + ny
end

paint(p::Point) = box(p, 1, 1, :fill)

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
