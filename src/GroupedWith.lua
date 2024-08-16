-- STEPS @VERSION@
GW_SLUG, GroupedWith = ...
GW_MSG_ADDONNAME     = C_AddOns.GetAddOnMetadata( GW_SLUG, "Title" )
GW_MSG_AUTHOR        = C_AddOns.GetAddOnMetadata( GW_SLUG, "Author" )
GW_MSG_VERSION       = C_AddOns.GetAddOnMetadata( GW_SLUG, "Version" )

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

function GroupedWith.OnLoad()
	GroupedWithFrame:RegisterEvent( "ADDON_LOADED" )
	GroupedWithFrame:RegisterEvent( "VARIABLES_LOADED" )
	GroupedWithFrame:RegisterEvent( "GROUP_ROSTER_UPDATE" )

	--register slash commands
	SLASH_GROUPEDWITH1 = "/groupedwith";
	SLASH_GROUPEDWITH2 = "/gw";
	SlashCmdList["GROUPEDWITH"] = function(msg) GroupedWith.command(msg); end

	-- Chat system hook
--	ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", Hitlist.CHAT_MSG_SYSTEM)
--	GameTooltip:HookScript( "OnTooltipSetUnit", GroupedWith.HookSetUnit )
end

-- events
function GroupedWith.ADDON_LOADED()
	GroupedWithFrame:UnregisterEvent( "ADDON_LOADED" )
	GroupedWith.Print( "Addon Loaded" )
	GroupedWith.name = UnitName("player")
	GroupedWith.realm = GetRealmName()
	GroupedWith.fullName = GroupedWith.name.."-"..GroupedWith.realm
end
function GroupedWith.VARIABLES_LOADED()
	GroupedWithFrame:UnregisterEvent( "VARIABLES_LOADED" )
	GroupedWith.Print( "Variables Loaded" )
end
function GroupedWith.GROUP_ROSTER_UPDATE( ... )
	GroupedWith.Print( "GROUP_ROSTER_UPDATE" )

	local memberCount = GetNumGroupMembers()
	GroupedWith.Print( ( memberCount or "nil" ) .. " members in the group." )
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		GroupedWith.Print( "Player is in an instance group!" )
	elseif IsInGroup() then
		GroupedWith.Print( "Player is in a normal group." )
	end
	pre = "party"
	if memberCount > 1 then
		for index = 1, memberCount-1 do
			key, name, realm = GroupedWith.GetNameRealm( pre..index )
			if key then
				GroupedWith_data[realm] = GroupedWith_data[realm] or {["firstSeen"] = time()}
				GroupedWith_data[realm][name] = GroupedWith_data[realm][name] or {["firstSeen"] = time(),["lfgIDs"] = {}}
				GroupedWith_data[realm][name].seenBy = GroupedWith_data[realm][name].seenBy or {}
				GroupedWith_data[realm][name].seenBy[GroupedWith.fullName] = GroupedWith_data[realm][name].seenBy[GroupedWith.fullName] or
						{["firstSeen"] = time()}

				name, type, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceMapId, lfgID = GetInstanceInfo()
				guildName, guildRankName, guildRankIndex = GetGuildInfo(pre..index)
				if lfgID then
					GroupedWith_data[realm][name].lfgIDs[lfgID] = GroupedWith_data[realm][name].lfgIDs[lfgID] or {}
					GroupedWith_data[realm][name].lfgIDs[lfgID].runAt = time()
					GroupedWith_data[realm][name].lfgIDs[lfgID].guildName = guildName
				end

			end
		end
	end
end
function GroupedWith.GetNameRealm( unitID )
	-- returns name-realm, name, realm
	name, realm = UnitName( unitID )
	if not realm then
		realm = GetRealmName()
	end

	return name.."-"..realm, name, realm
end

--[[
function GroupedWith.UpdateData( unitName )
	if GroupedWith_data[unitName] then
		GroupedWith_data[unitName].lastSeen = time()
	else
		GroupedWith_data[unitName] = {
			["lastSeen"] = time(),
			["firstSeen"] = time(),
			["seenBy"] = {
				[GroupedWith.fullName] = {
					["firstSeen"] = time()
				}
			}
		}
	end
	if GroupedWith_data[unitName].seenBy[GroupedWith.fullName] then
		GroupedWith_data[unitName].seenBy[GroupedWith.fullName].lastSeen = time()
	end
end

-- end events
function GroupedWith.HookSetUnit( arg1, arg2 )
	local name, unitID = GameTooltip:GetUnit()
--	print( "Name: "..(name or "nil").." UnitID: "..( unitID or "nil") )

	nameRealm = getNameRealm( unitID )
--	print( "nameRealm: "..nameRealm )

	ttPlayer = GroupedWith_data[nameRealm]
	if ttPlayer then
		firstSeen = date( "%x %X", ttPlayer.firstSeen )
		GameTooltip:AddLine( "First seen: "..firstSeen )

		for you, data in pairs( ttPlayer.seenBy ) do
			GameTooltip:AddLine( you.." at "..date( "%x %X", data.firstSeen ) )
		end
	end
end


function GroupedWith.command( msg )
	GroupedWith.GROUP_ROSTER_UPDATE()
end
]]

function GroupedWith.Print( msg, showName )
	-- print to the chat frame
	-- set showName to false to suppress the addon name printing
	if (showName == nil) or (showName) then
		msg = COLOR_GOLD..GW_MSG_ADDONNAME..COLOR_END.."> "..msg
	end
	DEFAULT_CHAT_FRAME:AddMessage( msg )
end
