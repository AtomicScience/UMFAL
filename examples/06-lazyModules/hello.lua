local app, lazyModule = require("umfal")("lazyModules")

function lazyModule.sayHello()
    print("Hello, ")
end

-- Nothing has to be returned from the module