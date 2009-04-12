package org.integratedsemantics.flexspaces.view.tree
{
    import mx.controls.Tree;
    import mx.events.ListEvent;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.model.tree.TreeNode;
    import org.integratedsemantics.flexspaces.presmodel.tree.TreePresModel;
    
        
    /**
     * Base view class for repository tree views
     * 
     */
    public class TreeViewBase extends Tree
    {        
        [Bindable]
        public var treePresModel:TreePresModel;
        

        /**
         * Constructor 
         */
        public function TreeViewBase()
        {
            super();
        }        
        
        /**
         * Handle view creation complete 
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:Event):void
        {
            addEventListener(ListEvent.CHANGE, treeChanged);
            addEventListener(ListEvent.ITEM_CLICK, treeClicked);     

            // cmis
            var path:String = "/";
            initTree(path);                                          
        }

        // cmis: separated this from onCreationComplete 
        public function initTree(path:String):void
        {
            //trace("TreeViewBase initTree() " + path);

            // call sever to request tree data, currently webscript will return data for company home data for "/"
            // regardless of the name of company home          
            var responder:Responder = new Responder(onResultTreeData, onFaultTreeData);
            treePresModel.getTreeData(path, responder);                            
        }
        
        /**
        * Get folder path of currently selected tree node
        *  
        * @return path of currently selected node
        */
        public function getPath():String
        {
            var path:String = null;           
            var selectedNode:TreeNode = selectedItem as TreeNode;
            
            if (selectedNode != null)
            {
                path = selectedNode.path;
            }
            
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
            //trace("TreeViewBase setPath " + path);
                                    
            var oldLabelField:String = labelField;
        	labelField = "path";
        	selectedIndex = -1;
			var foundAndSelected:Boolean = findString(path);
			labelField = oldLabelField;
			
			if (foundAndSelected == true)
			{
			    var node:TreeNode = selectedItem as TreeNode;
			    
                // cmis trigger folder list update
                if (node.hasBeenLoaded == true)
                {
                    treePresModel.doneTreeData = true;
                }                    			        

			    if (node.path == path)
			    {
			        
	                var responder:Responder = new Responder(onResultTreeData, onFaultTreeData);
  			        treePresModel.getNodeChildren(node, responder);
			    }
			    else
			    {
					//trace("TreePresModel.setPath: findString found wrong node " + path + " " + node.path);			
			    }                                                                
			}
			else
			{
				//trace("TreePresModel.setPath: path not found " + path);			    					
			}
        } 

        /**
         * refresh tree at folder currently selected in it 
         * 
         */
        public function refreshCurrentFolder():void
        {
        	var node:TreeNode = selectedItem as TreeNode;
        	if (node != null)
        	{
        		node.hasBeenLoaded = false;
                var responder:Responder = new Responder(onResultTreeData, onFaultTreeData);
			    treePresModel.getNodeChildren(node, responder);
			    invalidateList();
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
        override public function expandItem(item:Object, open:Boolean, animate:Boolean=false, dispatchEvent:Boolean=false, cause:Event=null):void
        {
            //trace("TreeViewBase expandItem");
            
            var node:TreeNode = item as TreeNode;
            
            if (open == true)
            {
                var responder:Responder = new Responder(onResultTreeData, onFaultTreeData);
                treePresModel.getNodeChildren(node, responder);                
            }

            super.expandItem(item, open, animate, dispatchEvent, cause);           
        }
        
		protected function expandLater():void
		{
            //trace("TreeViewBase expandLater");  
            
            treePresModel.doneTreeData = true;
            
			if (treePresModel.loadingNode != null)
			{
				var isOpen:Boolean = isItemOpen(treePresModel.loadingNode);
				if (isOpen == false)
				{
	        		expandItem(treePresModel.loadingNode, true, false);
	   			}
  			}			
		}
        
         /**
         * Handler called when tree data service successfully completed
         * 
         * @param data  tree data returned
         */
        protected function onResultTreeData(data:Object):void
        {
            //trace("TreeViewBase onResultTreeData");  
            treePresModel.onResultTreeData(data);
        	callLater(expandLater);
        }

        /**
         * Handler called when server get tree data returns fault
         *  
         * @param info fault info
         * 
         */
        protected function onFaultTreeData(info:Object):void
        {
            //trace("TreeViewBase onFaultGetTreeData" + info);            
        } 
        
        protected function treeChanged(event:Event):void
        {
            //trace("TreeViewBase treeChanged");            
            treePresModel.selectedNode = this.selectedItem as TreeNode;           
        }

        protected var prevItem:Object;
        
        /**
         * Handle toggling open location tree folder on clicks
         *  
         * @param event tree click event
         * 
         */
        protected function treeClicked(event:Event):void
        {            
            //trace("TreeViewBase treeClicked"); 

            // cmis trigger folder list update
            var node:TreeNode = selectedItem as TreeNode;
            if (node.hasBeenLoaded == true)
            {
                treePresModel.doneTreeData = true;
            }                    
            
            var toggle:Boolean = isItemOpen(selectedItem);
            if (toggle == true)
            {
                if (selectedItem == prevItem)
                {
                    expandItem(selectedItem, false, false);
                }
            } 
            else
            {
                expandItem(selectedItem, true, false);
            }
            
            prevItem = selectedItem;
        }
        
    }
}