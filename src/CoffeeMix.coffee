"use strict"


moduleKeywords = ['extended', 'included']


#
# Implements mixin and property helpers.
#
# Usage
# ------
#
# Extend this class and call it's static helpers as shown below.
#
# ```coffeescript
## Class mixin
#Extension =
#  classMethod: ->
#  # Method that will be invoked
#  # in class context
#  extended: ->
#
## Instance mixin
#Inclusion =
#  instanceMethod: ->
#  # And this one is for instances
#  # prototype context
#  included: ->
#
## Class and instance mixin
#Consern =
#  classProperties:
#    classConsern: -> @
#  instanceProperties:
#    instanceConsern: -> @
#  # Will be invoked in class context
#  conserned: -> #
#
#
#class Acceptor extends CoffeeMix
#  @get property: -> @_property
#  @set property: (property) -> @_property = property
#
#  @include Inclusion
#  @extend Extension
#  @consern Consern
# ```
#
class CoffeeMix
  #
  # Helper that creates property getters.
  #
  # Accepts a hash of property getters where keys are property names and values
  # are getter functions.
  #
  # @param props [Object] a hash of the propety getters
  #
  @get: (props) => @::__defineGetter__ name, getter for name, getter of props

  #
  # Helper that creates property setters.
  #
  # Accepts a hash of property setters where keys are property names and values
  # are setter functions.
  #
  # @param props [Object] a hash of the propety setters
  #
  @set: (props) => @::__defineSetter__ name, setter for name, setter of props

  #
  # Adds class-level mixin.
  #
  # This method extends constructor function with passed mixin.
  #
  # If the mixin has an `extended` method then it will be ivoked in the
  # constructor function context.
  #
  # @param obj [Object] mixin object
  # @option obj [Function] extended method that will be invoked in constructor
  #     function context. This property won't be added.
  #
  @extend: (obj) ->
    for key, value of obj when key not in moduleKeywords
      # Assign properties to constructor function
      @[key] = value

    obj.extended?.apply @
    @

  #
  # Adds instance-level mixin.
  #
  # This method includes passed mixin to constructor's prototype.
  #
  # If the mixin has an `included` method then it will be ivoked in the
  # constructor's prototype context.
  #
  # @param obj [Object] mixin object
  # @option obj [Function] included method that will be invoked in
  #     constructor's prototype context. This property won't be added.
  #
  @include: (obj) ->
    for key, value of obj when key not in moduleKeywords
      # Assign properties to the prototype
      @::[key] = value

    obj.included?.apply @::
    @

  #
  # Adds class- and instance-level mixin.
  #
  # This method includes passed mixin to constructor function and constructor's
  # prototype.
  #
  # If the mixin has an `conserned` method then it will be ivoked in the
  # constructor function context.
  #
  # @param obj [Object] mixin object
  # @option obj [Object] classProperties a hash of the class properties
  # @option obj [Object] instanceProperties a hash of the instance
  #     (e.g. prototype) properties
  # @option obj [Function] conserned method that will be invoked in constructor
  #     function context. This property won't be added.
  #
  @consern: (obj) ->
    @extend obj.classProperties
    @include obj.instanceProperties

    obj.conserned?.apply @
    @


module.exports = CoffeeMix