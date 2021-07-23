-- Line below is thoroughly explained in 'hello.lua'
local app = require("umfal")("applicationFetch")

-- This module is not a table, as usual, but a single function
--
-- It's worth noting, that module must not be a table of functions -
-- it can be a single function, a table with plain values, just anything you want!
return function()
    return "world"
end