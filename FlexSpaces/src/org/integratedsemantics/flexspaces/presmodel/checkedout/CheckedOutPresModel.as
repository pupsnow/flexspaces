 
package org.integratedsemantics.flexspaces.presmodel.checkedout
{
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.CheckedOutListEvent;
    import org.integratedsemantics.flexspaces.model.checkedout.CheckedOutCollection;
    import org.integratedsemantics.flexspaces.presmodel.folderview.NodeListViewPresModel;


	/**
	 * Presentation model of checked out list for current user 
	 * 
	 */
	[Bindable] 	 	
	public class CheckedOutPresModel extends NodeListViewPresModel
	{
	    /**
	     * Constructor 
	     * 
	     * @param folderView view to control
	     */
	    public function CheckedOutPresModel()
	    {
            super();                        
        }     	
        
        /**
         * Initialize model 
         * 
         */
        override public function initModel():void
        {
            this.nodeCollection = new CheckedOutCollection();       
        }


        /**
		 * Initialize checked out list 
		 * 
		 */
		public function initCheckedOutList():void
		{
    		// get checked out list
            var responder:Responder = new Responder(onResultCheckedOutList, onFaultCheckedOutList);
            var checkedOutListEvent:CheckedOutListEvent = new CheckedOutListEvent(CheckedOutListEvent.CHECKED_OUT_LIST, responder);
            checkedOutListEvent.dispatch();
		}		
		
        /**
         * Handler called for successful call to server to get checked out list
         *  
         * @param data checked out list data result
         * 
         */
        protected function onResultCheckedOutList(data:Object):void
        {
            var checkedOutCollection:CheckedOutCollection = this.nodeCollection as CheckedOutCollection;
            
		    checkedOutCollection.initData(data);		    
        }

        /**
         * Handler call for fault return in response to server call for get checked out liist
         *  
         * @param info fault info
         * 
         */
        protected function onFaultCheckedOutList(info:Object):void
        {
            trace("onFaultCheckedOutList" + info);            
        }
				
     }
}