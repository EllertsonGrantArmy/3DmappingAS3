package a3d
{
	import mx.core.EdgeMetrics;

	public class Facet extends Face
	{
		private var v:Vector.<Vertex>;
		private var e:Vector.<Edge>;
		private var normal:VectorPoint;
		private var filled:Boolean;
		private var marked:Boolean;
		
		public function Facet(a:Vertex, b:Vertex, c:Vertex, d:Vertex = null)
		{
			this.v = new Vector.<Vertex>();
			this.e = new Vector.<Edge>();
			this.v[0] = a;
			this.v[1] = b;
			this.v[2] = c;
			this.filled = true;
			this.marked = false;
			this.normal = Vertex.subtract(b,a).cross(Vertex.subtract(c,a));
			this.normal.normalize();
			createEdges();
			
			if(d)
				orient(d)
		}
		
		public function getNormal():VectorPoint
		{
			return this.normal;
		}
		
		public function getVertex(index:int):Vertex
		{
			return v[index];
		}
		
		public function getVertexCount():int
		{
			return v.length;
		}
		
		public function getEdge(index:int):Edge
		{
			if (index < 3 && index >= 0)
				return e[index];
			else
				return null
		}
		
		public function getEdgeCount():int
		{
			return e.length;
		}
		
		public function isFilled():Boolean
		{
			return this.filled;
		}
		
		public function setFilled(filled:Boolean):void
		{
			this.filled = filled;
		}
		
		public function isMarked():Boolean
		{
			return this.marked;
		}
		
		public function setMarked(marked:Boolean):void
		{
			this.marked = marked;
		}
		
		public function behind(test:Vertex):Boolean
		{
			return normal.dot(test) < normal.dot(v[0]);
		}
		
		public function connect(adjacent:Facet, a:Vertex, b:Vertex):void
		{
			var inner:Edge = getMatchingEdge(a,b);
			var outter:Edge = adjacent.getMatchingEdge(a,b);
			inner.setTwin(outter);
			outter.setTwin(inner);
		}
		
		public function connectEdge(e:Edge):void
		{
			var inner:Edge = getMatchingEdge(e.getSource(), e.getDest());
			inner.setTwin(e);
			e.setTwin(inner);
		}
		
		public function getMatchingEdge(a:Vertex, b:Vertex):Edge
		{
			for (var i:int = 0; i < 3; i++)
				if (e[i].matches(a,b)) return e[i];
			
			return null;
		}
		
		public function getHorizonEdge():Edge
		{
			var opposite:Edge;
			
			for (var i:int = 0; i < 3; i++)
			{
				opposite = e[i].getTwin();
				if (opposite != null && opposite.onHorizon())
					return e[i];
			}
			
			return null;
		}
		
		private function orient(reference:Vertex):void
		{
			if (!behind(reference))
			{
				var tmp:Vertex = v[1];
				v[1] = v[2];
				v[2] = tmp;
				normal.negate();
				createEdges();
			}
		}
		
		private function createEdges():void
		{
			e[0] = null;
			e[1] = null;
			e[2] = null;
			e[0] = new Edge(v[0], v[1], this);
			e[1] = new Edge(v[1], v[2], this);
			e[2] = new Edge(v[2], v[0], this);
			e[0].setNext(e[1]);
			e[0].setPrev(e[2]);
			e[1].setNext(e[2]);
			e[1].setPrev(e[0]);
			e[2].setNext(e[0]);
			e[2].setPrev(e[1]);
		}
	}
}