package org.integratedsemantics.sampleapp.view.main
{
    import mx.events.FlexEvent;
    
    import org.integratedsemantics.flexspaces.view.main.FlexSpacesViewBase;
    import org.integratedsemantics.sampleapp.presmodel.main.SampleAppPresModel;


    public class MainViewBase extends FlexSpacesViewBase
    {
        public function MainViewBase()
        {
            super();
        }
        
        [Bindable]
        public function get sampleAppPresModel():SampleAppPresModel
        {
            return this.flexSpacesPresModel as SampleAppPresModel;
        }

        public function set sampleAppPresModel(sampleAppPresModel:SampleAppPresModel):void
        {
            this.flexSpacesPresModel = sampleAppPresModel;            
        }               
        
        /**
         * Handle creation complete of repository browser after login
         *  
         * @param event on create complete event
         * 
         */
        override protected function onRepoBrowserCreated(event:FlexEvent):void
        {    
            super.onRepoBrowserCreated(event);  
        }
                
        /**
         * Switch on menu data to method for both main menu bar
         * and context menus
         *  
         * @param data menu command
         * 
         */
        override protected function handleBothKindsOfMenus(data:String):void
        {    
            var selectedItem:Object = flexSpacesPresModel.selectedItem;   
            var selectedItems:Array = flexSpacesPresModel.selectedItems; 
            
            switch(data)
            {
                default:
                    super.handleBothKindsOfMenus(data);
                    break;            
            }
        }            
        
    }
}