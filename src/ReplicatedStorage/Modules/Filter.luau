--!strict
-- CREDIT on the sphere: https://www.youtube.com/watch?v=XmPwEcrjdDU
local Filter = {}

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Filters = ReplicatedStorage:WaitForChild("Filters")

Filter.Filters = {
    Red   = 1,
    Blue  = 2,
    Green = 3,
}

Filter.Actives = {}

function Filter.Attach(filter)
    local _name = nil
    for k, v in pairs(Filter.Filters) do
        if v == filter then
            _name = k 
            break
        end
    end

    if not _name then return end

    local mesh = Filters:WaitForChild(_name):Clone()
    mesh.Parent = workspace.Invisible.Filters

    Filter.Actives[filter] = {
        Mesh = mesh,
        Connection = RunService.RenderStepped:Connect(function()
            local camera = workspace.CurrentCamera
            mesh.CFrame = camera.CFrame
        end),
    }
end

function Filter.Detach(filter)
    local _filter = Filter.Actives[filter]
    if not _filter then return end

    _filter.Connection:Disconnect()
    _filter.Mesh:Destroy()
    _filter = nil
end

function Filter.Reset()
    for _name, _ in pairs(Filter.Actives) do
        Filter.Detach(_name)
    end
end

return Filter
