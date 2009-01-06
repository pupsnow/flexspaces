package org.integratedsemantics.flexspaces.presmodel.deletion
{
    import flash.events.MouseEvent;
    
    import mx.collections.ArrayCollection;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.DeleteEvent;
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.repo.RepoNode;


    /**
     *  Delete dialog presentation model which confirms deletion of listed files before deleting
     *  
     */
    [Bindable] 
    public class DeletePresModel extends PresModel
    {
        public var selectedItems:Array;
        
        public var wcmMode:Boolean = false;
        
        public var remainingItems:ArrayCollection;
        
        public var parentPath:String = null;
        
        public var folderDeletion:Boolean = false;
        
        public var filesToDeleteDisplay:String = "";
        
        protected var viewResponder:Responder = null;
        
                        
        /**
         * Constructor 
         * 
         * @param deleteView  view for to control
         * @param selectedItems  array of node items to delete
         * @param wcmMode  is this for deleting wcm/avm nodes
         * 
         */
        public function DeletePresModel(selectedItems:Array, wcmMode:Boolean=false)
        {
            super();
            
            this.selectedItems = selectedItems;
            this.wcmMode = wcmMode;
            
            // formant display list of files to delete
            filesToDeleteDisplay = "";
            for each (var selectedItem:Object in selectedItems)
            {
                if (selectedItem != null)
                {
                    if (filesToDeleteDisplay == "")
                    {
                        filesToDeleteDisplay = selectedItem.name; 
                    }  
                    else
                    {
                        filesToDeleteDisplay = filesToDeleteDisplay + ", " + selectedItem.name; 
                    }
                    
                    var repoNode:RepoNode = selectedItem as RepoNode;
                    if (repoNode.isFolder == true)
                    {
                    	parentPath = repoNode.parentPath;
                    	folderDeletion = true;
                    }
                }
                else
                {
                    // todo
                }
            }
        }
                
        /**
         * Handle deletion operation(s) by requesting first delete node server operation
         * 
         * 
         */
        public function deleteNodes(viewResponder:Responder):void 
        {
        	this.viewResponder = viewResponder;
        	
            remainingItems = new ArrayCollection(selectedItems);
            deleteItem(remainingItems.getItemAt(0));
        }
        
        /**
         * Delete one node
         * 
         * @param item node to delete
         * 
         */
        protected function deleteItem(item:Object):void
        {
            var responder:Responder = new Responder(onResultDelete, onFaultDelete);
            if (wcmMode == false)
            {
                var deleteEvent:DeleteEvent = new DeleteEvent(DeleteEvent.DELETE, responder, item as IRepoNode);
                deleteEvent.dispatch();
            }
            else
            {
                deleteEvent = new DeleteEvent(DeleteEvent.DELETE_AVM, responder, item as IRepoNode);
                deleteEvent.dispatch();
            }              
        }
        
        /**
         * Handle successful completion of a delete operation
         * Kick off next one, or close dialog if all done
         *  
         * @param info delete operation result info
         * 
         */
        protected function onResultDelete(info:Object):void
        {
            if (remainingItems.length > 0)
            {
                remainingItems.removeItemAt(0);
            }
            
            if (remainingItems.length == 0)
            {
            	viewResponder.result(info);
            } 
            else
            {
                deleteItem(remainingItems.getItemAt(0));
            }                         
        }

        /**
         * Handle error in a delete operation
         * 
         * @param info delete operation fault info
         */
        protected function onFaultDelete(info:Object):void
        {
            trace("onFaultDelete " +  (remainingItems.getItemAt(0)).name + " " + info);            
            viewResponder.fault(info);
        }        
        
    }
}