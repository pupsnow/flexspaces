package org.integratedsemantics.flexspaces.control.event
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;
    
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


    /**
     * Event to request creation of an adm/avm space/folder or to request a list space templates  
     * 
     */
    public class FolderEvent extends UMEvent
    {
        /** Event name */
        public static const CREATE_SPACE:String = "createSpace";
        public static const SPACE_TEMPLATES:String = "spaceTemplates";
        public static const CREATE_AVM_FOLDER:String = "createAvmFolder";

        public var parentNode:IRepoNode; 
        public var newName:String; 
        public var newTitle:String;
        public var newDesc:String; 
        public var templateNode:IRepoNode; 
        public var iconName:String;


        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers handlers responder with result and fault handlers
         * @param parentNode adm folder to create new folder in
         * @param newName name for new space/folder
         * @param newTitle title for new space/folder
         * @param newDesc description for new space/folder
         * @param templateNode space template, if any, to use to create new space from
         * @param iconName symbolic icon name to use for folder, will use space-icon-default if null
         * 
         */
        public function FolderEvent(eventType:String, handlers:IResponder, parentNode:IRepoNode=null, newName:String=null, newTitle:String=null,
                                    newDesc:String=null, templateNode:IRepoNode=null, iconName:String=null)
        {
            super(eventType, handlers);
            
            this.parentNode = parentNode;
            this.newName = newName;
            this.newTitle = newTitle;
            this.newDesc = newDesc;
            this.templateNode = templateNode;
            this.iconName = iconName;
        }       
        
    }
}