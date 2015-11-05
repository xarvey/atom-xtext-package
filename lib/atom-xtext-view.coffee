module.exports =
class AtomXtextView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('test-atom')

    # Create Error indicator
    flag = document.createElement('div')
    flag.textContent = "Error"
    flag.classList.add('flag')
    @element.appendChild(flag)

    # Create message element
    message = document.createElement('div')
    xhttp = new XMLHttpRequest()
    xhttp.onreadystatechange = =>
      if xhttp.readyState == 4 and xhttp.status == 200
        message.textContent = xhttp.responseText;
    xhttp.open("GET", "http://localhost:5000/getError", true)
    xhttp.send()
    message.classList.add('message')
    @element.appendChild(message)
    @element.appendChild(message)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element


'''$ = jQuery = require 'jquery'

module.exports =
class AtomXtextView

  constructor: (serializedState) ->

    @linereport = '\'22\''
    # Create root element
    getRandomColor = ->
      letters = '0123456789ABCDEF'.split('')
      color = '#'
      i = 0
      while i < 6
        color += letters[Math.floor(Math.random() * 16)]
        i++
      color

    highlight = (editor, lineNumber, start, stop) ->
      range = new Range([0, 0], [1, 10])
      markerAttributes =
        type: 'highlight'
        class: 'keyword'
        position: 'head'
      marker = editor.markBufferRange(range, invalidate: 'never')
      editor.decorateMarker(marker, markerAttributes)
      query = ".pane.active .editor::shadow .line[data-screen-row='#{lineNumber}']"
      console.log query
      $(query).css('background',getRandomColor)

    @element = document.createElement('div')
    @element.id = 'linter-inline'
    @element.classList.add('atom-xtext')

    message = document.createElement('div')
    message.classList.add('middle')
    message.textContent = 'Loading...'
    @element.appendChild(message)

    atom.workspace.observeTextEditors (editor) =>
      editor.onDidChangeCursorPosition =>
        message.textContent = editor.getSelectedBufferRange()#editor.getCursorBufferPosition()
        $('.pane.active .editor::shadow .line-number').css('background', getRandomColor);
        highlight(editor,20,10,29)


  fetch: ->
    # Create message element
    xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = =>
      if xhttp.readyState == 4 and xhttp.status == 200
        message.textContent = xhttp.responseText;
    xhttp.open("GET", "http://localhost:5000/getError", true);

    xhttp.send();

    $('.pane.active .editor::shadow .line-number').css('background','#FF00FF');

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
    '''
