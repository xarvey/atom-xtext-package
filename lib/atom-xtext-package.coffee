AtomXtextPackageView = require './atom-xtext-package-view'
{CompositeDisposable} = require 'atom'
$ = require 'jquery'

module.exports = AtomXtextPackage =
  atomXtextPackageView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @atomXtextPackageView = new AtomXtextPackageView(state.atomXtextPackageViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @atomXtextPackageView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    @scopes = ['*']
    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-xtext-package:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @atomXtextPackageView.destroy()

  serialize: ->
    atomXtextPackageViewState: @atomXtextPackageView.serialize()

  provideLinter: ->
    provider =
      grammarScopes: @scopes
      scope: 'file'
      lintOnFly: true
      lint: (textEditor) ->
        filePath = textEditor.getPath()
        text = textEditor.getText()
        url = 'http://localhost:8080/xtext-service/validate?resource=text.mydsl1&fullText='+encodeURIComponent(text)
        console.log(url)
        results = []
        $.when(
          $.ajax url,
            type: 'POST'
            dataType: 'html'
            error: (jqXHR, textStatus, errorThrown) ->
              console.log "#{textStatus}"
            success: (data, textStatus, jqXHR) ->
              issue = JSON.parse(data).issues[0]
              console.log(issue)
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

  toggle: ->
    console.log 'AtomXtextPackage was toggled!'
