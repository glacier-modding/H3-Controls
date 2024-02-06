package menu3.basic
{
   import common.Animate;
   import common.MouseUtil;
   import common.menu.MenuConstants;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import menu3.MenuElementTileBase;
   import menu3.MenuImageLoader;
   import menu3.containers.ThumbnailScrollingListContainer;
   
   public dynamic class ThumbnailItemTile extends MenuElementTileBase implements IImageContainer
   {
       
      
      private var m_view:ThumbnailItemTileView;
      
      private var m_tileState:ThumbnailItemTileState;
      
      private var m_isFocusedOnParentList:Boolean = false;
      
      private var m_loader:MenuImageLoader;
      
      private var m_imageData:BitmapData;
      
      private var m_imagePath:String = null;
      
      private var m_expandedToHeight:int;
      
      private const ExpanderAlpha:Number = 0.2;
      
      private const MinimumHeight:Number = 165;
      
      public function ThumbnailItemTile(param1:Object)
      {
         super(param1);
         m_mouseMode = MouseUtil.MODE_ONOVER_HOVER_ONUP_SELECT;
         this.m_view = new ThumbnailItemTileView();
         this.m_tileState = new ThumbnailItemTileState(this.m_view.collapsed);
         if(this.m_view.mouseOverIndicator)
         {
            this.m_view.mouseOverIndicator.visible = false;
         }
         addChild(this.m_view);
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         this.m_tileState.onSetData(param1);
         if(param1.image)
         {
            this.m_imagePath = param1.image;
            if(param1.ondemand == undefined || !param1.ondemand)
            {
               this.loadImage();
            }
         }
         else
         {
            this.m_imagePath = null;
         }
         if(param1.expandedHeight)
         {
            this.m_expandedToHeight = param1.expandedHeight;
         }
         else
         {
            this.m_expandedToHeight = 300;
         }
         var _loc2_:ThumbnailScrollingListContainer = this.getParentThumbnailScrollingList();
         if(_loc2_ != null)
         {
            _loc2_.onReloadData(this,param1);
         }
      }
      
      override public function onUnregister() : void
      {
         if(this.m_view)
         {
            this.killAnimations();
            this.unloadImage();
            if(this.m_tileState)
            {
               this.m_tileState.destroy();
               this.m_tileState = null;
            }
            removeChild(this.m_view);
            this.m_view = null;
         }
         super.onUnregister();
      }
      
      override public function getView() : Sprite
      {
         return this.m_tileState.getView();
      }
      
      private function completeAnimations() : void
      {
         Animate.complete(this.m_view.expander);
         if(this.m_view.mouseOverIndicator)
         {
            Animate.complete(this.m_view.mouseOverIndicator);
         }
      }
      
      private function killAnimations() : void
      {
         Animate.kill(this.m_view.expander);
         if(this.m_view.mouseOverIndicator)
         {
            Animate.kill(this.m_view.mouseOverIndicator);
         }
      }
      
      public function isImageLoaded() : Boolean
      {
         return this.m_loader != null;
      }
      
      public function unloadImage() : void
      {
         if(this.m_loader == null)
         {
            return;
         }
         this.m_loader.cancelIfLoading();
         this.m_loader = null;
         this.m_imageData = null;
         if(this.m_tileState != null)
         {
            this.m_tileState.unloadImage();
         }
      }
      
      public function loadImage() : void
      {
         if(this.m_imagePath == null)
         {
            return;
         }
         this.unloadImage();
         this.m_loader = new MenuImageLoader();
         this.m_loader.loadImage(this.m_imagePath,function():void
         {
            var _loc1_:ThumbnailScrollingListContainer = null;
            if(m_imageData != null)
            {
               m_imageData = null;
            }
            m_imageData = m_loader.getImageData();
            if(m_imageData != null)
            {
               m_tileState.setImageFrom(m_imageData);
               _loc1_ = getParentThumbnailScrollingList();
               if(m_isFocusedOnParentList && _loc1_ != null)
               {
                  _loc1_.onImageLoaded(m_imageData);
               }
            }
         });
      }
      
      public function setFocusedOnParentList(param1:Boolean) : void
      {
         if(param1 == this.m_isFocusedOnParentList)
         {
            return;
         }
         this.m_isFocusedOnParentList = param1;
         if(this.m_isFocusedOnParentList)
         {
            this.onExpand(true);
         }
         else
         {
            this.onCollapse(true);
         }
      }
      
      private function getParentThumbnailScrollingList() : ThumbnailScrollingListContainer
      {
         if(parent == null || parent.parent == null)
         {
            return null;
         }
         return parent.parent as ThumbnailScrollingListContainer;
      }
      
      override protected function handleSelectionChange() : void
      {
         this.completeAnimations();
         var _loc1_:ThumbnailScrollingListContainer = this.getParentThumbnailScrollingList();
         if(m_isSelected)
         {
            if(_loc1_ != null)
            {
               _loc1_.onItemSelected(getData(),this.m_imageData);
            }
         }
         else if(_loc1_ != null)
         {
            _loc1_.onItemUnselected();
         }
      }
      
      public function setItemHover(param1:Boolean) : void
      {
         if(this.m_view.mouseOverIndicator)
         {
            if(m_isSelected || this.m_isFocusedOnParentList)
            {
               this.m_view.mouseOverIndicator.visible = false;
            }
            else
            {
               this.m_view.mouseOverIndicator.visible = param1;
               this.m_view.mouseOverIndicator.alpha = 0;
               Animate.legacyTo(this.m_view.mouseOverIndicator,MenuConstants.HiliteTime,{"alpha":1},Animate.SineIn);
            }
         }
      }
      
      private function onExpand(param1:Boolean) : void
      {
         this.completeAnimations();
         if(this.m_view.mouseOverIndicator)
         {
            this.m_view.mouseOverIndicator.visible = false;
         }
         this.m_view.collapsed.alpha = 0;
         this.m_view.expander.alpha = this.ExpanderAlpha;
         Animate.to(this.m_view.expander,MenuConstants.HiliteTime,0,{"height":this.m_expandedToHeight},Animate.SineIn,this.onExpandComplete);
      }
      
      public function onExpandComplete() : void
      {
         this.m_view.expander.alpha = 0;
         this.m_view.collapsed.alpha = 0;
      }
      
      private function onCollapse(param1:Boolean) : void
      {
         this.completeAnimations();
         this.m_view.collapsed.alpha = 0;
         this.m_view.expander.alpha = this.ExpanderAlpha;
         Animate.to(this.m_view.expander,MenuConstants.HiliteTime,0,{"height":this.MinimumHeight},Animate.SineIn,this.onCollapseComplete);
      }
      
      private function onCollapseComplete() : void
      {
         this.m_view.expander.alpha = 0;
         this.m_view.collapsed.alpha = 1;
      }
   }
}
