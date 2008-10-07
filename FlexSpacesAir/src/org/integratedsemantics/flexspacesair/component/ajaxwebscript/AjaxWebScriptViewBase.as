package org.integratedsemantics.flexspacesair.component.ajaxwebscript
{
    import mx.containers.HDividedBox;
    import mx.controls.HTML;
    

    /**
     * Base class for ajax webscript views  
     * 
     */
    public class AjaxWebScriptViewBase extends HDividedBox
    {
        public var html1:HTML;
        public var html2:HTML;
        
        /**
         * Constructor 
         */
        public function AjaxWebScriptViewBase()
        {
            super();
        }        
    }
}