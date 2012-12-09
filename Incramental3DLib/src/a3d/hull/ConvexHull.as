package a3d.hull
{
	import a3d.Edge;
	import a3d.Face;
	import a3d.Facet;
	import a3d.Polytope;
	import a3d.Vertex;

	public class ConvexHull extends Polytope {
		
		/** Current vertex to add to the hull */
		public var current:int;
		
		/** List of newly created facets */
		public var created:Vector.<Facet>;
		
		/** List of edges on the horizon */
		public var horizon:Vector.<Edge>;
		
		/** List of facets visible to the current vertex */
		public var visible:Vector.<Facet>;
		
		public function ConvexHull()
		{
			created = new Vector.<Facet>;
			horizon = new Vector.<Edge>;
			visible = new Vector.<Facet>;
			restart();
		}
		
		/**
		 * Clear existing vertices and facets and generate a new random point
		 * cloud.
		 */
		public function restart():void
		{
			clear();
			this.current = 0;
			this.created.length = 0;
			this.horizon.length = 0;
			this.visible.length = 0;
			
			var v:Vertex;
			var rand:Number = Math.random();
			var d:Number = getDiameter();
			var r:Number = d / 2;
			for (var i:int=0; i<40; i++) {
				v = new Vertex((Math.random() * d) - r,
											 (Math.random() * d) - r,
											 (Math.random() * d) - r);
				addVertex(v);
				v.setData(new ConflictList(false));
			}
		}
		
		/**
		 * Add the next vertex to the convex hull
		 */
		public function step():void
		{
			if (current == 0) {
				prep();
			} 
			else if (created.length == 0) {
				stepA();
				stepB();
			}
			else {
				stepC();
			}
		}
		
		/**
		 * To begin the convex hull algorithm, we create a tetrahedron from
		 * the first four vertices in the point cloud. 
		 */
		private function prep():void
		{
			var a:Vertex = getVertex(0),
					b:Vertex = getVertex(1),
					c:Vertex = getVertex(2),
					d:Vertex = getVertex(3);
			
			var f1:Facet = new Facet(a, b, c, d),
					f2:Facet = new Facet(a, c, d, b),
					f3:Facet = new Facet(a, b, d, c),
					f4:Facet = new Facet(b, c, d, a);
			
			f1.setData(new ConflictList(true));
			f2.setData(new ConflictList(true));
			f3.setData(new ConflictList(true));
			f4.setData(new ConflictList(true));
			
			addFacet(f1);
			addFacet(f2);
			addFacet(f3);
			addFacet(f4);
			
			f1.connect(f2, a, c);
			f1.connect(f3, a, b);
			f1.connect(f4, b, c);
			f2.connect(f3, a, d);
			f2.connect(f4, c, d);
			f3.connect(f4, b, d);
			
			this.current = 4;
			
			/*
			* Initialize the conflict graph
			*/
			var v:Vertex;
			for (var i:int=4; i<getVertexCount(); i++) {
				v = getVertex(i);
				if (!f1.behind(v)) addConflict(f1, v);
				if (!f2.behind(v)) addConflict(f2, v);
				if (!f3.behind(v)) addConflict(f3, v);
				if (!f4.behind(v)) addConflict(f4, v);
			}
			
			a.setVisible(false);
			b.setVisible(false);
			c.setVisible(false);
			d.setVisible(false);
		}
		
		/**
		 * StepA begins an incremental step of the algorithm. 
		 * <ul>
		 * <li>Identify the next vertex v.  O(1)
		 * <li>Identify all facets visible to v.  O(F(v))
		 * <li>Find the list of horizon edges for v.  O(F(v))
		 * </ul>
		 * F(v) refers to the facets visible to vertex v.
		 */
		private function stepA():void
		{
			if (this.current >= getVertexCount()) return;
			
			this.created.length = 0;
			this.horizon.length = 0;
			this.visible.length = 0;
			
			/*
			* Get list of visible facets for v.
			*/
			var v:Vertex = getVertex(current);
			ConflictList(v.getData()).getFacets(visible);
			
			/*
			* If v is already inside the convex hull, try the next point
			*/
			if (visible.length == 0) {
				v.setVisible(false);
				current++;
				stepA();
				return;
			}
			
			/*
			* Flag visible facets 
			*/
			for (var i:int=0; i<visible.length; i++) { 
				visible[i].setMarked(true);
			}
			
			/*
			* Find horizon edges 
			*/
			var e:Edge;
			for (i=0; i<visible.length; i++) {
//				visible[0].getHorizionEdge();
				e = visible[i].getHorizonEdge();
				if (e != null) {
					e.findHorizon(horizon);
					break;
				}
			}
		}
		
		/** 
		 * StepB continues the incremental step by conneting vertex v to
		 * each edge of the horizon.
		 */
		private function stepB():void
		{
			if (this.current >= getVertexCount()) return;
			
			var v:Vertex = getVertex(current);
			
			/*
			* Create new facets to connect to the horizon  O(v)
			*/
			var old:Facet, last:Facet, first:Facet;
			
			for (var i:int=0; i<horizon.length; i++) {
				
				var e:Edge = horizon[i];
				old = e.getTwin().getFacet();
				
				/*
				* Create a new facet
				*/
				var f:Facet = new Facet(v, e.getDest(), e.getSource());
				f.setData(new ConflictList(true));
				addFacet(f);
				created.push(f);
				f.setFilled(false);
				
				/*
				* Connect it to the hull
				*/
				f.connectEdge(e);
				if (last != null) f.connect(last, v, e.getSource());
				last = f;
				if (first == null) first = f;
				
				/*
				* Update conflict graph for the new facet
				*/
				addConflicts(f, old, e.getFacet());
			}
			
			if (last != null && first != null) {
				last.connect(first, v, first.getEdge(1).getDest());
			}
		}
		
		/**
		 * StepC cleans up the process started in steps A and B by removing
		 * all of the previously visible facets (including the corresponding
		 * nodes and edges in the conflict graph).
		 */
		private function stepC():void
		{
			/*
			* Hide the just-processed vertex
			*/
			getVertex(current).setVisible(false);
			
			/*
			* Remove all previously visible facets
			*/
			var f:Facet;
			for (var i:int=0; i<visible.length; i++) {
				f = visible[i];
				removeConflicts(f);
				removeFacet(f);
			}
			
			/*
			* Fill in all newly created facets
			*/
			for (i=0; i<created.length; i++) {
				created[i].setFilled(true);
			}
			created.length = 0;
			
			this.current++;
		}
		
		/**
		 * Add an arc to the conflict graph connecting the given facet and
		 * vertex.
		 */
		private function addConflict(f:Facet, v:Vertex):void
		{
			var arc:GraphArc = new GraphArc(f, v);
			ConflictList(f.getData()).add(arc);
			ConflictList(v.getData()).add(arc);
		}
			
		private function addConflicts(f:Facet, old1:Facet, old2:Facet):void
		{
			var l1:Vector.<Vertex> = new Vector.<Vertex>,
					l2:Vector.<Vertex> = new Vector.<Vertex>,
					l:Vector.<Vertex> = new Vector.<Vertex>;
			
			ConflictList(old1.getData()).getVertices(l1);
			ConflictList(old2.getData()).getVertices(l2);
			
			var v1:Vertex, v2:Vertex;
			var i1:int = 0, i2:int = 0;
			
			while (i1 < l1.length || i2 < l2.length) {
				
				if (i1 < l1.length && i2 < l2.length) {
					v1 = l1[i1];
					v2 = l2[i2];
					if (v1.getIndex() == v2.getIndex()) {
						l.push(v1);
						i1++;
						i2++;
					}
					else if (v1.getIndex() > v2.getIndex()) {
						l.push(v1);
						i1++;
					}
					else {
						l.push(v2);
						i2++;
					}
				}
				else if (i1 < l1.length) {
					l.push(l1[i1++]);
				}
				else {
					l.push(l2[i2++]);
				}
			}
			
			var v:Vertex;
			for (var i:int=l.length - 1; i >= 0; i--) {
				v = l[i];
				if (!f.behind(v))
					addConflict(f, v);
			}
		}
	
		private function removeConflicts(f:Facet):void
		{
			ConflictList(f.getData()).clear();
		}
	}
}