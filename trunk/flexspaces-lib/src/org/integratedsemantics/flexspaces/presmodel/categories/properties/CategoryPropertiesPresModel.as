package org.integratedsemantics.flexspaces.presmodel.categories.properties
{
    import mx.collections.ArrayCollection;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.CategoriesEvent;
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.repo.RepoNode;
    import org.integratedsemantics.flexspaces.model.vo.CategoryVO;
    import org.integratedsemantics.flexspaces.presmodel.categories.tree.CategoryTreePresModel;

    
    /**
     *  Presentation Model for Categories properties panel for viewing/editing category properties
     *  on a doc/folder
     *  
     */
    [Bindable] 
    public class CategoryPropertiesPresModel extends PresModel
    {
    	// doc/folder node to edit category properties on 
        public var repoNode:IRepoNode;  
              
        public var categories:ArrayCollection;  
        public var selectedNodeCategory:CategoryVO = null;

        public var categoryTreePresModel:CategoryTreePresModel;

		public var enableAdd:Boolean = true;
		public var enableRemove:Boolean = true;

               
        /**
         * Constructor 
         * 
         * @param repoNode  node to view/edit category properties on
         * 
         */
        public function CategoryPropertiesPresModel(repoNode:IRepoNode)
        {
            super();
            
            this.repoNode = repoNode;  

            categoryTreePresModel = new CategoryTreePresModel();  
            
            // disable add/remove category btns if don't have write permission 
            var node:Node = repoNode as Node;
            if (node.writePermission == false)
            {
                enableAdd = false;
                enableRemove = false;
            }                                                                             
        }

		public function getCategories():void
		{
            var categoriesResponder:Responder = new Responder(onResultGetCategories, onFaultGetCategories);
            var categoriesEvent:CategoriesEvent = new CategoriesEvent(CategoriesEvent.GET_CATEGORY_PROPERTIES, categoriesResponder, repoNode); 
            categoriesEvent.dispatch();      
  		}	
               
        /**
         * Handler called when get categories service successfully completed
         * 
         * @param data category data returned
         */
        protected function onResultGetCategories(data:Object):void
        {
            categories = data as ArrayCollection;
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
         * add existing category
         * 
         */
        public function addExistingCategoryFromTree():void 
        {            
            if (categoryTreePresModel.selectedNode != null)
            {
	            var responder:Responder = new Responder(onResultAddCategory, onFaultAddCategory);                        
	            var categoriesEvent:CategoriesEvent = new CategoriesEvent(CategoriesEvent.ADD_CATEGORY, responder, repoNode, 
	                                                                      categoryTreePresModel.selectedNode); 
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
         * remove category
         * 
         */
        public function removeNodeCategory():void 
        {      
            if (selectedNodeCategory != null)
            {            	
	            var responder:Responder = new Responder(onResultRemoveCategory, onFaultRemoveCategory);
	                        
	            var categoryNode:RepoNode = new RepoNode();                
	            categoryNode.nodeRef = selectedNodeCategory.nodeRef;           
	       
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