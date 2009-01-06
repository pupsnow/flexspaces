package org.integratedsemantics.flexspaces.control.command.ui
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    
    import mx.controls.Alert;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.CopyMoveEvent;
    import org.integratedsemantics.flexspaces.control.event.ui.ClipboardUIEvent;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.folder.Folder;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.presmodel.main.FlexSpacesPresModel;
    

    /**
     * ClipboardUICommand provides cut/copy/paste of multiple selected doc/folder node items
     * with internal clipoard 
     * 
     * See AirClipboardUICommand for added support for external native clipboard
     */
    public class ClipboardUICommand extends Command
    {
        protected var flexSpacesPresModel:FlexSpacesPresModel = AppModelLocator.getInstance().flexSpacesPresModel;

        /**
         * Constructor
         */
        public function ClipboardUICommand()
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
                case ClipboardUIEvent.CLIPBOARD_CUT:
                    cut(event as ClipboardUIEvent);  
                    break;
                case ClipboardUIEvent.CLIPBOARD_COPY:
                    copy(event as ClipboardUIEvent);  
                    break;
                case ClipboardUIEvent.CLIPBOARD_PASTE:
                    paste(event as ClipboardUIEvent);  
                    break;
            }
        }       

        /**
         * Cut
         * 
         * @param event clipboard ui event
         */
        public function cut(event:ClipboardUIEvent):void
        {
            var selectedItems:Array = event.selectedItems;
            
            if ( (selectedItems != null) && (selectedItems.length > 0))
            {
                flexSpacesPresModel.cut = selectedItems;
                flexSpacesPresModel.copy = null; 
                if (flexSpacesPresModel.wcmMode == true)
                {
                    flexSpacesPresModel.wcmCutCopy = true;
                }
                else
                {
                    flexSpacesPresModel.wcmCutCopy = false;                    
                }
            }
        }
        
        /**
         * Copy
         * 
         * @param event clipboard ui event
         */
        public function copy(event:ClipboardUIEvent):void
        {
            var selectedItems:Array = event.selectedItems;
            
            if ( (selectedItems != null) && (selectedItems.length > 0))
            {
                flexSpacesPresModel.cut = null;
                flexSpacesPresModel.copy = selectedItems; 
                if (flexSpacesPresModel.wcmMode == true)
                {
                    flexSpacesPresModel.wcmCutCopy = true;
                }
                else
                {
                    flexSpacesPresModel.wcmCutCopy = false;                    
                }
            }            
        }

        /**
         * Paste
         * 
         * @param event clipboard ui event
         * 
         */
        public function paste(event:ClipboardUIEvent):void
        {            
            if ( (flexSpacesPresModel.currentNodeList != null) && (flexSpacesPresModel.currentNodeList is Folder))
            {
                var folder:Folder = flexSpacesPresModel.currentNodeList as Folder;
                var parentNode:IRepoNode = folder.folderNode;
                var responder:Responder = new Responder(event.responder.result, event.responder.fault);
                
                if (flexSpacesPresModel.cut != null)
                {
                    for each (var cutItem:Object in flexSpacesPresModel.cut)
                    {
                        if ( (cutItem != null) && (cutItem is IRepoNode) )
                        {
                            var cutNode:IRepoNode = cutItem as IRepoNode;

                            if ( (flexSpacesPresModel.wcmCutCopy == false) && (flexSpacesPresModel.wcmMode == false) )
                            {
                                //  cut adm -> adm
                                var copyMoveEvent:CopyMoveEvent = new CopyMoveEvent(CopyMoveEvent.MOVE, responder, cutNode, parentNode);
                                copyMoveEvent.dispatch();                    
                                
                            }
                            else if ( (flexSpacesPresModel.wcmCutCopy == true) && (flexSpacesPresModel.wcmMode == true) )
                            {
                                // cut avm -> avm                                
                                copyMoveEvent = new CopyMoveEvent(CopyMoveEvent.AVM_MOVE, responder, cutNode, parentNode); 
                                copyMoveEvent.dispatch();                    
                            }
                            else
                            {
                                // cut/paste between adm and avm not supported
                                mx.controls.Alert.show("Cut / Paste between ADM and AVM not supported. Copy / Paste is supported.");
                            }                        
                        }
                    }
                    flexSpacesPresModel.cut = null;
                }
                else if (flexSpacesPresModel.copy != null)
                {
                    for each (var copyItem:Object in flexSpacesPresModel.copy)
                    {
                        if ( (copyItem != null) && (copyItem is IRepoNode) )
                        {
                            var copyNode:IRepoNode = copyItem as IRepoNode;

                            if  ( (flexSpacesPresModel.wcmCutCopy == false) && (flexSpacesPresModel.wcmMode == false) )
                            {
                                //  copy adm -> adm
                                copyMoveEvent = new CopyMoveEvent(CopyMoveEvent.COPY, responder, copyNode, parentNode);
                                copyMoveEvent.dispatch();                    
                            }
                            else if ( (flexSpacesPresModel.wcmCutCopy == true) && (flexSpacesPresModel.wcmMode == true) )
                            {
                                // copy  avm -> avm
                                copyMoveEvent = new CopyMoveEvent(CopyMoveEvent.AVM_COPY, responder, copyNode, parentNode); 
                                copyMoveEvent.dispatch();                                                                                
                            }
                            else
                            {
                                if (flexSpacesPresModel.wcmCutCopy == true)
                                {
                                    // avm -> adm                                
                                    mx.controls.Alert.show("Only copy from ADM to AVM seems to work on Alfresco, not AVM to ADM");
                                    //copyMoveEvent = new CopyMoveEvent(CopyMoveEvent.AVM_TO_ADM_COPY, responder, copyNode, parentNode);
                                    //copyMoveEvent.dispatch();                    
                                }
                                else
                                {
                                    // adm -> avm                               
                                    copyMoveEvent = new CopyMoveEvent(CopyMoveEvent.ADM_TO_AVM_COPY, responder, copyNode, parentNode);
                                    copyMoveEvent.dispatch();                    
                                }                            
                            }
                        }
                    }
                }
            }    
        }

    }
}