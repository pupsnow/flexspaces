package org.integratedsemantics.flexspaces.model.vo
{
	import mx.collections.ArrayCollection;
	
	public class GetTagsVO
	{
		public var countMin:int;
		public var countMax:int;
		
		// array of tagVO 
		public var tags:ArrayCollection = new ArrayCollection();
		
		public function GetTagsVO()
		{
		}

	}
}