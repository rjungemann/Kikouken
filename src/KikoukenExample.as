package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import com.teamsketchy.kikouken.Kikouken;
	
	public class KikoukenExample extends Sprite {
		public function KikoukenExample() {
			var text:TextField = new TextField();
			var text2:TextField = new TextField();

			text2.text = "Press down, down-right, right, 'z', to execute an \"Eclipse bite\"."
			text2.width = stage.stageWidth, text2.y = 24;

			addChild(text);
			addChild(text2);

			var kikouken:Kikouken = new Kikouken();

			stage.addEventListener(KeyboardEvent.KEY_DOWN, kikouken.keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, kikouken.keyUp);
			stage.addEventListener(Event.ENTER_FRAME, function(e:Event):void {
				kikouken.update(e);

				if(kikouken.specialMoves.length > 0)
					text.text = kikouken.specialMoves.map(function(el:*, i:*, a:*):* { return el.name || el.keyName; }).join(", ");
				else text.text = "";
			});
		}
	}
}