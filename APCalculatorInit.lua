local _, core = ...;

core.commands = {
    ["cal"] = core.Config.ShowCalculator,

    ["help"] = function()
        print(" ");
        core:Print("List of slash commands:")
        core:Print("|cff00cc66/apc cal|r - shows calculator window.")
        print(" ");
    end,

    --["example"] = {
    --    ["test"] = function(...)
    --        core:Print("My Value:", tostringall(...));
    --    end
    --},
}


local function HandleSlashCommands(str) 
    if(#str == 0) then
        core.commands.cal();
        return;
    end

    local args = {};-- what we will iterate over using for loop
    for _, arg in ipairs({string.split(' ', str) }) do
        if (#arg > 0) then
            table.insert( args, arg);
        end
    end

    local path = core.commands; --required for updating found tables

    for id, arg in ipairs(args) do
        if( #arg>0) then
            arg = arg:lower();
            if (path[arg]) then
                if (type(path[arg]) == "function") then
                    --all remaining args passed to our function!
                    path[arg](select(id + 1, unpack(args)));
                    return;
                elseif (type(path[arg]) == "table") then
                    path = path[arg];
                end
            else
                core.commands.cal();
                return;
            end
        end
    end
end

function core:Print(...)
    local hex = select(4, self.Config:GetThemeColor());
    local prefix = string.format("|cff%s%s|r", hex:upper(), "APCalculator:");
    DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", prefix, ...));
end

function core:init(event)   
    
    if (event ~= "APCalculator") then return end
    ---------------------------
    -- Register Slash Commands
    ---------------------------
    SLASH_APCalculator1 = "/apc";
    SlashCmdList.APCalculator = HandleSlashCommands;

    core:Print("Loaded, open pvp panel to check arena points or '/apc'.");
    CharacterFrame:HookScript("OnShow", core.Config.HandleCharacterPvpFrame)
    PVPTeamDetails:HookScript("OnShow", core.Config.HandleCharacterPvpFrame)
    core.Config.ShowFutureArenaPoints();
end
local events = CreateFrame("Frame");
events:RegisterEvent("ADDON_LOADED");
events:SetScript('OnEvent', function(self,event, ...)
    if (event == "ADDON_LOADED") then
        core.init(event,...)
    end
end)