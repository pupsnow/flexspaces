package org.integratedsemantics.flexspaces.component.tree
{
    import flash.events.Event;
    
    import mx.collections.ArrayCollection;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.TreeDataEvent;
    import org.integratedsemantics.flexspaces.framework.presenter.Presenter;
    import org.integratedsemantics.flexspaces.model.tree.TreeNode;
   
   
    /**
     * Presents a view of the repository in a tree
     *  
     * Supervising Presenter/Controller of TreeViewBase views 
     * 
     */
    public class TreePresenter extends Presenter
    {
        [Bindable] protected var rootNode:TreeNode;
        
        protected var loadingNode:TreeNode;

        
        /**
         * Constructor 
         * 
         * @param treeView tree view to control
         * 
         */
        public function TreePresenter(treeView:TreeViewBase)        
        {
            super(treeView);

            if (treeView.initialized == true)
            {
                onCreationComplete(new Event(""));
            }
            else
            {
                observeCreation(treeView, onCreationComplete);            
            }
        }
        
        /**
         * Getter for the view
         *  
         * @return view
         * 
         */
        protected function get treeView():TreeViewBase
        {
            return this.view as TreeViewBase;            
        }       

        /**
         * Handle view creation complete 
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:Event):void
        {
            // call sever to request tree data, currently webscript will return data for company home data for "/"
            // regardless of the name of company home          
            var path:String = "/";
            var responder:Responder = new Responder(onResultTreeData, onFaultTreeData);
            var treeDataEvent:TreeDataEvent = new TreeDataEvent(TreeDataEvent.TREE_DATA, responder, path); 
            treeDataEvent.dispatch();                                     
        }
        
        /**
        * Set the tree node being data loaded 
        * 
        * @param loadingNode tree node to load
        */
        protected function setLoadingNode(loadingNode:TreeNode):void
        {
            this.loadingNode = loadingNode;    
        }
                
        /**
        * Get folder path of currently selected tree node
        *  
        * @return path of currently selected node
        */
        public function getPath():String
        {
            var selectedNode:TreeNode = treeView.selectedItem as TreeNode;
            var path:String = selectedNode.path;
            return path;            
        }
        
        /**
         * Set the selected node based on folder path
         *  
         * @param path folder path of tree node to select
         * 
         */
        public function setPath(path:String):void
        {
        	var oldLabelField:String = treeView.labelField;
        	treeView.labelField = "path";
        	treeView.selectedIndex = -1;
			var foundAndSelected:Boolean = treeView.findString(path);
			treeView.labelField = oldLabelField;
			
			if (foundAndSelected == true)
			{
			    var node:TreeNode = treeView.selectedItem as TreeNode;
			    
			    if (node.path == path)
			    {
  			       getNodeChildren(node);
			    }
			    else
			    {
					//trace("TreePresenter.setPath: findString found wrong node " + path + " " + node.path);			
			    }                                                                
			}
			else
			{
				//trace("TreePresenter.setPath: path not found " + path);			    					
			}
        } 
        
        /**
         * refresh tree at folder currently selected in it 
         * 
         */
        public function refreshCurrentFolder():void
        {
        	var node:TreeNode = treeView.selectedItem as TreeNode;
        	if (node != null)
        	{
        		node.hasBeenLoaded = false;
			    getNodeChildren(node);
			    treeView.invalidateList();
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
       protected function getNodeChildren(node:TreeNode):void
        {
            if (node.hasBeenLoaded == false)
            {
                this.setLoadingNode(node);
                var responder:Responder = new Responder(onResultTreeData, onFaultTreeData);
                var treeDataEvent:TreeDataEvent = new TreeDataEvent(TreeDataEvent.TREE_DATA, responder, node.path); 
                treeDataEvent.dispatch();                                            
            }            
        } 
        
        /**
         * Expand tree node and get data from server for children
         *  
         * @param item     tree node item
         * @param open     open state
         * @param animate  should it animate while opening
         * @param dispatchEvent is dispatch event
         * @param cause  event cause
         * 
         */
        public function expandItem(item:Object, open:Boolean, animate:Boolean=false, dispatchEvent:Boolean=false, cause:Event=null):void
        {
            if (open == true)
            {
                var node:TreeNode = item as TreeNode;
                getNodeChildren(node);                
            }
            
            treeView.expandItem(item, open, animate, dispatchEvent, cause);           
        }
                
        /**
         * Handler called when tree data service successfully completed
         * 
         * @param data  tree data returned
         */
        protected function onResultTreeData(data:Object):void
        {
            var result:XML = data as XML;

            var currentNode:TreeNode = null;
            if (rootNode == null)
            {
                rootNode = new TreeNode(result.folder.name, result.folder.id);
                
                rootNode.name = result.folder.name;                    

                rootNode.nodeRef = result.folder.noderef;                    

                rootNode.storeProtocol = result.folder.storeProtocol;                    
                rootNode.storeId = result.folder.storeId;                    
                rootNode.id = result.folder.id;                    

                rootNode.path = result.folder.path;
                rootNode.displayPath = result.folder.path;
                rootNode.parentPath = result.folder.parentPath;
                                
                rootNode.qnamePath = result.folder.qnamePath;                

                rootNode.readPermission = (result.folder.readPermission == "true");
                rootNode.writePermission = (result.folder.writePermission == "true");
                rootNode.deletePermission = (result.folder.deletePermission == "true");
                rootNode.createChildrenPermission = (result.folder.createChildrenPermission == "true");

                currentNode = rootNode;
                loadingNode = rootNode;

                treeView.dataProvider = rootNode;
            }
            else
            {
                currentNode = loadingNode;
            }
       
            if (currentNode != null)
            {
                currentNode.children = new ArrayCollection();

                for each (var folder:XML in result.folder.children.folder)
                {
                    var childNode:TreeNode = new TreeNode(folder.name, folder.id);
                    
                    childNode.name = folder.name;                    
    
                    childNode.nodeRef = folder.noderef;                    

                    childNode.storeProtocol = folder.storeProtocol;                    
                    childNode.storeId = folder.storeId;                    
                    childNode.id = folder.id;                    

                    childNode.path = folder.path;
                    childNode.displayPath = folder.path;                    
                    childNode.parentPath = folder.parentPath;                                        

                    childNode.qnamePath = folder.qnamePath;                
                    
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

		protected function expandLater():void
		{
			var isOpen:Boolean = treeView.isItemOpen(loadingNode);
			if (isOpen == false)
			{
        		treeView.expandItem(loadingNode, true, false);
   			}			
		}
        
        /**
         * Handler called when server get tree data returns fault
         *  
         * @param info fault info
         * 
         */
        protected function onFaultTreeData(info:Object):void
        {
            trace("onFaultGetTreeData" + info);            
        }                                
        
    }

}
