package org.integratedsemantics.flexspaces.control.command
{
    import flash.events.DataEvent;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;


    public interface IUploadHandlers
    {
        /**
         * File open event
         * 
         * @param event open event
         * 
         */
        function openHandler(event:Event):void;
     
        /**
         * File upload progress event handler
         *  
         * @param event
         * 
         */
        function progressHandler(event:ProgressEvent):void;
     
        /**
         * File upload complete handler
         *  
         * @param event complete event
         * 
         */
        function completeHandler(event:Event):void;
     
        /**
         * File uploaded and data returned event handler
         *  
         * @param event upload data complete event
         * 
         */
        function uploadCompleteDataHandler(event:DataEvent):void; 

        /**
         * file i/o error handler
         *  
         * @param event io error event
         * 
         */
        function ioErrorHandler(event:IOErrorEvent):void;
     
        /**
         * Security error handler
         *  
         * @param event security error event
         * 
         */
        function securityErrorHandler(even:SecurityErrorEvent):void;
        
        /**
         * HTTP status handler 
         * @param event http status event
         * 
         */
        function httpStatusHandler(event:HTTPStatusEvent):void;
        
        // cmis for now have a way to notify, do this for now cause target of a new event is readonly
        function complete(target:Object):void;
                 
    }
}