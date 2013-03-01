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


describe 'Coffee Mix as a module', ->

  it "should export lib contents", ->
    expect(index).to.be.deep.equal lib