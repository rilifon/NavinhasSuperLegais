--MODULE FOR BACKGROUND MUSIC AND STUFF--

local bgm = {}

--BGM object that has a source, and a beat time to start playiing
BGM = Class{
    __includes = {ELEMENT},
    init = function(self, _source, _start_time)
        ELEMENT.init(self)

        self.source = _source --Sound
        self.started = false --If song has started
        self.start_time = _start_time --Time to start the bgm (in beats)

        self.type = "BGM"
    end
}

function BGM:update()
    local b = self

    if not b.started and MUSIC_BEAT >= b.start_time then
        b.started = true
        b.source:play()
    end
end

function BGM:pause()
    self:pause()
end

function BGM:resume()
    self:resume()
end

------------------
--USEFUL FUNCTIONS
------------------

--Create and return a bgm object
function bgm.create(source, start, id)
    local id = id or "cur_bgm"
    local b = BGM(source, start)
    b:setId(id)

    return b
end

---------------
--PRESET COLORS
---------------

--Return functions
return bgm
