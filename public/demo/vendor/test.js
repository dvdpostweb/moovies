$(function() {
  if ( document.location.protocol === 'file:' ) {
	alert('The HTML5 History API (and thus History.js) do not work on files, please upload it to a server.');
}

// Establish Variables
var
	State = History.getState();
	/*$log = $('#log');*/

// Log Initial State
/*History.log('initial:', State.data, State.title, State.url);*/

// Bind to State Change
History.Adapter.bind(window,'statechange',function(){ // Note: We are using statechange instead of popstate
	// Log the State
	var State = History.getState(); // Note: We are using History.getState() instead of event.state
	console.log('history')
	/*History.log('statechange:', State.data, State.title, State.url);*/
});

// Prepare Buttons
var
	buttons = document.getElementById('buttons'),
	scripts = [
		'History.pushState({state:1,rand:Math.random()}, "State 1", "?state=1"); // logs {state:1,rand:"some random value"}, "State 1", "?state=1"',
		'History.pushState({state:2,rand:Math.random()}, "State 2", "?state=2"); // logs {state:2,rand:"some random value"}, "State 2", "?state=2"',
		'History.replaceState({state:3,rand:Math.random()}, "State 3", "?state=3"); // logs {state:3,rand:"some random value"}, "State 3", "?state=3"',
		'History.pushState(null, null, "?state=4"); // logs {}, "", "?state=4"',
		'History.back(); // logs {state:3}, "State 3", "?state=3"',
		'History.back(); // logs {state:1}, "State 1", "?state=1"',
		'History.back(); // logs {}, "The page you started at", "?"',
		'History.go(2); // logs {state:3}, "State 3", "?state=3"'
	],
	buttonsHTML = ''
	;

// Add Buttons
for ( var i=0,n=scripts.length; i<n; ++i ) {
	var _script = scripts[i];
	buttonsHTML +=
		'<li><button onclick=\'javascript:'+_script+'\'>'+_script+'</button></li>';
}
buttons.innerHTML = buttonsHTML;
 });