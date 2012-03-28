package org.integratedsemantics.flexspaces.view.playvideo
{
    import flash.events.Event;
    
    import org.integratedsemantics.flexspaces.presmodel.playvideo.PlayVideoPresModel;
    
    import spark.components.Button;
    import spark.components.VGroup;
    import spark.components.VideoPlayer;
    
        
    /**
     * Base class for play video views  
     * 
     */
    public class PlayVideoViewBase extends VGroup
    {
        public var playBtn:Button;
        public var pauseBtn:Button;
        public var stopBtn:Button;
        
        public var videoDisplay:spark.components.VideoPlayer;
        
        [Bindable]
        public var playVideoPresModel:PlayVideoPresModel;
                
        
        /**
         * Constructor 
         * 
         */
        public function PlayVideoViewBase()
        {
            super();
        }        
        
        /**
         * Handle initialization after view has its creation complete
         *  
         * @param event create complete event
         * 
         */
        protected function onCreationComplete(event:Event):void
        {
            videoDisplay.source = playVideoPresModel.url;  
        }                 
        
    }
}