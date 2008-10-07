package org.integratedsemantics.flexspaces.component.preview
{
    import mx.containers.Panel;
    import mx.containers.VBox;
    import mx.controls.Button;
    import mx.controls.HSlider;
    import mx.controls.LinkButton;
    import mx.controls.SWFLoader;
    
        
    /**
     * Base class for preview views  
     * 
     */
    public class PreviewViewBase extends VBox
    {
        public var printBtn:LinkButton;
        
        public var zoomSlider:HSlider;
        
        public var previousPageBtn:Button
        public var nextPageBtn:Button;
        
        public var zoomOutButton:Button
        public var zoomInButton:Button;
        
        public var contentPanel:Panel;
        public var swfLoader:SWFLoader;
        
        
        /**
         * Constructor 
         */
        public function PreviewViewBase()
        {
            super();
        }        
    }
}