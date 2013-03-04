coffee-mix
==========

Mixins support for CoffeeScript.

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