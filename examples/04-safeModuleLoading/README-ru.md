# Безопасная загрузка модулей
[This material is available in **English**](https://github.com/AtomicScience/UMFAL/tree/master/examples/04-safeModuleLoading)

Все предыдущие примеры были **оптимистичны** - они были уверены в том, что модули находятся там, где они должны. Но что, если это не так

Этот пример объясняет, что происходит, когда мы пытаемся загрузить несуществующий модуль, а также то, как можно безопасно загружать потенциально несуществующие модули штатными средствами UMFAL.

*Новые темы в данном примере:*
1. Последствия импорта несуществующего модуля
2. Использование механизма безопасной загрузки

## init.lua
### Обычная загрузка модуля
Наша точка входа начинается с секции `'Classical' module loading`:

```lua
local app = require("umfal").initAppFromRelative("safeModuleLoad")

print("'Classical' module loading:")

app.moduleInRoot.sayHi()
app.folder.moduleInFolder.sayHi()
-- app.folder.absentModule.sayHi()
```

В ней просто загружаются несколько модулей и вызываются их функции

Но строка с третьим модулем закоментированна. В чем причина? В том, что ее запуск вызвал бы ошибку:
```
/lib/umfal.lua:217 : Failed to load node `absentModule`: file or folder does not exist
```
### Безопасная загрузка модулей
Что же делать, если мы хотим спокойно обработать возможное отсутствие модуля, без вызова ошибки?

Конечно, можно просто воспользоваться обычным `pcall()` и поймать и обработать ошибку, но выглядеть такая констукция будет... странно.

Решение проблемы - механизм **безопасной загрузки**.

Для ее использования, воспользуйтесь функцией `attemptToLoadModule()` в объекте вашего приложения:
```lua
print("'Safe' module load:")
local moduleInFolder = app:attemptToLoadModule(app.folder, "moduleInFolder")
moduleInFolder.sayHi()

local moduleInRoot = app:attemptToLoadModule(app, "moduleInRoot")
moduleInRoot.sayHi()

local absentModule = app:attemptToLoadModule(app.folder, "absentModule")
print("Absent module is nil: " .. tostring(absentModule == nil))
```
Первый аргумент этой функции - папка, в которой ваш модуль потенциально размещен (например, `app.folder`), или просто объект приложения (`app`), если модуль должен находиться в корне

В отличие от обычной загрузки, эта загрузка не вызывает ошибок, а просто возвращет nil
