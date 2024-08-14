#!/usr/bin/env lua

addonData = { ["version"] = "1.0",
}

require "wowTest"

test.outFileName = "testOut.xml"

-- require the file to test
package.path = "../src/?.lua;'" .. package.path
require "GroupedWith"

GroupedWithFrame = CreateFrame()

function test.before()
	GroupedWith.ADDON_LOADED()
end
function test.after()
end
function test.test_AddonLoaded_FullName()
	assertEquals( "testPlayer-Test Realm", GroupedWith.fullName )
end

test.run()
