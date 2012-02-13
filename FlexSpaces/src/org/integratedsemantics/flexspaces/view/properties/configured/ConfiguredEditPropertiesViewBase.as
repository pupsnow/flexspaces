package org.integratedsemantics.flexspaces.view.properties.configured
{
    //import com.adobe.serialization.json.JSON;
    
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    import flex.utils.spark.resize.ResizableTextAreaSkin;
    
    import mx.controls.DateField;
    import mx.events.CalendarLayoutChangeEvent;
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    import mx.rpc.AsyncToken;
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.http.HTTPService;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.FormBase;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.presmodel.properties.basic.PropertiesPresModel;
    
    import spark.components.CheckBox;
    import spark.components.FormItem;
    import spark.components.TextArea;
    import spark.components.TextInput;
    import spark.events.TextOperationEvent;
    

    /**
     * Base class for properties views  
     * 
     */
    public class ConfiguredEditPropertiesViewBase extends FormBase
    {
        [Bindable]
        public var propPresModel:PropertiesPresModel;
        
        private var formDefinition:Object;
        
        private var changedData:Object = new Object();
        
                
        /**
         * Constructor
         * 
         * @param onComplete  handler to call after properites setting
         * 
         */
        public function ConfiguredEditPropertiesViewBase()
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
            formDefinition = JSON.parse(dataStr);                  

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
                        // todo: fix only having textarea for description
                        // although don't want all mltext fields to have textarea
                        if (field.dataKeyName == "prop_cm_description")
                        {
                            var textArea:TextArea = new TextArea();
                            textArea.heightInLines = 2;
                            textArea.setStyle("skinClass", ResizableTextAreaSkin);
                            textArea.text = field.value;
                            textArea.addEventListener(TextOperationEvent.CHANGE, onTextAreaChange);
                            textArea.percentWidth = 100;
                            textArea.id = field.dataKeyName;
                            formItem.addChild(textArea);
                        }
                        else if (field.dataType == "boolean")
                        {
                            var checkbox:CheckBox = new CheckBox();
                            if (field.value == true)
                            {
                                checkbox.selected = true;
                            }
                            checkbox.addEventListener(Event.CHANGE, onCheckBoxChange);
                            checkbox.percentWidth = 100;
                            checkbox.id = field.dataKeyName;
                            formItem.addChild(checkbox);
                        }
                        else if (field.dataType == "date")
                        {
                            var dateField:DateField = new DateField();
                            dateField.styleName = "input";
                            // todo parse date 
                            dateField.text = field.value;  
                            dateField.addEventListener(CalendarLayoutChangeEvent.CHANGE, onDateChange);                            
                            dateField.percentWidth = 100;
                            dateField.id = field.dataKeyName;
                            formItem.addChild(dateField);
                        }
                        else if (field.dataType == "datetime")
                        {
                            dateField = new DateField();
                            dateField.styleName = "input";
                            // todo parse date 
                            dateField.text = field.value;
                            dateField.addEventListener(CalendarLayoutChangeEvent.CHANGE, onDateChange);    
                            dateField.percentWidth = 100;
                            dateField.id = field.dataKeyName;
                            formItem.addChild(dateField);
                            // todo add text field for time
                        }
                        else
                        {
                            var textInput:TextInput = new TextInput();
                            textInput.text = field.value;
                            textInput.addEventListener(TextOperationEvent.CHANGE, onTextInputChange);
                            textInput.percentWidth = 100;
                            textInput.id = field.dataKeyName;
                            formItem.addChild(textInput);
                        }
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
                
        private function onTextInputChange(event:Event):void
        {
           var control:TextInput = event.target as TextInput; 
           changedData[control.id] = control.text;
        }
        
        private function onTextAreaChange(event:Event):void
        {
            var control:TextArea = event.target as TextArea; 
            changedData[control.id] = control.text;
        }
        
        private function onCheckBoxChange(event:Event):void
        {
            var control:CheckBox = event.target as CheckBox; 
            changedData[control.id] = control.selected;
        }
        
        private function onDateChange(event:Event):void
        {
            var control:DateField = event.target as DateField;
            // todo: need to have date reformatting before can save
            //todo changedData[control.id] = control.text;
        }
        
        public function setFormProperties(repoNode:IRepoNode, responder:IResponder):void
        {
            var model:AppModelLocator = AppModelLocator.getInstance();
            var itemId:String = "workspace/SpacesStore/" + repoNode.getId();
            var url:String = model.ecmServerConfig.urlPrefix + "/api/node/" + itemId + "/formprocessor";
            url = url + "?alf_ticket=" + model.userInfo.loginTicket + "&alf_method=POST";
            
            var jsonStr:String = JSON.stringify(changedData);      
            
            var request:URLRequest = new URLRequest(url);
            request.contentType = "application/json";
            request.data = jsonStr;
            request.method = "POST";
            var loader:URLLoader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, responder.result);
            loader.addEventListener(IOErrorEvent.IO_ERROR, responder.fault);
            loader.load(request);
        }
        
        public function haveChanges():Boolean
        {
            var changesMade:Boolean = false;
            if (countKeys(changedData) > 0)
            {
                changesMade = true;
            }
            return changesMade;
        }
                        
        private static function countKeys(obj:Object):int 
        {
            var n:int = 0;
            for (var key:* in obj)
            {
                n++;
            }
            return n;
        }        
        
    }
}