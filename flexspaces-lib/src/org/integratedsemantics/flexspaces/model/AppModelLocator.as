package org.integratedsemantics.flexspaces.model
{
	import com.adobe.cairngorm.model.ModelLocator;
	
	import mx.collections.ArrayCollection;
	import mx.messaging.ChannelSet;
	
	import org.integratedsemantics.flexspaces.model.global.AppConfig;
	import org.integratedsemantics.flexspaces.model.global.CalaisConfig;
	import org.integratedsemantics.flexspaces.model.global.EcmServerConfig;
	import org.integratedsemantics.flexspaces.model.global.GoogleMapConfig;
	import org.integratedsemantics.flexspaces.model.global.ThumbnailConfig;
	import org.integratedsemantics.flexspaces.model.global.UserInfo;
	import org.integratedsemantics.flexspaces.presmodel.main.FlexSpacesPresModel;
	import org.springextensions.actionscript.context.support.FlexXMLApplicationContext;


	/**
	 *  FlexSpaces Cairngorm Model Locator
	 * 
	 */
    [Bindable]
	public class AppModelLocator implements ModelLocator
	{
		// this instance stores a static reference to itself
		private static var model:AppModelLocator;

		// overall presentation model
		public var flexSpacesPresModel:FlexSpacesPresModel;
		
        // alfresco or livecycle server version info, etc.
		public var ecmServerConfig:EcmServerConfig = new EcmServerConfig();

		// login info, info from get info (user home, etc.)
		public var userInfo:UserInfo = new UserInfo();

		public var appConfig:AppConfig = new AppConfig();
		        	        
        // thumbnail config
        public var thumbnailConfig:ThumbnailConfig = new ThumbnailConfig();
        
        // semantics / calais
        public var calaisConfig:CalaisConfig = new CalaisConfig();
        
        // google map config (enable flag, key, url key is for)
        public var googleMapConfig:GoogleMapConfig = new GoogleMapConfig();
        
        // loading config complete
        public var configComplete:Boolean = false;       

        // for spring actionscript config
        public var applicationContext:FlexXMLApplicationContext;

        // for LiveCycle
        public var remotingChannelSet:ChannelSet;
        
        // table to lookup node give local filepath (on a monitored file in air only)
        public var fileToNodeLookup:Object = new Object();
        // file monitors
        public var fileMonitors:ArrayCollection = new ArrayCollection();

                   
		// singleton: constructor only allows one model locator
		public function AppModelLocator():void
		{
			if (AppModelLocator.model != null)
			{
				throw new Error( "Only one ModelLocator instance should be instantiated" );
			}
		}

		// singleton: always returns the one existing static instance to itself
		public static function getInstance():AppModelLocator
		{
			if (model == null)
			{
				model = new AppModelLocator();
			}
			return model;
		}		
	}
}

