package org.integratedsemantics.flexspaces.component.search.advanced
{
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.collections.ArrayCollection;
    import mx.events.FlexEvent;
    import mx.events.ListEvent;
    import mx.formatters.DateFormatter;
    import mx.managers.PopUpManager;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.component.categories.tree.CategoryTreePresenter;
    import org.integratedsemantics.flexspaces.component.tree.TreePresenter;
    import org.integratedsemantics.flexspaces.control.command.search.QueryBuilder;
    import org.integratedsemantics.flexspaces.control.event.SearchEvent;
    import org.integratedsemantics.flexspaces.framework.dialog.DialogPresenter;
    import org.integratedsemantics.flexspaces.model.repo.RepoNode;
    import org.integratedsemantics.flexspaces.model.repo.RepoQName;


    /**
     *  Advanced Search Dialog Presenter
     *  
     *  Presenter/Controller of AdvancedSearchViewBase views
     * 
     *  Todo: support for more fields than just text input
     * 
     */
    public class AdvancedSearchPresenter extends DialogPresenter
    {        
        protected var onComplete:Function;
        
        protected static const MODE_ALL:String = "all";
        protected static const MODE_FILES_TEXT:String = "filenamesAndContent";
        protected static const MODE_FILES:String = "filenames";
        protected static const MODE_FOLDERS:String = "spacenames";

        protected static const LOOKIN_ALL:String = "allSpaces";
        protected static const LOOKIN_FOLDER:String = "specificSpaces";

        protected static const CONTENT_MODEL_1_0_URI:String = "http://www.alfresco.org/model/content/1.0";
        protected static const PROP_CREATED:RepoQName = new RepoQName(CONTENT_MODEL_1_0_URI, "created");
        protected static const PROP_MODIFIED:RepoQName = new RepoQName(CONTENT_MODEL_1_0_URI, "modified");
        protected static const PROP_TITLE:RepoQName = new RepoQName(CONTENT_MODEL_1_0_URI, "title");
        protected static const PROP_DESCRIPTION:RepoQName = new RepoQName(CONTENT_MODEL_1_0_URI, "description");
        protected static const PROP_AUTHOR:RepoQName = new RepoQName(CONTENT_MODEL_1_0_URI, "author");

        protected var categoryTreePresenter:CategoryTreePresenter;
        protected var treePresenter:TreePresenter;


        /**
         * Constructor
         *  
         * @param advancedSearchView view to control
         * @param onComplete handler to call after search is performed and results are available
         * 
         */
        public function AdvancedSearchPresenter(advancedSearchView:AdvancedSearchViewBase, onComplete:Function=null)
        {
            super(advancedSearchView);
            
            this.onComplete = onComplete;   
            
            advSearchView.categories = new ArrayCollection();         
        }
        
        /**
         * Getter for the view
         *  
         * @return this view
         * 
         */
        protected function get advSearchView():AdvancedSearchViewBase
        {
            return this.view as AdvancedSearchViewBase;            
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
            
            categoryTreePresenter = new CategoryTreePresenter(advSearchView.categoriesTreeView);  
            observeButtonClick(advSearchView.addExistingCategoryBtn, onAddExistingCategoryBtn);
            observeButtonClick(advSearchView.removeCategoryBtn, onRemoveCategoryBtn);  
            
            treePresenter = new TreePresenter(advSearchView.treeView);          
            advSearchView.treeView.addEventListener(ListEvent.CHANGE, locationTreeChanged);
            advSearchView.treeView.addEventListener(ListEvent.ITEM_CLICK, locationTreeClicked);           
        }
        
        /**
         * Handler called when search service successfully returns results
         * 
         * @parm data search results data
         */
        protected function onResultSearch(data:Object):void
        {
            PopUpManager.removePopUp(advSearchView);
            
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
            PopUpManager.removePopUp(advSearchView);
        }
        
        /**
         * Handle ok buttion click
         * 
         * @param click event
         * 
         */
        override protected function onOkBtn(event:MouseEvent):void 
        {
            // construct the query builder (like SearchContext bean)
            var queryBuilder:QueryBuilder = new QueryBuilder();
          
            // set the full-text/name field value 
            queryBuilder.setText(advSearchView.searchText.text);
          
            // set whether to force AND operation on text terms
            queryBuilder.setForceAndTerms(false);
          
            if (advSearchView.resultsForCombo.selectedItem.resultsFor == MODE_ALL)
            {
                queryBuilder.setMode(QueryBuilder.SEARCH_ALL);
            }
            else if (advSearchView.resultsForCombo.selectedItem.resultsFor == MODE_FILES_TEXT)
            {
                queryBuilder.setMode(QueryBuilder.SEARCH_FILE_NAMES_CONTENTS);
            }
            else if (advSearchView.resultsForCombo.selectedItem.resultsFor == MODE_FILES)
            {
                queryBuilder.setMode(QueryBuilder.SEARCH_FILE_NAMES);
            }
            else if (advSearchView.resultsForCombo.selectedItem.resultsFor == MODE_FOLDERS)
            {
                queryBuilder.setMode(QueryBuilder.SEARCH_SPACE_NAMES);
            }
          
            // additional attributes search
            
            var description:String = advSearchView.descriptionText.text;
            if (description != null && description.length != 0)
            {
                queryBuilder.addAttributeQuery(PROP_DESCRIPTION, description);
            }
            
            var title:String = advSearchView.titleText.text;
            if (title != null && title.length != 0)
            {
                queryBuilder.addAttributeQuery(PROP_TITLE, title);
            }
            var author:String = advSearchView.authorText.text;
            if (author != null && author.length != 0)
            {
                queryBuilder.addAttributeQuery(PROP_AUTHOR, author);
            }
            if (advSearchView.formatCombo != null && advSearchView.formatCombo.selectedItem.format != "allFormats")
            {
                queryBuilder.setMimeType(advSearchView.formatCombo.selectedItem.format);
            }

            var dateFormatter:DateFormatter = new DateFormatter();
            dateFormatter.formatString = "YYYY-MM-DDT00:00:00.000Z";

            if ( (advSearchView.createdDateCheckBox.selected == true) && (advSearchView.createdFromDate.text.length != 0)
                && (advSearchView.createdToDate.text.length != 0) )
            {
                var strCreatedDate:String = dateFormatter.format(advSearchView.createdFromDate.text);
                var strCreatedDateTo:String = dateFormatter.format(advSearchView.createdToDate.text);
                queryBuilder.addRangeQuery(PROP_CREATED, strCreatedDate, strCreatedDateTo, true);
            }
            if ( (advSearchView.modifiedDateCheckBox.selected == true) && (advSearchView.modifiedFromDate.text.length != 0)
                && (advSearchView.modifiedToDate.text.length != 0) )
            {
                var strModifiedDate:String = dateFormatter.format(advSearchView.modifiedFromDate.text);
                var strModifiedDateTo:String = dateFormatter.format(advSearchView.modifiedToDate.text);
                queryBuilder.addRangeQuery(PROP_MODIFIED, strModifiedDate, strModifiedDateTo, true);
            }

            // todo: add use of search attributes from xml config 

            // location path search
            if (advSearchView.locationCombo.selectedItem.location == LOOKIN_FOLDER)
            {
                var folderNode:RepoNode = advSearchView.treeView.selectedItem as RepoNode;
                var qnamePath:String = folderNode.qnamePath;
                if (advSearchView.includeChildSpacesCheckbox.selected == true)
                {
                    queryBuilder.setLocation(qnamePath + "//*");
                }
                else
                {
                    queryBuilder.setLocation(qnamePath + "/*");                    
                }
            }
          
            // category path search
            if (advSearchView.categories.length != 0)
            {
                var categoryPaths:Array = new Array(advSearchView.categories.length);
                for (var i:int = 0; i < categoryPaths.length; i++)
                {
                    var category:RepoNode = advSearchView.categories.getItemAt(i) as RepoNode;
                    var includeChildren:Boolean = advSearchView.includeSubCategoriesCheckbox.selected;
                    if (includeChildren == true)
                    {
                        // append syntax to get all children of the path
                        var categoryPath:String = category.qnamePath + "//*";
                    }
                    else
                    {
                        // append syntax to just represent the path, not the children
                        categoryPath = category.qnamePath + "/*";
                    }                    
                    categoryPaths[i] = categoryPath;
                }
                queryBuilder.setCategories(categoryPaths);
            }
          
            // content type restriction
            if (advSearchView.contentTypeCombo != null)
            {
                queryBuilder.setContentType(advSearchView.contentTypeCombo.selectedItem.type);
            }
          
            // folder type restriction
            if (advSearchView.folderTypeCombo != null)
            {
                queryBuilder.setFolderType(advSearchView.folderTypeCombo.selectedItem.type);
            }

            var query:String = queryBuilder.buildQuery(3);
            
            var responder:Responder = new Responder(onResultSearch, onFaultSearch);
            var searchEvent:SearchEvent = new SearchEvent(SearchEvent.ADVANCED_SEARCH, responder, query);
            searchEvent.dispatch();                                 
        }
        
        /**
         * Handle add existing category buttion click
         * 
         * @param click event
         * 
         */
        protected function onAddExistingCategoryBtn(event:MouseEvent):void 
        {            
            if  ( (advSearchView.categoriesTreeView.selectedItem != null) && (advSearchView.categoriesTreeView.selectedIndex != 0) )
            {
                var categoryNode:RepoNode = advSearchView.categoriesTreeView.selectedItem as RepoNode;
                advSearchView.categories.addItem(categoryNode);
            }                                            
        }
        
        /**
         * Handle remove category buttion click
         * 
         * @param click event
         * 
         */
        protected function onRemoveCategoryBtn(event:MouseEvent):void 
        {      
            if (advSearchView.categoryList.selectedItem != null)
            {     
                var index:int = advSearchView.categoryList.selectedIndex;
                advSearchView.categories.removeItemAt(index);
            }
        }
        
        /**
         * Handle location tree changed event
         *  
         * @param event tree changed event
         * 
         */
        protected function locationTreeChanged(event:Event):void
        {
            var path:String = treePresenter.getPath();            
        }

        protected var prevItem:Object;
        
        /**
         * Handle toggling open location tree folder on clicks
         *  
         * @param event tree click event
         * 
         */
        protected function locationTreeClicked(event:Event):void
        {
            var toggle:Boolean = advSearchView.treeView.isItemOpen(advSearchView.treeView.selectedItem);
            if (toggle == true)
            {
                if (advSearchView.treeView.selectedItem == prevItem)
                {
                    treePresenter.expandItem(advSearchView.treeView.selectedItem, false, true);
                }
            } 
            else
            {
                treePresenter.expandItem(advSearchView.treeView.selectedItem, true, true);
            }
            
            prevItem = advSearchView.treeView.selectedItem;
        }
        
        
    }
}