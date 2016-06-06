$(document). on 'click', '#update-button', (e) ->
  $.post '/rosters/update_starts',
    
