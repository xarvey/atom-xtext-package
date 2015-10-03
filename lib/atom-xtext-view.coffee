module.exports =
class AtomXtextView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('atom-xtext')

    message = document.createElement('div')
    message.classList.add('message')

    # Create message element
    xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = =>
      if xhttp.readyState == 4 and xhttp.status == 200
        message.textContent = xhttp.responseText
        @element.appendChild(message)
    xhttp.open("GET", "http://maple.fm/api/2/search?server=0", true);
    xhttp.send();

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
