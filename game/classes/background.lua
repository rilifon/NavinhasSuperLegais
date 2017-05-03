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

		self.parallax1 = {image=IMG_PARALAX1, tween_time=20,start=0,handle="parallax_tween_1"}
		self.parallax2 = {image=IMG_PARALAX2, tween_time=40,start=0,handle="parallax_tween_2"}

		parallax(self,self.parallax1)
		parallax(self,self.parallax2)
    end
}

--CLASS FUNCTIONS--

function Background:draw()
    local color --Temporary variable for color

    if self.mode == "game" then

        --Draw the background image
        Color.set(Color.white())
        local scale = WIN_H/IMG_BG:getHeight() --Scale bg to fit on screen
        --Draws the background image repeatedly until it fills the screen
        local x = 0
        while (x < WIN_W) do
            love.graphics.draw(IMG_BG, x, 0, 0, scale, scale)
            x = x + IMG_BG:getWidth()*scale
        end




        --Draw paralax
        Color.set(Color.white())
        local scale = .5
        local x = self.paralax_2_start
        while (x < WIN_W) do
            love.graphics.draw(self.paralax_2_image, x, WIN_H - self.paralax_2_image:getHeight()*scale, 0, scale, scale)
            x = x + self.paralax_2_image:getWidth()*scale
        end

        Color.set(Color.white())
        local x = self.paralax_1_start
        while (x < WIN_W) do
            love.graphics.draw(self.paralax_1_image, x, WIN_H - self.paralax_1_image:getHeight()*scale, 0, scale, scale)
            x = x + self.paralax_1_image:getWidth()*scale
        end

        --Draw ship "possible-positions" line
        s = Util.findId("player")
        if s then
            love.graphics.setLineWidth(3)
            local color = RGB(247, 116, 164,150)
            Color.set(color)
            local adjust = 25 --Adjust on line x coordinate so its alligned with the player body
            love.graphics.line(s.pos.x + adjust, s.margin_distance, s.pos.x + adjust, WIN_H - s.margin_distance)
        end

        --Draw window division for moving/shooting with the ship when touching
        love.graphics.setLineWidth(3)
        local color = RGB(247, 116, 164,150)
        Color.set(color)
        love.graphics.line(WINDOW_DIVISION, 0, WINDOW_DIVISION, WIN_H)

    end

end

function parallax(self,parallax_table)
	--print(self.paralax_1_image:getWidth()/self.paralax_1_speed)
	self.handles[parallax_table.handle] =
	MAIN_TIMER.tween(parallax_table.tween_time, parallax_table, {start = -parallax_table.image:getWidth()}, "in-linear", 
		function()
			parallax(parallax_table)
		end)
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
