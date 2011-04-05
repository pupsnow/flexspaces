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
        
        // air only, less steps editing (edit button saves offline without prompt or browse dialog, launches app
        public var useLessStepsEdit:Boolean = false;
        // air only, when using less step editing, whether to do auto update online, when user saves in app
        public var autoUpdateOnlineOnAppSave:Boolean = false;

        // whether to use configured properties form dialog using configuration from share, otherwise original fixed properties dialog will be used               
        public var useConfiguredProperties:Boolean = false;
        // what form configuration to use from share for properties, when empty string, default share form config used             
        public var propertiesFormName:String = "";      
        //whether to use configured properties for properties portion of advanced search, using configuration from share, 
        // otherwise original fixed search properties will be used -->                
        public var useConfiguredAdvancedSearchProperties:Boolean = false;
        // what form configuration to use from share for advanced search properties               
        public var searchFormName:String = "search";      
        
        
        
		public function AppConfig()
		{
		}

	}
}