var page = require('webpage').create();
var system = require('system');
var args = system.args;
args.shift();
var team = args[0];
var url = 'http://m.mlb.com/prospects/2015?list=' + team;

page.open(url, function(status) {
    var links = page.evaluate(function() {
        return [].map.call(document.querySelectorAll('li'), function(link) {
            var name = link.children[0].text.split('\n')[1].toLowerCase();
            var id = link.getAttribute('data-player-id');
            return id + ', ' + name;
        });
    });

    console.log(links.join("\n"));
    phantom.exit();
});