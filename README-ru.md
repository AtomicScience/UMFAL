# UMFAL

[This content is available in **English**](https://github.com/AtomicScience/UMFAL)

Меня всегда раздражал факт того, что почти все программисты в комьюнити OpenComputers - даже если они невероятно опытны и круты - пишут свои программы в огромных файлах с **тысячами** строк

Это просто неадекватно.

Но причина этого, как мне кажется, лежит не в том, что эти программисты не понимают недостатков этого "монолитного" подхода, но скорее в том, что для решения этой проблемы нет адекватных инструментов.

Столкнувшись с этой проблемой самостоятельно, я не смог смириться с подобным положением дел, поэтому накодил себе небольшой загрузчик модулей. 

Прошло полгода, и я решил серьезно взяться за то, чтобы привести его в "божеский" вид - перелопатить код, добавить пару фишек, и, самое главное, тщательно его задокументировать.

Теперь **версия 2.0** доступна широкой публике!
## Загрузка
Последняя версия UMFAL загружается следующей командой:
```
wget -f https://github.com/AtomicScience/UMFAL/releases/latest/download/umfal.lua /lib/umfal.lua
```

## Что такое UMFAL?
UMFAL (расшифровывается как **Unified Multi-File Application Loader** - *Универсальный Загрузчки Многофайловых Приложений*) - загрузчик модулей для сложных программ и библиотек, состоящих из множества модулей

В некотором отношении, он похож на стандартный загрузчик Lua, и, можно сказать, является его реализацией для загрузки модулей **внутри** приложений, а не для загрузки библиотек.

## Как им пользоваться?
Хотите освоить UMFAL на все 100%? В [примерах](https://github.com/AtomicScience/UMFAL/tree/master/examples) на практике продемонстрированы все аспекты библиотеки

Если же вы просто хотите быстро познакомиться с UMFAL - продолжайте читать этот файл
## Основные возможноти
### Гипотетический проект
Допустим, с помощью UMFAL мы хотим "оживить" следующий проект:
```
myAwesomeProject
├ gui
│  ├ menu.lua
│  └ dialog.lua
├ api
│  ├ internet
│  │  └ request.lua
|  └ stringFunctions.lua    
└ quickstart.lua
```
Здесь, `quickstart.lua` - так называемая **точка входа**, которая запускается для того, чтобы запустить все приложение

Прочие файлы - модули, которое выглядят так же, как обычные модули в Lua:
```lua
local module = {}
-- Модуль заполняется плюхами
return module
```
### Инициализация приложения
В *точке входа* первым делом нужно **инициализировать приложение** - создать специальный объект, который будет управлять файлами нашего приложения

Для этого в `quickstart.lua` мы должны прописать:
```lua
local app = require("umfal").initAppFromRelative("briefApp")
```
Здесь `"briefApp"` это **ID приложения** - уникальная строка, используемая для поиска нужного приложения. Обычно эта строка - просто название программы
### Использование модулей
Модули в UMFAL импортируются следующим образом:
```lua
local app = require("umfal").initAppFromRelative("briefApp")

local menu    = app.gui.menu
local dialog  = app.gui.dialog
local request = app.api.internet.request
local strFun  = app.api.stringFunction
```
Все эти переменные будут содержать таблицы, которые вернули файлы модулей. Иначе говоря, то же самое, что вернул бы обычный `require()`.

Но что отличает UMFAL от обычного загрузчика модулей Lua, так это то, что модули не нужно явно импортировать - полные пути к ним можно писать прямо в коде:
```lua
local app = require("umfal").initAppFromRelative("briefApp")

local function someFunction()
    local str1 = "Hello"
    local str2 = ", World!"
    return app.api.stringFunction.concat(str1, str2)
end

local function anotherFunction(address)
    return app.api.internet.request(address)
end
```
### Кеширование
Одна из самых странных вещей в системе модулей Lua - кеш, который нужно чистить от старых версий модулей *(`packages.loaded = nil`)*.

UMFAL **кеширует** модули, но этот кеш всегда будет в актуальном состоянии. Причина этого в том, что вместо глобального кеша, используется **индивидуальный** кеш у каждого приложения.

Что это значит? Рассмотрим следующий код:
```lua
-- Приложение инициализируется, кеш пуст
local app = require("umfal").initAppFromRelative("briefApp")

app.gui.menu.showMenu() -- .lua файл запускается, результат кешируется
app.gui.menu.showMenu() -- результат подгружается из кеша
app.gui.menu.showMenu() -- результат подгружается из кеша
app.gui.menu.showMenu() -- результат подгружается из кеша

-- Приложения инициализируется опять, кеш "briefApp" сбрасывается
app = require("umfal").initAppFromRelative("briefApp")

app.gui.menu.showMenu() -- .lua файл запускается, результат кешируется
app.gui.menu.showMenu() -- результат подгружается из кеша
app.gui.menu.showMenu() -- результат подгружается из кеша
app.gui.menu.showMenu() -- результат подгружается из кеша
```
Каждый раз, когда `initAppFromRelative` запускается *(это происходит при **каждом** запуске точки входа)*, кеш приложения очищается
### Подгрузка приложений
Теперь, когда у нас есть доступ к объекту приложения в точке входа, возникает вопрос:

А что делать, если модуль нам понадобится из **другого** модуля?
Например, `stringFunctions.lua` может пригодится в `request.lua`?

Чтобы не создавать объекты приложения каждый раз, мы можем просто подгрузить уже созданный объект следующим образом:
```lua
local app = require("umfal")("briefApp")
```
Полученный объект может использоваться как обычно
```lua
local app = require("umfal")("briefApp")

local request = {}

function request.sendRequest(where)
    return broadcast(app.api.stringFunction.concat("google.com", where))
end

return request
```
### Ленивые модули
Еще одна раздражающая вещь - необходимость повторять следующие строки в **каждом** модуле:
```lua
local module = {}
...
return module
```
Конечно, это всего две строчки, но они просто постоянно мозолят глаз

UMFAL решает и эту проблему, предлагая элегантную замену созданию и возврату модуля. Это решение - **ленивые модули**

Используя **ленивые модули**, вам не нужно заботиться ни о создании, ни о возврате таблицы - UMFAL все сделает за вас!

Вот пример "обычного" модуля:
```lua
local app = require("umfal")("briefApp")

local request = {}

function request.sendRequest(where)
    return broadcast(app.api.stringFunction.concat("google.com", where))
end

return request
```
И "ленивого":
```lua
local app, lazyModule = require("umfal")("briefApp")

function lazyModule.sendRequest(where)
    return broadcast(app.api.stringFunction.concat("google.com", where))
end
```