package org.integratedsemantics.flexspaces.component.categories.properties
{
    import flash.events.MouseEvent;
    
    import mx.collections.XMLListCollection;
    import mx.events.FlexEvent;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.component.categories.tree.CategoryTreePresenter;
    import org.integratedsemantics.flexspaces.control.event.CategoriesEvent;
    import org.integratedsemantics.flexspaces.framework.presenter.Presenter;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.repo.RepoNode;

    
    /**
     *  Presenter for Categories properties panel for viewing/editing category properties
     *  on a doc/folder
     *  
     *  Presenter/Controller of CategoryPropertiesViewBase views  
     * 
     */
    public class CategoryPropertiesPresenter extends Presenter
    {
        protected var repoNode:IRepoNode;        
        protected var categoryTreePresenter:CategoryTreePresenter;

               
        /**
         * Constructor 
         * 
         * @param categoriesView  view for to control
         * @param repoNode  node to view/edit category properties on
         * 
         */
        public function CategoryPropertiesPresenter(categoriesView:CategoryPropertiesViewBase, repoNode:IRepoNode)
        {
            super(categoriesView);
            
            this.repoNode = repoNode;  

            if (categoriesView.initialized == true)
            {
                onCreationComplete(new FlexEvent(""));
            }
            else
            {
                observeCreation(categoriesView, onCreationComplete);            
            }                                      
        }
        
        /**
         * Getter for the view
         *  
         * @return this view
         * 
         */
        protected function get categoriesView():CategoryPropertiesViewBase
        {
            return this.view as CategoryPropertiesViewBase;            
        }       

        /**
         * Handle view creation complete by requesting name property data from server 
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:FlexEvent):void
        {
            categoryTreePresenter = new CategoryTreePresenter(categoriesView.categoriesTreeView);    
                      
            observeButtonClick(categoriesView.addExistingCategoryBtn, onAddExistingCategoryBtn);
            observeButtonClick(categoriesView.removeCategoryBtn, onRemoveCategoryBtn);

            // get categories assigned to node                                                    
            var categoriesResponder:Responder = new Responder(onResultGetCategories, onFaultGetCategories);
            var categoriesEvent:CategoriesEvent = new CategoriesEvent(CategoriesEvent.GET_CATEGORY_PROPERTIES, categoriesResponder, repoNode); 
            categoriesEvent.dispatch();      
            
            // disable add/remove btns if don't have write permission 
            var node:Node = repoNode as Node;
            if (node.writePermission == false)
            {
                categoriesView.addExistingCategoryBtn.enabled = false;
                categoriesView.addExistingCategoryBtn.visible = false;
                categoriesView.removeCategoryBtn.enabled = false;
                categoriesView.removeCategoryBtn.visible = false;
            }                                                               
        }
               
        /**
         * Handler called when get categories service successfully completed
         * 
         * @param data category data returned
         */
        protected function onResultGetCategories(data:Object):void
        {
            var categoryCollection:XMLListCollection = new XMLListCollection(data.categories.category); 
            categoriesView.categories = categoryCollection;
        }        
        
        /**
         * Handler called when server get categories returns fault
         *  
         * @param info fault info
         * 
         */
        protected function onFaultGetCategories(info:Object):void
        {
            trace("onFaultGetCategories" + info);            
        }   
        
        /**
         * Handle add existing category buttion click
         * 
         * @param click event
         * 
         */
        protected function onAddExistingCategoryBtn(event:MouseEvent):void 
        {            
            if (categoriesView.categoriesTreeView.selectedItem != null)
            {
                var categoryNode:IRepoNode = categoriesView.categoriesTreeView.selectedItem as IRepoNode;                
                var responder:Responder = new Responder(onResultAddCategory, onFaultAddCategory);                        
                var categoriesEvent:CategoriesEvent = new CategoriesEvent(CategoriesEvent.ADD_CATEGORY, responder, repoNode, categoryNode); 
                categoriesEvent.dispatch();
            }                                            
        }

        /**
         * Handler called when add category successfully completed
         * 
         * @param data  result data
         */
        protected function onResultAddCategory(data:Object):void
        {
            // get updated list of categories on node
            var categoriesResponder:Responder = new Responder(onResultGetCategories, onFaultGetCategories);
            var categoriesEvent:CategoriesEvent = new CategoriesEvent(CategoriesEvent.GET_CATEGORY_PROPERTIES, categoriesResponder, repoNode); 
            categoriesEvent.dispatch();                                            
        }
        
        /**
         * Handler for add category fault 
         * 
         * @param info fault info
         * 
         */
        protected function onFaultAddCategory(info:Object):void
        {
            trace("onFaultAddCategory" + info);            
        }    

        /**
         * Handle remove category buttion click
         * 
         * @param click event
         * 
         */
        protected function onRemoveCategoryBtn(event:MouseEvent):void 
        {      
            if (categoriesView.categoryList.selectedItem != null)
            {      
                var responder:Responder = new Responder(onResultRemoveCategory, onFaultRemoveCategory);
                            
                var categoryNode:RepoNode = new RepoNode();                
                categoryNode.nodeRef = categoriesView.categoryList.selectedItem.noderef;                
           
                var categoriesEvent:CategoriesEvent = new CategoriesEvent(CategoriesEvent.REMOVE_CATEGORY, responder, repoNode, categoryNode); 
                categoriesEvent.dispatch();
            }
        }

        /**
         * Handler called when remove category successfully completed
         * 
         * @param data  result data
         */
        protected function onResultRemoveCategory(data:Object):void
        {
            // get updated list of categories on node
            var categoriesResponder:Responder = new Responder(onResultGetCategories, onFaultGetCategories);
            var categoriesEvent:CategoriesEvent = new CategoriesEvent(CategoriesEvent.GET_CATEGORY_PROPERTIES, categoriesResponder, repoNode); 
            categoriesEvent.dispatch();                                            
        }
        
        /**
         * Handler for remove category fault 
         * 
         * @param info fault info
         * 
         */
        protected function onFaultRemoveCategory(info:Object):void
        {
            trace("onFaultRemoveCategory" + info);            
        }            
        
    }
}