# "Hello, World!" Extreme
This example is an extended version of the first one, aiming to show how UMFAL deals with more than one module, and also to demonstrate, how to initialize an application with **level delta** parameter

Topics to be covered in this example
1. Initializing an application with **level delta** parameter

## Code explanation
### simpleInitScript.lua
`simpleInitScript.lua` - is an entry point for our app, and what's notable about it is the fact, that now it's not placed in **project root**, where all the modules are contained, but in a separate folder - `bin`.

Initializing an application the same way we did it before, would set this folder as a project root, effectively putting all the modules of the project out of reach.

We definitely do not this. And in order to notify UMFAL about actual root location, in `simpleInitScript.lua` we initialized an application like this:

```lua
local app = require("umfal").initAppFromRelative("helloWorldExtreme", 2)
```

Here, `2` is a parameter called **level delta** - it indicates, how root folder is located relative to the running entry point script:

* `1` - root folder is the folder that contains the script (`bin` in this example)
* `2` - root folder is one level higher (`02-helloWorldExtreme`)
* ... and so on

Below, modules from folder `subjects` are used to obtain values, that are later used in module `hello`
```lua
local worldSubject  = app.subjects.world.getSubject()
local numberSubject = app.subjects.number.getSubject(42)
local nameSubject   = app.subjects.nameGenerator.getSubject()

app.hello.greet(worldSubject)
app.hello.greet(numberSubject)
app.hello.greet(nameSubject)
```