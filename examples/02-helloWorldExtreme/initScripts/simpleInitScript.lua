-- If you didn't notice, our entry point is now not in the
-- root folder (02-helloWorldExtreme), but one level below it.
--
-- By default (as it did in first example), UMFAL considers as root
-- the folder the entry point script is placed.
--
-- And if it's not the case, UMFAL should be notified about it with
-- special LEVEL DELTA parameter, in this instance it's equal to 2.
local app = require("umfal").initAppFromRelative("helloWorldExtreme", 2)

local worldSubject  = app.subjects.world.getSubject()
local numberSubject = app.subjects.number.getSubject(42)
local nameSubject   = app.subjects.nameGenerator.getSubject()

app.hello.greet(worldSubject)
app.hello.greet(numberSubject)
app.hello.greet(nameSubject)