local _, core = ...;
core.Config = {};
local Config = core.Config;
local CalcUI;
local defaults = {
	theme = {
		r = 0,
		g = 0.8,
		b = 1,
		hex = "00ccff"
	}
}
local result2;
local result3;
local result5;

local arena2
local arena3
local arena5

local hideCalculatorButton
local optionsPanel
local calcButton
---------------------------
-- Config functions
---------------------------

function Config:GetThemeColor()
	local c = defaults.theme;
	return c.r, c.g, c.b, c.hex;
end

function Config:ShowFutureArenaPoints()
	PVPFrameArena:SetPoint("TOPLEFT", PVPFrameBackground, "TOPLEFT", 10, -95)
	PVPFrameArenaPoints:SetPoint("LEFT", PVPFrameArenaLabel, "RIGHT", 2, 0)

	arenaPointsHighest = CreateFrame("Frame", "PVPFrameArenaFuturePoints", PVPFrameArena)
	arenaPointsHighest:SetSize(100,15)
	arenaPointsHighest:SetPoint("LEFT", PVPFrameArenaIcon, "RIGHT", 15, 0)
	arenaFontHighest = arenaPointsHighest:CreateFontString(nil, "MEDIUM", "GameFontNormal")
	
	arenaFontHighest:SetPoint("CENTER", 0, 0)
	arenaFontHighest:SetFont("Fonts\\FRIZQT__.TTF", 10)	
	arenaFontHighest:SetJustifyH("CENTER")

	
	---------------------------
	--- ALL ARENA POINTS
	---------------------------
	arenaPointsAll = CreateFrame("Frame", "PVPFrameArenaFuturePointsAll", PVPFrameArena)
	arenaPointsAll:SetSize(80,15)
	arenaPointsAll:SetPoint("RIGHT", PVPFrameArena, "RIGHT", 20, 0)
	arenaFontAll = arenaPointsAll:CreateFontString(nil, "MEDIUM", "GameFontNormal")
	
	arenaFontAll:SetPoint("RIGHT", 0, 0)
	arenaFontAll:SetFont("Fonts\\FRIZQT__.TTF", 10)	

	
	Config:CalcButton()
	Config:CalcWindow()
	Config:CreateOptionsPanel()	
end

function Config:UpdateArenaValues()
	local hex = select(4, Config:GetThemeColor())
	local nextWeekText = "Next Week:\n"
	if hideText then
		nextWeekText = ""
	end
	local prefix = string.format("|cff%s%s|r", hex:upper(), nextWeekText .. Config:GetArenaPoints())
	--local prefix = string.format("|cff%s%s|r", hex:upper(), nextWeekText.."± 1789 - |cff00cc665v5|r" )
	arenaFontHighest:SetText(prefix)
	arenaFontAll:SetText(Config:GetArenaPoints(true))
end


function Config:CreateEditBox()

	local ratingLabel = CreateFrame("Frame", "ratingLabel", CalcUI)
	ratingLabel:SetSize(30,15)
	ratingLabel:SetPoint("TOPLEFT", CalcUI, "TOPLEFT", 20, -30)
	ratingLabelFont = ratingLabel:CreateFontString(nil, "MEDIUM", "GameFontNormal")
	
	ratingLabelFont:SetPoint("LEFT", 0, 0)
	ratingLabelFont:SetFont("Fonts\\FRIZQT__.TTF", 14)	

	ratingLabelFont:SetText("Rating")

	local pointsLabel = CreateFrame("Frame", "pointsLabel", CalcUI)
	pointsLabel:SetSize(30,15)
	pointsLabel:SetPoint("TOPLEFT", CalcUI, "TOPLEFT", 220, -30)
	pointsLabelFont = pointsLabel:CreateFontString(nil, "MEDIUM", "GameFontNormal")
	
	pointsLabelFont:SetPoint("LEFT", 0, 0)
	pointsLabelFont:SetFont("Fonts\\FRIZQT__.TTF", 14)	

	pointsLabelFont:SetText("Points")


	arena2 = Config:CreateSingleArenaModule("2v2", 1,CalcUI,30,-55)
	arena3 = Config:CreateSingleArenaModule("3v3", 2,arena2,0,-35)
	arena5 = Config:CreateSingleArenaModule("5v5", 3,arena3,0,-35)

	result2 = Config:CreatePointsEditBox(CalcUI,220,-70)
	result3 = Config:CreatePointsEditBox(result2,0,-50)
	result5 = Config:CreatePointsEditBox(result3,0,-50)

	local button = CreateFrame("Button", nil, arena3, "UIPanelButtonTemplate")
	button:SetWidth(80)
	button:SetHeight(20)
	button:SetPoint("BOTTOM", CalcUI,"BOTTOM", 0, 20)
	button:SetText("Calculate")
	button:SetScript("OnClick", Button_OnClick)
