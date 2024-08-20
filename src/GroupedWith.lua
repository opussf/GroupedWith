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
	TooltipDataProcessor.AddTooltipPostCall( Enum.TooltipDataType.Unit, GroupedWith.TooltipSetUnit )
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

	if IsInRaid() then

		pre = "raid"
	end

	if memberCount > 1 then
		for index = 1, memberCount-1 do
			key, name, realm = GroupedWith.GetNameRealm( pre..index )
			if key and name ~= "Unknown" then
				GroupedWith_data[realm] = GroupedWith_data[realm] or {["firstSeen"] = time()}
				GroupedWith_data[realm][name] = GroupedWith_data[realm][name] or {["firstSeen"] = time(),["lfgIDs"] = {}}
				GroupedWith_data[realm][name].lastSeen = time()
				GroupedWith_data[realm][name].seenBy = GroupedWith_data[realm][name].seenBy or {}
				GroupedWith_data[realm][name].seenBy[GroupedWith.fullName] = GroupedWith_data[realm][name].seenBy[GroupedWith.fullName] or
						{["firstSeen"] = time()}

				iname, itype, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceMapId, lfgID = GetInstanceInfo()
				guildName, guildRankName, guildRankIndex = GetGuildInfo(pre..index)
				if lfgID then
					print( "lfgID: "..lfgID..":"..instanceMapId )
					GroupedWith_data[realm][name].lfgIDs[instanceMapId] = GroupedWith_data[realm][name].lfgIDs[instanceMapId] or {}
					GroupedWith_data[realm][name].lfgIDs[instanceMapId].runAt = time()
					GroupedWith_data[realm][name].lfgIDs[instanceMapId].name  = iname
					GroupedWith_data[realm][name].lfgIDs[instanceMapId].guildName = guildName
					GroupedWith_data[realm][name].lfgIDs[instanceMapId].guildRankName = guildRankName
					GroupedWith_data[realm][name].lfgIDs[instanceMapId].guildRankIndex = guildRankIndex
				end

			end
		end
	end
	for realm, names in pairs( GroupedWith_data ) do
		local realmCount = 0
		for name, _ in pairs( names ) do
			realmCount = realmCount + ((name ~= "firstSeen" and name ~= "count") and 1 or 0)
		end
		GroupedWith_data[realm].count = realmCount
	end
end
function GroupedWith.GetNameRealm( unitID )
	-- returns name-realm, name, realm
	name, realm = UnitName( unitID )
	if not realm then
		realm = GetRealmName()
	end
	if name then
		return name.."-"..realm, name, realm
	end
end
function GroupedWith.TooltipSetUnit( arg1, arg2 )
	local name = GameTooltip:GetUnit()
	local realm = nil
	if UnitName( "mouseover" ) == name then
		_, realm = UnitName( "mouseover" )
		if not realm then
			realm = GetRealmName()
		end
	end
	if realm and GroupedWith_data[realm] then

		ttPlayer = GroupedWith_data[realm][name]
		if ttPlayer then
			-- firstSeenTxt = date( "%x %X", ttPlayer.firstSeen )
			firstSeenTxt = SecondsToTime( time() - ttPlayer.firstSeen )
			GameTooltip:AddLine( "First seen: "..firstSeenTxt.." ago." )
			GameTooltip:AddLine( "Seen in realm: "..GroupedWith_data[realm].count )
		end
	end
end
function GroupedWith.Print( msg, showName )
	-- print to the chat frame
	-- set showName to false to suppress the addon name printing
	if (showName == nil) or (showName) then
		msg = COLOR_GOLD..GW_MSG_ADDONNAME..COLOR_END.."> "..msg
	end
	DEFAULT_CHAT_FRAME:AddMessage( msg )
end
