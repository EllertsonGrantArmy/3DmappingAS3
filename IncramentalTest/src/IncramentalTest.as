package
{
	import a3d.hull.ConvexHull;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	public class IncramentalTest extends Sprite
	{
		private var hull:ConvexHull;
		private var tb:TextField;
		private var count:int = 1;
		
		public function IncramentalTest()
		{
			tb = new TextField();
			tb.width = 200;
			tb.height = 200;
			tb.background = true;
			tb.backgroundColor = 0xFF7777;
			tb.text = "Welcome!";
			addChild(tb);
			
			hull = new ConvexHull();
			hull.setDiameter(200);
			hull.restart();
			hull.step();
			updateTextBox();
			addEventListener(KeyboardEvent.KEY_DOWN, keyPress);
		}
		
		protected function keyPress(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.SPACE) {
				hull.step();
				updateTextBox();
			}
		}
		
		private function updateTextBox():void
		{
			tb.text = "Welcome!\nCurrent: " + hull.current + "\nCount: " + count++;
		}
	}
}