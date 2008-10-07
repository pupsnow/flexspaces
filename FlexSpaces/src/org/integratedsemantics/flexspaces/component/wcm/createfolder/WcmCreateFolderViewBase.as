package org.integratedsemantics.flexspaces.component.wcm.createfolder
{
    import mx.containers.FormItem;
    import mx.controls.TextInput;
    
    import org.integratedsemantics.flexspaces.framework.dialog.DialogViewBase;


    /**
     * Base class for wcm create folder views  
     * 
     */
    public class WcmCreateFolderViewBase extends DialogViewBase
    {
        public var nameItem:FormItem;
        public var foldername:TextInput;
        
        public var titleItem:FormItem;
        public var nodetitle:TextInput;

        public var descriptionItem:FormItem;
        public var description:TextInput;


        /**
         * Constructor 
         */
        public function WcmCreateFolderViewBase()
        {
            super();
        }        
    }
}