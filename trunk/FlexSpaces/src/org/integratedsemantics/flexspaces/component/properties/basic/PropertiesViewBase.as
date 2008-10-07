package org.integratedsemantics.flexspaces.component.properties.basic
{
    import mx.containers.FormItem;
    import mx.controls.List;
    import mx.controls.Text;
    import mx.controls.TextInput;
    
    import org.integratedsemantics.flexspaces.framework.dialog.DialogViewBase;


    /**
     * Base class for properties views  
     * 
     */
    public class PropertiesViewBase extends DialogViewBase
    {
        public var nameItem:FormItem;
        public var nodename:TextInput;
        public var titleItem:FormItem;
        public var nodetitle:TextInput;        
        public var descriptionItem:FormItem;
        public var description:TextInput;
        public var authorItem:FormItem;
        public var author:TextInput;

        public var sizeItem:FormItem;
        public var size:Text;

        public var creatorItem:FormItem;
        public var creator:Text;
        public var createdItem:FormItem;
        public var created:Text;
        public var modifierItem:FormItem;
        public var modifier:Text;
        public var modifiedItem:FormItem;
        public var modified:Text;

        public var mimetypeItem:FormItem;
        public var mimetype:Text;
        public var encodingItem:FormItem;
        public var encoding:Text;
        public var emailidItem:FormItem;
        public var emailid:Text;
        
        public var editinlineItem:FormItem;
        public var editinline:Text;

        /**
         * Constructor 
         */
        public function PropertiesViewBase()
        {
            super();
        }        
    }
}