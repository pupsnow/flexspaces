package org.integratedsemantics.flexspaces.view.login
{
	import flash.events.Event;
	
	import mx.containers.VBox;
	import mx.controls.Button;
	import mx.controls.Text;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	import mx.rpc.Responder;
	
	import org.integratedsemantics.flexspaces.presmodel.login.LoginPresModel;
	import org.integratedsemantics.flexspaces.util.ObserveUtil;
    
        
    /**
     * Base class for login views  
     * 
     */
    public class LoginViewBase  extends VBox
    {
        public var errorMessage:Text;
        public var username:TextInput;
        public var password:TextInput;
        public var loginBtn:Button;
        
        [Bindable]
        public var loginPresModel:LoginPresModel;
                

        /**
         * Constructor 
         */
        public function LoginViewBase()
        {
            super();            
        }   
            
		/**
		 * Handle view creation complete 
		 * 
		 * @param creation complete event
		 * 
		 */
		protected function onCreationComplete(event:Event):void
		{			
			username.text = loginPresModel.userName;
			password.text = loginPresModel.password;
			
			// Focus the user input box
			focusManager.setFocus(username);
			
			// add login btn and enter key handlers
            ObserveUtil.observeButtonClick(loginBtn, onLoginButton);                        
            username.addEventListener(FlexEvent.ENTER, onLoginButton);		 
            password.addEventListener(FlexEvent.ENTER, onLoginButton);         
		}
            
		/**
		 * Event handler for login button  
		 * 
		 * @param event click event or enter key event
		 */
		protected function onLoginButton(event:Event):void
		{	
			if (username.text != null && username.text.length == 0)
			{
				// Remind the user to enter a username
				// todo: i18n
				showErrorMessage("Enter a user name.");
			}
			else
			{
                var responder:Responder = new Responder(onResultLogin, onFaultLogin);
				loginPresModel.login(responder);
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
			username.text = "";
			password.text = "";
			errorMessage.text = " ";
		
            var loginDoneEvent:LoginDoneEvent = new LoginDoneEvent(LoginDoneEvent.LOGIN_DONE);
            var dispatched:Boolean = dispatchEvent(loginDoneEvent);                        
		}
		
        /**
         * Login fault handler
         * 
         * @param info result
         */
        protected function onFaultLogin(info:Object):void
        {
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
			errorMessage.text = message;			
		}
            
    }
}