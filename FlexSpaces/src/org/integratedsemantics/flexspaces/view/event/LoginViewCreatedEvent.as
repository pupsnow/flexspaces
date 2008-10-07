package org.integratedsemantics.flexspaces.view.event
{
    import flash.events.Event;


    /**
     *  Event to notify main view when login view has been created
     * 
     */
    public class LoginViewCreatedEvent extends Event
    {
        public static const CREATION_COMPLETE:String = "loginViewCreationComplete"
         
        public function LoginViewCreatedEvent(type:String=LoginViewCreatedEvent.CREATION_COMPLETE)
        {
            super(type);
        }
        
    }
}