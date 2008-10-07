package org.integratedsemantics.flexspacesair.component.create.xml
{
    import mx.controls.TextArea;
    import mx.controls.TextInput;
    
    import org.integratedsemantics.flexspaces.framework.dialog.DialogViewBase;


    /**
     * Base class for create xml views  
     * 
     */
    public class CreateXmlViewBase extends DialogViewBase
    {
        public var nodename:TextInput;
        public var textarea:TextArea;
        
        
        /**
         * Constructor 
         */
        public function CreateXmlViewBase()
        {
            super();
        }        
    }
}