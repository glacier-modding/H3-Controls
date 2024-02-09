package menu3.basic
{
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public dynamic class ThumbnailItemTileState implements IItemTileState
   {
      
      private static const DarkBgAlpha:Number = 0.08;
       
      
      private var m_view:Sprite;
      
      private var m_selectedIcon:MovieClip;
      
      private var m_selectedIcon2:MovieClip;
      
      private var m_tileSelect:Sprite;
      
      private var m_tileSelectPulsate:Sprite;
      
      private var m_icon:MovieClip;
      
      private var m_icon2:MovieClip;
      
      public var m_image:MovieClip;
      
      private var m_tileBg:MovieClip;
      
      private var m_tileDarkBg:MovieClip;
      
      private var m_image_width:int;
      
      private var m_image_height:int;
      
      private var m_desaturateNotComplete:Boolean;
      
      private var m_isCompleted:Boolean;
      
      public function ThumbnailItemTileState(param1:Sprite)
      {
         super();
         this.m_view = param1;
         if(this.m_view.hasOwnProperty("selectedIcon"))
         {
            this.m_selectedIcon = this.m_view["selectedIcon"];
         }
         if(this.m_view.hasOwnProperty("selectedIcon2"))
         {
            this.m_selectedIcon2 = this.m_view["selectedIcon2"];
         }
         if(this.m_view.hasOwnProperty("tileSelect"))
         {
            this.m_tileSelect = this.m_view["tileSelect"];
         }
         if(this.m_view.hasOwnProperty("tileSelectPulsate"))
         {
            this.m_tileSelectPulsate = this.m_view["tileSelectPulsate"];
         }
         if(this.m_view.hasOwnProperty("image"))
         {
            this.m_image = this.m_view["image"];
         }
         if(this.m_view.hasOwnProperty("imageMask"))
         {
            this.m_image_width = this.m_view["imageMask"].width;
            this.m_image_height = this.m_view["imageMask"].height;
         }
         if(this.m_view.hasOwnProperty("icon"))
         {
            this.m_icon = this.m_view["icon"];
         }
         if(this.m_view.hasOwnProperty("icon2"))
         {
            this.m_icon2 = this.m_view["icon2"];
         }
         if(this.m_view.hasOwnProperty("tileBg"))
         {
            this.m_tileBg = this.m_view["tileBg"];
            this.m_tileBg.alpha = 0;
         }
         if(this.m_view.hasOwnProperty("tileDarkBg"))
         {
            this.m_tileDarkBg = this.m_view["tileDarkBg"];
            this.m_tileDarkBg.alpha = DarkBgAlpha;
         }
      }
      
      public function onSetData(param1:Object) : void
      {
         if(this.m_tileSelectPulsate != null)
         {
            this.m_tileSelectPulsate.alpha = 0;
         }
         this.setupIcons(param1.icon);
         this.setupIcons2(param1.icon2);
         switch(param1.opportunitystate)
         {
            case "failed":
               MenuUtils.setColorFilter(this.m_image,"failed");
               break;
            case "disabled":
               MenuUtils.setColorFilter(this.m_image,"failed");
               break;
            case "completed":
               MenuUtils.setColorFilter(this.m_image,"completed");
               break;
            case "untracked":
               MenuUtils.setColorFilter(this.m_image,"available");
               break;
            case "tracked":
               MenuUtils.setColorFilter(this.m_image,"available");
               break;
            default:
               MenuUtils.setColorFilter(this.m_image,"available");
         }
         this.m_desaturateNotComplete = param1.hasOwnProperty("desaturateNotComplete") && Boolean(param1.desaturateNotComplete);
         this.m_isCompleted = param1.completed;
      }
      
      public function destroy() : void
      {
         if(this.m_view == null)
         {
            return;
         }
         this.unloadImage();
         this.m_selectedIcon = null;
         this.m_tileSelect = null;
         if(this.m_tileSelectPulsate != null)
         {
            MenuUtils.pulsate(this.m_tileSelectPulsate,false);
            this.m_tileSelectPulsate = null;
         }
         this.m_icon = null;
         this.m_tileBg = null;
         this.m_tileDarkBg = null;
         this.m_view = null;
      }
      
      public function setTileSelect() : void
      {
         if(this.m_tileSelect != null)
         {
            this.m_tileSelect.visible = true;
         }
         if(this.m_tileSelectPulsate != null)
         {
            MenuUtils.pulsate(this.m_tileSelectPulsate,true);
         }
      }
      
      public function hideTileSelect() : void
      {
         if(this.m_tileSelect != null)
         {
            this.m_tileSelect.visible = false;
         }
         if(this.m_tileSelectPulsate != null)
         {
            MenuUtils.pulsate(this.m_tileSelectPulsate,false);
         }
      }
      
      public function hideTitleAndHeader() : void
      {
      }
      
      public function getView() : Sprite
      {
         return this.m_tileBg;
      }
      
      private function setupIcons(param1:String) : void
      {
         if(this.m_selectedIcon != null)
         {
            if(param1 != null && param1.length > 0)
            {
               this.m_selectedIcon.visible = true;
               MenuUtils.setupIcon(this.m_selectedIcon,param1,MenuConstants.COLOR_GREY_DARK,false,true,MenuConstants.COLOR_WHITE);
            }
            else
            {
               this.m_selectedIcon.visible = false;
            }
         }
         if(this.m_icon != null)
         {
            if(param1 != null && param1.length > 0)
            {
               this.m_icon.visible = true;
               MenuUtils.setupIcon(this.m_icon,param1,MenuConstants.COLOR_GREY_DARK,false,true,MenuConstants.COLOR_WHITE);
            }
            else
            {
               this.m_icon.visible = false;
            }
         }
      }
      
      private function setupIcons2(param1:String) : void
      {
         if(this.m_selectedIcon2 != null)
         {
            if(param1 != null && param1.length > 0)
            {
               this.m_selectedIcon2.visible = true;
               MenuUtils.setupIcon(this.m_selectedIcon2,param1,MenuConstants.COLOR_GREY_DARK,false,true,MenuConstants.COLOR_WHITE);
            }
            else
            {
               this.m_selectedIcon2.visible = false;
            }
         }
         if(this.m_icon2 != null)
         {
            if(param1 != null && param1.length > 0)
            {
               this.m_icon2.visible = true;
               MenuUtils.setupIcon(this.m_icon2,param1,MenuConstants.COLOR_GREY_DARK,false,true,MenuConstants.COLOR_WHITE);
            }
            else
            {
               this.m_icon2.visible = false;
            }
         }
      }
      
      public function setImageFrom(param1:BitmapData) : void
      {
         var _loc2_:Bitmap = null;
         var _loc3_:Number = NaN;
         if(this.m_image == null)
         {
            return;
         }
         this.unloadImage();
         if(param1 != null)
         {
            _loc2_ = new Bitmap(param1);
            if(this.m_desaturateNotComplete)
            {
               if(!this.m_isCompleted)
               {
                  MenuUtils.setColorFilter(this.m_image,"notcompleted");
               }
               else
               {
                  MenuUtils.setColorFilter(this.m_image);
               }
            }
            _loc2_.smoothing = true;
            this.m_image.addChild(_loc2_);
            _loc3_ = _loc2_.width / _loc2_.height;
            this.m_image.width = this.m_image_width;
            this.m_image.height = this.m_image_width / _loc3_;
            if(this.m_image.height < this.m_image_height)
            {
               this.m_image.height = this.m_image_height;
               this.m_image.width = this.m_image_height * _loc3_;
               this.m_image.x = (this.m_image_width - this.m_image.width) / 2;
            }
         }
      }
      
      public function unloadImage() : void
      {
         if(this.m_image == null)
         {
            return;
         }
         while(this.m_image.numChildren > 0)
         {
            this.m_image.removeChildAt(0);
         }
      }
   }
}
