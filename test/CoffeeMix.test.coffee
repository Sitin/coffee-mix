"use strict"


# Setup chai assertions.
chai = require 'chai'
spies = require 'chai-spies'
chai.use spies
{expect} = chai

# Utilities:
_ = require 'lodash'

CoffeeMix = require '../lib/CoffeeMix'


describe 'CoffeeMix', ->

  it "should be a function", ->
    expect(CoffeeMix).to.be.a 'function'