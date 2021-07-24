# UMFAL
For me, one of the most frustrating things about the OpenComputers community is the fact, that no matter how complex one's program is, chances, that it's just one big file - sometimes up to **thousands** of lines - are extremely high.

This is not adequate. And this is not how things are done in *real-life* programming.

However, the reason for this, in my opinion, is not the lack of skill of programmers, but rather a lack of proper tools to manage multifile applications

*"So, why should I suffer from this?"* - I thought, and coded myself a nice-and-little module loader, that gets the job done.

*"So, why should **anyone** suffer from this?"* - I thought, and released it to the public.

Enjoy!
## Download
Latest version of UMFAL can be obtained with this command:
```
wget -f https://github.com/AtomicScience/UMFAL/releases/latest/download/umfal.lua /lib/umfal.lua
```


## What is UMFAL?
UMFAL (stands for **Unified Multi-File Application Loader**) is a library, that serves as a module loader for complex multifile applications.

It's somewhat similar to the 'stock' Lua module system, but it does not aim to replace it, but rather *reimplement* it to allow to link files within a single application
## How do I use it?
Since there is no way to learn something but in practice, all the features of the UMFAL are covered in a series of throughly explained examples.
### List of examples:
1. Hello World
2. Hello World Extreme
3. Application Fetch
4. Safe Module Loading
5. Module Caching