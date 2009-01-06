package org.integratedsemantics.flexspaces.presmodel.login
{
	import mx.rpc.Responder;
	
	import org.integratedsemantics.flexspaces.control.event.LoginEvent;
	import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
	import org.integratedsemantics.flexspaces.model.AppModelLocator;
	
	
	/**
	 * Login form presentaton model for user to login to alfresco server
	 * 
	 */
	[Bindable] 
    public class LoginPresModel extends PresModel
	{		
		public var model : AppModelLocator = AppModelLocator.getInstance();                            

        public var errorMessage:String;
        public var userName:String;
        public var password:String;


		/** 
		 * Constructor
		 * 
		 */
		public function LoginPresModel()
		{
		    super();
		    
			if (model.ecmServerConfig.isLiveCycleContentServices == true)
			{
			    userName = "administrator";
			    password = "password"; 
			}
			else
			{
				userName = "admin";
				password = "admin";
			}		    		    
		}
			
		/**
		 * Login to alfresco
		 *  
		 * @param userName user name
		 * @param password password
		 * 
		 */
		public function login(responder:Responder):void
		{	
            var loginEvent:LoginEvent = new LoginEvent(LoginEvent.LOGIN, responder, userName, password);
            loginEvent.dispatch();				
		}

        public function updateUserName(user:String):void
        {
        	this.userName = user;	
        }
		
        public function updatePassword(pwd:String):void
        {
        	this.password = pwd;	
        }
	}	
}