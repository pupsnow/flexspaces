 package org.integratedsemantics.flexspaces.control.error
{
	import flash.events.Event;

	public class ErrorRaisedEvent extends Event
	{
		public static const ERROR_RAISED:String = "errorRaised";
	
		private var error:Error;
		
		private var errorType:String;
		
		public function ErrorRaisedEvent(type:String, errorType:String, error:Error, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.error = error;
			this.errorType = errorType;
		}
		
		public function getError():Error
		{
			return this.error;
		}
		
		public function getErrorType():String
		{
			return this.errorType;	
		}
		
	}
}