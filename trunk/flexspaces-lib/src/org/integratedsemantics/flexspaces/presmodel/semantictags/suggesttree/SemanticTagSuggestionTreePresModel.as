package org.integratedsemantics.flexspaces.presmodel.semantictags.suggesttree
{
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.SemanticTagsEvent;
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.tree.SemanticTagTreeNode;
    import org.integratedsemantics.flexspaces.model.tree.TreeNode;
   
   
    /**
     * Presentation model for view of all semantic tag categories and suggested semantic tags in a tree
     *  
     */
    [Bindable] 
    public class SemanticTagSuggestionTreePresModel extends PresModel
    {
        public var repoNode:IRepoNode;        

        public var rootNode:TreeNode;
        
        public var selectedNode:SemanticTagTreeNode = null;
        		
		        
        /**
         * Constructor 
         * 
         */
        public function SemanticTagSuggestionTreePresModel(repoNode:IRepoNode)        
        {
            super();

            this.repoNode = repoNode;  
        }
        
        /**
         * Refresh semantic tag tree with latest semantic tag data 
         * 
         */
        public function refresh(responder:Responder):void
        {
            var semanticTagsEvent:SemanticTagsEvent = new SemanticTagsEvent(SemanticTagsEvent.SUGGEST_SEMANTIC_TAGS, responder, repoNode); 
            semanticTagsEvent.dispatch();                                            
        }
                
    }   
}
