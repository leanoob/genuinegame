local TileSize = 7
local HalfTile = TileSize/2
local TilesPerChunkX, TilesPerChunkY, TilesPerChunkZ = 32, 5, 32
local ChunkWorldX = TilesPerChunkX * TileSize
local ChunkWorldY = TilesPerChunkY * TileSize
local ChunkWorldZ = TilesPerChunkZ * TileSize

local function GetChunk(Location: Vector3)
    local tx = Location.X // TileSize
    local ty = Location.Y // TileSize
    local tz = Location.Z // TileSize
    return Vector3.new(
        tx // TilesPerChunkX,
        ty // TilesPerChunkY,
        tz // TilesPerChunkZ
    )
end

local function GetTile(Location: Vector3)
    local tx = Location.X // TileSize
    local ty = Location.Y // TileSize
    local tz = Location.Z // TileSize
    return Vector3.new(
        tx % TilesPerChunkX,
        ty % TilesPerChunkY,
        tz % TilesPerChunkZ
    )
end

local function GetWorldFromTile(ChunkIndex: Vector3, Tile: Vector3)
    local nx = ChunkIndex.X + (Tile.X // TilesPerChunkX)
    local ny = ChunkIndex.Y + (Tile.Y // TilesPerChunkY)
    local nz = ChunkIndex.Z + (Tile.Z // TilesPerChunkZ)

    local rx = Tile.X % TilesPerChunkX
    local ry = Tile.Y % TilesPerChunkY
    local rz = Tile.Z % TilesPerChunkZ

    return Vector3.new(
        (nx * TilesPerChunkX + rx) * TileSize,
        (ny * TilesPerChunkY + ry) * TileSize,
        (nz * TilesPerChunkZ + rz) * TileSize
    )
end

local function GetWorldFromTileCentered(ChunkIndex: Vector3, Tile: Vector3)
    local nx = ChunkIndex.X + (Tile.X // TilesPerChunkX)
    local ny = ChunkIndex.Y + (Tile.Y // TilesPerChunkY)
    local nz = ChunkIndex.Z + (Tile.Z // TilesPerChunkZ)

    local rx = Tile.X % TilesPerChunkX
    local ry = Tile.Y % TilesPerChunkY
    local rz = Tile.Z % TilesPerChunkZ

    return Vector3.new(
        (nx * TilesPerChunkX + rx) * TileSize + HalfTile,
        (ny * TilesPerChunkY + ry) * TileSize + HalfTile,
        (nz * TilesPerChunkZ + rz) * TileSize + HalfTile
    )
end

return {
	GetChunk = GetChunk,
	GetTile = GetTile,
	GetWorldFromTile = GetWorldFromTile,
	GetWorldFromTileCentered = GetWorldFromTileCentered
}
