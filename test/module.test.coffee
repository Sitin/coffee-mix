"use strict"


# Setup chai assertions.
chai = require 'chai'
spies = require 'chai-spies'
chai.use spies
{expect} = chai

# Utilities:
_ = require 'lodash'

index = require '../index'
lib = require '../lib/'
CoffeeMix = require '../lib/CoffeeMix'


describe 'Coffee Mix as a module', ->

  it "should export lib contents", ->
    expect(index).to.be.deep.equal lib

  it "should export CoffeeMix class", ->
    expect(index).to.respondTo 'CoffeeMix'
    expect(new index.CoffeeMix).to.be.instanceOf CoffeeMix