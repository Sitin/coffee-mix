"use strict"


# Setup chai assertions.
chai = require 'chai'
spies = require 'chai-spies'
chai.use spies
{expect} = chai

# Utilities:
_ = require 'lodash'

# System under test
CoffeeMix = require '../lib/CoffeeMix'


# Class mixin
extendedBy = []
Extension =
  extension: -> @
  extended: chai.spy -> extendedBy.push @

# Instance mixin
includedBy = []
Inclusion =
  inclusion: -> @
  included: chai.spy -> includedBy.push @

# Class and instance mixin
consernedBy = []
Consern =
  classProperties:
    classConsern: -> @
  instanceProperties:
    instanceConsern: -> @
  conserned: chai.spy -> consernedBy.push @


class Acceptor extends CoffeeMix
  @get property: -> @_property
  @set property: (property) -> @_property = property

  @include Inclusion
  @extend Extension
  @consern Consern


describe 'CoffeeMix', ->

  it "should be a function", ->
    expect(CoffeeMix).to.be.a 'function'


  describe "property helpers", ->

    it "should maintain instance properties", ->
      eggs = new Acceptor
      spam = new Acceptor

      eggs.property = 'Eggs'
      spam.property = 'Spam'

      expect(eggs).to.have.property '_property', 'Eggs'
      expect(eggs).to.have.property 'property', 'Eggs'
      expect(spam).to.have.property '_property', 'Spam'
      expect(spam).to.have.property 'property', 'Spam'


  describe ".extend", ->

    it "should provide prototype mixins support", ->
      expect(Acceptor).to.have.property 'extension'
      expect(Acceptor.extension).to.be.a 'function'
      expect(do Acceptor.extension).to.be.equal Acceptor

    it "should pass constructor function to mixin's #extended", ->
      expect(Extension.extended).to.have.been.called.once
      expect(extendedBy[0]).to.be.equal Acceptor


  describe ".include", ->

    it "should provide instance mixins support", ->
      acceptor = new Acceptor
      expect(acceptor).to.respondTo 'inclusion'
      expect(do acceptor.inclusion).to.be.equal acceptor

    it "should pass constructor's prototype to mixin's #included", ->
      expect(Inclusion.included).to.have.been.called.once
      expect(includedBy[0]).to.be.equal Acceptor.prototype


  describe ".consern", ->

    it "should provide prototype mixins support", ->
      expect(Acceptor).to.have.property 'classConsern'
      expect(Acceptor.classConsern).to.be.a 'function'
      expect(do Acceptor.classConsern).to.be.equal Acceptor

    it "should provide instance mixins support", ->
      acceptor = new Acceptor
      expect(acceptor).to.respondTo 'instanceConsern'
      expect(do acceptor.instanceConsern).to.be.equal acceptor

    it "should pass constructor function to mixin's #conserned", ->
      expect(Consern.conserned).to.have.been.called.once
      expect(consernedBy[0]).to.be.equal Acceptor