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
