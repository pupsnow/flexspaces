package org.integratedsemantics.flexspaces.control.event
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;
    
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


	/**
	 * Event to request copying or moving a node to a folder
	 */
	public class CopyMoveEvent extends UMEvent
	{
		/** Event names */
		
		// adm to adm
		public static const COPY:String = "admCopy";
        public static const MOVE:String = "admMove";

        // avm to avm
        public static const AVM_COPY:String = "avmCopy";
        public static const AVM_MOVE:String = "avmMove";

        // adm to avm
        public static const ADM_TO_AVM_COPY:String = "admToAvmCopy";

        // avm to adm
        public static const AVM_TO_ADM_COPY:String = "avmToAdmCopy";

        public var sourceNode:IRepoNode;
        public var targetFolderNode:IRepoNode;
        		
        		
        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers handlers responder with result and fault handlers
         * @param sourceNode source node
         * @param targetFolderNode target folder
         * 
         */
        public function CopyMoveEvent(eventType:String, handlers:IResponder, sourceNode:IRepoNode, targetFolderNode:IRepoNode)
        {
            super(eventType, handlers);
            
            this.sourceNode = sourceNode;

            this.targetFolderNode = targetFolderNode;
        }       
		
	}
}