"use strict"


# Setup chai assertions.
chai = require 'chai'
spies = require 'chai-spies'
chai.use spies
{expect} = chai

# Utilities:
_ = require 'lodash'

# System under test
{CoffeeMix, Mixins} = require '../../lib/'
{Outgrowthable} = Mixins


class Acceptor extends CoffeeMix
  @include Outgrowthable

  set = => @set arguments...

  state: 'Class'

  set prop: (value) -> @_prop = value


describe "Outgrowthable", ->

  it "should have an #$outgrow method", ->
    expect(Outgrowthable).to.respondTo '$outgrow'

  it "should provide ramification", ->
    acceptor = new Acceptor
    rame = do acceptor.$outgrow
    acceptor.state = 'Instance'
    rame.state = 'Rame'
    rame.distinct = 'Rame'

    expect(acceptor).to.have.ownProperty 'state', 'Instance'
    expect(rame).to.have.ownProperty 'state', 'Rame'
    expect(acceptor).to.have.not.property 'distinct'

  it "should aware about properties", ->
    acceptor = new Acceptor
    rame = do acceptor.$outgrow
    acceptor.prop = 'Instance property'
    rame.prop = 'Rame property'

    expect(acceptor).to.have.ownProperty '_prop', 'Instance property'
    expect(rame).to.have.ownProperty '_prop', 'Rame property'

