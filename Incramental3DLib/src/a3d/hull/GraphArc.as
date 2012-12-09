package a3d.hull
{
	import a3d.Facet;
	import a3d.Vertex;

	public class GraphArc
	{
		public var facet:Facet;
		public var vertex:Vertex;
		
		public var nextv:GraphArc;
		public var prevv:GraphArc;
		
		public var nextf:GraphArc;
		public var prevf:GraphArc;
		
		public function GraphArc(f:Facet, v:Vertex) {
			this.vertex = v;
			this.facet = f;
		}
		
		public function deleteSelf():void {
			if (this.prevv)
				prevv.nextv = nextv;
			if (this.nextv)
				nextv.prevv = prevv;
			if (this.prevf)
				prevf.nextf = nextf;
			if (this.nextf)
				nextf.prevf = prevf;
			
			var list:ConflictList;
			
			if (this.prevv == null) {
				list = ConflictList(this.vertex.getData());
				list.head = this.nextv;
			}
			
			if(this.prevf == null) {
				list = ConflictList(this.vertex.getData());
				list.head = this.nextf;
			}
		}
	}
}