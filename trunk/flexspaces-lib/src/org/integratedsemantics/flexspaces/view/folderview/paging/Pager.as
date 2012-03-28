package org.integratedsemantics.flexspaces.view.folderview.paging
{
    import flash.events.Event;
   
    import mx.collections.ArrayCollection;
    import mx.collections.ICollectionView;
    import mx.collections.IList;
    import mx.collections.ListCollectionView;
    import mx.collections.Sort;
    import mx.collections.SortField;
    import mx.core.UIComponent;
    import mx.events.CollectionEvent;
    import mx.events.CollectionEventKind;
   
    /**
     *  Pager for array collections
     * 
     *  Based on FXCPager by Maikel Sibbald info@flexcoders.nl http://labs.flexcoders.nl        
     *  and based on: http://gurufaction.blogspot.com/2007/02/flex-datagrid-paging-example-with.html
     * 
     */
    [Bindable]      
    public class Pager extends UIComponent
    {
        public var clientSidePage:Boolean = true;
   
        private var _index:int              = 0;
        private var _pageSize:int           = 10;
        private var _pageData:ArrayCollection  = new ArrayCollection();
        private var collection:ICollectionView;
        private var _totalPages:int = 1;
        private var prevSortField:String = null;
        private var descending:Boolean = false;
      
        private function refreshDataProvider(event:Event= null):void
        {
            var data:ArrayCollection = collection as ArrayCollection;
            if (data != null)
            {
                if (clientSidePage == true)
                {  
                    this.pageData = new ArrayCollection( data.toArray().slice((this.pageIndex * this.pageSize),(this.pageIndex * this.pageSize) + this.pageSize) );
                }
                else
                {
                    // paged data done serverside in web scripts
                    this.pageData = new ArrayCollection( data.toArray() );            
                }            
            }
        }
      
      public function set pageData(value:ArrayCollection):void
      {
         this._pageData = value;
      }
      
      public function get pageData():ArrayCollection
      {
         return _pageData;
      }
      
      public function set pageIndex(value:int):void
      {
         this._index = value;
         this.refreshDataProvider();
      }
      
      public function get pageIndex():int{
         return _index;
      }
      
      public function set pageSize(value:int):void
      {
         this._pageSize = value;
         this.refreshDataProvider();
      }
      
      public function get pageSize():int
      {
         return _pageSize;
      }
      
      [Bindable("collectionChange")]
       [Inspectable(category="Data", defaultValue="undefined")]
   
       public function get dataProvider():Object
       {
           return collection;
       }

       /**
        *   set data provider to page
        */
       public function set dataProvider(value:Object):void
       {
           if (collection)
           {
               collection.removeEventListener(CollectionEvent.COLLECTION_CHANGE, this.refreshDataProvider);
           }
         if (value is Array)
         {
               collection = new ArrayCollection(value as Array);
           }
           else if (value is ICollectionView)
           {
               collection = ICollectionView(value);
         }
         else if (value is IList)
         {
               collection = new ListCollectionView(IList(value));
         }
         else
         {
               // convert it to an array containing this one item
               var tmp:Array = [];
               if (value != null)
                   tmp.push(value);
               collection = new ArrayCollection(tmp);
         }
 
           collection.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.refreshDataProvider, false, 0, true);
   
           var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
           event.kind = CollectionEventKind.RESET;
           this.refreshDataProvider(event);
           dispatchEvent(event);
        }

        public function set totalSize(totalSize:int):void
        {
            if (clientSidePage == false)
            {
                totalPages = Math.max(Math.ceil(totalSize/pageSize),1);
            }
        }

        public function set dataSize(dataSize:int):void
        {
            if (clientSidePage == true)
            {
                totalPages = Math.max(Math.ceil(dataSize/pageSize),1);
            }
        }

        public function get totalPages():int 
        {             
            return _totalPages;
        }
        
        public function set totalPages(pages:int):void
        {
            _totalPages = pages;
        }
        
        public function sortColumn(dataField:String):void
        {
            var sort:Sort = new Sort();
            
            if ((prevSortField != null) && (prevSortField == dataField))
            {
                descending = !descending;
            } 
            else
            {
                descending = false;
            }
            sort.fields = [new SortField(dataField,false, descending)];
            collection.sort = sort;
            collection.refresh();
            prevSortField = dataField;
        }
        
   }  
   
}
