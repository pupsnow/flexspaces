package org.integratedsemantics.flexspaces.model.global
{
	[Bindable]
	public class EcmServerConfig
	{
		// what type of server (alfresco or livecycle content services es)
		public var isLiveCycleContentServices:Boolean = false;				 
				
        public var serverEdition:String;
        public var serverVersion:String = "2.1";

        // config of webscript service url parts
        public var protocol:String;
        public var domain:String;
        public var port:String;
        public var alfrescoUrlPart:String;

        // configured webscript serviced url parts put together
        public var urlPrefix:String = null;

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