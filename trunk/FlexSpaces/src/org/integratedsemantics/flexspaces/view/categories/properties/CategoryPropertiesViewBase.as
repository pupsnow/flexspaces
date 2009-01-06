package org.integratedsemantics.flexspaces.view.categories.properties
{
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.controls.Button;
    import mx.controls.List;
    import mx.events.FlexEvent;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.FormBase;
    import org.integratedsemantics.flexspaces.model.vo.CategoryVO;
    import org.integratedsemantics.flexspaces.presmodel.categories.properties.CategoryPropertiesPresModel;
    import org.integratedsemantics.flexspaces.view.categories.tree.CategoryTreeViewBase;


    /**
     * Base class for category view/edit views  
     * 
     */
    public class CategoryPropertiesViewBase extends FormBase
    {
        public var categoryList:List;
        public var removeCategoryBtn:Button;        
        
        public var categoriesTreeView:CategoryTreeViewBase;
        public var addExistingCategoryBtn:Button;

        [Bindable]
        public var categoryPropertiesPresModel:CategoryPropertiesPresModel;  
                    
        /**
         * Constructor 
         */
        public function CategoryPropertiesViewBase()
        {
            super();
        }   
        
        /**
         * Handle view creation complete by requesting name property data from server 
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:FlexEvent):void
        {
            observeButtonClick(addExistingCategoryBtn, onAddExistingCategoryBtn);
            observeButtonClick(removeCategoryBtn, onRemoveCategoryBtn);

            // get categories assigned to node  
            categoryPropertiesPresModel.getCategories();                                                             
        }
        
        /**
         * Handle add existing category buttion click
         * 
         * @param click event
         * 
         */
        protected function onAddExistingCategoryBtn(event:MouseEvent):void 
        {            
        	categoryPropertiesPresModel.addExistingCategoryFromTree();          
        }
        
        /**
         * Handle remove category buttion click
         * 
         * @param click event
         * 
         */
        protected function onRemoveCategoryBtn(event:MouseEvent):void 
        {      
	       	categoryPropertiesPresModel.removeNodeCategory();  
        }    
        
        protected function onChangeCategoryList(event:Event):void
        {
			categoryPropertiesPresModel.selectedNodeCategory = categoryList.selectedItem as CategoryVO;     		
        }
                     
    }
}