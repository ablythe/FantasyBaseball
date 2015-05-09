
var page = require('webpage').create();
var system = require('system');
var args = system.args;
args.shift();
var url = 'http://www.milb.com/roster/index.jsp?sid=milb&cid=' + String(args[0]);

page.open(url, function(status) {
    var links = page.evaluate(function() {
        return [].map.call(document.querySelectorAll('a'), function(link) {
            var name = link.text;
            var id = link.getAttribute('href').match(/player_id=.+/);
            return id +', '+ name;
        });
    });
    for (var i = 0; i < links.length; i++){
        if(links[i].indexOf('player') > -1){
            console.log(links[i]);
          };
        };
    phantom.exit();
});

