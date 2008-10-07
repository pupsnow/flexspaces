package org.integratedsemantics.flexspaces.component.playvideo
{
    import mx.containers.Panel;
    import mx.containers.VBox;
    import mx.controls.Button;
    import mx.controls.VideoDisplay;
    
        
    /**
     * Base class for play video views  
     * 
     */
    public class PlayVideoViewBase extends VBox
    {
        public var playBtn:Button
        public var pauseBtn:Button
        public var stopBtn:Button
        
        public var contentPanel:Panel;
        public var videoDisplay:VideoDisplay;
        
        
        /**
         * Constructor 
         */
        public function PlayVideoViewBase()
        {
            super();
        }        
    }
}