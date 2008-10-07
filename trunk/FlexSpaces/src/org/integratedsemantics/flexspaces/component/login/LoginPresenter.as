package org.integratedsemantics.flexspaces.component.login
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	import mx.rpc.Responder;
	
	import org.integratedsemantics.flexspaces.control.event.LoginEvent;
	import org.integratedsemantics.flexspaces.framework.presenter.Presenter;
	
	
	/**
	 * Login form for user to login to alfresco server
	 * 
	 * Presenter/Controller of passive view LoginViewBase views
	 *  
	 */
    public class LoginPresenter extends Presenter
	{		
		/** 
		 * Constructor
		 * 
		 * @param loginView login view to control
		 * 
		 */
		public function LoginPresenter(loginView:LoginViewBase)
		{
		    super(loginView);
		    
		    if (loginView.initialized == true)
		    {
		        onCreationComplete(new Event(""));
	        }
	        else
	        {
                observeCreation(loginView, onCreationComplete);            
	        }
		}
		
        /**
         * Getter for the view
         *  
         * @return the view
         * 
         */
        protected function get loginView():LoginViewBase
        {
            return this.view as LoginViewBase;            
        }       

		/**
		 * Handle view creation complete 
		 * 
		 * @param creation complete event
		 * 
		 */
		protected function onCreationComplete(event:Event):void
		{			
			// Focus the user input box
			loginView.focusManager.setFocus(loginView.username);
			
			// add login btn and enter key handlers
            observeButtonClick(loginView.loginBtn, onLoginButton);                        
            loginView.username.addEventListener(FlexEvent.ENTER, onLoginButton);		 
            loginView.password.addEventListener(FlexEvent.ENTER, onLoginButton);         
		}
	
		/**
		 * Event handler for login button  
		 * 
		 * @param event click event or enter key event
		 */
		protected function onLoginButton(event:Event):void
		{	
			if (loginView.username.text != null && loginView.username.text.length == 0)
			{
				// Remind the user to enter a username
				showErrorMessage("Enter a user name.");
			}
			else
			{
				// Get the password assuring is it now passed as null
				var password:String = loginView.password.text;
				if (password == null)
				{
					password = "";
				}
				
                var responder:Responder = new Responder(onResultLogin, onFaultLogin);
                var loginEvent:LoginEvent = new LoginEvent(LoginEvent.LOGIN, responder, loginView.username.text, password);
                loginEvent.dispatch();				
			}
		}
		
		/**
		 * Login success result handler
		 * 
		 * @param info result
		 */
        protected function onResultLogin(info:Object):void
		{
			// Return the control to its base state
			loginView.username.text = "";
			loginView.password.text = "";
			loginView.errorMessage.text = " ";
		
            var loginDoneEvent:LoginDoneEvent = new LoginDoneEvent(LoginDoneEvent.LOGIN_DONE);
            var dispatched:Boolean = loginView.dispatchEvent(loginDoneEvent);                        
		}
		
        /**
         * Login fault handler
         * 
         * @param info result
         */
        protected function onFaultLogin(info:Object):void
        {
            trace("onFaulLogin" + info);            
            // Show the error message
            showErrorMessage(info.type);
        }
		
		/**
		 * Show error message on login form
		 *  
		 * @param message
		 * 
		 */
		protected function showErrorMessage(message:String):void
		{
			// Set the new error message
			loginView.errorMessage.text = message;			
		}
	}	
}