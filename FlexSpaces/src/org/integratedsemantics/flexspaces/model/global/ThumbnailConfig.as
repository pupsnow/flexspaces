package org.integratedsemantics.flexspaces.model.global
{
	[Bindable]
	public class ThumbnailConfig
	{
        public var thumbnailName:String = "doclib";

		public var thumbnailHeight:int = 100;
		public var thumbnailWidth:int = 100;
		
		// request generation of thumbnail on upload with alfresco 3.0 "share" thumbnail service
		public var requestOnUpload:Boolean = false;  


		/**
		 * Constructor 
		 * 
		 */
		public function ThumbnailConfig()
		{
		}

	}
}