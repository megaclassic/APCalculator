local _, core = ...;
core.APCData = {};

local APCData = core.APCData;
function APCData:Print(...)
    local hex = select(4, core.Config:GetThemeColor());
    local prefix = string.format("|cff%s%s|r", hex:upper(), "APCalculator:");
    DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", prefix, ...));
end


function APCData:APCalculate(bracket,rating)
	if(rating == nil or rating == 0 or rating == '') then
		return ''
	end
	local result = 0
	result = 580 + (1022/(1+(123*2.71828^(-0.00412*rating))))
	if bracket == "2v2" then
		result = result * 0.76
	elseif bracket == "3v3" then
		result = result * 0.88
	else
		result = result
	end
	return math.floor( result + 0.5)
end
