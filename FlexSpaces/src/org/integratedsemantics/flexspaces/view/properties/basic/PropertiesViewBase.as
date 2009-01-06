package org.integratedsemantics.flexspaces.view.properties.basic
{
    import flash.events.MouseEvent;
    
    import mx.containers.FormItem;
    import mx.controls.Text;
    import mx.controls.TextInput;
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.DialogViewBase;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.presmodel.properties.basic.PropertiesPresModel;


    /**
     * Base class for properties views  
     * 
     */
    public class PropertiesViewBase extends DialogViewBase
    {
        public var onComplete:Function;

        public var nameItem:FormItem;
        public var nodename:TextInput;
        public var titleItem:FormItem;
        public var nodetitle:TextInput;        
        public var descriptionItem:FormItem;
        public var description:TextInput;
        public var authorItem:FormItem;
        public var author:TextInput;

        public var sizeItem:FormItem;
        public var size:Text;

        public var creatorItem:FormItem;
        public var creator:Text;
        public var createdItem:FormItem;
        public var created:Text;
        public var modifierItem:FormItem;
        public var modifier:Text;
        public var modifiedItem:FormItem;
        public var modified:Text;

        public var mimetypeItem:FormItem;
        public var mimetype:Text;
        public var encodingItem:FormItem;
        public var encoding:Text;
        public var emailidItem:FormItem;
        public var emailid:Text;
        
        public var editinlineItem:FormItem;
        public var editinline:Text;

        [Bindable]
        public var propPresModel:PropertiesPresModel;

                
        /**
         * Constructor
         * 
         * @param onComplete  handler to call after properites setting
         * 
         */
        public function PropertiesViewBase(onComplete:Function=null)
        {
            super();

            this.onComplete = onComplete;            
        }        
        
        /**
         * Handle creation complete 
         * 
         * @param creation complete event
         * 
         */
        override protected function onCreationComplete(event:FlexEvent):void
        {
            super.onCreationComplete(event);

            if (propPresModel.isAvmStore == true)
            {
                // for avm store roots use name area for viewing storeid
                // todo i18n
                nameItem.label = "AVM Store:";                    
            }
            
            // get properties
        	propPresModel.getProperties();                
        }
        
        /**
         * Handle close buttion click
         * (not for X close in title area)
         * (used when no write permissions)
         * 
         * @param click event
         * 
         */
        override protected function onCloseBtn(event:MouseEvent):void 
        {            
            PopUpManager.removePopUp(this);
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

            if (propPresModel.isAvmStore == false)
            {
                propPresModel.setProperties(responder);
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
         * @info results info
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