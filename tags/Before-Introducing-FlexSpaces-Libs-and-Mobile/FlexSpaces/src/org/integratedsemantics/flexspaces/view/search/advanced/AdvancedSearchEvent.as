package org.integratedsemantics.flexspaces.view.search.advanced
{
    import flash.events.Event;

    /**
     * Event to request the display of advanced search dialog 
     * 
     */
    public class AdvancedSearchEvent extends Event
    {
        /** Event name */
        public static const ADVANCED_SEARCH_REQUEST:String = "advancedSearchRequested";


        /**
         * Constructor
         * 
         * @param type event name
         * 
         */
        public function AdvancedSearchEvent(type:String)
        {
            super(type, bubbles, cancelable);
        }
        
    }
}