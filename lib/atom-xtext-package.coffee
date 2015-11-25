AtomXtextPackageView = require './atom-xtext-package-view'
{CompositeDisposable} = require 'atom'
$ = require 'jquery'

module.exports = AtomXtextPackage =
  atomXtextPackageView: null
  modalPanel: null
  subscriptions: null
  provider: null

  activate: (state) ->
    @atomXtextPackageView = new AtomXtextPackageView(state.atomXtextPackageViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @atomXtextPackageView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    @scopes = ['.mydsl1']
    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-xtext-package:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @atomXtextPackageView.destroy()

  serialize: ->
    atomXtextPackageViewState: @atomXtextPackageView.serialize()

  getProvider: ->
    if not @provider?
      XtextProvider = require './xtext-provider'
      @provider = new XtextProvider()
    console.log(@provider)
    return @provider

  provideLinter: ->
    provider =
      grammarScopes: ['*']
      scope: 'file'
      lintOnFly: true
      lint: (textEditor) ->
        filePath = textEditor.getPath()
        text = textEditor.getText()
        url = 'http://localhost:8080/xtext-service/validate?resource=text.mydsl1&fullText='+encodeURIComponent(text)
        #console.log(url)
        results = []
        $.when(
          $.ajax url,
            type: 'POST'
            dataType: 'html'
            error: (jqXHR, textStatus, errorThrown) ->
              #console.log "#{textStatus}"
            success: (data, textStatus, jqXHR) ->
              issue = JSON.parse(data).issues[0]
              #console.log(issue)
              if (issue and issue.length>0)
                res = {
                  type: issue.severity
                  text: issue.description,
                  range: [[issue.line-1,issue.column],[issue.line-1,issue.column+issue.length]],
                  filePath: textEditor.getPath()
                }
                results.push(res)
        ).then ->
          return results


  provide: ->
    @provider =
  # This will work on JavaScript and CoffeeScript files, but not in js comments.
      selector: '.source.mydsl1, .source.coffee'
      disableForSelector: '.source.js .comment'

      # This will take priority over the default provider, which has a priority of 0.
      # `excludeLowerPriority` will suppress any providers with a lower priority
      # i.e. The default provider will be suppressed
      inclusionPriority: 1
      excludeLowerPriority: true
      # Required: Return a promise, an array of suggestions, or null.
      getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix, activatedManually}) ->
        console.log(bufferPosition)
        console.log(editor)
        editor = atom.workspace.getActiveTextEditor()
        buffer = editor.getBuffer()
        charOffset = buffer.characterIndexForPosition(bufferPosition)
        new Promise (resolve) ->
          suggestion =
            text: 'someText'
            leftLabel: 'xtext' # (optional)
          suggestion2 =
            text: 'someTextotherShit'
            leftLabel: 'xtext' # (optional)

          resolve([suggestion,suggestion2])
      # (optional): called _after_ the suggestion `replacementPrefix` is replaced
      # by the suggestion `text` in the buffer
      onDidInsertSuggestion: ({editor, triggerPosition, suggestion}) ->

      # (optional): called when your provider needs to be cleaned up. Unsubscribe
      # from things, kill any processes, etc.
      dispose: ->


  toggle: ->
    console.log 'AtomXtextPackage was toggled!'
