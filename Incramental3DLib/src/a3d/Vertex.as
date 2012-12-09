package a3d
{
	public class Vertex extends Face
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public function Vertex(x:Number = 0, y:Number = 0, z:Number = 0)
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		public static function subtract(a:Vertex, b:Vertex):VectorPoint
		{
			return new VectorPoint(a.x - b.x, a.y - b.y, a.z - b.z);
		}
	}
}