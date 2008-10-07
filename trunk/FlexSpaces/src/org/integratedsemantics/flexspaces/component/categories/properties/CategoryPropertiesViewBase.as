package org.integratedsemantics.flexspaces.component.categories.properties
{
    import mx.collections.XMLListCollection;
    import mx.containers.Form;
    import mx.controls.Button;
    import mx.controls.List;
    
    import org.integratedsemantics.flexspaces.component.categories.tree.CategoryTreeViewBase;


    /**
     * Base class for tags view/edit views  
     * 
     */
    public class CategoryPropertiesViewBase extends Form
    {
        [Bindable] public var categories:XMLListCollection;   

        public var categoryList:List;
        public var removeCategoryBtn:Button;        
        
        public var categoriesTreeView:CategoryTreeViewBase;
        public var addExistingCategoryBtn:Button;
              
        /**
         * Constructor 
         */
        public function CategoryPropertiesViewBase()
        {
            super();
        }        
    }
}