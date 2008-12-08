package org.integratedsemantics.flexspaces.component.semantictags.properties
{
    import mx.collections.XMLListCollection;
    import mx.containers.Form;
    import mx.controls.Button;
    import mx.controls.List;
    
    import org.integratedsemantics.flexspaces.component.semantictags.tree.SemanticTagTreeViewBase;


    /**
     * Base class for semantic tags view/edit views  
     * 
     */
    public class SemanticTagPropertiesViewBase extends Form
    {
        [Bindable] public var categories:XMLListCollection;   

        public var categoryList:List;
        public var removeCategoryBtn:Button;        
        
        public var semanticTagTreeView:SemanticTagTreeViewBase;
        public var addExistingCategoryBtn:Button;
              
        /**
         * Constructor 
         */
        public function SemanticTagPropertiesViewBase()
        {
            super();
        }        
    }
}