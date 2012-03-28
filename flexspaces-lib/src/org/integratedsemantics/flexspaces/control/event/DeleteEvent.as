package org.integratedsemantics.flexspaces.control.event
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;
    
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


    /**
     * Event to request deletion of an adm or avm node 
     * 
     */
    public class DeleteEvent extends UMEvent
    {
        /** Event name */
        public static const DELETE:String = "delete";
        public static const DELETE_AVM:String = "deleteAVM";

        public var repoNode:IRepoNode;


        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers handlers responder with result and fault handlers
         * @param repoNode adm node to delete
         * 
         */
        public function DeleteEvent(eventType:String, handlers:IResponder, repoNode:IRepoNode)
        {
            super(eventType, handlers);
            
            this.repoNode = repoNode;
        }       
        
    }
}