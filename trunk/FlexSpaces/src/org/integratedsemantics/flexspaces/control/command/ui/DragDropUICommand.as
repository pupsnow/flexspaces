package org.integratedsemantics.flexspaces.control.command.ui
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    
    import mx.managers.DragManager;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.CopyMoveEvent;
    import org.integratedsemantics.flexspaces.control.event.ui.DropNodesUIEvent;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.presmodel.main.FlexSpacesPresModel;
    

    /**
     * DragDropUICommand provides internal drag/drop of multiple selected doc/folder node items
     * 
     * 
     * See AirDragDropUICommand class for added support for external native drag drop
     */
    public class DragDropUICommand extends Command
    {
        protected var model:FlexSpacesPresModel = AppModelLocator.getInstance().flexSpacesPresModel;

        /**
         * Constructor
         */
        public function DragDropUICommand()
        {
            super();
        }

        /**
         * Execute command for the given event
         *  
         * @param event event calling command
         * 
         */
        override public function execute(event:CairngormEvent):void
        {
            // always call the super.execute() method which allows the 
            // callBack information to be cached.
            super.execute(event);
 
            switch(event.type)
            {
                case DropNodesUIEvent.DROP_NODES:
                    dropNodes(event as DropNodesUIEvent);  
                    break;
            }
        }       

        /**
         * Handle dropping node items
         *  
         * @param event drop nodes ui event         * 
         */
        protected function dropNodes(event:DropNodesUIEvent):void
        {    
            for each (var item:Object in event.items)
            {
                if (item is IRepoNode)
                {
                    var repoNode:IRepoNode = item as IRepoNode;
                    dropNode(event, repoNode);
                }
            }
        }

        /**
         * Drop Node
         * 
         * @param event drop nodes ui event
         * @param repoNode node to copy or move
         * 
         */
        protected function dropNode(event:DropNodesUIEvent, repoNode:IRepoNode):void
        {            
            var responder:Responder = new Responder(event.responder.result, event.responder.fault);

            if (event.action == DragManager.MOVE)
            {
                if ( model.wcmMode == false )
                {
                    //  move adm -> adm
                    var copyMoveEvent:CopyMoveEvent = new CopyMoveEvent(CopyMoveEvent.MOVE, responder, repoNode, event.parentNode);
                    copyMoveEvent.dispatch();                    
                }
                else
                {
                    // move avm -> avm                            
                    copyMoveEvent = new CopyMoveEvent(CopyMoveEvent.AVM_MOVE, responder, repoNode, event.parentNode);
                    copyMoveEvent.dispatch();                                                                    
                }
            }
            else if (event.action == DragManager.COPY) 
            {
                if  ( model.wcmMode == false )
                {
                    //  copy adm -> adm
                    copyMoveEvent = new CopyMoveEvent(CopyMoveEvent.COPY, responder, repoNode, event.parentNode);
                    copyMoveEvent.dispatch();                    
                }
                else
                {
                    // copy  avm -> avm
                    copyMoveEvent = new CopyMoveEvent(CopyMoveEvent.AVM_COPY, responder, repoNode, event.parentNode);
                    copyMoveEvent.dispatch();                                                                    
                }                                                
            }
        }

    }
}