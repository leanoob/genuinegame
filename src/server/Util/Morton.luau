local band = bit32.band
local bor = bit32.bor
local bxor = bit32.bxor
local lshift = bit32.lshift
local rshift = bit32.rshift

-- max 1073741823

local function part1by2(n)
    n = band(n, 0x3FF)
    n = band(bor(n, lshift(n, 16)), 0x030000FF)
    n = band(bor(n, lshift(n,  8)), 0x0300F00F)
    n = band(bor(n, lshift(n,  4)), 0x030C30C3)
    n = band(bor(n, lshift(n,  2)), 0x09249249)
    return n
end

local function compact1by2(n)
    n = band(n, 0x09249249)
    n = band(bxor(n, rshift(n,  2)), 0x030C30C3)
    n = band(bxor(n, rshift(n,  4)), 0x0300F00F)
    n = band(bxor(n, rshift(n,  8)), 0x030000FF)
    n = band(bxor(n, rshift(n, 16)), 0x000003FF)
    return n
end

function morton3D_encode(x, y, z)
    return bor(
        part1by2(x),
        lshift(part1by2(y), 1),
        lshift(part1by2(z), 2)
    )
end

function morton3D_decode(code)
    local x = compact1by2(code)
    local y = compact1by2(rshift(code, 1))
    local z = compact1by2(rshift(code, 2))
    return x, y, z
end

return {
	encode = morton3D_encode,
	decode = morton3D_decode
}
