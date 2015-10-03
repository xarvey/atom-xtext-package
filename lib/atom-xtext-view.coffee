$ = jQuery = require 'jquery'

module.exports =
class AtomXtextView
  constructor: (serializedState) ->
    # Create root element
    getRandomColor = ->
      letters = '0123456789ABCDEF'.split('')
      color = '#'
      i = 0
      while i < 6
        color += letters[Math.floor(Math.random() * 16)]
        i++
      color

    @element = document.createElement('div')
    @element.classList.add('atom-xtext')

    message = document.createElement('div')
    message.classList.add('message')
    message.textContent = 'Loading...'
    @element.appendChild(message)

    atom.workspace.observeTextEditors (editor) =>
      editor.onDidChangeCursorPosition =>
        message.textContent = editor.getCursorBufferPosition()
        $('.pane.active .editor::shadow .line-number').css('background', getRandomColor);

    # Create message element
    xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = =>
      if xhttp.readyState == 4 and xhttp.status == 200
        message.textContent = xhttp.responseText.substr(0,30)
    xhttp.open("GET", "http://maple.fm/api/2/search?server=0", true);
    xhttp.send();

    $('.pane.active .editor::shadow .line-number').css('background','#FF00FF');

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
