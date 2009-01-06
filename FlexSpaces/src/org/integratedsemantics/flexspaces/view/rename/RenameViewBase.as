package org.integratedsemantics.flexspaces.view.rename
{
    import flash.events.MouseEvent;
    
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    import mx.rpc.Responder;
    
    import mx.containers.FormItem;
    import mx.controls.TextInput;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.DialogViewBase;
    import org.integratedsemantics.flexspaces.presmodel.rename.RenamePresModel;


    /**
     * Base class for rename views  
     * 
     */
    public class RenameViewBase extends DialogViewBase
    {
        public var onComplete:Function;

        public var nameItem:FormItem;
        public var nodename:TextInput;
        
        [Bindable]
        public var renamePresModel:RenamePresModel;


        /**
         * Constructor
         *  
         * @param onComplete  handler to call after renaming
         * 
         */
        public function RenameViewBase(onComplete:Function=null)
        {
            super();

            this.onComplete = onComplete;                        
        }      
        
        /**
         * Handle view creation complete by requesting name property data from server 
         * 
         * @param creation complete event
         * 
         */
        override protected function onCreationComplete(event:FlexEvent):void
        {
            super.onCreationComplete(event);

            if (renamePresModel.isAvmStore == true)
            {
                // for avm stores use name area for viewing storeid
                // todo i18n
                nameItem.label = "AVM Store:";
            } 
                                                                                                                                                                                                  // disable ok,cancel, have close if don't have write permission 
            // get properties
        	renamePresModel.getProperties();                
        }
        
        /**
         * Handle ok buttion click
         * 
         * @param click event
         * 
         */
        override protected function onOkBtn(event:MouseEvent):void 
        {            
            var responder:Responder = new Responder(onResultSetProperties, onFaultSetProperties);

            if (renamePresModel.isAvmStore == false)
            {
                renamePresModel.setProperties(responder);
            }
            else
            {
                // can't set properties on avm store root dir fake nodes
                PopUpManager.removePopUp(this);
            }                          
        }

        /**
         * Handler called when set properties successfully completed
         * 
         * @info  results info
         */
        protected function onResultSetProperties(info:Object):void
        {            
            PopUpManager.removePopUp(this);
            if (onComplete != null)
            {
                onComplete();
            }                        
        }
        
        /**
         * Handler for set properties fault 
         * 
         * @param info fault info
         * 
         */
        protected function onFaultSetProperties(info:Object):void
        {
            PopUpManager.removePopUp(this);
            trace("onFaultSetProperties" + info);
        }

          
    }
}