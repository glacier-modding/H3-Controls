package menu3.containers
{
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import menu3.ScreenResizeEvent;
   import menu3.basic.SimpleButtonTile;
   
   public dynamic class SimpleButtonTileScrollingListContainer extends ScrollingListContainer
   {
       
      
      private var m_background:Sprite;
      
      private var m_screenWidth:Number;
      
      private var m_screenHeight:Number;
      
      private var m_safeAreaRatio:Number;
      
      private var m_originalBarPosX:Number;
      
      private var m_yPos:Number;
      
      private var m_tileFound:Boolean;
      
      public function SimpleButtonTileScrollingListContainer(param1:Object)
      {
         this.m_originalBarPosX = (MenuConstants.MenuWidth - MenuConstants.BaseWidth) * 0.5;
         super(param1);
         this.m_screenWidth = isNaN(param1.sizeX) ? MenuConstants.BaseWidth : Number(param1.sizeX);
         this.m_screenHeight = isNaN(param1.sizeY) ? MenuConstants.BaseHeight : Number(param1.sizeY);
         this.m_safeAreaRatio = isNaN(param1.safeAreaRatio) ? 1 : Number(param1.safeAreaRatio);
         this.m_background = new Sprite();
         this.m_background.visible = false;
         this.createBackgroundGraphics();
         addChildAt(this.m_background,0);
         this.m_background.x = this.m_originalBarPosX;
      }
      
      override public function onUnregister() : void
      {
         if(this.m_background)
         {
            removeChild(this.m_background);
            this.m_background = null;
         }
         super.onUnregister();
      }
      
      override public function repositionChild(param1:Sprite) : void
      {
         var _loc2_:SimpleButtonTile = null;
         var _loc3_:Rectangle = null;
         super.repositionChild(param1);
         if(!this.m_tileFound)
         {
            _loc2_ = this.GetFirstSimpleButtonTile(this);
            if(_loc2_ != null)
            {
               _loc3_ = _loc2_.getView().getRect(this);
               this.m_yPos = _loc3_.y;
               this.m_background.y = this.m_yPos + 1;
               this.m_background.visible = true;
               this.m_tileFound = true;
            }
         }
      }
      
      private function GetFirstSimpleButtonTile(param1:BaseContainer) : SimpleButtonTile
      {
         var _loc3_:SimpleButtonTile = null;
         var _loc4_:BaseContainer = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.m_children.length)
         {
            _loc3_ = null;
            if((_loc4_ = param1.m_children[_loc2_] as BaseContainer) != null)
            {
               _loc3_ = this.GetFirstSimpleButtonTile(_loc4_);
            }
            else
            {
               _loc3_ = param1.m_children[_loc2_] as SimpleButtonTile;
            }
            if(_loc3_ != null)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      private function createBackgroundGraphics() : void
      {
         this.m_background.graphics.clear();
         this.m_background.graphics.beginFill(MenuConstants.COLOR_MENU_TABS_BACKGROUND,MenuConstants.MenuElementBackgroundAlpha);
         this.m_background.graphics.drawRect(0,0,MenuConstants.BaseWidth,MenuConstants.SimpleButtonTileScrollingListContainerHeight);
         this.m_background.graphics.endFill();
      }
      
      override protected function onAddedToStage(param1:Event) : void
      {
         super.onAddedToStage(param1);
         this.scaleBackground();
      }
      
      override protected function onScreenResize(param1:ScreenResizeEvent) : void
      {
         super.onScreenResize(param1);
         var _loc2_:Object = param1.screenSize;
         this.m_screenWidth = _loc2_.sizeX;
         this.m_screenHeight = _loc2_.sizeY;
         this.m_safeAreaRatio = _loc2_.safeAreaRatio;
         this.scaleBackground();
      }
      
      private function scaleBackground() : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc1_:Number = MenuConstants.BaseWidth;
         var _loc2_:Number = 0;
         if(ControlsMain.isVrModeActive())
         {
            _loc1_ = MenuConstants.MenuWidth + MenuConstants.ScrollingList_VR_ExtendWidth * 2;
            _loc2_ = MenuConstants.ScrollingList_VR_ExtendWidth * -1;
         }
         else
         {
            _loc3_ = MenuUtils.getFillAspectScale(MenuConstants.BaseWidth,MenuConstants.BaseHeight,this.m_screenWidth,this.m_screenHeight) * this.m_safeAreaRatio;
            _loc1_ = _loc4_ = this.m_screenWidth / _loc3_;
            _loc2_ = this.m_originalBarPosX + (MenuConstants.BaseWidth - _loc1_) / 2;
         }
         this.m_background.width = _loc1_;
         this.m_background.x = _loc2_;
      }
   }
}
