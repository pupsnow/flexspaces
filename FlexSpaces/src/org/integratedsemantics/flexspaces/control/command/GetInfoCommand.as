package org.integratedsemantics.flexspaces.control.command
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    import com.universalmind.cairngorm.events.Callbacks;
    
    import org.alfresco.framework.service.webscript.ConfigService;
    import org.integratedsemantics.flexspaces.control.delegate.webscript.InfoDelegate;
    import org.integratedsemantics.flexspaces.control.delegate.webscript.ValidateTicketDelegate;
    import org.integratedsemantics.flexspaces.control.event.GetInfoEvent;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.repo.RepoNode;


    /**
     * Get Info Command gets server and user info via webscript 
     * 
     */
    public class GetInfoCommand extends Command
    {
        /**
         * Constructor
         */
        public function GetInfoCommand()
        {
            super();
        }

        /**
         * Execute command for the given event
         *  
         * @param event event calling command
         * 
         */
        override public function execute(event:CairngormEvent):void
        {
            // always call the super.execute() method which allows the 
            // callBack information to be cached.
            super.execute(event);
 
            switch(event.type)
            {
                case GetInfoEvent.GET_INFO:
                    getInfo(event as GetInfoEvent);  
                    break;
            }
        } 
        
        /**
         * Get info
         * 
         * @param event get info event
         */
        public function getInfo(event:GetInfoEvent):void
        {
            
            var model : AppModelLocator = AppModelLocator.getInstance();

			if (model.ecmServerConfig.isLiveCycleContentServices == false)
			{
				// first validate ticket before getting info
	            var handlers:Callbacks = new Callbacks(onValidateTicketSuccess, onValidateTicketFault);
	            var validateDelegate:ValidateTicketDelegate = new ValidateTicketDelegate(handlers);
	            validateDelegate.validateTicket(model.userInfo.loginTicket);
            }
            else
            {
				// skip ticket check on livecycle content services
	            handlers = new Callbacks(onGetInfoSuccess, onGetInfoFault);
	            var infoDelegate:InfoDelegate = new InfoDelegate(handlers);
	            infoDelegate.getInfo();                                          				            	
            }                             
        }

        /**
         * onValidateTicketSuccess event handler
         * 
         * @param event success event
         */
        protected function onValidateTicketSuccess(event:*):void
        {
            // now do the get info
            var handlers:Callbacks = new Callbacks(onGetInfoSuccess, onGetInfoFault);
            var delegate:InfoDelegate = new InfoDelegate(handlers);
            delegate.getInfo();                                          
        }

        /**
         * onValidateTicketFault event handler
         * 
         * @param event fault event
         */
        protected function onValidateTicketFault(event:*):void
        {
            this.onFault(event);
        }    

        /**
         * onGetInfoSuccess event handler
         * 
         * @param event success event
         */
        protected function onGetInfoSuccess(event:*):void
        {
            var model : AppModelLocator = AppModelLocator.getInstance();
            
            if (event.result is XML)
            {
                var result:XML = event.result as XML;
                
                model.ecmServerConfig.urlPrefix = ConfigService.instance.url;
                
                model.ecmServerConfig.serverEdition = result.serverEdition;
                model.ecmServerConfig.serverVersion = result.serverVersion;
        
                model.userInfo.userName = result.userName;
                model.userInfo.firstName = result.firstName;
                model.userInfo.lastName = result.lastName;
        
                model.userInfo.companyHome = new RepoNode();
                model.userInfo.companyHome.nodeRef = result.companyHome.noderef;
                model.userInfo.companyHome.name = result.companyHome.name;
                model.userInfo.companyHome.path = result.companyHome.path;
                model.userInfo.companyHome.storeProtocol = result.companyHome.storeProtocol;
                model.userInfo.companyHome.storeId = result.companyHome.storeId;
                model.userInfo.companyHome.id = result.companyHome.id

                model.userInfo.userHome = new RepoNode();               
                model.userInfo.userHome.nodeRef = result.userHome.noderef;
                model.userInfo.userHome.name = result.userHome.name;
                model.userInfo.userHome.path = result.userHome.path;
                model.userInfo.userHome.storeProtocol = result.userHome.storeProtocol;
                model.userInfo.userHome.storeId = result.userHome.storeId;
                model.userInfo.userHome.id = result.userHome.id
                
                this.result(event.result);     
            }            
        }
                   
        /**
         * onGetInfoFault event handler
         * 
         * @param event fault event
         */
        protected function onGetInfoFault(event:*):void
        {
            this.onFault(event);
        }    

    }
}