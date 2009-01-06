package org.integratedsemantics.flexspaces.model.global
{
	[Bindable]
	public class AppConfig
	{
		// src path used as root to locate images, etc.
        public var srcPath:String = "";
        
        // running in AIR
        public var airMode:Boolean = false;

        // locale for menu config path 
        // note: curently resource bundle properties locale from project compile options
        public var locale:String = "en_US";     
        

		public function AppConfig()
		{
		}

	}
}