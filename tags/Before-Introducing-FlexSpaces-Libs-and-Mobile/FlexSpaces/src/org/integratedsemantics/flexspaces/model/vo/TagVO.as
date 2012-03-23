package org.integratedsemantics.flexspaces.model.vo
{
	public class TagVO
	{
		public var name:String;
		public var count:int;
		
		// latitude/longitude only for semantic tags
		public var latitude:String = "";
		public var longitude:String = "";
		
		public function TagVO()
		{
		}

	}
}