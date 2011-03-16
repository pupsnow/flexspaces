package org.integratedsemantics.flexspaces.model.wcm.tree
{
    import org.integratedsemantics.flexspaces.model.tree.TreeNode;


    /**
     * AVM / WCM tree node  model used in WCM Tree
     * 
     * 
     */
    [Bindable] 
    public class WcmTreeNode extends TreeNode
    {        
        /**
         * Constructor 
         * @param storeId  avm store id
         * @param newLabel label for display
         * @param newId    node id
         * 
         */
        public function WcmTreeNode(storeId:String, newLabel:String, newId:String)
        {
            super(newLabel, newId);
            this.storeId = storeId;
        }        

    }   

}
