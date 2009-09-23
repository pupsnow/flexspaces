 package org.integratedsemantics.flexspaces.control.delegate.webscript
{
    import mx.messaging.ChannelSet;
    import mx.messaging.channels.AMFChannel;
    import mx.messaging.channels.HTTPChannel;
    import mx.messaging.channels.SecureAMFChannel;
    import mx.messaging.channels.SecureHTTPChannel;    
	import mx.rpc.AsyncToken;
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.utils.Base64Encoder;
	
	import org.integratedsemantics.flexspaces.control.delegate.webscript.event.FailureEvent;
	import org.integratedsemantics.flexspaces.control.delegate.webscript.event.SuccessEvent;
	import org.integratedsemantics.flexspaces.control.error.ErrorMgr;
	import org.integratedsemantics.flexspaces.control.error.WebScriptError;
	import org.integratedsemantics.flexspaces.model.AppModelLocator;

	
	public class WebScriptService extends HTTPService
	{
		public static const GET:String = "GET";
		public static const POST:String = "POST";
		public static const PUT:String = "PUT";
		public static const DELETE:String = "DELETE";
		
		// unique last part of webscript url
		private var relativeUrl:String;
		
		private var requestedMethod:String;	
		private var alwaysTunnelGetMethod:Boolean = true;
        private var ticketRequired:Boolean = true;
		
		
		public function WebScriptService(relativeUrl:String, method:String, onSuccess:Function=null, onFailure:Function=null, ticketRequired:Boolean=true, alwaysTunnelGetMethod:Boolean = true)
		{
			super();
			
			this.relativeUrl = relativeUrl;
			this.requestedMethod = method;
            this.alwaysTunnelGetMethod = alwaysTunnelGetMethod;
            this.ticketRequired = ticketRequired;
			
			if (this.requestedMethod == GET && this.alwaysTunnelGetMethod == false)
			{
				this.method = GET;	
			}
			else
			{
				this.method = POST;
			}			
			
            var model:AppModelLocator = AppModelLocator.getInstance();
            this.url = model.ecmServerConfig.urlPrefix +  relativeUrl;
			
			addEventListener(ResultEvent.RESULT, onResultEvent);
			addEventListener(FaultEvent.FAULT, onFaultEvent);
			
			if (onSuccess != null)
			{
				addEventListener(SuccessEvent.SUCCESS, onSuccess);
			}
			if (onFailure != null)
			{
				addEventListener(FailureEvent.FAILURE, onFailure);
			}	
			
            // using e4x result format by default not object format
            resultFormat = HTTPService.RESULT_FORMAT_E4X;
		}
		
		public function execute(parameters:Object=null):AsyncToken
		{
			var result:AsyncToken = null;
			
			try
			{
				if (parameters == null)
				{
					parameters = new Object();
				}
				
				// livecycle
	            var model:AppModelLocator = AppModelLocator.getInstance();
				
				if (model.ecmServerConfig.isLiveCycleContentServices == true)
				{
                    if (model.remotingChannelSet == null)
                    {
                        setupChannels();
                    }                   

                    this.useProxy = true;
                    
                    //this.destination = "DefaultHTTP";

                    this.channelSet = model.remotingChannelSet;
				    
                    // basic auth header
                    if ( (model.userInfo.loginUserName != null) && (model.userInfo.loginPassword != null) &&
                         (model.userInfo.loginUserName != "") && (model.userInfo.loginPassword != "") )
	            	{
						var headerList:Array = new Array();

	            		var encoder:Base64Encoder = new Base64Encoder();
	            		encoder.encode(model.userInfo.loginUserName + ":" + model.userInfo.loginPassword);
	            		headerList["Authorization"] = "Basic " + encoder.toString();
	            		
	            		// saml assertion ticket header
						//headerList["ticket"] = model.userInfo.loginTicket;
						
			            this.headers = headerList;						
	            	}
    			}
            	else
				{												
                    if (this.ticketRequired == true)
                    {
						var ticket:String = model.userInfo.loginTicket;
						if (ticket == null)
						{
							throw new Error("Unable to execute web script because required ticket is not available");	
						}
    					
    					parameters.alf_ticket = ticket;
                    }
				}
				
				if (this.method == POST && this.requestedMethod != POST)
				{
					parameters.alf_method = this.requestedMethod;
				}			
				
				result = send(parameters);
			}
			catch (error:Error)
			{
				ErrorMgr.getInstance().raiseError(ErrorMgr.APPLICATION_ERROR, error);
			}
			
			return result;
		}
		
		public function onResultEvent(event:ResultEvent):void
		{
			var newEvent:SuccessEvent = new SuccessEvent(SuccessEvent.SUCCESS, event.bubbles, event.cancelable, event.result, event.token, event.message);			
			dispatchEvent(newEvent);
		}
		
		public function onFaultEvent(event:FaultEvent):void
		{
			var fault:Fault = event.fault;

			if (hasEventListener(FailureEvent.FAILURE) == true)
			{
				var newEvent:FailureEvent = new FailureEvent(FailureEvent.FAILURE, false, true, fault);
				dispatchEvent(newEvent);			
			}
			else
			{
				var error:WebScriptError = new WebScriptError("Web script failed: " + this.requestedMethod + " " + this.url + " " + fault.faultString); 
				ErrorMgr.getInstance().raiseError(ErrorMgr.APPLICATION_ERROR, error);
			}
		}
		
        private function setupChannels():void
        {
            var model:AppModelLocator = AppModelLocator.getInstance();
            
            var channelSet:ChannelSet = new ChannelSet();

            var baseUrl:String = model.ecmServerConfig.protocol + "://" + model.ecmServerConfig.domain + ":" + model.ecmServerConfig.port;     

            if (model.ecmServerConfig.protocol == "http")
            {
                // setup a channel for web scripts
                var channelUrl:String = baseUrl + "/remoting/messagebroker/http";
                var channelId:String = "remoting-http";
                var channel:HTTPChannel = new HTTPChannel(channelId, channelUrl);            
                channelSet.addChannel(channel);
                
                // setup a channel for remoting to LC for directory mgr service, etc.
                var channelUrl2:String = baseUrl + "/remoting/messagebroker/amf";
                var channelId2:String = "remoting-amf";
                var channel2:AMFChannel = new AMFChannel(channelId2, channelUrl2);
                channelSet.addChannel(channel2);
            }
            else if (model.ecmServerConfig.protocol == "https")
            {   
                // setup a channel for web scripts
                var channelUrl3:String = baseUrl + "/remoting/messagebroker/httpsecure";
                var channelId3:String = "remoting-secure-http";
                var channel3:SecureHTTPChannel = new SecureHTTPChannel(channelId3, channelUrl3);            
                channelSet.addChannel(channel3);
                
                // setup a channel for remoting to LC for directory mgr service, etc.
                var channelUrl4:String = baseUrl + "/remoting/messagebroker/amfsecure";
                var channelId4:String = "remoting-secure-amf";
                var channel4:SecureAMFChannel = new SecureAMFChannel(channelId4, channelUrl4);
                channelSet.addChannel(channel4);
            }                                                                                   
            model.remotingChannelSet = channelSet;  
        }
		
	}
}