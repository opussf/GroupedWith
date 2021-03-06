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
	GroupedWithFrame:RegisterEvent( "ADDON_LOADED" )
	GroupedWithFrame:RegisterEvent( "GROUP_ROSTER_UPDATE" )

	--register slash commands
	SLASH_GROUPEDWITH1 = "/groupedwith";
	SLASH_GROUPEDWITH2 = "/gw";
	SlashCmdList["GROUPEDWITH"] = function(msg) GroupedWith.command(msg); end

	-- Chat system hook
--	ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", Hitlist.CHAT_MSG_SYSTEM)
	GameTooltip:HookScript( "OnTooltipSetUnit", GroupedWith.HookSetUnit )
end

-- events
function GroupedWith.ADDON_LOADED()
	GroupedWithFrame:UnregisterEvent( "ADDON_LOADED" )
	GroupedWith.Print( "Addon Loaded" )
	GroupedWith.realm = GetRealmName()
	GroupedWith.name = GetUnitName("player")
	GroupedWith.fullName = GroupedWith.name.."-"..GroupedWith.realm
end

function GroupedWith.GROUP_ROSTER_UPDATE()
	GroupedWith.Print( "GROUP_ROSTER_UPDATE" )

	local memberCount = GetNumGroupMembers()
	GroupedWith.Print( ( memberCount or "nil" ) .. " members in the group." )

	local inInstanceGroup = IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
	if inInstanceGroup then
  		print("Player is in an instance group!")
	elseif IsInGroup() then
  		print("Player is in a normal group!")
	end

	local pre="party"

	if memberCount > 1 then -- not just alone.
		for index = 1, memberCount-1 do
			uID = string.format( "%s%s", pre, index )
			uName = GetUnitName( uID, true )
			print( "uName: "..uName )

			_, _, strippedName = string.find( uName, "(.+)-" )
			uName = strippedName or uName

			print( "uName: "..uName )

			rName = GetRealmName( uID )
			nameRealm = uName.."-"..rName

			print( nameRealm )
			print( index..": "..nameRealm )
			if( uName ~= "Unknown" ) then
				GroupedWith.UpdateData( nameRealm )
			end
		end
	end
end

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
	local realm = GetRealmName( unitID )
--	print( "Realm: "..realm )
	nameRealm = name.."-"..realm

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

function GroupedWith.Print( msg, showName )
	-- print to the chat frame
	-- set showName to false to suppress the addon name printing
	if (showName == nil) or (showName) then
		msg = COLOR_GOLD..GROUPEDWITH_MSG_ADDONNAME..COLOR_END.."> "..msg
	end
	DEFAULT_CHAT_FRAME:AddMessage( msg )
end

