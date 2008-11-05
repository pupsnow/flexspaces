 
package org.integratedsemantics.flexspaces.component.search.results
{
    import flash.events.Event;
    
    import mx.controls.Label;
    import mx.printing.*;
    
    import org.integratedsemantics.flexspaces.component.folderview.FolderViewBase;
    import org.integratedsemantics.flexspaces.component.folderview.NodeListViewPresenter;
    import org.integratedsemantics.flexspaces.component.menu.contextmenu.ConfigurableContextMenu;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.searchresults.SearchResultsCollection;


	/**
	 * Presenter of search results with folder like view display (icons/details modes)
	 * 
	 * Supervising Presenter/Controller of databoud FolderViewBase views
	 * 
	 */	 	
	public class SearchResultsPresenter extends NodeListViewPresenter
	{
	    protected var resultCountLabel:Label;
	    		    
	    /**
	     * Constructor 
	     * 
	     * @param folderView view to control
	     */
	    public function SearchResultsPresenter(folderView:FolderViewBase)
	    {
	        super(folderView);
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
            
            folderView.breadCrumb.visible = false;
            folderView.breadCrumb.includeInLayout = false;       
            
            // add search count readout in breadcrumb area
            resultCountLabel = new Label();  
            resultCountLabel.setStyle("color", 0xFFFFFF); 
            resultCountLabel.setStyle("fontSize", 11); 
            folderView.breadCrumbAreaBox.addChild(resultCountLabel);     
        }
        
        /**
         * Initialize model 
         * 
         */
        override protected function initModel():void
        {
            this.nodeCollection = new SearchResultsCollection();       
        }

        /**
         * Initialize context menus 
         * 
         */
        override protected function initContextMenu():void
        {
            fileContextMenu = new ConfigurableContextMenu(this, folderView, model.srcPath + "config/" + model.locale + "/contextmenu/searchresults/fileContextMenu.xml");
            folderContextMenu = new ConfigurableContextMenu(this, folderView, model.srcPath + "config/" + model.locale + "/contextmenu/searchresults/folderContextMenu.xml");
            
            folderView.folderIconView.folderTileList.contextMenu = fileContextMenu.contextMenu;         
            folderView.folderGridView.folderGrid.contextMenu = fileContextMenu.contextMenu;                    
        }        

        /**
		 * Initialize with new search results data
		 * 
		 * @param data search results data
		 */
		public function initResultsData(data:Object):void
		{
		    var resultsCollection:SearchResultsCollection = this.nodeCollection as SearchResultsCollection; 
		    resultsCollection.initData(data);
		    
            folderView.folderGridView.repoFolderCollection = resultsCollection; 
            folderView.folderIconView.repoFolderCollection = resultsCollection; 
		    		    
            var xmlData:XML = data as XML;	
            
            // update result count readout
            resultCountLabel.text = data.totalResults + " results";		
            
            // set showThumbnail flags on nodes
            for each (var node:Node in nodeCollection)
            {
                node.showThumbnail = folderView.showThumbnails;
            }                                
		}		
		
     }
}