end

function Config:CreateSingleArenaModule(labelText, arenaGroupIndex, parent, X, Y)
	local arenaLabel = CreateFrame("Frame", "arenaLabel"..arenaGroupIndex, parent)
	arenaLabel:SetSize(30,15)
	arenaLabel:SetPoint("TOPLEFT", parent, "TOPLEFT", X, Y)
	arenaLabelFont = arenaLabel:CreateFontString(nil, "MEDIUM", "GameFontNormal")
	
	arenaLabelFont:SetPoint("LEFT", 0, 0)
	arenaLabelFont:SetFont("Fonts\\FRIZQT__.TTF", 12)	

	arenaLabelFont:SetText(labelText)

	local arena = CreateFrame("EditBox", "EditBox1", arenaLabel, "InputBoxTemplate");
	arena:SetAutoFocus(false)
	arena:SetMaxLetters(4)
	arena:SetSize(55, 20);
	arena:SetPoint("TOPLEFT", arenaLabel, "BOTTOMLEFT", 0, 0)
	arena:SetScript("OnEscapePressed", EditBox_OnEscapePressed)

	return arena
end

function Config:CreatePointsEditBox(parent, X, Y)
	local arena = CreateFrame("EditBox", "EditBoxPoints", parent, "InputBoxTemplate");
	arena:SetAutoFocus(false)
	arena:SetSize(55, 20);
	arena:SetPoint("TOPLEFT", parent, "TOPLEFT", X, Y)
	arena:Disable()

	return arena
end

function Config:CreateCheckBox(globalBool,checkLabeText,callback,xOffset,yOffset)
	-- Check
	local checkButton1 = CreateFrame("CheckButton", nil, optionsPanel, "UICheckButtonTemplate");
	checkButton1:SetPoint("TOPLEFT", optionsPanel, "TOPLEFT", xOffset, yOffset);
	checkButton1.text:SetText(checkLabeText);
	checkButton1:SetChecked(globalBool)
	checkButton1:SetScript("OnClick", callback)
end

function Config:CalcWindow()
	local frameToAttach = PVPFrame
	if PVPTeamDetails:IsShown() then
		frameToAttach = PVPTeamDetails
	end
	
	CalcUI = CreateFrame("Frame", "CalcFrame", frameToAttach, "UIPanelDialogTemplate");
	CalcUI:SetSize(300, 250)
	CalcUI:SetPoint("LEFT", frameToAttach, "RIGHT", 30, 0)

	CalcUI.Title:ClearAllPoints()
	CalcUI.Title:SetFontObject("GameFontHighlight")
	CalcUI.Title:SetPoint("LEFT", CalcUI, "TOPLEFT", 15, -15);
	CalcUI.Title:SetText("Arena Point Calculator")

	Config:CreateEditBox()
	CalcUI:Hide()	
end

function Config:HandleCharacterPvpFrame()
	if CalcUI ~= nil then
		if CalcUI:IsShown() then
			CalcUI:Hide()
		end
	end
	Config:UpdateArenaValues()
end

function Config:SetCalculatorParent()
	local frameToAttach = PVPFrame
	if PVPTeamDetails:IsShown() then
		frameToAttach = PVPTeamDetails
	end
	local calcUIWindow = CalcUI or Config:CalcWindow()
	calcUIWindow:SetParent(frameToAttach)
	calcUIWindow:SetPoint("LEFT", frameToAttach, "RIGHT", 30, 0)
end

function Config:CalcButton()
	calcButton = CreateFrame("Button", "CalcButton", PVPFrameArena, "UIPanelButtonTemplate")
	calcButton:SetSize(80,16)
	calcButton:SetPoint("TOP", PVPFrameArena, "BOTTOM", 20, -4)
	calcButton:SetText("Calculator")
	calcButton:HookScript("OnMouseUp", function(self, calcButton) 
		Config:ShowCalculator()
	end)
	calcButton:SetShown(not hideCalcButton)

