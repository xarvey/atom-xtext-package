{CompositeDisposable} = require 'atom'
path = require 'path'

module.exports =

  activate: ->
    @subscriptions = new CompositeDisposable
    @scopes = ['source.xtext']

  deactivate: ->
    @subscriptions.dispose()

  provideLinter: ->
    provider =
      grammarScopes: @scopes
      scope: 'file'
      lintOnFly: true
      lint: (textEditor) ->
        console.log(textEditor)
    console.log('shit')
    console.log(provider)
