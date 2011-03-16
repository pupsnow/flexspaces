package org.integratedsemantics.flexspaces.presmodel.logout
{
	import mx.core.Application;
	import mx.rpc.Responder;
	
	import org.integratedsemantics.flexspaces.control.event.LogoutEvent;
	import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
	import org.integratedsemantics.flexspaces.view.logout.LogoutDoneEvent;

	
	/**	 
	 * Logout dialog presentation model which displays alert box to confirm and logs the user out.
	 * 
	 */
	[Bindable] 
	public class LogoutPresModel extends PresModel
	{
		/**
		 * Constructor
		 * 
		 */
		public function LogoutPresModel():void
		{
		    super();
		    
		}				
				
		/**
		 *  log the current user out
		 * 
		 * @param responder responder
		 * 
		 */
		public function logout(responder:Responder):void 
		{
            var logoutEvent:LogoutEvent = new LogoutEvent(LogoutEvent.LOGOUT, responder);
            logoutEvent.dispatch();              
		}
								
	}
}
