 
package org.integratedsemantics.flexspaces.presmodel.versions.versionlist
{
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.VersionListEvent;
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.versionlist.VersionHistoryCollection;


	/**
	 * Presentation model of version history for doc node with folder like view display (icons/details modes)
	 * 
	 */
	[Bindable] 	 	
	public class VersionListPresModel extends PresModel
	{
		public var selectedNode:IRepoNode = null;
	    		    
        public var nodeCollection:VersionHistoryCollection;

        public var model:AppModelLocator = AppModelLocator.getInstance();

        
	    /**
	     * Constructor 
	     * 
	     * @param folderView view to control
	     */
	    public function VersionListPresModel()
	    {
            super();                        
        }     	
        
        /**
         * Initialize model 
         * 
         */
        public function initModel():void
        {
            this.nodeCollection = new VersionHistoryCollection();       
        }


        /**
		 * Initialize version list 
		 * 
		 * @param selectItem selected node to get version history on
		 */
		public function initVersionList(selectedItem:Object):void
		{
			this.selectedNode = selectedItem as IRepoNode;
			
			if (model.flexSpacesPresModel.wcmMode == true)
			{
				// for now have blank version history for wcm
				// todo: add support for wcm version history
				this.nodeCollection = new VersionHistoryCollection();				 
			}
			else
			{
				if (selectedNode != null)
				{
					if (selectedNode.getIsFolder() == true)
					{
						// have empty version list for folders
						this.nodeCollection = new VersionHistoryCollection();
					}
					else
					{
						// get doc version history
			            var responder:Responder = new Responder(onResultVersionList, onFaultVersionList);
			            var versionListEvent:VersionListEvent = new VersionListEvent(VersionListEvent.VERSION_LIST, responder, selectedNode);
			            versionListEvent.dispatch();
		   			}
	   			} 
	   			else
	   			{
					// have empty version list for when no node selected in main folder view
					this.nodeCollection = new VersionHistoryCollection();
	        	}
   			}                       			
		}		
		
        /**
         * Handler called for successful call to server for get version list
         *  
         * @param data version list data result
         * 
         */
        protected function onResultVersionList(data:Object):void
        {
		    nodeCollection.initData(data);		    
        }

        /**
         * Handler call for fault return in response to server call for get version list
         *  
         * @param info fault info
         * 
         */
        protected function onFaultVersionList(info:Object):void
        {
            trace("onFaultVersionList" + info);            
        }
				
     }
}