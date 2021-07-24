-- This line will be printed every time when UMFAL
-- runs the code of the module - it happens when
-- module's content is used somewhere else in the
-- app for the FIRST time.
--
-- After that, results will be CACHED, and code
-- of the module will not be run again, thus, this
-- line will not be printed
print("Code of module.lua is run")

local module = {}

function module.sayHi()
    print("Hello from module!")
end

return module