#!/usr/bin/env lua

require "wowTest"

test.outFileName = "testOut.xml"
test.coberturaFileName = "../coverage.xml"

ParseTOC( "../src/GroupedWith.toc" )

-- GroupedWithFrame = CreateFrame()

function test.before()
	GroupedWith.ADDON_LOADED()
	GroupedWith.VARIABLES_LOADED()
end
function test.after()
end
function test.test_AddonLoaded_FullName()
	assertEquals( "testPlayer-Test Realm", GroupedWith.fullName )
end
function test.test_GroupRosterUpdate_01()
	myParty = { ["group"] = true, ["raid"] = nil, ["roster"] = {
			{ "Number1", "rank", 1, 100, "class", "fileName", "zone", true, false, "role", true},
			{ "Number2", "rank", 1, 100, "class", "fileName", "zone", true, false, "role", true},
		}
	}
	Units["party1"] = {
		["class"] = "Priest",
		["classCAPS"] = "PRIEST",
		["classIndex"] = 99999,  -- find this out
		["faction"] = {"Alliance", "Alliance"},
		["name"] = "Number1",
		["race"] = "Dwarf",
		["realm"] = "mouserealm",
		["sex"] = 1,
	}
	Units["party2"] = {
		["class"] = "Priest",
		["classCAPS"] = "PRIEST",
		["classIndex"] = 99999,  -- find this out
		["faction"] = {"Alliance", "Alliance"},
		["name"] = "Number2",
		["race"] = "Dwarf",
		["realm"] = "mouserealm",
		["sex"] = 1,
	}
	GroupedWith.GROUP_ROSTER_UPDATE()
	test.dump( GroupedWith_data )
end
function test.test_fail()
	--fail("stop")
end

test.run()
