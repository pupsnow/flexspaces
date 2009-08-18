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
        
        public var cmisMode:Boolean = false;        

        // whether to use short term shared object to store ticket / docLibPath / tabIndex
        // allows restoring state after browser refresh, portlet resize, and re-running app
        public var useSessionData:Boolean = false;
        
        // when sessionData shared object is used (useSessionData true),
        // how long can (in minutes) can its data be used to restore state when app restarts
        public var sessionDataValidTime:int = 30;

		public function AppConfig()
		{
		}

	}
}