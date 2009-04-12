package org.integratedsemantics.flexspaces.view.search.results
{
    import flash.events.Event;
    
    import mx.binding.utils.ChangeWatcher;
    import mx.collections.ArrayCollection;
    import mx.controls.Label;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.presmodel.search.results.SearchResultsPresModel;
    import org.integratedsemantics.flexspaces.view.folderview.NodeListViewBase;
    import org.integratedsemantics.flexspaces.view.menu.contextmenu.ConfigurableContextMenu;

	
	public class SearchResultsViewBase extends NodeListViewBase
	{		
	    public var resultsCountLabel:Label;

        [Bindable]
        protected var dataProvider:ArrayCollection;


		/**
		 * Constructor 
		 * 
		 */
		public function SearchResultsViewBase()
		{
			super();
		}

        /**
         * Getter for the search results pres model
         *  
         * @return the pres model
         * 
         */
    	[Bindable]
    	public function get searchResultsPresModel():SearchResultsPresModel
        {
            return this.nodeListViewPresModel as SearchResultsPresModel;            
        }       
        
    	public function set searchResultsPresModel(searchResultsPresModel:SearchResultsPresModel):void
        {
            this.nodeListViewPresModel = searchResultsPresModel;            
        }       

        /**
         * Handle view creation complete 
         * 
         * @param creation complete event
         * 
         */
        override protected function onCreationComplete(event:Event):void
        {
            super.onCreationComplete(event);
            
            // init search count readout in breadcrumb area
            resultsCountLabel.setStyle("color", 0xFFFFFF); 
            resultsCountLabel.setStyle("fontSize", 11); 
            
            
            // cmis spaces uses clientside paging only, flexspaces by default uses serverside paging
            var cmisMode:Boolean = searchResultsPresModel.model.appConfig.cmisMode;
            if (cmisMode == true)
            {
                dataProvider = pager.pageData;
                ChangeWatcher.watch(pager, "pageData", onDataProviderChange);
            }   
            else
            {
                dataProvider = nodeListViewPresModel.nodeCollection;
                ChangeWatcher.watch(nodeListViewPresModel, "nodeCollection", onDataProviderChange);
                
                ChangeWatcher.watch(pageBar, "curPageIndex", onPageChange);            
                pager.clientSidePage = false;                 
            }                                                                       
        }

        protected function onDataProviderChange(event:Event):void
        {
            var cmisMode:Boolean = searchResultsPresModel.model.appConfig.cmisMode;
            if (cmisMode == true)
            {
                dataProvider = pager.pageData;
            }   
            else
            {
                dataProvider = nodeListViewPresModel.nodeCollection;
            }                                                                       
        }

        /**
         * Initialize context menus 
         * 
         */
        override protected function initContextMenu():void
        {
        	var srcPath:String = searchResultsPresModel.model.appConfig.srcPath;
        	var locale:String = searchResultsPresModel.model.appConfig.locale;
        	
            fileContextMenu = new ConfigurableContextMenu(searchResultsPresModel, this, srcPath + "config/" + locale + "/contextmenu/searchresults/fileContextMenu.xml");
            folderContextMenu = new ConfigurableContextMenu(searchResultsPresModel, this, srcPath + "config/" + locale + "/contextmenu/searchresults/folderContextMenu.xml");
            
            folderIconView.folderTileList.contextMenu = fileContextMenu.contextMenu;         
            folderGridView.folderGrid.contextMenu = fileContextMenu.contextMenu;                    
        }    
        
        override protected function requery():void
        {
            var pageSize:int = searchResultsPresModel.model.flexSpacesPresModel.searchPageSize;
            var pageNum:int = pageBar.curPageIndex;
            var responder:Responder = new Responder(onResultSearch, onFaultSearch);
            searchResultsPresModel.requery(responder, pageSize, pageNum);                
        }

        /**
         * Handle successful requery search
         *  
         * @param data search results data
         * 
         */
        protected function onResultSearch(data:Object):void
        {
            searchResultsPresModel.initResultsData(data);                     
        }

        /**
         * Handle requery search fault
         *  
         * @param info fault info
         * 
         */
        protected function onFaultSearch(info:Object):void
        {
            trace("onFaultRequerySearch " + info);     
        }

        protected function onPageSizeChange(event:Event):void
        {
            searchResultsPresModel.model.flexSpacesPresModel.searchPageSize = event.target.value;
            
            resetPaging();
            
            var cmisMode:Boolean = searchResultsPresModel.model.appConfig.cmisMode;
            if (cmisMode == false)
            {
                // for server side paging
                requery();
            }
        }
                
	}
}