#!/usr/bin/env lua

require "wowTest"

test.outFileName = "testOut.xml"

ParseTOC( "../src/GroupedWith.toc" )

-- GroupedWithFrame = CreateFrame()

function test.before()
	GroupedWith.ADDON_LOADED()
end
function test.after()
end
function test.test_AddonLoaded_FullName()
	assertEquals( "testPlayer-Test Realm", GroupedWith.fullName )
end

test.run()