end

function Config:ShowCalculator()
	if CharacterFrame:IsShown() == false then
		ToggleCharacter("PVPFrame")
	end
	local calcUIWindow = CalcUI or Config:CalcWindow()
	if calcUIWindow ~= nil then
		calcUIWindow:SetShown(not calcUIWindow:IsShown())
		Config:SetCalculatorParent()
	end
end

function Config:GetArenaPoints(returnAll)
	local twosRating = nil
	local threesRating = nil
	local fivesRating = nil
	local twosPoints = nil
	local threesPoints = nil
	local fivesPoints = nil
	for i = 1, 3 do
		local currentSize = select(2,GetArenaTeam(i))
		local weekPlayed,_,_,_,playerPlayed = select(4,GetArenaTeam(i))
		if currentSize ~= nil and weekPlayed > 9 and playerPlayed/weekPlayed >= 0.30 and playerPlayed > 2 then 
			if currentSize == 2 then
				twosRating = select(3,GetArenaTeam(i))
				twosPoints = core.APCData:APCalculate("2v2",twosRating)
			end
			if currentSize == 3 then
				threesRating = select(3,GetArenaTeam(i))
				threesPoints = core.APCData:APCalculate("3v3",threesRating)
			end
			if currentSize == 5 then
				fivesRating = select(3,GetArenaTeam(i))
				fivesPoints = core.APCData:APCalculate("5v5",fivesRating)
			end
		end
	end
	if returnAll == true then
		return ((twosPoints or 0) .." / "..(threesPoints or 0) .." / "..(fivesPoints or 0))
		--return "2142 / 2418 / 2660"
	end
	local addedText = ""
	local highest = twosPoints or 0
	if highest > 0 then
		addedText = " - |cff00cc662v2|r"
	end
	if threesPoints ~= nil and threesPoints > highest then
		highest = threesPoints
		addedText = " - |cff00cc663v3|r"
	end
	if fivesPoints ~= nil and fivesPoints > highest then 
		highest = fivesPoints
		addedText = " - |cff00cc665v5|r"
	end
	if(highest == 0) then
		return "|cff5c9456Not enough arenas|r"
	end
	return "±" .. highest .. addedText
end

function EditBox_OnEscapePressed(frame)
	frame:ClearFocus()
end

function Button_OnClick(frame)
	arena2:ClearFocus()
	arena3:ClearFocus()
	arena5:ClearFocus()
	result2:SetText(core.APCData:APCalculate("2v2",arena2:GetNumber()))
	result3:SetText(core.APCData:APCalculate("3v3",arena3:GetNumber()))
	result5:SetText(core.APCData:APCalculate("5v5",arena5:GetNumber()))
end

function HideTextCheckBoxOnCheck()
	hideText = not hideText
	Config:UpdateArenaValues()
end

function HideCalcButtonCheckBoxOnCheck()
	hideCalcButton = not hideCalcButton
	calcButton:SetShown(not hideCalcButton)
end

----------------------------
--[[	Options Panel	]]--
----------------------------
function Config:CreateOptionsPanel()
	optionsPanel=CreateFrame("Frame");
	optionsPanel.name="Arena Point Calculator";
	InterfaceOptions_AddCategory(optionsPanel);
	local title=optionsPanel:CreateFontString(nil,"OVERLAY","GameFontNormalLarge");
	title:SetPoint("TOP",0,-12);
	title:SetText("Arena Point Calculator");

	local author=optionsPanel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall");
	author:SetPoint("TOP",title,"BOTTOM",0,0);
	author:SetTextColor(1,0.5,0.25);
	author:SetText("by Pumpel");

	local ver=optionsPanel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall");
	ver:SetPoint("TOPLEFT",title,"TOPRIGHT",4,0);
	ver:SetTextColor(0.5,0.5,0.5);
	ver:SetText("v".."1.06");

	local showNextWeekCheckbox = Config:CreateCheckBox(hideText,"Hide 'Next Week' Text",HideTextCheckBoxOnCheck,45,-45)
	local showCalcButtonCheckbox = Config:CreateCheckBox(hideCalcButton,"Hide Calculator Button",HideCalcButtonCheckBoxOnCheck,45,-75)
end