local app = dofile("../umfal.lua").initAppFromRelative("safeModuleLoad")

print("'Classical' module loading:")
-- The 'Classical' loading, that was used before, is just using an `app` as a table
app.moduleInRoot.sayHi()
app.folder.moduleInFolder.sayHi()
-- However, if module is not in its place, this loading way will raise an error
-- The line below is commented, because it would have crashed an application otherwise
--app.folder.absentModule.sayHi()

print("'Safe' module load:")
-- However, sometimes it's required to be able to process an absence of the module
-- (for instance, in plugin-like systems, that could process optional files (plugins))
--
-- For such applications, a special 'safe loading' mechanic is available
-- To use it, utilize an 'attemptToLoadModule' method.
--
-- Its first argument is the folder (it must not be absent, function will crash otherwise)
-- to load the module from, and the second argument is the module name, as a string.
local moduleInFolder = app:attemptToLoadModule(app.folder, "moduleInFolder")
moduleInFolder.sayHi()
-- To load a module in the root, an application object must be passed as a first argument
local moduleInRoot = app:attemptToLoadModule(app, "moduleInRoot")
moduleInRoot.sayHi()
-- This function will return a module if succeeded, and 'nil' otherwise
local absentModule = app:attemptToLoadModule(app.folder, "absentModule")
print("Absent module is nil: " .. tostring(absentModule == nil))