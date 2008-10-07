package org.integratedsemantics.flexspaces.view.event
{
    import flash.events.Event;


    /**
     *  Event to notify main view when repository subview has been created
     *  after login
     * 
     */
    public class RepoBrowserCreatedEvent extends Event
    {
        public static const CREATION_COMPLETE:String = "repoBrowserCreationComplete"
         
        public function RepoBrowserCreatedEvent(type:String=RepoBrowserCreatedEvent.CREATION_COMPLETE)
        {
            super(type);
        }
        
    }
}