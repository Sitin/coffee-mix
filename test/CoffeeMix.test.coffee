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
attachedBy = []
Attachment =
  member: "attachment's member"
  attachment: -> @
  attached: chai.spy (acceptor) -> attachedBy.push [@, acceptor]

# Integration
integratedBy = []
Integration =
  integration: -> @
  integrated: chai.spy -> integratedBy.push @


class Acceptor extends CoffeeMix
  @get property: -> @_property
  @set property: (property) -> @_property = property

  @include Inclusion
  @extend Extension
  @consern Consern

  attach: ->
    @$attach Attachment

  integrate: ->
    @$integrate Integration


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

    it "should call mixin's #extended in constructor function context", ->
      expect(Extension.extended).to.have.been.called.once
      expect(extendedBy[0]).to.be.equal Acceptor

    it "shouldn't extend target with an #extended property", ->
      expect(Acceptor).to.have.not.property 'extended'


  describe ".include", ->

    it "should provide instance mixins support", ->
      acceptor = new Acceptor
      expect(acceptor).to.respondTo 'inclusion'
      expect(do acceptor.inclusion).to.be.equal acceptor

    it "should call mixin's #included in constructor's prototype context", ->
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

    it "should call mixin's #conserned in constructor function context", ->
      expect(Consern.conserned).to.have.been.called.once
      expect(consernedBy[0]).to.be.equal Acceptor

    it "shouldn't extend target with a #conserned property", ->
      expect(Acceptor).to.have.not.property 'conserned'


  describe "#integrate", ->
    acceptor = new Acceptor
    do acceptor.integrate

    it "should provide object mixins support", ->
      expect(acceptor).to.have.property 'integration'
      expect(acceptor.integration).to.be.a 'function'
      expect(do acceptor.integration).to.be.equal acceptor

    it "should call mixin's #integrated in constructor function context", ->
      expect(Integration.integrated).to.have.been.called.once
      expect(integratedBy[0]).to.be.equal acceptor

    it "shouldn't extend target with an #extended property", ->
      expect(acceptor).to.have.not.property 'integrated'


  describe "#$attach", ->
    acceptor = new Acceptor
    do acceptor.attach

    it "should provide mixin attachment support", ->
      expect(acceptor).to.respondTo 'attachment'
      expect(do acceptor.attachment).to.be.equal Attachment

    it "should create setters and getters for mixin members", ->
      expect(acceptor).to.have.property 'member'
      expect(acceptor.__lookupGetter__ 'member').to.be.a 'function'
      expect(acceptor.__lookupSetter__ 'member').to.be.a 'function'

      expect(acceptor.member).to.be.deep.equal Attachment.member

      backup = Attachment.member
      acceptor.member = 'new value'
      expect(Attachment.member).to.be.equal 'new value'
      Attachment.member = backup

    it "should call mixin's #connected in mixin context passin constructor " +
    "function context as a parameter", ->
      expect(Attachment.attached).to.have.been.called.once
      expect(attachedBy[0][0]).to.be.equal Attachment
      expect(attachedBy[0][1]).to.be.equal acceptor

    it "shouldn't extend target with an #attached property", ->
      expect(acceptor).to.have.not.property 'attached'