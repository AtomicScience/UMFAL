local app, lazyModule = require("umfal")("lazyModules")

function lazyModule.sayWorld()
    print("This function will be overridden by returned one")
end

local notLazyModule = {}

function notLazyModule.sayWorld()
    print("World!")
end

return notLazyModule