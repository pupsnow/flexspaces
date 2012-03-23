package org.integratedsemantics.flexspaces.presmodel.search.advanced
{
    import mx.collections.ArrayCollection;
    import mx.formatters.DateFormatter;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.command.search.QueryBuilder;
    import org.integratedsemantics.flexspaces.control.event.SearchEvent;
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.repo.RepoNode;
    import org.integratedsemantics.flexspaces.model.repo.RepoQName;
    import org.integratedsemantics.flexspaces.model.tree.TreeNode;
    import org.integratedsemantics.flexspaces.presmodel.categories.tree.CategoryTreePresModel;
    import org.integratedsemantics.flexspaces.presmodel.tree.TreePresModel;


    /**
     *  Advanced Search Dialog Presentation model
     *  
     */
    [Bindable] 
    public class AdvancedSearchPresModel extends PresModel
    {        
        public static const MODE_ALL:String = "all";
        public static const MODE_FILES_TEXT:String = "filenamesAndContent";
        public static const MODE_FILES:String = "filenames";
        public static const MODE_FOLDERS:String = "spacenames";

        public static const LOOKIN_ALL:String = "allSpaces";
        public static const LOOKIN_FOLDER:String = "specificSpaces";

        public static const CONTENT_MODEL_1_0_URI:String = "http://www.alfresco.org/model/content/1.0";
        public static const PROP_CREATED:RepoQName = new RepoQName(CONTENT_MODEL_1_0_URI, "created");
        public static const PROP_MODIFIED:RepoQName = new RepoQName(CONTENT_MODEL_1_0_URI, "modified");
        public static const PROP_TITLE:RepoQName = new RepoQName(CONTENT_MODEL_1_0_URI, "title");
        public static const PROP_DESCRIPTION:RepoQName = new RepoQName(CONTENT_MODEL_1_0_URI, "description");
        public static const PROP_AUTHOR:RepoQName = new RepoQName(CONTENT_MODEL_1_0_URI, "author");

        public var searchText:String = "";
        
        public var resultsForSelection:Object = null;        
        
        public var folderTypeSelection:Object = null;        
        public var contentTypeSelection:Object = null;        
        public var formatSelection:Object = null;        

        public var locationSelection:Object = null;                
        public var treePresModel:TreePresModel;
        public var includeChildSpaces:Boolean = true;    

        public var categories:ArrayCollection;               
        public var categoryListSelectedIndex:int = -1;
        public var categoryTreePresModel:CategoryTreePresModel;
        public var includeSubCategories:Boolean = true;

        public var titleText:String = "";
        public var descriptionText:String = "";
        public var authorText:String = "";
        
        public var modifiedDateCheckState:Boolean = false;
        public var modifiedFromDate:String = "";
        public var modifiedToDate:String = "";

        public var createdDateCheckState:Boolean = false;
        public var createdFromDate:String = "";
        public var createdToDate:String = "";


        /**
         * Constructor
         *  
         * @param advancedSearchView view to control
         * 
         */
        public function AdvancedSearchPresModel()
        {
            super();
            
            categories = new ArrayCollection(); 
            
            setupSubViews();        
        }
        
        /**
         * Setup presentation models for subviews
         * 
         */
        protected function setupSubViews():void
        {
            categoryTreePresModel = new CategoryTreePresModel();  
            
            treePresModel = new TreePresModel();          
        }
                
        /**
         * Perform search for query string
         * 
         * @param query query string
         * 
         */
        public function search(responder:Responder):void 
        {
            // construct the query builder (like SearchContext bean)
            var queryBuilder:QueryBuilder = new QueryBuilder();
          
            // set the full-text/name field value 
            queryBuilder.setText(searchText);
          
            // set whether to force AND operation on text terms
            queryBuilder.setForceAndTerms(false);
          
            if (resultsForSelection.resultsFor == AdvancedSearchPresModel.MODE_ALL)
            {
                queryBuilder.setMode(QueryBuilder.SEARCH_ALL);
            }
            else if (resultsForSelection.resultsFor == AdvancedSearchPresModel.MODE_FILES_TEXT)
            {
                queryBuilder.setMode(QueryBuilder.SEARCH_FILE_NAMES_CONTENTS);
            }
            else if (resultsForSelection.resultsFor == AdvancedSearchPresModel.MODE_FILES)
            {
                queryBuilder.setMode(QueryBuilder.SEARCH_FILE_NAMES);
            }
            else if (resultsForSelection.resultsFor == AdvancedSearchPresModel.MODE_FOLDERS)
            {
                queryBuilder.setMode(QueryBuilder.SEARCH_SPACE_NAMES);
            }
          
            // additional attributes search
            
            var description:String = descriptionText;
            if (description != null && description.length != 0)
            {
                queryBuilder.addAttributeQuery(AdvancedSearchPresModel.PROP_DESCRIPTION, description);
            }
            
            var title:String = titleText;
            if (title != null && title.length != 0)
            {
                queryBuilder.addAttributeQuery(AdvancedSearchPresModel.PROP_TITLE, title);
            }
            var author:String = authorText;
            if (author != null && author.length != 0)
            {
                queryBuilder.addAttributeQuery(AdvancedSearchPresModel.PROP_AUTHOR, author);
            }
            
            if (formatSelection.format != "allFormats")
            {
                queryBuilder.setMimeType(formatSelection.format);
            }

            var dateFormatter:DateFormatter = new DateFormatter();
            dateFormatter.formatString = "YYYY-MM-DDT00:00:00.000Z";

            if ( (createdDateCheckState == true) && (createdFromDate.length != 0) && (createdToDate.length != 0) )
            {
                var strCreatedDate:String = dateFormatter.format(createdFromDate);
                var strCreatedDateTo:String = dateFormatter.format(createdToDate);
                queryBuilder.addRangeQuery(AdvancedSearchPresModel.PROP_CREATED, strCreatedDate, strCreatedDateTo, true);
            }
            if ( (modifiedDateCheckState == true) && (modifiedFromDate.length != 0) && (modifiedToDate.length != 0) )
            {
                var strModifiedDate:String = dateFormatter.format(modifiedFromDate);
                var strModifiedDateTo:String = dateFormatter.format(modifiedToDate);
                queryBuilder.addRangeQuery(AdvancedSearchPresModel.PROP_MODIFIED, strModifiedDate, strModifiedDateTo, true);
            }

            // todo: add use of search attributes from xml config 

            // location path search
            if (locationSelection.location == AdvancedSearchPresModel.LOOKIN_FOLDER)
            {
            	if (treePresModel.selectedNode != null)
            	{
	                var folderNode:RepoNode = treePresModel.selectedNode as RepoNode;
	                var qnamePath:String = folderNode.qnamePath;
	                if (includeChildSpaces == true)
	                {
	                    queryBuilder.setLocation(qnamePath + "//*");
	                }
	                else
	                {
	                    queryBuilder.setLocation(qnamePath + "/*");                    
	                }
             	}
            }
          
            // category path search
            var categories:ArrayCollection = categories;
            if (categories.length != 0)
            {
                var categoryPaths:Array = new Array(categories.length);
                for (var i:int = 0; i < categoryPaths.length; i++)
                {
                    var category:RepoNode = categories.getItemAt(i) as RepoNode;
                    var includeChildren:Boolean = includeSubCategories;
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
            if (contentTypeSelection != null)
            {
                queryBuilder.setContentType(contentTypeSelection.type);
            }
          
            // folder type restriction
            if (folderTypeSelection != null)
            {
                queryBuilder.setFolderType(folderTypeSelection.type);
            }

            var query:String = queryBuilder.buildQuery(3);
                        
            var model:AppModelLocator = AppModelLocator.getInstance();
            var pageSize:int = model.flexSpacesPresModel.searchPageSize;
                        
            if ((searchText != null) && (searchText.length > 2))
            {
                if  (model.appConfig.cmisMode == true)
                {    
                    // cmis: todo use new query builder
                    // test for non full text cmis query
                    query = "SELECT * FROM cmis:document";
                    var searchEvent:SearchEvent = new SearchEvent(SearchEvent.ADVANCED_SEARCH, responder, query, pageSize, 0);
                }
                else
                {
                    searchEvent = new SearchEvent(SearchEvent.ADVANCED_SEARCH, responder, query, pageSize, 0);
                }
                searchEvent.dispatch();
            }                                 
        }
         
        /**
         * add existing category
         * 
         */
        public function addExistingCategoryFromTree():void 
        {            
        	var selectedNode:TreeNode = categoryTreePresModel.selectedNode;
        	
        	// don't allow add of the root "Categories" node 
            if ((selectedNode != null) && (selectedNode != categoryTreePresModel.rootNode))
            {
                categories.addItem(selectedNode);
            }                                            
        }
         
        /**
         * remove category
         * 
         */
        public function removeCategory():void 
        {   
            if (categoryListSelectedIndex != -1)
            {     
                categories.removeItemAt(categoryListSelectedIndex);
            }            
        }
                
    }
}