local QUERY = "http://names.drycodes.com/1?nameOptions=boy_names&separator=space&format=text"

local internet = require("component").internet

local nameGenerator = {}

function nameGenerator.getSubject()
    if not internet then
        return "[ No internet card found ]"
    end

    local requestResult = internet.request(QUERY).read();
    if not requestResult then
        return "[ Request error ]"
    end

    return requestResult
end

return nameGenerator