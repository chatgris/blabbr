source = new EventSource('/events')

source.addEventListener 'open', (event) ->
  console.log 'connected'
, false

source.addEventListener 'join', (event) ->
  console.log event.data
, false

source.addEventListener 'leave', (event) ->
  console.log event.data
, false
