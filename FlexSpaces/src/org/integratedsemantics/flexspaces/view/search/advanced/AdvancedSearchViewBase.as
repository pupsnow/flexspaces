package org.integratedsemantics.flexspaces.view.search.advanced
{
        
    import flash.events.MouseEvent;
    
    import mx.controls.Button;
    import mx.controls.CheckBox;
    import mx.controls.ComboBox;
    import mx.controls.DateField;
    import mx.controls.List;
    import mx.controls.TextInput;
    import mx.events.FlexEvent;
    import mx.events.ListEvent;
    import mx.managers.PopUpManager;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.DialogViewBase;
    import org.integratedsemantics.flexspaces.model.repo.RepoNode;
    import org.integratedsemantics.flexspaces.model.tree.TreeNode;
    import org.integratedsemantics.flexspaces.presmodel.search.advanced.AdvancedSearchPresModel;
    import org.integratedsemantics.flexspaces.util.ObserveUtil;
    import org.integratedsemantics.flexspaces.view.categories.tree.CategoryTreeViewBase;
    import org.integratedsemantics.flexspaces.view.tree.TreeViewBase;


    /**
     * Base class for advanced search views  
     * 
     */
    public class AdvancedSearchViewBase extends DialogViewBase
    {
        public var onComplete:Function;

        public var searchText:TextInput;
        
        public var resultsForCombo:ComboBox;        
        
        public var folderTypeCombo:ComboBox;        
        public var contentTypeCombo:ComboBox;        
        public var formatCombo:ComboBox;        

        public var locationCombo:ComboBox;                
        public var treeView:TreeViewBase;
        public var includeChildSpacesCheckbox:CheckBox;        
        
        public var categoryList:List;
        public var removeCategoryBtn:Button;        
        public var addExistingCategoryBtn:Button;        
        public var categoriesTreeView:CategoryTreeViewBase;
        public var includeSubCategoriesCheckbox:CheckBox;

        public var titleText:TextInput;
        public var descriptionText:TextInput;
        public var authorText:TextInput;
        
        public var modifiedDateCheckBox:CheckBox;
        public var modifiedFromDate:DateField;
        public var modifiedToDate:DateField;

        public var createdDateCheckBox:CheckBox;
        public var createdFromDate:DateField;
        public var createdToDate:DateField;
        
        [Bindable]
        public var advancedSearchPresModel:AdvancedSearchPresModel;

        
        /**
         * Constructor
         *  
         * @param onComplete handler to call after search is performed and results are available
         * 
         */
        public function AdvancedSearchViewBase(onComplete:Function=null)
        {
            super();
            
            this.onComplete = onComplete;                           
        }   
        
        /**
         * Handle creation compete of view
         * 
         * @param creation complete event
         * 
         */
        override protected function onCreationComplete(event:FlexEvent):void
        {
            super.onCreationComplete(event);
            
            ObserveUtil.observeButtonClick(addExistingCategoryBtn, onAddExistingCategoryBtn);
            ObserveUtil.observeButtonClick(removeCategoryBtn, onRemoveCategoryBtn);       
            
            // save initial selections without initialization in pres model
			advancedSearchPresModel.resultsForSelection = resultsForCombo.selectedItem;
			advancedSearchPresModel.folderTypeSelection = folderTypeCombo.selectedItem;
			advancedSearchPresModel.contentTypeSelection = contentTypeCombo.selectedItem;
			advancedSearchPresModel.formatSelection = formatCombo.selectedItem;
			advancedSearchPresModel.locationSelection = locationCombo.selectedItem;
			advancedSearchPresModel.treePresModel.selectedNode = treeView.selectedItem as TreeNode;                   
        }
         
        /**
         * Handle ok buttion click
         * 
         * @param click event
         * 
         */
        override protected function onOkBtn(event:MouseEvent):void 
        {
            var responder:Responder = new Responder(onResultSearch, onFaultSearch);
            
            advancedSearchPresModel.search(responder);
        }

        /**
         * Handler called when search service successfully returns results
         * 
         * @parm data search results data
         */
        protected function onResultSearch(data:Object):void
        {
            PopUpManager.removePopUp(this);
            
            if (onComplete != null)
            {
                onComplete(data);
            }                        
        }

        /**
         * Handle fault in search operation
         * 
         * @param info fault info
         */
        protected function onFaultSearch(info:Object):void
        {
            trace("onFaultSearch " + info);     
            PopUpManager.removePopUp(this);
        }
             
        /**
         * Handle add existing category buttion click
         * 
         * @param click event
         * 
         */
        protected function onAddExistingCategoryBtn(event:MouseEvent):void 
        {            
	        advancedSearchPresModel.addExistingCategoryFromTree();
        }
        
        /**
         * Handle remove category buttion click
         * 
         * @param click event
         * 
         */
        protected function onRemoveCategoryBtn(event:MouseEvent):void 
        {      
            advancedSearchPresModel.removeCategory();
        }
                     
    }
}