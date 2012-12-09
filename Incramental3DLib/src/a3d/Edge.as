package a3d
{
	public class Edge extends Face
	{
		private var a:Vertex;
		private var b:Vertex;
		private var facet:Facet;
		private var next:Edge;
		private var prev:Edge;
		private var twin:Edge;
		
		public function Edge(a:Vertex, b:Vertex, facet:Facet)
		{
			this.a = a;
			this.b = b;
			this.facet = facet;
			this.twin = null;
			this.next = null;
			this.prev = null;
		}
		
		public function getFacet():Facet
		{
			return this.facet;
		}
		
		public function getNext():Edge
		{
			return this.next;
		}
		
		public function setNext(next:Edge):void
		{
			this.next = next;
		}
		
		public function getPrev():Edge
		{
			return this.prev;
		}
		
		public function setPrev(prev:Edge):void
		{
			this.prev = prev;
		}
		
		public function getTwin():Edge
		{
			return this.twin;
		}
		
		public function setTwin(twin:Edge):void
		{
			this.twin = twin;
		}
		
		public function getSource():Vertex
		{
			return this.a;
		}
		
		public function getDest():Vertex
		{
			return this.b;
		}
		
		public function onHorizon():Boolean
		{
			if (twin == null)
				return false;
			else
				return (!facet.isMarked() && twin.getFacet().isMarked());
		}
		
		public function findHorizon(horizon:Vector.<Edge>):void
		{
			if (onHorizon())
			{
				if (horizon.length > 0 && this == horizon[0])
					return;
				else
				{
					horizon.push(this);
					next.findHorizon(horizon);
				}
			}
			else
			{
				if (twin != null)
					twin.getNext().findHorizon(horizon);
			}
		}
		
		public function matches(a:Vertex, b:Vertex):Boolean
		{
			return ((this.a == a && this.b == b) ||
					(this.a == b && this.b == a));
		}
	}
}