-- In addition to simply requiring the UMFAL as a library, one should also
-- INIT AN APPLICATION by calling an initAppFromRelative function
--
-- The string argument for the said function is the IDENTIFIER - a token that
-- can be later used by other modules to fetch an already initialized applications later
-- (this feature of UMFAL is covered in example #3 "Application Fetch")
--
-- The reason IDENTIFIER in this example is absurdly long is the desire to demonstrate
-- that IDENTIFIER can be any string you want, with the only limitation - it MUST be unique
-- between different UMFAL apps.
local helloWorldApp = require("umfal").initAppFromRelative("helloWorldExampleForMyAwesomeOpenComputersLibraryCalledUMFAL")

helloWorldApp.helloWorld.sayHelloWorld();