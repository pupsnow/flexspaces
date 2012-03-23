package org.integratedsemantics.flexspaces.model.tree
{
	[Bindable]
	public class SemanticTagTreeNode extends TreeNode
	{
		public var uri:String = null;
		public var relevance:String = null;
		public var normalizedName:String = null;
		public var latitude:String = null;
		public var longitude:String = null;
		public var website:String = null;
		public var ticker:String = null;
		
		public var semanticCategoryName:String = null;		
		
		
		public function SemanticTagTreeNode(newLabel:String, newId:String)
		{
			super(newLabel, newId);
		}
		
	}
}