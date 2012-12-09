package a3d
{
	import flash.geom.Matrix3D;

	public class MatrixA3D
	{
		internal var xx:Number;
		internal var xy:Number;
		internal var xz:Number;
		internal var xo:Number;
		internal var yx:Number;
		internal var yy:Number;
		internal var yz:Number;
		internal var yo:Number;
		internal var zx:Number;
		internal var zy:Number;
		internal var zz:Number;
		internal var zo:Number;
		
		public function MatrixA3D()
		{
			identity();
		}
		
		public function identity():void
		{
			xo = 0;
			xx = 1;
			xy = 0;
			xz = 0;
			yo = 0;
			yx = 0;
			yy = 1;
			yz = 0;
			zo = 0;
			zx = 0;
			zy = 0;
			zz = 1;
		}
		
		public function scale(xf:Number, yf:Number, zf:Number):void
		{
			xx *= xf;
			xy *= xf;
			xz *= xf;
			xo *= xf;
			yx *= yf;
			yy *= yf;
			yz *= yf;
			yo *= yf;
			zx *= zf;
			zy *= zf;
			zz *= zf;
			zo *= zf;
		}
		
		public function translate(x:Number, y:Number, z:Number):void
		{
			xo += x;
			yo += y;
			zo += z;
		}
		
		public function rotate(x:Number, y:Number, z:Number):void
		{
			xrot(x);
			yrot(y);
			zrot(z);
		}
		
		public function xrot(theta:Number):void
		{
			theta *= (Math.PI / 180.0);
			
			var ct:Number = Math.cos(theta);
			var st:Number = Math.sin(theta);
			
			var Nyx:Number = yx * ct + zx * st;
			var Nyy:Number = yy * ct + zy * st;
			var Nyz:Number = yz * ct + zz * st;
			var Nyo:Number = yo * ct + zo * st;
			var Nzx:Number = zx * ct - yx * st;
			var Nzy:Number = zy * ct - yy * st;
			var Nzz:Number = zz * ct - yz * st;
			var Nzo:Number = zo * ct - yo * st;
			
			yo = Nyo;
			yx = Nyx;
			yy = Nyy;
			yz = Nyz;
			zo = Nzo;
			zx = Nzx;
			zy = Nzy;
			zz = Nzz;
		}
		
		public function yrot(theta:Number):void
		{
			theta *= (Math.PI / 180.0);
			
			var ct:Number = Math.cos(theta);
			var st:Number = Math.sin(theta);
			
			var Nxx:Number = xx * ct + zx * st;
			var Nxy:Number = xy * ct + zy * st;
			var Nxz:Number = xz * ct + zz * st;
			var Nxo:Number = xo * ct + zo * st;
			var Nzx:Number = zx * ct - xx * st;
			var Nzy:Number = zy * ct - xy * st;
			var Nzz:Number = zz * ct - xz * st;
			var Nzo:Number = zo * ct - xo * st;
			
			xo = Nxo;
			xx = Nxx;
			xy = Nxy;
			xz = Nxz;
			zo = Nzo;
			zx = Nzx;
			zy = Nzy;
			zz = Nzz;
		}
		
		public function zrot(theta:Number):void
		{
			theta *= (Math.PI / 180.0);
			
			var ct:Number = Math.cos(theta);
			var st:Number = Math.sin(theta);
			
			var Nyx:Number = yx * ct + xx * st;
			var Nyy:Number = yy * ct + xy * st;
			var Nyz:Number = yz * ct + xz * st;
			var Nyo:Number = yo * ct + xo * st;
			var Nxx:Number = xx * ct - yx * st;
			var Nxy:Number = xy * ct - yy * st;
			var Nxz:Number = xz * ct - yz * st;
			var Nxo:Number = xo * ct - yo * st;
			
			yo = Nyo;
			yx = Nyx;
			yy = Nyy;
			yz = Nyz;
			xo = Nxo;
			xx = Nxx;
			xy = Nxy;
			xz = Nxz;
		}
		
		public function mult(rhs:MatrixA3D):void
		{
			var lxx:Number = xx * rhs.xx + yx * rhs.xy + zx * rhs.xz;
			var lxy:Number = xy * rhs.xx + yy * rhs.xy + zy * rhs.xz;
			var lxz:Number = xz * rhs.xx + yz * rhs.xy + zz * rhs.xz;
			var lxo:Number = xo * rhs.xx + yo * rhs.xy + zo * rhs.xz + rhs.xo;
			var lyx:Number = xx * rhs.yx + yx * rhs.yy + zx * rhs.yz;
			var lyy:Number = xy * rhs.yx + yy * rhs.yy + zy * rhs.yz;
			var lyz:Number = xz * rhs.yx + yz * rhs.yy + zz * rhs.yz;
			var lyo:Number = xo * rhs.yx + yo * rhs.yy + zo * rhs.yz + rhs.yo;
			var lzx:Number = xx * rhs.zx + yx * rhs.zy + zx * rhs.zz;
			var lzy:Number = xy * rhs.zx + yy * rhs.zy + zy * rhs.zz;
			var lzz:Number = xz * rhs.zx + yz * rhs.zy + zz * rhs.zz;
			var lzo:Number = xo * rhs.zx + yo * rhs.zy + zo * rhs.zz + rhs.zo;
			
			xx = lxx;
			xy = lxy;
			xz = lxz;
			xo = lxo;
			yx = lyx;
			yy = lyy;
			yz = lyz;
			yo = lyo;
			zx = lzx;
			zy = lzy;
			zz = lzz;
			zo = lzo;
		}
		
		public function transform(v:Vector, t:Object):void
		{
			t.x = (v.x * xx + v.y * xy + v.z * xz + xo);
			t.y = (v.x * yx + v.y * yy + v.z * yz + yo);
			t.z = (v.x * zx + v.y * zy + v.z * zz + zo);
		}
	}
}