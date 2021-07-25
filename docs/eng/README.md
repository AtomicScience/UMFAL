# UMFAL
For me, one of the most frustrating things about the OpenComputers community is the fact, that no matter how complex one's program is, chances, that it's just one big file - sometimes up to **thousands** of lines - are extremely high.

This is not adequate. And this is not how things are done in *real-life* programming.

However, the reason for this, in my opinion, is not the lack of skill of programmers, but rather a lack of proper tools to manage multifile applications

*"So, why should I suffer from this?"* - I thought, and coded myself a nice-and-little module loader, that gets the job done.

*"So, why should **anyone** suffer from this?"* - I thought, and released it to the public.

Enjoy!
## Download
Latest version of UMFAL can be obtained with this command:
```
wget -f https://github.com/AtomicScience/UMFAL/releases/latest/download/umfal.lua /lib/umfal.lua
```

## What is UMFAL?
UMFAL (stands for **Unified Multi-File Application Loader**) is a library, that serves as a module loader for complex multifile applications.

It's somewhat similar to the 'stock' Lua module system, but it does not aim to replace it, but rather *reimplement* it to allow to link files within a single application
## How do I use it?
If you feel like diving in the topic, check out code examples that cover all the features of UMFAL.

But if you just want to get familiar with what's UMFAL is capable of, below is a quick brief of its features:
## Features brief
### Overview
Consider a following multifile project you supposedly want to use UMFAL at:
```
myAwesomeProject
├ bin
│  ├ start.lua
│  └ config.lua
├ gui
│  ├ menu.lua
│  └ dialog.lua
├ api
│  ├ internet
│  │  └ request.lua
|  └ stringFunctions.lua    
└ quickstart.lua
```
Here, `quickstart.lua`, `start.lua`, and `config.lua` are **entry points**, that start all the application.

All other files are modules, that look similar to 'standard' Lua modules:
```lua
local module = {}
-- module is filled with needed stuff here
return module
```
### Initializing an application
In *entry points*, we must first **initialize an application** - to
create a special object, that will manage our application.

In `quickstart.lua` it is done the following way:
```lua
local app = require("umfal").initAppFromRelative("briefApp")
```
Where `"briefApp"` is the **application ID** - a unique string,
that is usually just a project name.
### Importing modules
After correctly initializing an application object, we can use it to load our modules:
```lua
local menu    = app.gui.menu
local dialog  = app.gui.dialog
local request = app.api.internet.request
local strFun  = app.api.stringFunction
```
These variables will contain tables that modules have returned - the same thing that `require()` returns.

But one great thing about UMFAL modules is that you don't have to explicitly *require* modules, or even to put them in variables like it's done above - you can use modules right from the code:
```lua
local function someFunction()
    local str1 = "Hello"
    local str2 = ", World!"
    return app.api.stringFunction.concat(str1, str2)
end
```