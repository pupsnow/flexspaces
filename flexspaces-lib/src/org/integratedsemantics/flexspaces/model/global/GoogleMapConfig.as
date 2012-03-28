package org.integratedsemantics.flexspaces.model.global
{
	[Bindable]
	public class GoogleMapConfig
	{
		// whether displaying google maps feature is enabled
        public var enableGoogleMap:Boolean = false;
        
        // url of ip or domain google api key is for 
        public var googleMapUrl:String = null;
        
        // google map api key
        public var googleMapKey:String = null;

		public function GoogleMapConfig()
		{
		}

	}
}