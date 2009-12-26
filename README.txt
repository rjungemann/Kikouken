Kikouken
    by Roger Jungemann
    http://www.thefifthcircuit.com

== DESCRIPTION:

A "Street Fighter"-esque special move system for Flash. Allow users to input key commands similar to those used in fighting games.

== FEATURES/PROBLEMS:

* Keeps a key mapping (the "codes" hash), so that you can use keywords instead of integers to see what key is pressed.
* Keeps a list of special moves (the "moves" array), which includes a name identifier for each move and an array representing the key presses, according to the mapping above.
* Each special move can include key presses in sequence (i.e. ["down", "down-right", "right"]) or in parallel (i.e. ["down", "right kick"]).
* Allows "move mirroring". If enabled, the direction keys for a special move will be flipped when the player is facing the opposite direction. How each key is mirrored is customizable with a "mirrors" hash.
* For move mirroring, what direction the player is facing can be handled automatically (pressing left makes player face left, pressing right makes player face right), or by hand by setting the "facingLeft" property.
* Parses diagonal key presses in two ways: they can be pressed simultaneously, or "glided" to (pressing "down", then pressing "right" without lifting "down", will be interpreted as ["down", "down-right"]. This allows the inputting of special moves in an intuitive way, familiar to console gamers.
* Keys can be "charged" if they are held down for a certain duration (default 2 seconds).

Missing features:
* Special moves cannot interpret charge moves yet.
* Mirroring isn't fully implemented.
* Allow events to be triggered when a special move occurs or a new key is pressed (ignoring key-repeat rate).

== SYNOPSIS:

  // import Kikouken
  import com.teamsketchy.kikouken.Kikouken;
  
  // instantiate class. View the source to see all customizable variables.
  var kikouken:Kikouken = new Kikouken();

  // attach events for key pressed, lifted, and for updating.
  // note how the kikouken.keyDown, keyUp, and update events can be attached
  // directly, or inside another function.
	stage.addEventListener(KeyboardEvent.KEY_DOWN, kikouken.keyDown);
	stage.addEventListener(KeyboardEvent.KEY_UP, kikouken.keyUp);
	stage.addEventListener(Event.ENTER_FRAME, function(e:Event):void {
		kikouken.update(e);

		if(kikouken.specialMoves.length > 0)
			var moves:Array = kikouken.specialMoves.map(function(el:*, i:*, a:*):* {  
			  return el.name || el.keyName;
			});
			trace(moves.join(", "));
	});

== REQUIREMENTS:

* Flash 9 or greater.
* Flash Builder, Flash CS4, or my ActionscriptRakeTemplate project.

== INSTALL:

* Check out the code.
* Copy the "src/com" directory into the main source directory of your Flash or Flex project.
* Try the sample in the above synopsis.
* If you are using OS X, you can also run this project by installing Flex Builder, setting the path to a valid Flex SDK in the Rakefile, and typing in "rake" from Terminal, while in the "Kikouken" directory.

== LICENSE:

(The MIT License)

Copyright (c) 2009 thefifthcircuit.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
