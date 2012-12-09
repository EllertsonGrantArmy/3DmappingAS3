package a3d
{
	public class Face
	{
		private var index:int;
		private var data:Object;
		private var visible:Boolean;
		
		public function Face()
		{
			this.index = -1;
			this.data = null;
			this.visible = true;
		}
		
		public function getIndex():int
		{
			return this.index;
		}
		
		public function setIndex(index:int):void
		{
			this.index = index;
		}
		
		public function getData():Object
		{
			return this.data;
		}
		
		public function setData(data:Object):void
		{
			this.data = data;
		}
		
		public function isVisible():Boolean
		{
			return this.visible;
		}
		
		public function setVisible(visible:Boolean):void
		{
			this.visible = visible;
		}
	}
}