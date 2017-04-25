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

        --Draw the background right side
        local bg_color = RGB(185, 66, 237)
        Color.set(bg_color)
        love.graphics.rectangle("fill", WINDOW_DIVISION, 0, WIN_W - WINDOW_DIVISION, WIN_H)

        --Draw the background left side
        bg_color = RGB(66,134,244)
        Color.set(bg_color)
        love.graphics.rectangle("fill", 0, 0, WINDOW_DIVISION, WIN_H)

        --Draw ship "possible-positions" line
        s = Util.findId("player")
        if s then
            love.graphics.setLineWidth(3)
            local color = Color.copy(bg_color)
            color.r, color.g, color.b = 1.3*color.r, 1.3*color.g, 1.3*color.b --Make it the color of the bg but lighter
            Color.set(color)
            love.graphics.line(s.pos.x, s.margin_distance, s.pos.x, WIN_H - s.margin_distance)
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
