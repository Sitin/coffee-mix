"use strict"


# Setup chai assertions.
chai = require 'chai'
spies = require 'chai-spies'
chai.use spies
{expect} = chai

# Utilities:
_ = require 'lodash'

CoffeeMix = require '../lib/CoffeeMix'


class Acceptor extends CoffeeMix
  get = @get
  set = @set

  get property: -> @_property
  set property: (property) -> @_property = property


describe 'CoffeeMix', ->

  it "should be a function", ->
    expect(CoffeeMix).to.be.a 'function'

  it "should provide utility methods for properties", ->
    eggs = new Acceptor
    spam = new Acceptor

    eggs.property = 'Eggs'
    spam.property = 'Spam'

    expect(eggs).to.have.property 'property', 'Eggs'
    expect(spam).to.have.property 'property', 'Spam'