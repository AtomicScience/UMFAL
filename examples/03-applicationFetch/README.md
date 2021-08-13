# Application fetch
[Этот материал доступен на **русском**](https://github.com/AtomicScience/UMFAL/blob/master/examples/03-applicationFetch/README-ru.md)

This example explains, how modules can be linked with each other using **application fetch**.

And as a bonus, it demonstrates, that modules can be any value, basically, not just tables

Topics to be covered in this example
1. Fetching an application object
2. Non-table modules

## Code explanation
### init.lua
`init.lua` - is an entry point, and it is simple.

It just invokes a function from `hello.lua`, that, in its turn, invokes a function from `world.lua`, and that's it
### hello.lua
In this file, we just want to use another module.

But a problem arises - how do we obtain an **application object**? Usually, we did it when initializing an app:
```lua
local app = require("umfal").initAppFromRelative("applicationFetch")
```
But initializing an application in every module is... *weird*, to say the least

Instead, we should **fetch** an already initialized application - get it from the UMFAL's cache, where all the application objects are stored. 

In `hello.lua`, it's done the following way, nice and simple:
```lua
local app = require("umfal")("applicationFetch")
```
Where `"applicationFetch"` is the application identifier - the same one that we have used when initializing an application at an entry point

Also, this syntax allows using **lazy modules** that, will be explained later in another example.

After **fetching**, the obtained object can be used as usual:
```lua
print("Hello, " .. app.world() .. "!")
```
### world.lua
This file is a module, but, unlike other modules, it returns not the table of functions, but **just** a function.

This file demonstrates, that UMFAL module can be any value you want - a function, a string, a number - you name it

But your modules should **never** return nil *(except if you use lazy modules, which will be explained later)*