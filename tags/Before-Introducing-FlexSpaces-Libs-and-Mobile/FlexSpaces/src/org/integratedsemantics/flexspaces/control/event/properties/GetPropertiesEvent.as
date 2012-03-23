package org.integratedsemantics.flexspaces.control.event.properties
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;

    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;

    
    /**
     * Event to request getting the properties for a adm or avm node
     * 
     */
    public class GetPropertiesEvent extends UMEvent
    {
        public static const GET_PROPERTIES:String = "getProperties";
        public static const GET_AVM_PROPERTIES:String = "getAvmProperties";
        
        public var repoNode:IRepoNode;
        
        
        /**
         * Constructor
         * 
         * @param eventType event name
         * @param handlers responder with result and fault handlers
         * @param repoNode node to get properties from
         */
        public function GetPropertiesEvent(eventType:String, handlers:IResponder, repoNode:IRepoNode)
        {
            super(eventType, handlers);
            this.repoNode = repoNode;
        }        

    }
}

