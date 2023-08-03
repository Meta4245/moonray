# moonray
(sorry for the messy directory structure) <br/>
LuaJIT bindings for raylib

## example
```lua
dofile("moonray.lua")

InitWindow(640, 480, "Example")

while not WindowShouldClose() do
    BeginDrawing()
        ClearBackground(RAYWHITE)
    EndDrawing()
end

CloseWindow()
```