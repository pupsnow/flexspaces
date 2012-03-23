package org.integratedsemantics.flexspaces.control.event.properties
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;

    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


    /**
     * Event to request setting the properties on a adm or avm node
     * 
     */
    public class SetPropertiesEvent extends UMEvent
    {
        public static const SET_PROPERTIES:String = "setProperties";
        public static const SET_AVM_PROPERTIES:String = "setAvmProperties";
        
        public var repoNode:IRepoNode;

        public var name:String;
        public var title:String;
        public var description:String;
        public var author:String;


        /**
         * Constructor
         * 
         * @param eventType event name
         * @param handlers responder with result and fault handlers
         * @param repoNode node to set properties on
         * @param name value for name propetry
         * @param title value for title property
         * @param description value for description property
         * @param author value for author property 
         * 
         */
        public function SetPropertiesEvent(eventType:String, handlers:IResponder, repoNode:IRepoNode, name:String = null, title:String = null, 
                                           description:String = null, author:String = null)
        {
            super(eventType, handlers);
            
            this.repoNode = repoNode;

            this.name = name;
            this.title = title;
            this.description = description;
            this.author = author;
        }
        
    }
}