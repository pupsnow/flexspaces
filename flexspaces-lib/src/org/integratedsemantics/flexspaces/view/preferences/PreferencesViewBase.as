package org.integratedsemantics.flexspaces.view.preferences
{
    import flash.events.MouseEvent;
    
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.DialogViewBase;
    import org.integratedsemantics.flexspaces.presmodel.preferences.PreferencesPresModel;
    
    import spark.components.CheckBox;
    import spark.components.TextInput;


    /**
     * Base class for preferences views  
     * 
     */
    public class PreferencesViewBase extends DialogViewBase
    {
        public var domain:TextInput;
        public var protocol:TextInput;
        public var port:TextInput;

        public var showTasks:CheckBox;
        
        public var enableCalais:CheckBox;
        public var calaisKey:TextInput;

        public var enableGoogleMap:CheckBox;
        public var googleMapKey:TextInput;
        public var googleMapUrl:TextInput;
        
        
        [Bindable]
        public var preferencesPresModel:PreferencesPresModel;
        
        
        /**
         * Constructor 
         */
        public function PreferencesViewBase()
        {
            super();
        }  
        
        /**
         * Handle view creation complete
         * 
         * @param creation complete event
         * 
         */
        override protected function onCreationComplete(event:FlexEvent):void
        {
            super.onCreationComplete(event);
            
            preferencesPresModel.init();
            
            domain.text = preferencesPresModel.domain;
            protocol.text = preferencesPresModel.protocol;
            port.text = preferencesPresModel.port;
            showTasks.selected = preferencesPresModel.showTasks;
            
            enableCalais.selected = preferencesPresModel.enableCalais;
            calaisKey.text = preferencesPresModel.calaisKey;
            enableGoogleMap.selected = preferencesPresModel.enableGoogleMap;
            //googleMapKey.text = preferencesPresModel.googleMapKey;
            //googleMapUrl.text = preferencesPresModel.googleMapUrl;                        
        }                

        /**
         * Handle ok buttion click
         * 
         * @param click event
         * 
         */
        override protected function onOkBtn(event:MouseEvent):void 
        {
            PopUpManager.removePopUp(this);
            
            preferencesPresModel.save();
        }
              
    }
}