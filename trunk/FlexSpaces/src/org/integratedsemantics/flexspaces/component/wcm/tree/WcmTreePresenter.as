package org.integratedsemantics.flexspaces.component.wcm.tree
{
    import flash.events.Event;
    
    import mx.collections.ArrayCollection;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.component.tree.TreePresenter;
    import org.integratedsemantics.flexspaces.component.tree.TreeViewBase;
    import org.integratedsemantics.flexspaces.control.event.wcm.WcmTreeDataEvent;
    import org.integratedsemantics.flexspaces.model.tree.TreeNode;
    import org.integratedsemantics.flexspaces.model.wcm.folder.WcmFolder;
    import org.integratedsemantics.flexspaces.model.wcm.tree.WcmTreeNode;
   
   
    /**
     * Presents a view of the avm stores in a tree
     *  
     * Supervising Presenter/Controller of TreeViewBase views 
     * 
     */
    public class WcmTreePresenter extends TreePresenter
    {

        /**
         * Constructor 
         * 
         * @param treeView tree view to control
         * 
         */
        public function WcmTreePresenter(treeView:TreeViewBase)        
        {
            super(treeView);            
        }
        
        /**
         * Handle view creation complete 
         * 
         * @param creation complete event
         * 
         */
        override protected function onCreationComplete(event:Event):void
        {
            var path:String = "/AVM";
            var responder:Responder = new Responder(onResultGetStores, onFaultGetStores);
            var wcmTreeDataEvent:WcmTreeDataEvent = new WcmTreeDataEvent(WcmTreeDataEvent.WCM_STORES_DATA, responder);
            wcmTreeDataEvent.dispatch();                                
        }
        
        /**
         * Set the selected node based on folder path
         *  
         * @param path folder path of tree node to select
         * 
         */
        override public function setPath(path:String):void
        {
        	var oldLabelField:String = treeView.labelField;
        	treeView.labelField = "path";
        	treeView.selectedIndex = -1;
			var foundAndSelected:Boolean = treeView.findString(path);
			treeView.labelField = oldLabelField;
			
			if (foundAndSelected == true)
			{
			    var node:WcmTreeNode = treeView.selectedItem as WcmTreeNode;
			    
			    if (node.path == path)
			    {
			    	if (node.hasBeenLoaded == false)
			    	{
	                    if (path.length > 4)
	                    {
	                        getNodeChildren(node);                            
	                    }
				    }
			    }
			    else
			    {
					//trace("WcmTreePresenter.setPath: findString found wrong node " + path + " " + node.path);			
			    }                                                                
			}
			else
			{
				//trace("WcmTreePresenter.setPath: path not found " + path);			    					
			}
        } 

        
       /**
        * Get subfolder data for node from the server 
        * 
        * @param node parent folder node to get subfolder data for
        * 
        * todo: curently won't get nodes already loaded, need to suport refreshing tree after deletions, 
        * time period to refresh to get other user edits, etc.
        * 
        */
        override protected function getNodeChildren(node:TreeNode):void
        {
            if (node.hasBeenLoaded == false)
            {
                this.setLoadingNode(node);
                var pathWithoutStoreId:String = "/" + node.path.substr(node.storeId.length + 6);
                var responder:Responder = new Responder(onResultWcmTreeData, onFaultWcmTreeData);
                var wcmTreeDataEvent:WcmTreeDataEvent = new WcmTreeDataEvent(WcmTreeDataEvent.WCM_TREE_DATA, responder, 
                                                                             node.storeId, pathWithoutStoreId);
                wcmTreeDataEvent.dispatch();                                
                
            }            
        } 
        
        /**
         * Handler called when tree data service successfully completed
         * 
         * @param data tree data return
         */
        protected function onResultWcmTreeData(data:Object):void
        {
            var result:XML = data as XML;

            var currentNode:WcmTreeNode = null;
            if (rootNode == null)
            {
                rootNode = new WcmTreeNode(result.folder.storeId, result.folder.name, result.folder.id);
                
                rootNode.name = result.folder.name;                    

                rootNode.nodeRef = result.folder.noderef;                    

                rootNode.storeProtocol = result.folder.storeProtocol;                    
                rootNode.storeId = result.folder.storeId;                    
                rootNode.id = result.folder.id;                    

                rootNode.path = result.folder.path;
                rootNode.displayPath = result.folder.path;
                rootNode.parentPath = result.folder.parentPath;
                                
                rootNode.readPermission = (result.folder.readPermission == "true");
                rootNode.writePermission = (result.folder.writePermission == "true");
                rootNode.deletePermission = (result.folder.deletePermission == "true");
                rootNode.createChildrenPermission = (result.folder.createChildrenPermission == "true");

                currentNode = rootNode as WcmTreeNode;
                loadingNode = rootNode as WcmTreeNode;
                treeView.dataProvider = rootNode;
            }
            else
            {
                currentNode = loadingNode as WcmTreeNode;
            }
       
            if (currentNode != null)
            {
                currentNode.children = new ArrayCollection();

                for each (var folder:XML in result.folder.children.folder)
                {
                    var childNode:WcmTreeNode = new WcmTreeNode(folder.storeId, folder.name, folder.id);
                    
                    childNode.name = folder.name;                    

                    childNode.nodeRef = folder.noderef;                    

                    childNode.storeProtocol = folder.storeProtocol;                    
                    childNode.storeId = folder.storeId;                    
                    childNode.id = folder.id;                    

                    childNode.path = currentNode.path + "/" + folder.name;
                    //childNode.path = folder.path;
                    childNode.displayPath = folder.path;
                    childNode.parentPath = folder.parentPath;
                                        
                    childNode.readPermission = (folder.readPermission == "true");
                    childNode.writePermission = (folder.writePermission == "true");
                    childNode.deletePermission = (folder.deletePermission == "true");
                    childNode.createChildrenPermission = (folder.createChildrenPermission == "true");

                    currentNode.children.addItem(childNode);
                }
                currentNode.hasBeenLoaded = true;

                treeView.callLater(expandLater);
            }                
        }

        /**
         * Handler called when server get tree data returns fault
         *  
         * @param info fault info
         * 
         */
        protected function onFaultWcmTreeData(info:Object):void
        {
            trace("onFaultWcmTreeData" + info);            
        }                                
        
        /**
         * Handler called when store data service successfully completed
         * 
         * @param data store data
         */
        protected function onResultGetStores(data:Object):void
        {
            var result:XML = data as XML;
            
            var currentNode:WcmTreeNode = null;
            if (rootNode == null)
            {
                rootNode = new WcmTreeNode("AVM", "AVM", "AVM");
                rootNode.path = "/AVM";
                currentNode = rootNode as WcmTreeNode;
                loadingNode = rootNode as WcmTreeNode;
                treeView.dataProvider = rootNode;
            }
            else
            {
                currentNode = loadingNode as WcmTreeNode;
            }
       
            if (currentNode != null)
            {
                currentNode.children = new ArrayCollection();

                for each (var store:XML in result.store)
                {
                    if ( WcmFolder.displayStore(store.id) == true)
                    {
                        var childNode:WcmTreeNode = new WcmTreeNode(store.id, store.name, store.id);
                        childNode.path = "/AVM/" + store.id;
                        currentNode.children.addItem(childNode);
                    }
                }
                currentNode.hasBeenLoaded = true;

                treeView.callLater(expandLater);
            }                
        }
        
        /**
         * Handler called when server get store data returns fault
         *  
         * @param info fault info
         * 
         */        
        protected function onFaultGetStores(info:Object):void
        {
            trace("onFaultGetStores" + info);            
        }                                                

    }
}