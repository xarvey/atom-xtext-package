AtomXtextView = require './atom-xtext-view'
{CompositeDisposable} = require 'atom'

module.exports = TestAtom =
  testAtomView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @atomXtextView = new AtomXtextView(state.atomXtextViewState)
    #@modalPanel = atom.workspace.addModalPanel(item: @testAtomView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-xtext:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()
    @atomXtextView.destroy()

  serialize: ->
    atomXtextViewState: @atomXtextView.serialize()

  toggle: ->
    console.log 'TestAtom was toggled!'

    @editor = atom.workspace.getActiveTextEditor()
    marker = @editor.markBufferRange(@editor.getSelectedBufferRange());
    decoration = @editor.decorateMarker(marker,{type: 'overlay', item: @atomXtextView.getElement(), position: 'tail'})
    # if @modalPanel.isVisible()
    #  @modalPanel.hide()
    #else
    #  @modalPanel.show()
