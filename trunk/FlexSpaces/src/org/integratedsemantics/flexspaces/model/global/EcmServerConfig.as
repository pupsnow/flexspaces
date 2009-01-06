package org.integratedsemantics.flexspaces.model.global
{
	[Bindable]
	public class EcmServerConfig
	{
		// what type of server (alfresco or livecycle content services es)
		public var isLiveCycleContentServices:Boolean = false;				 
		
		// from config service
		public var urlPrefix:String = null;
		
        public var serverEdition:String;
        public var serverVersion:String = "2.1";


		public function EcmServerConfig()
		{
		}

        public function serverVersionNum():Number
        {
            var number:Number = new Number( Number(serverVersion.substr(0,3)) );
            return number;
        }

	}
}