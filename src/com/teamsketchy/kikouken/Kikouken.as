// to do:
// * special move mirroring if !facingRight
// * charge moves
// * special move events

package com.teamsketchy.kikouken {
	import flash.events.*;
	import flash.utils.Timer;
	
	public class Kikouken extends EventDispatcher {	
		public var moves:Array = [
			{ "name": "eclipse bite", "moves": ["down", "down-right", "right", "bite"] }
		];
		public var codes:Object = { 37: "left", 38: "up", 39: "right", 40: "down", 90: "bite", 88: "yip", 7: "strike", 16: "jump" };
		public var mirrors:Object = { "up-left": "up-right", "left": "right", "down-left": "down-right", "up-right": "up-left", "right": "left", "down-right": "down-left" };
		public var chargeTime:Number = 1000;
		public var resetTime:Number = 250;
		public var simultaneousTime:Number = 50;
		public var diagonalTime:Number = 150;
		public var changesDirection:Boolean = true;
		public var timeStarted:Number = new Date().getTime();
		public var facingRight:Boolean = true;
		public var action:String = null;
	
		private var _keys:Array = [], _combination:Array = [];
		private var combinationTimer:Timer = new Timer(resetTime, 1);
	
		public function Kikouken() {
			combinationTimer.addEventListener(TimerEvent.TIMER, resetCombination);
		}
		public function unload():void {
			combinationTimer.removeEventListener(TimerEvent.TIMER, resetCombination);
		}
		public function get combination():Array { return _combination; }
		public function get specialMoves():Array { return parseMoves(moves, parseKeys(_combination)); }
		
		public function keyDown(e:KeyboardEvent):void {
			// key not yet registered as pressed
			if(_keys.every(function(el:*, i:*, a:*):Boolean { return el.keyCode != e.keyCode; })) {
				var key:Object = { keyCode: e.keyCode, timePressed: currentTime(), natural: true };
				_keys.push(key), _combination.push(key);
			}
			combinationTimer.reset(), combinationTimer.start();
		}
		public function keyUp(e:KeyboardEvent):void {
			_keys = _keys.filter(function(el:*, i:*, a:*):Boolean { return el.keyCode != e.keyCode; });
		}
		public function update(e:Event):void {
			_keys.forEach(function(el:*, i:*, a:*):void {
				switch(el.keyCode) {
					case 37: case 39: { action = el.charged ? "running" : "walking"; break; }
				}
			});
			if(!action || _keys.length == 0) action = "standing";
		}
		
		private function resetCombination(e:TimerEvent):void { _combination = []; } // timer event
		private function currentTime():Number { return new Date().getTime() - timeStarted; }
		
		// add diagonals, check for charging, and update facing direction
		private function parseKeys(combination:Array):Array {
			var combi:Array = combination.map(function(el:*, i:*, a:*):* {
				el.keyName = keyNameFromCode(el.keyCode);
				
				return el;
			});
			combi.forEach(function(el:*, i:*, a:*):void {
				if(!el) return;
				
				var key:Object;
				
				if(_keys.every(function(ele:*, ind:*, ar:*):Object { return el != ele; })) {
					if(!el.timeLifted) el.timeLifted = new Date().getTime() - timeStarted;
				} // combine simultaneous directionals into diagonals
				if(i+1 < a.length) {
					key = a[i+1];

					var upLeft:Boolean = a[i].keyName == "left" && a[i+1].keyName == "up" || a[i].keyName == "up" && a[i+1].keyName == "left";
					var upRight:Boolean = a[i].keyName == "up" && a[i+1].keyName == "right" || a[i].keyName == "right" && a[i+1].keyName == "up";
					var downRight:Boolean = a[i].keyName == "right" && a[i+1].keyName == "down" || a[i].keyName == "down" && a[i+1].keyName == "right";
					var downLeft:Boolean = a[i].keyName == "down" && a[i+1].keyName == "left" || a[i].keyName == "left" && a[i+1].keyName == "down";

					if(keysHitSimultaneously(a[i], a[i+1])) { // keys hit at same time
						if(upLeft) { key.keyName = "up-left"; a.splice(i, 2, key); }
						else if(upRight) { key.keyName = "up-right"; a.splice(i, 2, key); }
						else if(downRight) { key.keyName = "down-right"; a.splice(i, 2, key); }
						else if(downLeft) { key.keyName = "down-left"; a.splice(i, 2, key); }
					// if a directional was hit, and another directional hit after, add an artificial diagonal
					} else if(Math.abs(a[i].timePressed - a[i+1].timePressed) < diagonalTime) { // one key hit before the other was lifted--lazy directionals
						if(upLeft) { key.keyName = "up-left"; a.splice(i+1, 1, key); }
						else if(upRight) { key.keyName = "up-right"; a.splice(i+1, 1, key); }
						else if(downRight) { key.keyName = "down-right"; a.splice(i+1, 1, key); }
						else if(downLeft) { key.keyName = "down-left"; a.splice(i+1, 1, key); }
					}
				} // if a 2nd directional is held after the first has lifted and a diagonal has been added, add a "plain" directional after the 2nd.
				if(i > 0) if(a[i-1].timeLifted) if(a[i].timePressed < a[i-1].timeLifted) if(isDiagonal(a[i])) if(!keysHitSimultaneously(a[i-1], a[i])) if(!keysLiftedSimultaneously(a[i-1], a[i])) {
					key = { keyCode: a[i].keyCode, timePressed: a[i-1].timePressed };

					if(a[i-1].keyName == "down") {
						if(a[i].keyName == "down-right") key.keyName = "right";
						if(a[i].keyName == "down-left") key.keyName = "left";
					} else if(a[i-1].keyName == "up") {
						if(a[i].keyName == "up-right") key.keyName = "right";
						if(a[i].keyName == "up-left") key.keyName = "left";
					} else if(a[i-1].keyName == "left") {
						if(a[i].keyName == "down-left") key.keyName = "down";
						if(a[i].keyName == "up-left") key.keyName = "up";
					} else if(a[i-1].keyName == "right") {
						if(a[i].keyName == "down-right") key.keyName = "down";
						if(a[i].keyName == "up-right") key.keyName = "up";
					}
					if(key.keyName) a.splice(i+1, 0, key);
				}
				// update which direction the player is facing
				if(changesDirection) {
					if((a[i+1] ? a[i+1] : a[i]).keyName == "left") facingRight = false;
					if((a[i+1] ? a[i+1] : a[i]).keyName == "right") facingRight = true;
				}
				// check for charging
				if(a[i].timeLifted) { if(a[i].timeLifted - a[i].timePressed > chargeTime) a[i].charged = true; }
				else if(currentTime() - a[i].timePressed > chargeTime) a[i].charged = true;
				// if a diagonal is artificially added, allow it to be charged without the previous key being charged too
				if(a[i-1]) if(a[i-1].charged) if(isDiagonal(a[i]))
					a[i].charged = true, a[i-1].charged = false;
				if(a[i-1]) if(a[i-2]) if(a[i].charged) if(isPlainDirectional(a[i]))
					a[i].charged = true, a[i-1].charged = false, a[i-2].charged = false;
			});
			return combi;
		}
		private function parseMoves(specialMoves:Array, combination:Array):Array {
			var moves:Array = [];
			
			specialMoves.forEach(function(el:*, i:*, a:*):void {
				if(hasSpecialMove(el, combination)) {
					var move:Object = combination[combination.length - el.moves.length];
					move.name = el.name;
					
					moves.push(move);
				}																																	
			});
			return moves;
		}
		private function keyNameFromCode(code:Number):String {
			return codes[code] ? codes[code] : "?"
		}
		private function keysHitSimultaneously(key1:Object, key2:Object):Boolean {
			return Math.abs(key1.timePressed - key2.timePressed) < simultaneousTime;
		}
		private function keysLiftedSimultaneously(key1:Object, key2:Object):Boolean {
			return(Math.abs(key1.timeLifted - key2.timeLifted) < simultaneousTime);
		}
		private function isDiagonal(key:Object):Boolean {
			return ["down-left", "down-right", "up-right", "up-left"].some(
				function(el:*, i:*, a:*):Boolean { return el == key.keyName; }
			);					
		}
		private function isPlainDirectional(key:Object):Boolean {
			return ["up", "down", "left", "right"].some(
				function(el:*, i:*, a:*):Boolean { return el == key.keyName; }
			);
		}
		private function mirroredDirectional(direction:String):String {
			return mirrors[direction] ? mirrors[direction] : "";
		}
		private function hasSpecialMove(specialMove:Object, moves:Array):Boolean {
			if(moves.length >= specialMove.moves.length) {
				var movesToCompareForSpecialMove:Array = moves.slice(moves.length - specialMove.moves.length, moves.length);
				
				return movesToCompareForSpecialMove.every(function(el:*, i:*, a:*):Boolean {
					var splitSpecialMove:Array = specialMove.moves[i].split(" "),
						splitMove:Array = a[i].keyName.split(" ");
					return (splitSpecialMove[0] == splitMove[0]);
				});
			} else return false;
		}
	}
}