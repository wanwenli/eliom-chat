Eliom Chat
======
Chat is a small application built for multiuser online chatting using Ocsigen framework.

## Dependencies
* Ocaml release 4.00.1 or above
* [Opam](http://opam.ocaml.org/) (Ocaml Package Manager)
* [Ocsigen framework](http://ocsigen.org/) release 3.0 or above (installation from Opam)

## Execution
Test your application by compiling it and running ocsigenserver locally
```
$ make test.byte (or test.opt)
```

Deploy your project on your system
```
$ sudo make install (or install.byte or install.opt)
```

Run the server on the deployed project
```
$ sudo make run.byte (or run.opt)
```
