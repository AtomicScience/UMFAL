"Application fetch" example demonstrates, how UMFAL features can be used not only in init scripts, but in modules as well

It features an entry point - `init.lua`, that loads module 'hello.lua', which, in its turn, loads another module - 'world.lua'
Also, it shows an example of non-table module - 'world.lua' in this example is just a function