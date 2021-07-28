local app = require("umfal")("applicationFetch")

local hello = {}

function hello.sayHello()
    print("Hello, " .. app.world() .. "!")
end

return hello