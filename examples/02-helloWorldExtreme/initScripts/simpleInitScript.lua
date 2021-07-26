local app = require("umfal").initAppFromRelative("helloWorldExtreme", 2)

local worldSubject  = app.subjects.world.getSubject()
local numberSubject = app.subjects.number.getSubject(42)
local nameSubject   = app.subjects.nameGenerator.getSubject()

app.hello.greet(worldSubject)
app.hello.greet(numberSubject)
app.hello.greet(nameSubject)