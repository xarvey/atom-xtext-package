AtomXtextView = require './atom-xtext-view'
{CompositeDisposable} = require 'atom'

module.exports = AtomXtext =
  atomXtextView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @atomXtextView = new AtomXtextView(state.atomXtextViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @atomXtextView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-xtext:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @atomXtextView.destroy()

  serialize: ->
    atomXtextViewState: @atomXtextView.serialize()

  toggle: ->
    console.log 'AtomXtext was toggled!'
    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
