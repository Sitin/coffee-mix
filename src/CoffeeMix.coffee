"use strict"


forbiddenKeys = ['extended', 'included', 'integrated', 'attached']


#
# @author [Mikhail Zyatin](https://twitter.com/vivisjatin/) <mikhail.zyatin@gmail.com>
# @copyright 2013 Mikhail Zyatin
#
# Implements mixin and property helpers.
#
# Usage
# ------
#
# Extend this class and call it's static and dynamic helpers as shown below.
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
#  conserned: ->
#
## Object mixin
#Integration =
#  objectMethod: ->
#  # Method that will be invoked
#  # in instance context
#  integrated: ->
#
## Attachable mixin
#Attachment =
#  # This property will be attached
#  # via setter and getter
#  attachmentMember: "attachment's member"
#  # Will be called in mixin context
#  attachmentMethod: ->
#  # Will be invoked in instance context
#  attached: (acceptor) ->
#
#
#class Acceptor extends CoffeeMix
#  @get property: -> @_property
#  @set property: (property) -> @_property = property
#
#  @include Inclusion
#  @extend Extension
#  @consern Consern
#
#  constructor: (connection) ->
#    @$attach attachment
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
  # @note Although this method looks suitable for extending dedicated
  #     instances we recommend to use {#$integrate} for this task.
  #
  # @param obj [Object] mixin object
  # @option obj [Function] extended method that will be invoked in constructor
  #     function context. This property won't be added.
  #
  @extend: (obj) ->
    for key, value of obj when key not in forbiddenKeys
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
    for key, value of obj when key not in forbiddenKeys
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

  #
  # Adds object-level mixin.
  #
  # This method is a "dynamic" version of the {.extend} method.
  # It extends current context with passed mixin.
  #
  # If the mixin has an `extended` method then it will be ivoked in the
  # caller's context.
  #
  # @param obj [Object] mixin object
  # @option obj [Function] integrated method that will be invoked in caller's
  #     context. This property won't be added.
  #
  # @since 0.0.3
  #
  $integrate: (obj) ->
    for key, value of obj when key not in forbiddenKeys
      # Assign properties to instance object
      @[key] = value

    obj.integrated?.apply @
    @

  #
  # Attaches mixin to current instance.
  #
  # This method extends instance with bounded versions of the passed mixin
  # methods and creates getter and setter for mixin members.
  #
  # If the mixin has a `attached` method then it will be ivoked in the
  # current context.
  #
  # @param obj [Object] mixin object
  # @option obj [Function] attached method that will be invoked in mixin
  #     context with current context as a parameter. This property won't be
  #     added.
  #
  # @since 0.0.3
  #
  $attach: (obj) ->
    ctx = @

    for key, value of obj when key not in forbiddenKeys
      # Add bounded to mixin method versions
      if typeof value is 'function'
        @[key] = do (value) -> ->
          value.apply obj, arguments
      # Create getters and setters for mixin members
      else
        do (key) ->
          ctx.__defineGetter__ key, -> obj[key]
          ctx.__defineSetter__ key, (param) -> obj[key] = param

    obj.attached? @
    @


module.exports = CoffeeMix