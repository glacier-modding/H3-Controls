package menu3.containers
{
   import common.CommonUtils;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import common.menu.textTicker;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import menu3.MenuElementBase;
   
   public dynamic class ListContainerWithHeader extends ListContainer
   {
       
      
      private const HEADLINE_OFFSET_X:Number = 10;
      
      private const HEADLINE_OFFSET_Y:Number = 16;
      
      private const HEADLINE_VERTICAL_OFFSET:Number = 12;
      
      private const HEADLINE_BG_WIDTH_OFFSET:Number = -5;
      
      private const HEADLINE_BG_HEIGHT_OFFSET:Number = -5;
      
      private const HEADLINE_TEXT_RIGHT_OFFSET:Number = 20;
      
      private var m_headLineView:ListContainerHeadlineView = null;
      
      private var m_headLineTitleText:String;
      
      private var m_headLineTitlePos:Point;
      
      private var m_currentLocalPos:Point;
      
      protected var m_headLineVerticalView:* = null;
      
      private var m_scrollListContainer:ScrollingListContainer;
      
      private var m_previousScrollPosX:Number;
      
      private var m_containerBoundsWidth:Number;
      
      private var m_containerBoundsHeight:Number;
      
      private var m_isFloatingPositionActive:Boolean;
      
      private var m_textTicker:textTicker;
      
      public function ListContainerWithHeader(param1:Object)
      {
         super(param1);
         this.m_currentLocalPos = new Point(0,0);
         if(param1.headlinetitle)
         {
            if(m_direction == "horizontal")
            {
               this.m_headLineView = new ListContainerHeadlineView();
               this.m_headLineView.visible = false;
               this.m_headLineView.title.x = this.HEADLINE_OFFSET_X;
               this.m_headLineTitlePos = new Point(this.m_headLineView.title.x,this.m_headLineView.title.y);
               addChildAt(this.m_headLineView,0);
               MenuUtils.setupTextUpper(this.m_headLineView.title,param1.headlinetitle,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
               this.m_headLineTitleText = this.m_headLineView.title.htmlText;
               this.m_headLineView.title.selectable = false;
               this.m_headLineView.x = 0;
               this.m_headLineView.y = int((this.m_headLineView.height + this.HEADLINE_OFFSET_Y) * -1);
               MenuUtils.setColor(this.m_headLineView.bg,MenuConstants.COLOR_MENU_TABS_BACKGROUND,true,MenuConstants.MenuElementBackgroundAlpha);
               this.addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
            }
            else if(m_direction == "vertical")
            {
               this.m_headLineVerticalView = this.createHeadLineVerticalView();
               this.m_headLineVerticalView.visible = false;
               addChildAt(this.m_headLineVerticalView,0);
               MenuUtils.setupTextUpper(this.m_headLineVerticalView.title,param1.headlinetitle,24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
               this.m_headLineVerticalView.title.selectable = false;
               this.m_headLineVerticalView.title.autoSize = TextFieldAutoSize.RIGHT;
               this.m_headLineVerticalView.y = -3;
               this.m_headLineVerticalView.x = this.HEADLINE_VERTICAL_OFFSET * -1;
               MenuUtils.setColor(this.m_headLineVerticalView.bg,MenuConstants.COLOR_MENU_TABS_BACKGROUND,true,MenuConstants.MenuElementBackgroundAlpha);
            }
         }
      }
      
      public function onAdded(param1:Event) : void
      {
         this.removeEventListener(Event.ADDED_TO_STAGE,this.onAdded);
         this.addEventListener(Event.ENTER_FRAME,this.positionHeadlineTitle);
         this.m_scrollListContainer = parent.parent as ScrollingListContainer;
      }
      
      protected function createHeadLineVerticalView() : *
      {
         return new ListContainerHeadlineVerticalView();
      }
      
      private function positionHeadlineTitle() : void
      {
         var _loc5_:Number = NaN;
         if(this.m_scrollListContainer == null || this.m_headLineView == null || m_children.length == 0)
         {
            return;
         }
         var _loc1_:Number = this.m_scrollListContainer.getPositionX();
         if(_loc1_ == this.m_previousScrollPosX)
         {
            return;
         }
         this.m_previousScrollPosX = _loc1_;
         var _loc2_:Boolean = false;
         var _loc3_:Point = new Point(0,0);
         var _loc4_:Rectangle;
         if((_loc4_ = this.m_headLineView.getBounds(this.m_scrollListContainer)).x < 0)
         {
            _loc5_ = this.m_containerBoundsWidth - this.HEADLINE_TEXT_RIGHT_OFFSET - this.m_headLineView.title.textWidth;
            _loc5_ = Math.max(_loc5_,0);
            _loc3_.x = _loc4_.x * -1;
            if(_loc3_.x <= _loc5_)
            {
               _loc2_ = true;
            }
            else
            {
               _loc3_.x = _loc5_;
            }
         }
         this.setFloatingPositionHeadLineTitle(_loc2_,_loc3_);
      }
      
      private function setFloatingPositionHeadLineTitle(param1:Boolean, param2:Point) : void
      {
         var _loc3_:Rectangle = null;
         if(this.m_headLineView == null || param2 == null || m_children.length == 0)
         {
            return;
         }
         if(this.m_isFloatingPositionActive == param1 && this.m_currentLocalPos.x == param2.x && this.m_currentLocalPos.y == param2.y)
         {
            return;
         }
         this.m_isFloatingPositionActive = param1;
         this.m_currentLocalPos = param2;
         if(!param1)
         {
            this.m_headLineView.addChild(this.m_headLineView.title);
            this.m_headLineView.title.x = param2.x + this.HEADLINE_OFFSET_X;
            this.m_headLineView.title.y = this.m_headLineTitlePos.y;
         }
         else
         {
            _loc3_ = this.m_headLineView.title.getBounds(this.m_scrollListContainer);
            this.m_scrollListContainer.addChild(this.m_headLineView.title);
            this.m_headLineView.title.x = this.HEADLINE_OFFSET_X;
            this.m_headLineView.title.y = _loc3_.y;
         }
      }
      
      override public function onUnregister() : void
      {
         this.setFloatingPositionHeadLineTitle(false,this.m_headLineTitlePos);
         this.removeEventListener(Event.ENTER_FRAME,this.positionHeadlineTitle);
         super.onUnregister();
      }
      
      override public function repositionChild(param1:Sprite) : void
      {
         super.repositionChild(param1);
         this.updateHeadlineTitle();
      }
      
      private function updateHeadlineTitle() : void
      {
         var bgWidth:Number = NaN;
         var bgHeight:Number = NaN;
         var containerBounds:Rectangle = getMenuElementBounds(this,this,function(param1:MenuElementBase):Boolean
         {
            return param1.visible;
         });
         if(this.m_headLineView != null)
         {
            this.m_headLineView.visible = false;
            this.m_containerBoundsWidth = containerBounds.width;
            bgWidth = this.m_containerBoundsWidth + this.HEADLINE_BG_WIDTH_OFFSET;
            this.m_headLineView.bg.width = bgWidth;
            this.m_headLineView.bg.x = this.m_containerBoundsWidth / 2;
            this.m_headLineView.title.width = this.m_containerBoundsWidth - this.HEADLINE_OFFSET_X * 2;
            MenuUtils.setupTextUpper(this.m_headLineView.title,this.m_headLineTitleText,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
            this.m_headLineView.visible = true;
            MenuUtils.truncateTextfield(this.m_headLineView.title,1,MenuConstants.FontColorWhite);
         }
         if(this.m_headLineVerticalView != null)
         {
            this.m_containerBoundsHeight = containerBounds.height;
            bgHeight = this.m_containerBoundsHeight + this.HEADLINE_BG_HEIGHT_OFFSET;
            this.m_headLineVerticalView.bg.height = bgHeight;
            this.m_headLineVerticalView.bg.y = this.m_containerBoundsHeight / 2;
            this.m_headLineVerticalView.visible = true;
         }
      }
      
      override protected function handleChildSelectionChange() : void
      {
         if(this.m_headLineView.title == null)
         {
            return;
         }
         if(m_isChildSelected)
         {
            if(!this.m_textTicker)
            {
               this.m_textTicker = new textTicker();
            }
            this.m_textTicker.startTextTickerHtml(this.m_headLineView.title,this.m_headLineTitleText,CommonUtils.changeFontToGlobalIfNeeded);
         }
         else if(this.m_textTicker)
         {
            this.m_textTicker.stopTextTicker(this.m_headLineView.title,this.m_headLineTitleText);
            this.m_textTicker = null;
            MenuUtils.truncateTextfield(this.m_headLineView.title,1,MenuConstants.FontColorWhite);
         }
      }
   }
}
