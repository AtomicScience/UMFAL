# Hello, World!
[Этот материал доступен на **русском**](https://github.com/AtomicScience/UMFAL/blob/master/examples/01-helloWorld/README-ru.md)

This example aims on explaining the bare basics of the UMFAL - **three** things, to be exact:

Topics to be covered:
1. Initializing an application
2. Composing a module
3. Using a module

## Code explanation
### init.lua
Let's start with `init.lua` - this file is our **entry point** - meaning that this file gets started, in order to start all the application.

#### Application initializing in `init.lua`
And the first line in it deserves attention:
```lua
local helloWorldApp = require("umfal").initAppFromRelative("helloWorldExampleForMyAwesomeOpenComputersLibraryCalledUMFAL")
```
In addition to simply requiring the UMFAL as a library, one should also INIT AN APPLICATION by calling an `initAppFromRelative` function

The string argument for the said function is the **identifier** - a token that can be later used by other modules to fetch an already initialized applications later

*(this feature of UMFAL is covered in example #3 "Application Fetch")*

The reason **identifier** in this example is absurdly long is the desire to demonstrate that IDENTIFIER can be any string you want, with the only limitation - it MUST be unique between different UMFAL apps.

#### Module usage in `init.lua`
The next line is too full of surprises:

```lua
helloWorldApp.helloWorld.sayHelloWorld();
```

Here, we **used a module**. In other words, we used UMFAL to load it, then invoked one of its functions.

One of the nicest things about UMFAL is the fact that one doesn't have to import the module explicitly, but rather just... *use* it.

But, of course, if you dislike long lines in your code, you can always *"import"* modules like this:
```lua
local helloWorld = helloWorldApp.helloWorld

helloWorld.sayHelloWorld()
```

## helloWorld.lua
The last file of this example is `helloWorld.lua` - a **module**

It looks just like "vanilla" module from Lua - a table, that gets returned:

```lua
-- An empty module is created
local helloWorld = {}

-- A function is added to the module
function helloWorld.sayHelloWorld()
    print("Hello World!")
end

-- A module is returned
return helloWorld
```
If you are familiar with module system in Lua and have made a library or two by yourself, this shouldn't pose a challenge to you