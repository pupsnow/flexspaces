package org.integratedsemantics.flexspaces.view.properties.configured
{
    import com.adobe.serialization.json.JSON;
    
    import mx.containers.FormItem;
    import mx.events.FlexEvent;
    import mx.rpc.AsyncToken;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.http.HTTPService;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.FormBase;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.presmodel.properties.basic.PropertiesPresModel;
    
    import spark.components.Label;
    

    /**
     * Base class for view properties views  
     * 
     */
    public class ConfiguredViewPropertiesViewBase extends FormBase
    {
        [Bindable]
        public var propPresModel:PropertiesPresModel;
        
        private var formDefinition:Object;
                
                
        /**
         * Constructor
         * 
         * @param onComplete  handler to call after properites setting
         * 
         */
        public function ConfiguredViewPropertiesViewBase()
        {
            super();
        }        
        
        /**
         * Handle creation complete 
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:FlexEvent):void
        {
        }
        
        public function getFormProperties(repoNode:IRepoNode):void
        {
            var service:HTTPService = new HTTPService;            
            var model:AppModelLocator = AppModelLocator.getInstance();
            service.url = model.ecmServerConfig.shareUrl + "/page/";            
            service.url += "components/form";
            service.resultFormat = "text";
                        
            service.addEventListener(ResultEvent.RESULT, onGetFormPropertiesComplete);           
            service.addEventListener(FaultEvent.FAULT, onFaultGetFormProperties);

            var parameters:Object = new Object();
            parameters.alf_ticket = model.userInfo.loginTicket;            
            parameters.itemKind = "node";
            parameters.itemId = repoNode.getNodeRef();    
            if (model.appConfig.propertiesFormName != "")
            {
                parameters.formId = model.appConfig.propertiesFormName;                
            }
            parameters.mode = "edit";
            parameters.format = "json";
            
            var result:AsyncToken = null;
            result = service.send(parameters);                                   
        }
        
        private function onGetFormPropertiesComplete(event:ResultEvent):void
        {
            var dataStr:String = String(event.result);
            formDefinition = JSON.decode(dataStr);                  

            var fields:Object = formDefinition.fields as Object;
            var structures:* = formDefinition.structure;
            var structure:* = structures[0];
            for (var i:int = 0; i < structure.children.length; i++)
            {
                var structChild:* =  structure.children[i];
                var key:* = structChild.id;
                var field:Object = fields[key];
                switch (field.dataType)
                {
                    case "text":
                    case "mltext":
                    case "date":
                    case "datetime":
                    case "int":
                    case "long":
                    case "double":
                    case "float":
                    case "boolean":
                        var formItem:FormItem = new FormItem();
                        formItem.percentWidth = 100;
                        formItem.label = field.label + ":";
                        formItem.id = field.dataKeyName + "_item";
                        var control:UIComponent;
                        control = new Label();
                        control.percentWidth = 100;
                        control.id = field.dataKeyName;
                        control.text = field.value;
                        formItem.addChild(control);
                        this.addChild(formItem);
                        break;
                    default:
                        // todo: support displaying other datatypes
                        break;                           
                }                        
            }                                    
        }        
        
        private function onFaultGetFormProperties(event:FaultEvent):void
        {
            trace("onFaultGetFormProperties fault");           
        }
                                
    }
}