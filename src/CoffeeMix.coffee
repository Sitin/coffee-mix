"use strict"


moduleKeywords = ['extended', 'included']


class CoffeeMix
  # Properties helpers
  get = (props) => @::__defineGetter__ name, getter for name, getter of props
  set = (props) => @::__defineSetter__ name, setter for name, setter of props

  @extend: (obj) ->
    for key, value of obj when key not in moduleKeywords
      @[key] = value

    obj.extended?.apply(@)
    @

  @include: (obj) ->
    for key, value of obj when key not in moduleKeywords
      # Assign properties to the prototype
      @::[key] = value

    obj.included?.apply(@)
    @

  @consern: (obj) ->
    @extend obj.classProperties
    @include obj.instanceProperties


module.exports = CoffeeMix