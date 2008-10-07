package org.integratedsemantics.flexspacesair.component.create.html
{
    import mx.controls.HTML;
    import mx.controls.TextInput;
    
    import org.integratedsemantics.flexspaces.framework.dialog.DialogViewBase;


    /**
     * Base class for create html views  
     * 
     */
    public class CreateHtmlViewBase extends DialogViewBase
    {
        public var nodename:TextInput;
        public var htmlControl:HTML;
        
        /**
         * Constructor 
         */
        public function CreateHtmlViewBase()
        {
            super();
        }        
    }
}