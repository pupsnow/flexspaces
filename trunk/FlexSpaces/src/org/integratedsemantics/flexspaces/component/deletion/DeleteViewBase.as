package org.integratedsemantics.flexspaces.component.deletion
{   
    import mx.controls.Text;
    
    import org.integratedsemantics.flexspaces.framework.dialog.DialogViewBase;


    /**
     * Base class for delete views  
     * 
     */
    public class DeleteViewBase extends DialogViewBase
    {
        public var filelist:Text;
        
        /**
         * Constructor 
         */
        public function DeleteViewBase()
        {
            super();
        }        
    }
}