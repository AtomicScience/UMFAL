-- Actually, module fetching returns TWO values - we were simply
-- ignoring the second one
--
-- This second value is a 'lazy module' - a table for module's
-- content, that is created automatically by UMFAL
--
-- You can fill it, and you don't have to return it!
local app, lazyModule = require("umfal")("lazyModules")

function lazyModule.sayHello()
    print("Hello")
end

-- Nothing have to be returned from the module