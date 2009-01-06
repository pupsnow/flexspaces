/*  
 * Copyright (C) 2005-2007 Alfresco Software Limited.
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
  
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

 * As a special exception to the terms and conditions of version 2.0 of 
 * the GPL, you may redistribute this Program in connection with Free/Libre 
 * and Open Source Software ("FLOSS") applications as described in Alfresco's 
 * FLOSS exception.  You should have recieved a copy of the text describing 
 * the FLOSS exception, and it is also available here: 
 * http://www.alfresco.com/legal/licensing"
 */

package org.alfresco.framework.service.webscript
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import org.alfresco.framework.service.error.ErrorService;
	import org.integratedsemantics.flexspaces.model.AppModelLocator; 
    
    /**
	 * Config service.
	 * 
	 * This provides an encapsulated way for handling URLS
	 * 
	 * @author Saravanan Sellathurai
	 */
    	
	public class ConfigService extends EventDispatcher
	{		
		private var myXML:XML = new XML();
		private var XML_URL:String;
		private var myXMLURL:URLRequest;
		private var myLoader:URLLoader;
		private var myList:XMLList;
		private var myDoc:XMLDocument;
		private var node:XMLNode;
		
		private var _domain:String;
		private var _protocol:String;
		private var _port:String;
		
		// sreiner added additional config of rest of url
		private var _alfrescoUrlPart:String;
	
		/** Static instance of the authentication service */
		private static var _instance:ConfigService;
		
		/** Name of the configuration file */
		private static var CONFIG_FILE:String = "alfresco-config.xml";
		
		/** url for config */
		private var _url:String;
		
		/**
		 * Singleton method to get the instance of the Search Service
		 */
		public static function get instance():ConfigService
		{
			if (ConfigService._instance == null)
			{
				ConfigService._instance = new ConfigService();
				
			}
			return ConfigService._instance;
		}
		
		/**
		 * Default constructor
		 */
		public function ConfigService()
		{
			
			/**
			* 
			* Place the ace-config.xml file into the bin directory, where all the compiled swf's reside
			* Sample contents of the ace-config.xml file
			* 
			* <?xml version="1.0"?>
			*	<alfresco-config>
			*		<url protocol="http" domain="localhost" port="8080"/>
			*	</alfresco-config>
			* 
			*/
			
			try
			{
				myXML = new XML();

                var model:AppModelLocator = AppModelLocator.getInstance();

				XML_URL = model.appConfig.srcPath + CONFIG_FILE;

				myXMLURL = new URLRequest(XML_URL);
				myLoader = new URLLoader(myXMLURL); 
				myLoader.addEventListener("complete", xmlLoaded);				
			}
			catch (error:Error)
			{
				ErrorService.instance.raiseError(ErrorService.APPLICATION_ERROR, error);
			}
		}
		
		public function get url():String
		{
			return this._url;
		}
		
		private function xmlLoaded(evtObj:Event):void
		{
			try
			{
				myXML = XML(myLoader.data);
				myDoc = new XMLDocument();
				
				myDoc.ignoreWhite=true;
				myDoc.parseXML(myXML.toXMLString());
				node = myDoc.firstChild;
				
				// get the url information from the ace-config.xml file
				this._domain = node.firstChild.attributes['domain'];
				this._port = node.firstChild.attributes['port'];
				this._protocol = node.firstChild.attributes['protocol'];
				
				// sreiner: added addtional config, adding alfrescoUrlPart
				this._alfrescoUrlPart = node.firstChild.attributes['alfrescoUrlPart'];
				
				// sreiner: added having /alfresco/service configurable 
				if (this.port!= null)
				{
				    this._url = this._protocol + "://" + this._domain + ":" + this._port + this._alfrescoUrlPart;
				}
				else
				{
				    this._url = this._protocol + "://" + this._domain + this._alfrescoUrlPart;
				}
				
				var model : AppModelLocator = AppModelLocator.getInstance();

				var nodeServerElement:XMLNode = node.firstChild.nextSibling;
				
				if (nodeServerElement.attributes['livecycle'] == "true")
				{
					model.ecmServerConfig.isLiveCycleContentServices = true;	
				}
				var nodeLocaleElement:XMLNode = nodeServerElement.nextSibling;
				if ((nodeLocaleElement != null) && (nodeLocaleElement.attributes['default-locale'] != null))
				{
					model.appConfig.locale = nodeLocaleElement.attributes['default-locale'];
				}	
				
				var nodeCalaisElement:XMLNode = nodeLocaleElement.nextSibling;
				if (nodeCalaisElement != null)
				{
					if (nodeCalaisElement.attributes['enable'] == "true")
					{
						model.calaisConfig.enableCalias = true;
					}
					
					if (nodeCalaisElement.attributes['key'] != null)
					{
						model.calaisConfig.calaisKey = nodeCalaisElement.attributes['key'];
					}	
				}	

				var nodeGoogleMapElement:XMLNode = nodeCalaisElement.nextSibling;
				if (nodeGoogleMapElement != null)
				{
					if (nodeGoogleMapElement.attributes['enable'] == "true")
					{
						model.googleMapConfig.enableGoogleMap = true;
					}
					
					if (nodeGoogleMapElement.attributes['url'] != null)
					{
						model.googleMapConfig.googleMapUrl = nodeGoogleMapElement.attributes['url'];
					}	

					if (nodeGoogleMapElement.attributes['key'] != null)
					{
						model.googleMapConfig.googleMapKey = nodeGoogleMapElement.attributes['key'];
					}	
				}	

				this.dispatchEvent(new ConfigCompleteEvent(ConfigCompleteEvent.CONFIG_COMPLETE));
			}
			catch (error:Error)
			{
				ErrorService.instance.raiseError(ErrorService.APPLICATION_ERROR, error);
			}
			
		}
		
		/**
		 * getter methods
		 * to return the url info from the ace-config.xml file
		 */		
		 
		public function get domain():String
		{
			return this._domain;
		}
		
		public function get protocol():String
		{
			return this._protocol;
		}
		
		public function get port():String
		{
			return this._port;
		} 
		
		// sreiner added
        public function get alfrescoUrlPart():String
        {
            return this._alfrescoUrlPart;
        } 
	}
}