local app = require("umfal").initAppFromRelative("safeModuleLoad")

print("'Classical' module loading:")

app.moduleInRoot.sayHi()
app.folder.moduleInFolder.sayHi()
-- app.folder.absentModule.sayHi()

print("'Safe' module load:")
local moduleInFolder = app:attemptToLoadModule(app.folder, "moduleInFolder")
moduleInFolder.sayHi()

local moduleInRoot = app:attemptToLoadModule(app, "moduleInRoot")
moduleInRoot.sayHi()

local absentModule = app:attemptToLoadModule(app.folder, "absentModule")
print("Absent module is nil: " .. tostring(absentModule == nil))