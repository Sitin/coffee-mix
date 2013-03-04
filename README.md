coffee-mix
==========

Mixins support for CoffeeScript compatible with [Codo](https://github.com/Sitin/coffee-mix/edit/master/README.md)
and inspired by [The Little Book on CoffeeScript](http://arcturo.github.com/library/coffeescript/03_classes.html).

Install
--------

```bash
npm install -s coffee-mix
```

Usage
------

Extend this class and call it's static and dynamic helpers as shown below.

```coffeescript
{CoffeeMix} = require 'coffee-mix'


# Class mixin
Extension =
  classMethod: ->
  # Method that will be invoked
  # in class context
  extended: ->

# Instance mixin
Inclusion =
  instanceMethod: ->
  # And this one is for instances
  # prototype context
  included: ->

# Class and instance mixin
Consern =
  classProperties:
    classConsern: -> @
  instanceProperties:
    instanceConsern: -> @
  # Will be invoked in class context
  conserned: ->

# Connectable mixin
Connection =
  # This property will be attached
  # via setter and getter
  connectionMember: "connector's member"
  # Will be called in mixin context
  connectionMethod: ->
  # Will be invoked in instance context
  connected: ->


class Acceptor extends CoffeeMix
  @get property: -> @_property
  @set property: (property) -> @_property = property

  @include Inclusion
  @extend Extension
  @consern Consern

  constructor: (connection) ->
    @$connect connection
```

License
--------
(The MIT License)

Copyright (C) 2013 Mikhail Zyatin
https://github.com/Sitin/
With contributions by several individuals:
https://github.com/Sitin/node-ovirt/graphs/contributors

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.