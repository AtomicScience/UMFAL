# Safe Module Loading
[Этот материал доступен на **русском**](https://github.com/AtomicScience/UMFAL/blob/master/examples/04-safeModuleLoading/README-ru.md)

All the previous examples were **optimistic** - they were assuming that all the modules always are where they are expected to be. But what if it's not the case?

This example demonstrates, how UMFAL reacts to missing modules, and how to properly handle their possible absence using UMFAL facilities.

*Topics to be covered in this example:*
1. Result of usage of the missing modules
2. Safe loading mechanics

## init.lua
### Classical module loading
Our entry point's code begins with `'Classical' module loading` section:

```lua
local app = require("umfal").initAppFromRelative("safeModuleLoad")

print("'Classical' module loading:")

app.moduleInRoot.sayHi()
app.folder.moduleInFolder.sayHi()
-- app.folder.absentModule.sayHi()
```

It just loads a couple of modules and invokes their functions.

But the bottom line was commented out. The reason is that it would've caused an error otherwise:
```
/lib/umfal.lua:217 : Failed to load node `absentModule`: file or folder does not exist
```
### Safe module loading
But what if you, for some reason, want to handle the possible absence of the module?

Of course, you could handle the error using `pcall()`, but it will result into very bulky and hard-to-read construction.

The solution is simple - **safe loading**.

To use it, invoke an `attemptToLoadModule()` function of your application object, like it's done in the second section of the `init.lua`:
```lua
print("'Safe' module load:")
local moduleInFolder = app:attemptToLoadModule(app.folder, "moduleInFolder")
moduleInFolder.sayHi()

local moduleInRoot = app:attemptToLoadModule(app, "moduleInRoot")
moduleInRoot.sayHi()

local absentModule = app:attemptToLoadModule(app.folder, "absentModule")
print("Absent module is nil: " .. tostring(absentModule == nil))
```

Its first argument is the folder your module is placed in (`app.folder`), or just an application object if your module resides in the root (`app`).

Unlike *classical* loading, safe loading will not raise an error but just return nil.