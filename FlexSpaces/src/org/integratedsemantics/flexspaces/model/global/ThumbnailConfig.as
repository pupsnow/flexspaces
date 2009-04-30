package org.integratedsemantics.flexspaces.model.global
{
	[Bindable]
	public class ThumbnailConfig
	{
        public var thumbnailName:String = "doclib";

		public var thumbnailHeight:int = 100;
		public var thumbnailWidth:int = 100;
		
		// request generation of thumbnail on upload with alfresco 3.0 "share" thumbnail service
		// note: currently this shouldn't be set to true since calling createThumbnail in upload webscript right after file upload/save
		// causes problems, and can use c=force to get thumbnail generated if needed on get thumbnail rest url
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