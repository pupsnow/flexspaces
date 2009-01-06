package org.integratedsemantics.flexspaces.control.command
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    import com.universalmind.cairngorm.events.Callbacks;
    
    import org.alfresco.framework.service.webscript.ConfigService;
    import org.integratedsemantics.flexspaces.control.delegate.webscript.LoginDelegate;
    import org.integratedsemantics.flexspaces.control.event.LoginEvent;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;


    /**
     * Login Command provides the operation to login a user to alfresco 
     * 
     */
    public class LoginCommand extends Command
    {
        /**
         * Constructor
         */
        public function LoginCommand()
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
                case LoginEvent.LOGIN:
                    login(event as LoginEvent);  
                    break;
            }
        } 
        
        /**
         * Perform Login
         * 
         * @param event login event
         */
        public function login(event:LoginEvent):void
        {
            var model : AppModelLocator = AppModelLocator.getInstance();
            
            model.ecmServerConfig.urlPrefix = ConfigService.instance.url;

            model.userInfo.loginUserName = event.userName;
            model.userInfo.loginPassword = event.password;
            
            var handlers:Callbacks = new Callbacks(onLoginSuccess, onLoginFault);
            var delegate:LoginDelegate = new LoginDelegate(handlers);
            delegate.login(event.userName, event.password);                  
        }

        /**
         * onLoginSuccess event handler
         * 
         * @param event success event
         */
        protected function onLoginSuccess(event:*):void
        {
            var model : AppModelLocator = AppModelLocator.getInstance();
                             
            if (model.ecmServerConfig.isLiveCycleContentServices == true)
            {               
				var result:String = event.result;
				var start:int = result.indexOf("<Assertion");
				var end:int = result.indexOf("</ticket>");
				var ticket:String = result.substring(start, end);   
	            model.userInfo.loginTicket = ticket;         
            }
            else
            {
				model.userInfo.loginTicket = event.result;            	
            }
            
            this.result(model.userInfo.loginTicket);            
        }               
        
        /**
         * onLoginFault event handler
         * 
         * @param event fault event
         */
        protected function onLoginFault(event:*):void
        {
            this.onFault(event);
        }    
        
    }
}