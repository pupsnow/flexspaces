package org.integratedsemantics.flexspaces.component.logout
{
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.rpc.Responder;
	
	import org.integratedsemantics.flexspaces.control.event.LogoutEvent;
	import org.integratedsemantics.flexspaces.framework.presenter.Presenter;

	
	/**	 
	 * Logout dialog presenter which displays alert box to confirm and logs the user out.
	 * 
	 * Presenter/Controller for LogoutViewBase views
	 */
	public class LogoutPresenter extends Presenter
	{
		/** Icon used in the confirmation dialog */
		protected var confirmIcon:Class;
		

		/**
		 * Constructor
		 * 
		 * @param logoutView  logout view being controlled
		 */
		public function LogoutPresenter(logoutView:LogoutViewBase):void
		{
		    super(logoutView);
		    
            logoutView.logoutBtn.addEventListener(MouseEvent.CLICK, onLogoutBtn); 
		}				
		
        /**
         * Getter for the view
         *  
         * @return view
         * 
         */
        protected function get logoutView():LogoutViewBase
        {
            return this.view as LogoutViewBase;            
        }       

		/**
		 * Handle clicking on the logout label link "button"
		 * 
		 * @param click event
		 */
		protected function onLogoutBtn(event:MouseEvent):void 
		{
			// instantiate the Alert box
			var a:Alert = Alert.show("Are you sure to Logout ?", "Confirmation", 
								      Alert.YES|Alert.NO, logoutView, doLogout,	confirmIcon, Alert.NO);
			
			// modify the look of the Alert box
			a.setStyle("backgroundColor", 0xffffff);
			a.setStyle("backgroundAlpha", 0.50);
			a.setStyle("borderColor", 0xffffff);
			a.setStyle("borderAlpha", 0.75);
			a.setStyle("color", 0x000000); // text color
		}
		
		/**
		 * Confirmation event handler that logs the current user out of the application
		 * 
		 * @param close event
		 * 
		 */
		protected function doLogout(event:CloseEvent):void 
		{
			if (event.detail == Alert.YES) 
			{
                var responder:Responder = new Responder(onResultLogout, onFaultLogout);
                var logoutEvent:LogoutEvent = new LogoutEvent(LogoutEvent.LOGOUT, responder);
                logoutEvent.dispatch();              
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
            var dispatched:Boolean = logoutView.dispatchEvent(logoutDoneEvent);                        
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
