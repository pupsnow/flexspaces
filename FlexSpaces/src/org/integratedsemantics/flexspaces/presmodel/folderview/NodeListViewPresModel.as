package org.integratedsemantics.flexspaces.presmodel.folderview
{
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.folder.NodeCollection;


    /**
     * Presentation model for folder like view supporting multiple view modes (icons, detail list, etc.)
     * for any list of nodes such as search results, task attachments, etc.
     * 
     */
    [Bindable] 
    public class NodeListViewPresModel extends PresModel
    {
        public var nodeCollection:NodeCollection;
        
        public var serverVersionNum:Number;

        public var showThumbnails:Boolean = false;

        public var model:AppModelLocator = AppModelLocator.getInstance();

		protected var _selectedItem:Object = null;
		
		protected var _selectedItems:Array = new Array();
		
		
        /**
         * Constructor 
         * 
         */
        public function NodeListViewPresModel()
        {
            super();
            
            serverVersionNum = model.ecmServerConfig.serverVersionNum();  
            
            nodeCollection = new NodeCollection();          
        }

        /** Get selected item (or last selected item if multiple selection
         *  
         * @return selected item 
         * 
         */
        public function get selectedItem():Object
        {
        	return _selectedItem;
        }
                   
        public function set selectedItem(item:Object):void
        {
        	_selectedItem = item;
        }

        /**
         * Get multiple selected items
         *  
         * @return selected items 
         * 
         */
        public function get selectedItems():Array
        {
        	return _selectedItems;
        }

        public function set selectedItems(items:Array):void
        {
        	_selectedItems = items;
        }

        /**
         * Initialize model 
         * 
         */
        public function initModel():void
        {            
        }
        
        public function changeSelection(item:Object, items:Array):void
        {        	
        	_selectedItem = item;
        	_selectedItems = items;	
        }
               
        /**
         * Clear selection in all view modes 
         * 
         */
        public function clearSelection():void
        {
        	// set with public names to kickoff databinding 
            selectedItem = null;
            selectedItems = new Array();
        }        

        /**
         * Clear selection if not selected folder presentation model / view 
         * 
         * @param selectedFolderList selected folder presentation model / view
         * 
         */
        public function clearOtherSelections(selectedFolderList:PresModel):void
        {
            if (selectedFolderList != this)
            {
                clearSelection();
            }
        }
                                     
    }
}