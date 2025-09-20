--!strict
local Timer = {}
Timer.__index = Timer

function Timer.new()
    local events = {
        Progression = Instance.new("BindableEvent"),
        Finished = Instance.new("BindableEvent"),
    }

	return setmetatable({
        Events = events,

        -- NOTE: somehow if we named these events the same as `Events.Timer` (deleted now), it gets
        --       replaced, lmao what a language.
        Progression = events.Progression.Event,
        Finished = events.Finished.Event,

        Running = false,
        StartTime = 0,
        Duration = 0,
    }, Timer)
end

function Timer:Start(duration)
    if self.Running then
        warn("Warning: timer could not start again as it is already running.")
        return
    end

    self.Running = true
    self.Duration = duration
    self.StartTime = tick()

    task.spawn(function()
        local lastUpdate = 0

        while self.Running and tick() - self.StartTime < duration do
            task.wait()

            local elapsed = tick() - self.StartTime
            local alpha = elapsed / duration -- 0 -> 1 progress

            if elapsed - lastUpdate >= .25 then
                self.Events.Progression:Fire(1 - alpha) -- 1 -> 0 progress

                lastUpdate = elapsed
            end
        end

        -- NOTE: stopped by other script, we don't want to fire finished.
        if not self.Running then return end

        self:Stop()
        self:Reset()

        self.Events.Finished:Fire()
    end)
end

function Timer:GetTimeLeft()
    if not self.Running then
        warn("Warning: could not get remaining time, timer is not running.")
        return
    end

    local now = tick()
    local timeLeft = self.Duration - (now - self.StartTime)

    if timeLeft < 0 then
        timeLeft = 0
    end

    return timeLeft
end

function Timer:Reset()
    self.StartTime = 0
    self.Duration = 0
end

function Timer:Stop()
    self.Running = false
end

return Timer
