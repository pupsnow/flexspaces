package org.integratedsemantics.sampleapp.control
{
    
    import org.integratedsemantics.flexspaces.control.AppController;


    /**
     * 
     */
    public class SampleAppController extends AppController
    {
        /**
         * Constructor 
         * 
         */
        public function SampleAppController()
        {
            super();
        }
        
        /**
         * Register each cairngorm event with command 
         * 
         */
        override protected function registerAllCommands():void
        {
            super.registerAllCommands();
            
            // register additional alfresco server commands

            // register additional UI commands     

        }
        
    }
}