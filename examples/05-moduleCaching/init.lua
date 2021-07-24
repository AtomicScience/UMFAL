-- In UMFAL, caching is done inside application objects, that are
-- instantiated every time when invoking an 'initAppFromRelative' function
local app = require("umfal").initAppFromRelative("moduleCaching")

-- Module 'said hi' three times, but "module.lua is started"
-- is printed only once.
--
-- It means, that module's code was run only once, before saying
-- hi the first time, and second and third invocations of a function
-- were done from the cache
app.module.sayHi()
app.module.sayHi()
app.module.sayHi()

print("Wiping the cache...")
-- Imagine we initialize the application again (note, that identifiers remain the same)
-- Initializing an application more than once is discouraged in your apps,
-- but here it's done just to show what happens when application is reinitialized
app = require("umfal").initAppFromRelative("moduleCaching")

-- And module's code is run again! It means, that the cache was wiped!
app.module.sayHi()
app.module.sayHi()
app.module.sayHi()