package org.integratedsemantics.flexspaces.framework.dialog
{
    import mx.containers.TitleWindow;
    import mx.controls.Button;


    /**
     * Base View class for dialog views 
     * 
     */
    public class DialogViewBase extends TitleWindow
    {
        public var okBtn:Button;
        public var cancelBtn:Button;
        public var closeBtn:Button;
        
        /**
         * Constructor 
         */
        public function DialogViewBase()
        {
            super();
        }
        
    }
}