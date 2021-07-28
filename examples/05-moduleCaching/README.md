# Module Caching
This example explains the caching policy of UMFAL

*Topics to be covered in this example*
1. UMFAL's caching policy
2. Cache wiping conditions

## module.lua
This module is just a module, with the only exception: it has a `print` not inside a function, but just in the code:

```lua
print("Code of module.lua is run")
```

This line will be run when the module will be used **for the first time**. After the first run, modules are **immediately cached** in the application object.

All the following runs will take modules from **cache** directly.

UMFAL wipes a cache of the application each time it is initialized:
```lua
-- Cache is wiped
local app = require("umfal").initAppFromRelative("moduleCaching")
```
And applicaiton is initialized **each time** you run your entry point