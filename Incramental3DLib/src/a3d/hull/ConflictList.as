package a3d.hull
{
	import a3d.Facet;
	import a3d.Vertex;

	public class ConflictList
	{
		public var head:GraphArc;
		private var facet:Boolean;
		
		public function ConflictList(facet:Boolean)
		{
			this.facet = facet;
		}
		
		public function add(arc:GraphArc):void {
			if(this.facet) {
				if (this.head)
					this.head.prevf = arc;
				arc.nextf = this.head;
				this.head = arc;
			}
			else {
				if (this.head)
					this.head.prevv = arc;
				arc.nextv = this.head;
				this.head = arc;
			}
		}
		
		public function empty():Boolean {
			return (this.head == null);
		}
		
		public function clear():void {
			while(this.head)
				this.head.deleteSelf();
		}
		
		public function getVertices(list:Vector.<Vertex>):void {
			var arc:GraphArc = this.head;
			while (arc) {
				list.push(arc.vertex);
				arc = arc.nextf;
			}
		}
		
		public function getFacets(list:Vector.<Facet>):void {
			var arc:GraphArc = this.head;
			while (arc) {
				list.push(arc.facet);
				arc = arc.nextv;
			}
		}
		
		public function printFacetList():void {
			trace("Why would I print the list?");
		}
		
		public function printVertexList():void {
			trace("Why would I print the list?");
		}
	}
}