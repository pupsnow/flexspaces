package org.integratedsemantics.flexspaces.component.deletion
{
    import flash.events.MouseEvent;
    
    import mx.collections.ArrayCollection;
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.DeleteEvent;
    import org.integratedsemantics.flexspaces.framework.dialog.DialogPresenter;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


    /**
     *  Delete dialog which confirms deletion of listed files before deleting
     *  
     *  Presenter/Controller of DeleteViewBase views 
     * 
     */
    public class DeletePresenter extends DialogPresenter
    {
        protected var selectedItems:Array;
        protected var wcmMode:Boolean = false;
        protected var onComplete:Function;
        protected var remainingItems:ArrayCollection;
                        
        /**
         * Constructor 
         * 
         * @param deleteView  view for to control
         * @param selectedItems  array of node items to delete
         * @param wcmMode  is this for deleting wcm/avm nodes
         * @param onComplete  handler to call after each node deletion
         * 
         */
        public function DeletePresenter(deleteView:DeleteViewBase, selectedItems:Array, wcmMode:Boolean=false, onComplete:Function=null)
        {
            super(deleteView);
            
            this.selectedItems = selectedItems;
            this.wcmMode = wcmMode;
            this.onComplete = onComplete;
        }
        
        /**
         * Getter for the view
         *  
         * @return this view
         * 
         */
        protected function get deleteView():DeleteViewBase
        {
            return this.view as DeleteViewBase;            
        }       

        /**
         * Init the dialog with the display of list of files to delete 
         * 
         * @param creation complete event
         * 
         */
        override protected function onCreationComplete(event:FlexEvent):void
        {
            super.onCreationComplete(event);
            
            // display list of files to delete
            deleteView.filelist.text = "";
            for each (var selectedItem:Object in selectedItems)
            {
                if (selectedItem != null)
                {
                    if (deleteView.filelist.text == "")
                    {
                        deleteView.filelist.text = selectedItem.name; 
                    }  
                    else
                    {
                        deleteView.filelist.text = deleteView.filelist.text + ", " + selectedItem.name; 
                    }
                }
                else
                {
                    // todo
                }
            }
        }
                
        /**
         * Handle ok buttion click by requesting first delete node server operation
         * 
         * @param click event
         * 
         */
        override protected function onOkBtn(event:MouseEvent):void 
        {
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
            if (wcmMode == false)
            {
                var responder:Responder = new Responder(onResultDelete, onFaultDelete);
                var deleteEvent:DeleteEvent = new DeleteEvent(DeleteEvent.DELETE, responder, item as IRepoNode);
                deleteEvent.dispatch();
            }
            else
            {
                responder = new Responder(onResultDelete, onFaultDelete);
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
                PopUpManager.removePopUp(dialogView);
                if (onComplete != null)
                {
                    onComplete();
                }          
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
            PopUpManager.removePopUp(dialogView);
        }        
        
    }
}