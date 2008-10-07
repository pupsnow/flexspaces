package org.integratedsemantics.flexspaces.component.rename
{
    import mx.containers.FormItem;
    import mx.controls.TextInput;
    
    import org.integratedsemantics.flexspaces.framework.dialog.DialogViewBase;


    /**
     * Base class for rename views  
     * 
     */
    public class RenameViewBase extends DialogViewBase
    {
        public var nameItem:FormItem;
        public var nodename:TextInput;
        
        /**
         * Constructor 
         */
        public function RenameViewBase()
        {
            super();
        }        
    }
}