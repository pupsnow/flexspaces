package org.integratedsemantics.flexspaces.view.wcm.tree
{
    import flash.events.Event;
    
    import mx.events.ListEvent;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.model.wcm.tree.WcmTreeNode;
    import org.integratedsemantics.flexspaces.presmodel.wcm.tree.WcmTreePresModel;
    import org.integratedsemantics.flexspaces.view.tree.TreeViewBase;
    
        
    /**
     * Base view class for repository tree views
     * 
     */
    public class WcmTreeViewBase extends TreeViewBase
    {        
        /**
         * Constructor 
         */
        public function WcmTreeViewBase()
        {
            super();
        }        
        
        /**
         * Getter for the wcm tree view pres model
         *  
         * @return the wcm tree pes model
         * 
         */
        [Bindable] 
        public function get wcmTreePresModel():WcmTreePresModel
        {
            return this.treePresModel as WcmTreePresModel;            
        }       

        public function set wcmTreePresModel(wcmTreePresModel:WcmTreePresModel):void
        {
            this.treePresModel = wcmTreePresModel;  
        }       

        /**
         * Handle view creation complete 
         * 
         * @param creation complete event
         * 
         */
        override protected function onCreationComplete(event:Event):void
        {
            addEventListener(ListEvent.CHANGE, treeChanged);
            addEventListener(ListEvent.ITEM_CLICK, treeClicked);                       

            var responder:Responder = new Responder(onResultGetStores, onFaultGetStores);
            wcmTreePresModel.getStores(responder);                                      	
        }
        
        /**
         * Set the selected node based on folder path
         *  
         * @param path folder path of tree node to select
         * 
         */
        override public function setPath(path:String):void
        {
        	var oldLabelField:String = labelField;
        	labelField = "path";
        	selectedIndex = -1;
			var foundAndSelected:Boolean = findString(path);
			labelField = oldLabelField;
			
			if (foundAndSelected == true)
			{
			    var node:WcmTreeNode = selectedItem as WcmTreeNode;
			    
			    if (node.path == path)
			    {
			    	if (node.hasBeenLoaded == false)
			    	{
	                    if (path.length > 4)
	                    {
			                var responder:Responder = new Responder(onResultTreeData, onFaultTreeData);
	                        wcmTreePresModel.getNodeChildren(node, responder);                            
	                    }
				    }
			    }
			    else
			    {
					//trace("WcmTreePresModel.setPath: findString found wrong node " + path + " " + node.path);			
			    }                                                                
			}
			else
			{
				//trace("WcmTreePresModel.setPath: path not found " + path);			    					
			}
        } 

        /**
         * Handler called when tree data service successfully completed
         * 
         * @param data tree data return
         */
        override protected function onResultTreeData(data:Object):void
        {
        	wcmTreePresModel.onResultWcmTreeData(data);
            callLater(expandLater);        	
        }
        
        /**
         * Handler called when server get tree data returns fault
         *  
         * @param info fault info
         * 
         */
        override protected function onFaultTreeData(info:Object):void
        {
            trace("onFaultWcmTreeData" + info);            
        }                                
        
        /**
         * Handler called when store data service successfully completed
         * 
         * @param data store data
         */
        public function onResultGetStores(data:Object):void
        {
        	wcmTreePresModel.onResultGetStores(data);
         	callLater(expandLater);        	
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