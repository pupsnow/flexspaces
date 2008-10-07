package org.integratedsemantics.flexspacesair.control
{
    import org.integratedsemantics.flexspaces.control.AppController;
    import org.integratedsemantics.flexspacesair.control.command.*;
    import org.integratedsemantics.flexspacesair.control.event.*;


    /**
     * FlexSpacesAir Cairngorm / UM front controller
     *  
     * Handles routing cairngorm events to call registered command
     * 
     */
    public class AirAppController extends AppController
    {
        /**
         * Constructor 
         * 
         */
        public function AirAppController()
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
            
            addCommand(AirClipboardUIEvent.AIR_CLIPBOARD_CUT, AirClipboardUICommand);
            addCommand(AirClipboardUIEvent.AIR_CLIPBOARD_COPY, AirClipboardUICommand);
            addCommand(AirClipboardUIEvent.AIR_CLIPBOARD_PASTE, AirClipboardUICommand);
            
            addCommand(AirViewNodeUIEvent.AIR_VIEW_NODE, AirViewNodeUICommand);
            
            addCommand(AirMakeAvailOfflineUIEvent.AIR_MAKE_AVAIL_OFFLINE, AirMakeAvailOfflineUICommand);

            addCommand(AirOfflineUploadUIEvent.AIR_OFFLINE_UPLOAD, AirOfflineUploadUICommand);
        }
        
    }
}