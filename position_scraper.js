var page = require('webpage').create();
var system = require('system');
var args = system.args;
args.shift();
var id = args[0];
var url = 'http://mlb.mlb.com/team/player.jsp?player_id=' + id;

page.open(url, function(status) {
    window.setTimeout(function(){
      var position = page.evaluate(function() {
        return document.getElementById('player_name').textContent.split("|")[1];
      });
    console.log(position);
    phantom.exit();
  }, 500);
});