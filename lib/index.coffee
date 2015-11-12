{CompositeDisposable} = require 'atom'
path = require 'path'

module.exports =

  activate: ->
    @subscriptions = new CompositeDisposable
    @scopes = ['*']

  deactivate: ->
    @subscriptions.dispose()

  provideLinter: ->

    provider =
      grammarScopes: @scopes
      scope: 'file'
      lintOnFly: true
      lint: (textEditor) ->
        new Promise((resolve, reject) ->
          [ {
            type: 'Error'
            text: 'Something went wrong'
            range: [
              [
                0
                0
              ]
              [
                0
                1
              ]
            ]
            filePath: textEditor.getPath()
          } ]
      )
