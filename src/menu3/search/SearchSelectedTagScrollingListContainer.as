package menu3.search
{
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import menu3.MenuElementBase;
   import menu3.containers.ScrollingListContainer;
   
   public dynamic class SearchSelectedTagScrollingListContainer extends ScrollingListContainer
   {
       
      
      private const GROUPHEADER_HEIGHT:Number = 56.32;
      
      private const GROUPHEADER_OFFSET_X:Number = 10;
      
      private var m_groupHeader:ContractSearchTagGroupHeaderView = null;
      
      private var m_background:Sprite = null;
      
      private var m_emptyElements:Array;
      
      private var m_elementHeight:Number = 0;
      
      private var m_emptyElementFillCount:Number = 1;
      
      public function SearchSelectedTagScrollingListContainer(param1:Object)
      {
         this.m_emptyElements = new Array();
         var _loc2_:Number = param1.offsetRow != undefined ? Number(param1.offsetRow) : 0;
         _loc2_ += this.GROUPHEADER_HEIGHT / MenuConstants.GridUnitHeight;
         param1.offsetRow = _loc2_;
         super(param1);
         setScrollIndicatorColors();
         if(param1.elementnrows != undefined)
         {
            this.m_elementHeight = param1.elementnrows * MenuConstants.GridUnitHeight;
         }
         if(param1.emptyelementfillcount != undefined)
         {
            this.m_emptyElementFillCount = Math.max(param1.emptyelementfillcount,0);
         }
         this.setupGroupHeader(param1);
         this.setupBackground();
         var _loc3_:int = param1.emptycount != undefined ? int(param1.emptycount) : 5;
         this.setupEmptyElements(_loc3_);
         this.repositionAllElements();
      }
      
      override public function repositionChild(param1:Sprite) : void
      {
         super.repositionChild(param1);
         this.repositionAllElements();
      }
      
      override public function getVisibleContainerBounds() : Rectangle
      {
         var _loc1_:MenuElementBase = null;
         if(m_children.length > 0)
         {
            _loc1_ = m_children[0];
         }
         var _loc2_:Rectangle = _loc1_.getVisualBounds(this);
         var _loc3_:int = Math.max(m_children.length + this.m_emptyElementFillCount,this.m_emptyElements.length);
         _loc2_.height = _loc3_ * this.m_elementHeight;
         return _loc2_;
      }
      
      private function setupGroupHeader(param1:Object) : void
      {
         this.m_groupHeader = new ContractSearchTagGroupHeaderView();
         this.m_groupHeader.bg.visible = false;
         this.m_groupHeader.label_txt.selectable = false;
         this.m_groupHeader.x = this.GROUPHEADER_OFFSET_X;
         this.m_groupHeader.y = 0;
         addChild(this.m_groupHeader);
         var _loc2_:String = !!param1.title ? String(param1.title) : "";
         MenuUtils.setupText(this.m_groupHeader.label_txt,_loc2_,24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         MenuUtils.truncateTextfield(this.m_groupHeader.label_txt,1);
         if(param1.icon)
         {
            MenuUtils.setupIcon(this.m_groupHeader.icon,param1.icon,MenuConstants.COLOR_WHITE,true,false);
         }
      }
      
      private function setupBackground() : void
      {
         var _loc1_:Rectangle = new Rectangle(0,0,getWidth(),getHeight());
         _loc1_.inflate(0,5);
         this.m_background = new Sprite();
         addChildAt(this.m_background,0);
         this.m_background.graphics.clear();
         this.m_background.graphics.beginFill(MenuConstants.COLOR_MENU_SOLID_BACKGROUND,1);
         this.m_background.graphics.drawRect(_loc1_.x,_loc1_.y,_loc1_.width,_loc1_.height);
         this.m_background.graphics.endFill();
      }
      
      private function setupEmptyElements(param1:int) : void
      {
         var _loc3_:Sprite = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1)
         {
            _loc3_ = new ContractSearchSelectedTagElementEmptyView();
            MenuUtils.setColor(_loc3_,MenuConstants.COLOR_MENU_SOLID_BACKGROUND,false);
            _loc3_.alpha = 1;
            this.m_emptyElements.push(_loc3_);
            getContainer().addChild(_loc3_);
            _loc2_++;
         }
      }
      
      private function repositionAllElements() : void
      {
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         var _loc3_:int = Math.max(m_children.length + this.m_emptyElementFillCount,this.m_emptyElements.length);
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < m_children.length)
         {
            _loc2_ = _loc4_ * this.m_elementHeight;
            _loc4_++;
            m_children[_loc5_].x = _loc1_ + m_xOffset * MenuConstants.GridUnitWidth;
            m_children[_loc5_].y = _loc2_ + m_yOffset * MenuConstants.GridUnitHeight;
            _loc5_++;
         }
         var _loc6_:int = 0;
         while(_loc6_ < this.m_emptyElements.length)
         {
            this.m_emptyElements[_loc6_].visible = false;
            if(_loc4_ < _loc3_)
            {
               this.m_emptyElements[_loc6_].visible = true;
               _loc2_ = _loc4_ * this.m_elementHeight;
               _loc4_++;
               this.m_emptyElements[_loc6_].x = _loc1_ + m_xOffset * MenuConstants.GridUnitWidth;
               this.m_emptyElements[_loc6_].y = _loc2_ + m_yOffset * MenuConstants.GridUnitHeight;
            }
            _loc6_++;
         }
      }
   }
}
