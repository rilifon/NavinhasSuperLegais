--MODULE FOR BACKGROUND--
local Color = require "classes.color"

local bg = {}

--BACKGROUND CLASS--
--[Represents the background and grid visual]--

Background = Class{
    __includes = {ELEMENT},
    init = function(self, _mode)

        ELEMENT.init(self)

        self.mode = _mode or "game" --What mode the background is

        self.type = "background"
    end
}

--CLASS FUNCTIONS--

function Background:draw()

    if self.mode == "game" then
        --Draw the background
        local bg_color = RGB(66,134,244)
        Color.set(bg_color)
        love.graphics.rectangle("fill", 0, 0, WIN_W, WIN_H)

        --Draw the grid background
        local grid_color = RGB(115,216,60)
        Color.set(grid_color)
        local start_grid = (WIN_H - GRID_ROWS*TILESIZE)/2 --Start y position of grid on map
        love.graphics.rectangle("fill", 0, start_grid, GRID_COLS*TILESIZE, GRID_ROWS*TILESIZE)

        --Draw the grid lines--
        local line_color = RGB(255,255,255)
        Color.set(line_color)
        --Draw the vertical lines
        for i=0,GRID_COLS do
            love.graphics.line(i*TILESIZE, start_grid, i*TILESIZE, start_grid + TILESIZE*GRID_ROWS)
        end

        --Draw the horizontal lines
        for i=0,GRID_ROWS do
            love.graphics.line(0, start_grid + i*TILESIZE, GRID_COLS*TILESIZE, start_grid + i*TILESIZE)
        end

    end

end

--UTILITY FUNCTIONS--

--Create a background and initializes with give mode (default is "game")
function bg.create(mode)

    local background = Background(mode)
    background:addElement(DRAW_TABLE.BG, nil, "background")

    return background
end

--Return functions
return bg
