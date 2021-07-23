-- This line is, basically, the essence of this tutorial
--
-- What's done here is called 'FETCHING an application' or, in other words,
-- getting an app that was already initialized in some init script
--
-- To do so, UMFAL must be called as a function - a nice and clean way.
-- And as an argument, an application identifier must be passed
--
-- FETCHING an application, instead of reinitializing it every time,
-- bears a handful of advantages - from obvious ones like lack of need to
-- resolve paths every time, to more sophisticated ones, such as an ability
-- to share a single module cache between all the app's components

-- (Caching is deeply covered in example [TODO])
local app = require("umfal")("applicationFetch")

local hello = {}

function hello.sayHello()
    -- Please note, that 'app.world' is a module, and yet it is called as a function
    print("Hello, " .. app.world() .. "!")
end

return hello