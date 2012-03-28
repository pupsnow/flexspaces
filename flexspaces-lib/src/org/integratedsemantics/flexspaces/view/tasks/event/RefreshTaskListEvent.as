package org.integratedsemantics.flexspaces.view.tasks.event
{
    import flash.events.Event;

    /**
     * Event to request refresh of task liist 
     * 
     */
    public class RefreshTaskListEvent extends Event
    {
        /** Event name */
        public static const REFRESH_TASK_LIST:String = "refreshTaskList";

        /**
         * Constructor
         *  
         * @param type event name
         * 
         */
        public function RefreshTaskListEvent(type:String)
        {
            super(type);
        }
        
    }
}