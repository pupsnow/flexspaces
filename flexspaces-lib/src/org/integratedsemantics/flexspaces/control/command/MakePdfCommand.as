package org.integratedsemantics.flexspaces.control.command
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    import com.universalmind.cairngorm.events.Callbacks;
    
    import org.integratedsemantics.flexspaces.control.delegate.webscript.MakePdfDelegate;
    import org.integratedsemantics.flexspaces.control.event.MakePdfEvent;
    
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    

    /**
     * Make Pdf Command provides the operation to make a pdf version of an adm node 
     * 
     */
    public class MakePdfCommand extends Command
    {
        /**
         * Constructor
         */
        public function MakePdfCommand()
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
                case MakePdfEvent.MAKE_PDF:
                    makePDF(event as MakePdfEvent);  
                    break;
            }
        }       

        /**
         * Perform Make PDF
         * 
         * @param event make pdf event
         */
        public function makePDF(event:MakePdfEvent):void
        {
            var handlers:Callbacks = new Callbacks(onDocActionSuccess, onFault);
            var delegate:MakePdfDelegate = new MakePdfDelegate(handlers);
            delegate.makePDF(event.repoNode);                  
        }

        /**
         * onDocActionSuccess event handler
         * 
         * @param event success event
         */
        protected function onDocActionSuccess(event:*):void
        {
            this.result(event.result);
        }
        
    }
}