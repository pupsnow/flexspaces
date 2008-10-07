package org.integratedsemantics.flexspacesair.component.create.text
{
    import mx.controls.TextArea;
    import mx.controls.TextInput;
    
    import org.integratedsemantics.flexspaces.framework.dialog.DialogViewBase;


    /**
     * Base class for create text views  
     * 
     */
    public class CreateTextViewBase extends DialogViewBase
    {
        public var nodename:TextInput;
        public var textarea:TextArea;
        
        
        /**
         * Constructor 
         */
        public function CreateTextViewBase()
        {
            super();
        }        
    }
}