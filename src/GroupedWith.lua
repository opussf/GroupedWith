GROUPEDWITH_MSG_VERSION = GetAddOnMetadata("GroupedWith","version")
GROUPEDWITH_MSG_ADDONNAME = "GroupedWith"

-- Colours
COLOR_RED = "|cffff0000"
COLOR_GREEN = "|cff00ff00"
COLOR_BLUE = "|cff0000ff"
COLOR_PURPLE = "|cff700090"
COLOR_YELLOW = "|cffffff00"
COLOR_ORANGE = "|cffff6d00"
COLOR_GREY = "|cff808080"
COLOR_GOLD = "|cffcfb52b"
COLOR_NEON_BLUE = "|cff4d4dff"
COLOR_END = "|r"

GroupedWith_data = {}

GroupedWith = {}

-- loaded
function GroupedWith.OnLoad()
	GroupedWithFrame:RegisterEvent("ADDON_LOADED")
	GroupedWithFrame:RegisterEvent("PARTY_MEMBERS_CHANGED")

	--register slash commands
	SLASH_GROUPEDWITH1 = "/groupedwith";
	SLASH_GROUPEDWITH2 = "/gw";
	SlashCmdList["GROUPEDWITH"] = function(msg) GroupedWith.command(msg); end

	-- Chat system hook
--	ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", Hitlist.CHAT_MSG_SYSTEM)
--	GameTooltip:HookScript( "OnTooltipSetUnit", Hitlist.HookSetUnit )
end

-- events
function GroupedWith.ADDON_LOADED()
end

function GroupedWith.PARTY_MEMBERS_CHANGED()
	print( "PARTY_MEMBERS_CHANGED" )
end

