package org.integratedsemantics.flexspaces.view.login
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	import mx.rpc.Responder;
	
	import org.integratedsemantics.flexspaces.presmodel.login.LoginPresModel;
	import org.integratedsemantics.flexspaces.presmodel.preferences.PreferencesPresModel;
	import org.integratedsemantics.flexspaces.util.ObserveUtil;
	import org.integratedsemantics.flexspaces.view.preferences.PreferencesView;
	
	import spark.components.BorderContainer;
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.TextInput;
    
        
    /**
     * Base class for login views  
     * 
     */
    public class LoginViewBase extends BorderContainer
    {
        public var errorMessage:Label;
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
		    loginPresModel.init();	
			username.text = loginPresModel.userName;
			password.text = loginPresModel.password;
			
			// Focus the user input box
			focusManager.setFocus(username);
			
			// add login btn and enter key handlers
            ObserveUtil.observeButtonClick(loginBtn, onLoginButton);                        
            username.addEventListener(FlexEvent.ENTER, onLoginButton);		 
            password.addEventListener(FlexEvent.ENTER, onLoginButton);  
            
            if (loginPresModel.autoLogin == true)
            {
                login();                
            }       
		}
            
		/**
		 * Event handler for login button  
		 * 
		 * @param event click event or enter key event
		 */
		protected function onLoginButton(event:Event):void
		{
		    login();	
		}
		
		protected function login():void
		{
            if (username.text != null && username.text.length == 0)
            {
                // todo: i18n
                showErrorMessage("Enter a user name.");
            }
            else if (password.text != null && password.text.length == 0)
            {
                // todo: i18n
                showErrorMessage("Enter a password.");
            }
            else
            {
                CursorManager.setBusyCursor();
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
            CursorManager.removeBusyCursor();

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
            CursorManager.removeBusyCursor();

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
            
        protected function onPreferences():void
        {
            var preferencesView:PreferencesView = PreferencesView(PopUpManager.createPopUp(this, PreferencesView, false));
            var preferencesPresModel:PreferencesPresModel = new PreferencesPresModel();
            preferencesView.preferencesPresModel = preferencesPresModel;
        }
            
    }
}