package org.integratedsemantics.flexspaces.presmodel.preferences
{
	import flash.net.SharedObject;
	
	import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
	import org.integratedsemantics.flexspaces.model.AppModelLocator;
	import org.springextensions.actionscript.objects.propertyeditors.BooleanPropertyEditor;

	[Bindable]
	public class PreferencesPresModel extends PresModel
	{        
        public var model : AppModelLocator = AppModelLocator.getInstance();                            
        
        public var domain:String;
        public var protocol:String;
        public var port:String;
        public var showTasks:Boolean;

        public var enableCalais:Boolean;
        public var calaisKey:String;
        
        public var enableGoogleMap:Boolean;
        public var googleMapKey:String;
        public var googleMapUrl:String;
        
        
        private var userPrefs:SharedObject;

        
		public function PreferencesPresModel()
		{
			super();
		}
        
        public function init():void
        {            
            userPrefs = SharedObject.getLocal("userPrefs");
            if (userPrefs.data.domain == undefined)
            {   
                domain = model.ecmServerConfig.domain;
                protocol = model.ecmServerConfig.protocol;
                port = model.ecmServerConfig.port;
                showTasks = model.flexSpacesPresModel.showTasks;
                
                enableCalais = model.calaisConfig.enableCalais;
                calaisKey = model.calaisConfig.calaisKey;
                enableGoogleMap = model.googleMapConfig.enableGoogleMap;
                googleMapKey = model.googleMapConfig.googleMapKey;
                googleMapUrl = model.googleMapConfig.googleMapUrl;
            }
            else
            {
                domain = userPrefs.data.domain;
                protocol = userPrefs.data.protocol;
                port = userPrefs.data.port;                
                showTasks = userPrefs.data.showTasks;

                enableCalais = userPrefs.data.enableCalais;
                calaisKey = userPrefs.data.calaisKey;
                enableGoogleMap = userPrefs.data.enableGoogleMap;
                googleMapKey = userPrefs.data.googleMapKey;
                googleMapUrl = userPrefs.data.googleMapUrl;            
            }            
        }
        
        public function updateDomain(domain:String):void
        {
            this.domain = domain;    
        }

        public function updateProtocol(protocol:String):void
        {
            this.protocol = protocol;    
        }
        
        public function updatePort(port:String):void
        {
            this.port = port;    
        }

        public function updateShowTasks(selected:Boolean):void
        {
            this.showTasks = selected;    
        }
        
        public function updateEnableCalais(selected:Boolean):void
        {
            this.enableCalais = selected;    
        }

        public function updateCalaisKey(calaisKey:String):void
        {
            this.calaisKey = calaisKey;    
        }

        public function updateEnableGoogleMap(selected:Boolean):void
        {
            this.enableGoogleMap = selected;    
        }
        
        public function updateGoogleMapKey(googleMapKey:String):void
        {
            this.googleMapKey = googleMapKey;    
        }

        public function updateGoogleMapUrl(googleMapUrl:String):void
        {
            this.googleMapUrl = googleMapUrl;    
        }

        public function save():void
        {
            model.ecmServerConfig.domain = domain;
            model.ecmServerConfig.protocol = protocol;
            model.ecmServerConfig.port = port;            
            model.ecmServerConfig.urlPrefix = protocol + "://" 
                + domain + ":" + port + model.ecmServerConfig.alfrescoUrlPart;

            model.flexSpacesPresModel.showTasks = showTasks;

            model.calaisConfig.enableCalais = enableCalais;
            model.calaisConfig.calaisKey = calaisKey;
            model.googleMapConfig.enableGoogleMap = enableGoogleMap;
            model.googleMapConfig.googleMapKey = googleMapKey;
            model.googleMapConfig.googleMapUrl = googleMapUrl;;
                        
            // save user prefs locally
            userPrefs.data.domain = domain;
            userPrefs.data.protocol = protocol;
            userPrefs.data.port = port;
            userPrefs.data.showTasks = showTasks;            
            userPrefs.data.enableCalais = enableCalais;
            userPrefs.data.calaisKey = calaisKey;
            userPrefs.data.enableGoogleMap = enableGoogleMap;
            userPrefs.data.googleMapKey = googleMapKey;
            userPrefs.data.googleMapUrl = googleMapUrl;            
            
            userPrefs.flush();            
        }        
		
	}
}