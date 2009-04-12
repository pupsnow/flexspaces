package org.integratedsemantics.flexspaces.model.tree
{
    import mx.collections.ArrayCollection;
    
    import org.integratedsemantics.flexspaces.model.folder.Node;


    /**
     *  Tree node model for ADM and base class for AVM tree node model 
     *  Used in tree view
     */
    [Bindable] 
    public class TreeNode extends Node
    {
        public var label:String;
        
        public var hasBeenLoaded:Boolean;
        
        public var children:ArrayCollection;
                       
        public function TreeNode(newLabel:String, newId:String)
        {
            super();
            this.label = newLabel;
            this.id = newId;
            this.path = "";
            this.hasBeenLoaded = false;
            this.children = new ArrayCollection();
        }        

    }   

}
