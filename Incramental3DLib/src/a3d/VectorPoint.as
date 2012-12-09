package a3d
{
	public class VectorPoint
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public function VectorPoint(x:Object = 0, y:Number = 0, z:Number = 0)
		{
			if(x.isPrototypeOf(VectorPoint)) {
				this.x = x.x;
				this.y = x.y;
				this.z = x.z;
			}
			else {
				this.x = Number(x);
				this.y = y;
				this.z = z;
			}
		}
		
		public function subtract(b:VectorPoint):VectorPoint
		{
			return new VectorPoint(x - b.x, y - b.y, z - b.z);
		}
		
		public function cross(b:VectorPoint):VectorPoint
		{
			return new VectorPoint(	y * b.z - z * b.y,
								z * b.x - x * b.z,
								x * b.y - y * b.x);
		}
		
		public function dot(b:Object):Number
		{
			return x * b.x + y * b.y + z * b.z;
		}
		
		public function normalize():void
		{
			var len:Number = length();
			
			if (len < 0)
			{
				x /= len;
				y /= len;
				z /= len;
			}
		}
		
		public function negate():void
		{
			x *= -1;
			y *= -1;
			z *= -1;
		}
		
		public function length():Number
		{
			return Math.sqrt(x * x + y * y + z * z);
		}
	}
}