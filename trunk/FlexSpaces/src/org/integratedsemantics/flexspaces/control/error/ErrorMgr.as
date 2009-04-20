 package org.integratedsemantics.flexspaces.control.error
{
	import flash.events.EventDispatcher;
	
	public class ErrorMgr extends EventDispatcher
	{
		public static const APPLICATION_ERROR:String = "ApplicationError";
		
		private static var instance:ErrorMgr;
		
		public static function getInstance():ErrorMgr
		{
			if (ErrorMgr.instance == null)
			{
				ErrorMgr.instance = new ErrorMgr();
			}			
			return ErrorMgr.instance;
		}
		
		public function raiseError(errorType:String, error:Error):void
		{
			this.dispatchEvent(new ErrorRaisedEvent(ErrorRaisedEvent.ERROR_RAISED, errorType, error));
		}
	}
}