package a3d
{
	import flash.geom.Matrix;

	public class Polytope
	{
		private var points:Vector.<Vertex>;
		private var facets:Vector.<Facet>;
		private var matrix:MatrixA3D;
		private var diameter:Number;
		
		public function Polytope()
		{
			this.diameter = 0;
			this.points = new Vector.<Vertex>();
			this.facets = new Vector.<Facet>();
			this.matrix = new MatrixA3D();
			clear();
		}
		
		public function clear():void
		{
			this.points.length = 0;
			this.facets.length = 0;
			this.matrix.identity();
		}
		
		public function getMatrix():MatrixA3D
		{
			return this.matrix;
		}
		
		public function getDiameter():Number
		{
			return this.diameter;
		}
		
		public function setDiameter(diameter:Number):void
		{
			this.diameter = diameter;
		}
		
		public function getVertex(index:int):Vertex
		{
			if (index < 0 || index >= getVertexCount())
			{
				return null;
			}
			else
			{
				return Vertex(this.points[index]);
			}
		}
		
		public function getVertexCount():int
		{
			return this.points.length;
		}
		
		public function addVertex(v:Vertex):void
		{
			v.setIndex(getVertexCount());
			this.points.push(v);
		}
		
		public function removeVertex(v:Vertex):void
		{
			var index:int = this.points.indexOf(v);
			
			v.setIndex(-1);
			
			if (index == -1) return;
			
			if (index == getVertexCount() - 1)
				this.points.pop();
			else
			{
				var last:Vertex = this.points.pop();
				last.setIndex(index);
				this.points.splice(index, 1, last);
			}
		}
		
		public function getFacet(index:int):Facet
		{
			if (index < 0 || index >= getFacetCount())
				return null;
			else
				return Facet(this.facets[index]);
		}
		
		public function getFacetCount():int
		{
			return this.facets.length;
		}
		
		public function addFacet(f:Facet):void
		{
			f.setIndex(getFacetCount());
			this.facets.push(f);
		}
		
		public function removeFacet(f:Facet):void
		{
			var index:int = this.facets.indexOf(f);
			
			f.setIndex(-1);
			
			if (index == -1) return;
			
			if (index == getFacetCount() - 1)
				this.facets.pop();
			else
			{
				var last:Vertex = this.facets.pop();
				last.setIndex(index);
				this.facets.splice(index, 1, last);
			}
		}
	}
}