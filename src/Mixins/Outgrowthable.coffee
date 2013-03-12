"use strict"


Mixins = {}


#
# Provides methods for object ramification.
#
# @mixin
#
# @author [Mikhail Zyatin](https://twitter.com/vivisjatin/) <mikhail.zyatin@gmail.com>
# @copyright 2013 Mikhail Zyatin
#
Mixins.Outgrowthable =
  #
  # Creates an object with current instance as a prototype.
  #
  # @return [Object] outgrown object
  #
  $outgrow: ->
    Rame = ->
    Rame.prototype = @

    new Rame


module.exports = Mixins.Outgrowthable