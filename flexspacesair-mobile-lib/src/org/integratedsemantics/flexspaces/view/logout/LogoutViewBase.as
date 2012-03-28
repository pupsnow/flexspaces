package org.integratedsemantics.flexspaces.view.logout
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.controls.LinkButton;
	import mx.events.CloseEvent;
	import mx.rpc.Responder;
	
	import org.integratedsemantics.flexspaces.presmodel.logout.LogoutPresModel;
	
	import spark.components.VGroup;
    
        
    /**
     * Base class for logout views  
     * 
     */
    public class LogoutViewBase extends VGroup
    {
        public var logoutBtn:LinkButton;

		/** Icon used in the confirmation dialog */
		protected var confirmIcon:Class;
		               
        [Bindable]
        public var logoutPresModel:LogoutPresModel;

                
        /**
         * Constructor 
         */
        public function LogoutViewBase()
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
            logoutBtn.addEventListener(MouseEvent.CLICK, onLogoutBtn); 					
  		} 
  		
		/**
		 * Handle clicking on the logout label link "button"
		 * 
		 * @param click event
		 */
		protected function onLogoutBtn(event:MouseEvent):void 
		{
			// instantiate the Alert box
			// todo i18n
			var a:Alert = Alert.show("Are you sure to Logout ?", "Confirmation", 
								      Alert.YES|Alert.NO, null, logout,	confirmIcon, Alert.NO);
			
		}
		
		/**
		 * Confirmation event handler that logs the current user out of the application
		 * 
		 * @param close event
		 * 
		 */
		public function logout(event:CloseEvent):void 
		{
			if (event.detail == Alert.YES) 
			{
                var responder:Responder = new Responder(onResultLogout, onFaultLogout);
                logoutPresModel.logout(responder);             
			}
		}
		
        /**
         * Logout success result handler
         * 
         * @param info result info
         */
        protected function onResultLogout(info:Object):void
        {
            var logoutDoneEvent:LogoutDoneEvent = new LogoutDoneEvent(LogoutDoneEvent.LOGOUT_DONE);
            var dispatched:Boolean = dispatchEvent(logoutDoneEvent);    
        }
        
        /**
         * Logout fault handler
         * 
         * @param info fault info
         */
        protected function onFaultLogout(info:Object):void
        {
            trace("onFaultLogout" + info);            
        }		
  		 
    }
}