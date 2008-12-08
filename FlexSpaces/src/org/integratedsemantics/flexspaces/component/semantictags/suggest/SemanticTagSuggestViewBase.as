package org.integratedsemantics.flexspaces.component.semantictags.suggest
{
    import mx.collections.XMLListCollection;
    import mx.controls.Button;
    import mx.controls.List;
    
    import org.integratedsemantics.flexspaces.component.semantictags.suggesttree.SemanticTagSuggestionTreeViewBase;
    import org.integratedsemantics.flexspaces.framework.dialog.DialogViewBase;


    /**
     * Base class for semantic tag suggestions views  
     * 
     */
    public class SemanticTagSuggestViewBase extends DialogViewBase
    {
        [Bindable] public var categories:XMLListCollection;   

        public var categoryList:List;
        public var removeCategoryBtn:Button;        
        
        public var semanticTagTreeView:SemanticTagSuggestionTreeViewBase;
        public var addExistingCategoryBtn:Button;
                
              
        /**
         * Constructor 
         */
        public function SemanticTagSuggestViewBase()
        {
            super();
        }        
    }
}