# Lazy Modules
[Этот материал доступен на **русском**](https://github.com/AtomicScience/UMFAL/blob/master/examples/06-lazyModules/README-ru.md)

This example demonstrates one of the coolest feature of the UMFAL - the **lazy modules**

*Topics to be covered in this example*
1. Lazy modules syntax
2. UMFAL's choice between the returned value and the lazy module

## What's a lazy module?
I bet you remember the structure of an average module:
```lua
local module = {}
...
return module
```
The fact that these two lines must be repeated in **every** file is annoying.

This is why UMFAL promotes a different approach - **lazy modules**!

Here is how it works:
```lua
local app, lazyModule = require("umfal")("lazyModules")

function lazyModule.sayHello()
    print("Hello")
end
```
Actually, application fetch returns not only the application object, but a special **lazy table**, that can be filled with functions. And after filling it, you don't have to return it!

## Code explanation
### init.lua
It's damn simple - it just invokes functions from two modules
### hello.lua
This module is a **lazy** one - it uses a **lazy table** instead of a usual approach with `return`
### world.lua
This module answers the possible question you might have asked: *"What happens when we both feel a lazy table and return a value?"*

If it's the case, then UMFAL prioritizes returned value over lazy table