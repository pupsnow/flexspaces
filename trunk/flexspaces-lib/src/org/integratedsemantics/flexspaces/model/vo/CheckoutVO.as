package org.integratedsemantics.flexspaces.model.vo
{
	/**
	 * For return info on working copy after checkout 
	 * 
	 */
	public class CheckoutVO
	{
		public var name:String;
		public var nodeRef:String;
		public var storeProtocol:String;
		public var storeId:String;
		public var id:String;
		public var viewUrl:String;
		
		public function CheckoutVO()
		{
		}

	}
}