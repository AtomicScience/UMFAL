local app = require("umfal").initAppFromRelative("moduleCaching")

app.module.sayHi()
app.module.sayHi()
app.module.sayHi()

print("Wiping the cache...")
app = require("umfal").initAppFromRelative("moduleCaching")

app.module.sayHi()
app.module.sayHi()
app.module.sayHi()