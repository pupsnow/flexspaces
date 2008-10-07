package org.integratedsemantics.flexspaces.control.event
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;
    
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


    /**
     * Event to request making a pdf version of a document 
     * 
     */
    public class MakePdfEvent extends UMEvent
    {
        /** Event name */
        public static const MAKE_PDF:String = "makePdf";

        public var repoNode:IRepoNode;
        

        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers handlers responder with result and fault handlers
         * @param repoNode node to transform
         * 
         */
        public function MakePdfEvent(eventType:String, handlers:IResponder, repoNode:IRepoNode)
        {
            super(eventType, handlers);
            
            this.repoNode = repoNode;
        }       
        
    }
}