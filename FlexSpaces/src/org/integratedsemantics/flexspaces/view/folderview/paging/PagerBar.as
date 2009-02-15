package org.integratedsemantics.flexspaces.view.folderview.paging
{
	import mx.collections.ArrayCollection;
	import mx.controls.ToggleButtonBar;
	import mx.events.ItemClickEvent;
	

    /**
     *  Paging control bar
     * 
     *  Based on FXCPagerBar by Maikel Sibbald info@flexcoders.nl http://labs.flexcoders.nl        
     *  and based on: http://gurufaction.blogspot.com/2007/02/flex-datagrid-paging-example-with.html
     * 
     */
	public class PagerBar extends ToggleButtonBar
	{		
		public var maxVisiblePages:Number = 10;		
		
		private var _pager:Pager;		
		
		private var _totalPages:Number = 1;
		
		[Bindable]
		public var curPageIndex:int = 0;  

        // button selection status
		private var firstDisplayed:int = 0;
		private var lastDisplayed:int = 0;
		private var prevSelectedIndex:int = 0;
		
		
		/**
		 * Constructor 
		 * 
		 */
		public function PagerBar():void
		{
			super();
			this.addEventListener(ItemClickEvent.ITEM_CLICK, this.navigatePage);
		}
		
		public function set pager(value:Pager):void
		{
			this._pager = value;
			this.createNavBar(this.totalPages);
		}
		
		public function get pager():Pager
		{
			return this._pager;
		}
		        
		public function set totalPages(value:Number):void
		{
			this._totalPages = value;
			this.createNavBar(this.totalPages);
		}
		
		public function get totalPages():Number
		{
			return this._totalPages;
		}
		
		/**
		 * Handle page number and first/previous/next/last button
		 *  
		 * @param event click event
		 * 
		 */
		private function navigatePage(event:ItemClickEvent):void
		{			
		    var label:String = event.item.label.toString();
		    
			if (label == "|<")
			{
			    curPageIndex = 0;
			    if (firstDisplayed > 0)  
			    {
			        createNavBar(totalPages, 0);    
			    }  
			    selectedIndex = prevSelectedIndex = 0 + 2;
			}
			else if (label == ">|")  
			{
			    curPageIndex = totalPages - 1;
			    if (lastDisplayed < (totalPages -1))
			    {
            	   createNavBar(totalPages, totalPages - maxVisiblePages);		        
			    }
			    selectedIndex = prevSelectedIndex = dataProvider.length - 1 - 2;
			}
            else if (label == "<")  
            {
                if ( curPageIndex > 0)
                {
                    curPageIndex = curPageIndex - 1;
                    if (firstDisplayed > curPageIndex)
                    {
                        createNavBar(totalPages, firstDisplayed-1);      
                        selectedIndex = prevSelectedIndex = 0 + 2;
                    }
                    else
                    {
                        selectedIndex = prevSelectedIndex - 1;
                        prevSelectedIndex -= 1;
                    }
                }
                else
                {
                    selectedIndex = prevSelectedIndex = 0 + 2;        
                }
            }
            else if (label == ">")  
            {
                if (curPageIndex < (totalPages -1) )
                {
                    curPageIndex = curPageIndex + 1;
                    if (lastDisplayed < curPageIndex)
                    {
                        createNavBar(totalPages, firstDisplayed+1); 
                        selectedIndex = prevSelectedIndex = dataProvider.length - 1 - 2;
                    } 
                    else
                    {
                        selectedIndex = prevSelectedIndex + 1;
                        prevSelectedIndex += 1;
                    }
                }
                else
                {
                    selectedIndex = prevSelectedIndex = dataProvider.length - 1 - 2;    
                }
            }
			else
			{
			    if ( (event.item.data >= 0) && (event.item.data <= (totalPages - 1)) )
			    {
                    curPageIndex = event.item.data;
                    prevSelectedIndex = selectedIndex;                                
                }    			    
			}

            pager.pageIndex = curPageIndex;  
		}
		
		/**
		 * Create inital paging buttons or recreate when display different pages
		 *  
		 * @param pages total num pages
		 * @param start which page to start with
		 * 
		 */
		private function createNavBar(pages:uint, start:uint=0):void
		{
		    dataProvider = new ArrayCollection();
			if ( pages > 1 )
			{
				dataProvider.addItem({label:"|<" ,data:0});
				
                if( (start - maxVisiblePages ) >= 0 )
                {
                    dataProvider.addItem({label:"<", data:start - maxVisiblePages});
                }
                else
                {
                    dataProvider.addItem({label:"<", data:0});
                }
                
                firstDisplayed = x + start;										
				for ( var x:uint = 0; x < maxVisiblePages; x++)
				{
                    if (x + start < totalPages)
                    {
                        var pg:uint = x + start;
                        dataProvider.addItem({label: pg + 1, data: pg});
                        lastDisplayed = pg;
                    }					
				}
				
				if ( (pg + 1) < totalPages-1 )
				{
				    dataProvider.addItem({label:">", data:pg + 1});
				}
				else
				{
				    dataProvider.addItem({label:">", data:totalPages-1});
				}
				dataProvider.addItem({label:">|", data:totalPages-1});
				
				if (start == 0)
				{
				    curPageIndex = 0;
                    pager.pageIndex = curPageIndex;
				    this.selectedIndex = 0 + 2;
				    this.prevSelectedIndex = 0 + 2;
			    }
				
				this.invalidateDisplayList();
			}
		}
				
	}
}
