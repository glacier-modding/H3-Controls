package menu3.basic
{
   import common.menu.MenuUtils;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import menu3.containers.ThumbnailScrollingListContainer;
   
   public dynamic class ThumbnailSelectedltemTile extends Sprite implements IConfigurableMenuResource
   {
      
      private static const SelectedItemOffsetY:Number = 22;
       
      
      private var m_view:ThumbnailSelectedItemTileView;
      
      private var m_tileState:IItemTileState;
      
      private var m_thumbnailScrollingList:ThumbnailScrollingListContainer;
      
      public function ThumbnailSelectedltemTile(param1:ThumbnailScrollingListContainer)
      {
         super();
         this.m_thumbnailScrollingList = param1;
         this.m_view = new ThumbnailSelectedItemTileView();
         this.m_tileState = new ThumbnailItemTileState(this.m_view);
         this.m_view.x = 0;
         this.m_view.y = SelectedItemOffsetY;
         addChild(this.m_view);
         this.m_view.addEventListener(MouseEvent.ROLL_OVER,this.handleMouseRollOverSelection,false,0,false);
      }
      
      public function onSetData(param1:Object) : void
      {
         this.m_tileState.onSetData(param1);
      }
      
      public function onUnregister() : void
      {
         if(this.m_view == null)
         {
            return;
         }
         this.unloadImage();
         this.m_view.removeEventListener(MouseEvent.ROLL_OVER,this.handleMouseRollOverSelection,false);
         this.m_thumbnailScrollingList = null;
         this.m_tileState.destroy();
         this.m_tileState = null;
         removeChild(this.m_view);
         this.m_view = null;
      }
      
      public function onItemSelectionChanged(param1:Object, param2:BitmapData) : void
      {
         this.onSetData(param1);
         this.m_tileState.setImageFrom(param2);
         MenuUtils.setColorFilter(this.m_view.image);
         this.m_tileState.setTileSelect();
      }
      
      public function setImageFrom(param1:BitmapData) : void
      {
         this.m_tileState.setImageFrom(param1);
         MenuUtils.setColorFilter(this.m_view.image);
      }
      
      public function unloadImage() : void
      {
         this.m_tileState.unloadImage();
      }
      
      public function onItemUnselected() : void
      {
         this.m_tileState.hideTileSelect();
      }
      
      private function handleMouseRollOverSelection(param1:MouseEvent) : void
      {
         this.m_thumbnailScrollingList.onSelectedItemRollOver();
      }
   }
}
