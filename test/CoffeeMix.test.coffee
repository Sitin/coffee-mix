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

# Coonnection
connectedBy = []
Connection =
  member: "connector's member"
  connection: -> @
  connected: chai.spy -> connectedBy.push @


class Acceptor extends CoffeeMix
  @get property: -> @_property
  @set property: (property) -> @_property = property

  @include Inclusion
  @extend Extension
  @consern Consern

  connect: ->
    @$connect Connection


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

    it "shouldn't extend target with an #extended property", ->
      expect(Acceptor).to.have.not.property 'extended'


  describe ".include", ->

    it "should provide instance mixins support", ->
      acceptor = new Acceptor
      expect(acceptor).to.respondTo 'inclusion'
      expect(do acceptor.inclusion).to.be.equal acceptor

    it "should pass constructor's prototype to mixin's #included", ->
      expect(Inclusion.included).to.have.been.called.once
      expect(includedBy[0]).to.be.equal Acceptor.prototype

    it "shouldn't include #included property to target's prototype", ->
      expect(Acceptor.prototype).to.have.not.property 'included'


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

    it "shouldn't extend target with a #conserned property", ->
      expect(Acceptor).to.have.not.property 'conserned'


  describe "#$connect", ->
    acceptor = new Acceptor
    do acceptor.connect

    it "should provide mixin connection support", ->
      expect(acceptor).to.respondTo 'connection'
      expect(do acceptor.connection).to.be.equal Connection

    it "should create setters and getters for mixin members", ->
      expect(acceptor).to.have.property 'member'
      expect(acceptor.__lookupGetter__ 'member').to.be.a 'function'
      expect(acceptor.__lookupSetter__ 'member').to.be.a 'function'

      expect(acceptor.member).to.be.deep.equal Connection.member

      backup = Connection.member
      acceptor.member = 'new value'
      expect(Connection.member).to.be.equal 'new value'
      Connection.member = backup

    it "should pass constructor function to mixin's #connected", ->
      expect(Connection.connected).to.have.been.called.once
      expect(connectedBy[0]).to.be.equal acceptor

    it "shouldn't extend target with an #connected property", ->
      expect(acceptor).to.have.not.property 'connected'