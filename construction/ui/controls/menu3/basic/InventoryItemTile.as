package menu3.basic
{
   import common.Animate;
   import common.Log;
   import common.MouseUtil;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import fl.motion.Color;
   import flash.display.Sprite;
   import flash.text.TextField;
   import menu3.MenuElementTileBase;
   import menu3.MenuImageLoader;
   
   public dynamic class InventoryItemTile extends MenuElementTileBase
   {
      
      public static const ITEM_SIZE_WIDTH:int = 140;
      
      public static const ITEM_SIZE_HEIGHT:int = 80;
      
      public static const ITEM_SIZE_SMALL_WIDTH:int = 98;
      
      public static const ITEM_SIZE_SMALL_HEIGHT:int = 56;
      
      private static const ITEM_STATE_NORMAL:int = 0;
      
      private static const ITEM_STATE_SELECTED:int = 1;
      
      private static const ITEM_STATE_NOT_PRESSABLE:int = 2;
      
      private static const ITEM_STATE_NOT_PRESSABLE_SELECTED:int = 3;
      
      private static const ITEM_STATE_HIGHLIGHTED:int = 4;
      
      private static const ITEM_STATE_HIGHLIGHTED_SELECTED:int = 5;
       
      
      private const WIGGLE_ROTATION:int = 1;
      
      private var m_rot:Number = 1;
      
      protected var m_isSmallView:Boolean = false;
      
      protected var m_view:*;
      
      protected var m_rotationBase:Sprite;
      
      private var m_loader:MenuImageLoader;
      
      private var m_textObj:Object;
      
      private var m_pressable:Boolean = true;
      
      private var m_isHighlighted:Boolean = false;
      
      private var m_isPressable:Boolean = true;
      
      public var m_itemName:String = "";
      
      public var m_itemCount:int = 0;
      
      public var m_uniqueId:int;
      
      private var m_infoIndicatorWithTitle:InfoIndicatorWithTitleSmallView;
      
      private var m_saveSlotHeaderIndicator:SaveSlotHeaderIndicatorView;
      
      private var m_itemNaxe_txt:TextField;
      
      private var m_iconRid:String = "";
      
      private var m_details:InventoryItemDetail = null;
      
      private var m_rarityIndicator:Sprite = null;
      
      public function InventoryItemTile(param1:Object)
      {
         this.m_textObj = new Object();
         super(param1);
         this.m_isSmallView = param1.small === true;
         if(this.m_isSmallView)
         {
            this.m_view = new InventorySmallItemTileView();
         }
         else
         {
            this.m_view = new InventoryItemTileView();
         }
         this.m_view.tileSelect.alpha = 0;
         this.m_view.tileSelectPulsate.alpha = 0;
         this.m_view.tileBg.alpha = 0;
         this.m_view.tileBorder.alpha = 0;
         this.m_rotationBase = new Sprite();
         this.m_rotationBase.x = this.m_view.x + this.m_view.width * 0.5;
         this.m_rotationBase.y = this.m_view.y + this.m_view.height * 0.5;
         this.m_view.x -= this.m_view.width * 0.5;
         this.m_view.y -= this.m_view.height * 0.5;
         this.m_rotationBase.addChild(this.m_view);
         addChild(this.m_rotationBase);
         this.m_details = new InventoryItemDetail();
         this.m_details.x = ITEM_SIZE_WIDTH + 30;
         addChild(this.m_details);
         this.m_rarityIndicator = new Sprite();
         this.m_view.addChild(this.m_rarityIndicator);
      }
      
      override public function onSetData(param1:Object) : void
      {
         var _loc5_:int = 0;
         super.onSetData(param1);
         Log.debugData(this,param1);
         var _loc2_:String = this.m_itemName;
         this.m_itemName = param1.label;
         this.m_itemCount = param1.count;
         this.m_uniqueId = param1.uniqueId;
         var _loc3_:String = "";
         if(param1.count != undefined)
         {
            if((_loc5_ = int(param1.count)) > 1)
            {
               _loc3_ = "x" + _loc5_.toString();
            }
         }
         MenuUtils.setupText(this.m_view.countLabel,_loc3_,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraLight);
         this.m_isPressable = true;
         if(getNodeProp(this,"pressable") == false)
         {
            this.m_isPressable = false;
         }
         if(getNodeProp(this,"selectable") == false)
         {
            m_mouseMode = MouseUtil.MODE_ONOVER_HOVER_ONUP_SELECT;
         }
         else
         {
            m_mouseMode = MouseUtil.MODE_ONOVER_SELECT_ONUP_CLICK;
         }
         if(param1.highlighted != undefined)
         {
            this.m_isHighlighted = param1.highlighted;
         }
         var _loc4_:String = "";
         if(this.m_itemName != null && this.m_itemName.length > 0)
         {
            _loc4_ = String(param1.icon);
         }
         if(this.m_iconRid != _loc4_)
         {
            this.m_iconRid = _loc4_;
            this.destroyImageLoader();
            if(_loc4_ != null && _loc4_.length > 0)
            {
               this.m_loader = new MenuImageLoader();
               if(this.m_isSmallView)
               {
                  this.m_loader.x = ITEM_SIZE_WIDTH - ITEM_SIZE_SMALL_WIDTH * 0.5;
                  this.m_loader.y = ITEM_SIZE_SMALL_HEIGHT * 0.5;
               }
               else
               {
                  this.m_loader.x = ITEM_SIZE_WIDTH * 0.5;
                  this.m_loader.y = ITEM_SIZE_HEIGHT * 0.5;
               }
               this.m_view.addChild(this.m_loader);
               this.loadIconImage(this.m_loader,_loc4_);
            }
         }
         if(param1.enableColor === false)
         {
            MenuUtils.setTintColor(this.m_view.tileDarkBg,MenuUtils.TINT_COLOR_GREY);
            MenuUtils.setTintColor(this.m_view.tileBorder,MenuUtils.TINT_COLOR_GREY);
         }
         else
         {
            MenuUtils.setTintColor(this.m_view.tileDarkBg,MenuUtils.TINT_COLOR_RED);
            MenuUtils.setTintColor(this.m_view.tileBorder,MenuUtils.TINT_COLOR_RED);
         }
         this.m_details.onSetData(param1);
         this.m_details.visible = false;
         this.updateRarity(param1.rarity);
         this.updateStates();
      }
      
      private function updateRarity(param1:String) : void
      {
         this.m_rarityIndicator.graphics.clear();
         if(param1 == null || param1.length == 0)
         {
            return;
         }
         var _loc2_:uint = 14409180;
         if(param1 == "ITEMRARITY_UNCOMMON")
         {
            _loc2_ = 6222732;
         }
         else if(param1 == "ITEMRARITY_RARE")
         {
            _loc2_ = 7845610;
         }
         var _loc3_:Number = 24;
         var _loc4_:Number;
         var _loc5_:Number = (_loc4_ = this.m_isSmallView ? ITEM_SIZE_WIDTH + 3 : ITEM_SIZE_WIDTH - 2) - _loc3_;
         var _loc6_:Number;
         var _loc7_:Number = (_loc6_ = this.m_isSmallView ? ITEM_SIZE_SMALL_HEIGHT - 2 : ITEM_SIZE_HEIGHT - 2) - _loc3_;
         this.m_rarityIndicator.graphics.beginFill(_loc2_,1);
         this.m_rarityIndicator.graphics.moveTo(_loc4_,_loc6_);
         this.m_rarityIndicator.graphics.lineTo(_loc5_,_loc6_);
         this.m_rarityIndicator.graphics.lineTo(_loc4_,_loc7_);
         this.m_rarityIndicator.graphics.lineTo(_loc4_,_loc6_);
         this.m_rarityIndicator.graphics.endFill();
      }
      
      override public function getView() : Sprite
      {
         return this.m_view.tileBg;
      }
      
      override protected function handleSelectionChange() : void
      {
         super.handleSelectionChange();
         if(m_loading)
         {
            return;
         }
         this.updateStates();
      }
      
      public function onSetHighlighted(param1:Boolean) : void
      {
         if(param1 == this.m_isHighlighted)
         {
            return;
         }
         this.m_isHighlighted = param1;
         this.updateStates();
      }
      
      private function updateStates() : void
      {
         if(!this.m_isPressable)
         {
            if(m_isSelected)
            {
               this.setState(ITEM_STATE_NOT_PRESSABLE_SELECTED);
            }
            else
            {
               this.setState(ITEM_STATE_NOT_PRESSABLE);
            }
         }
         else if(this.m_isHighlighted)
         {
            if(m_isSelected)
            {
               this.setState(ITEM_STATE_HIGHLIGHTED_SELECTED);
            }
            else
            {
               this.setState(ITEM_STATE_HIGHLIGHTED);
            }
         }
         else if(m_isSelected)
         {
            this.setState(ITEM_STATE_SELECTED);
         }
         else
         {
            this.setState(ITEM_STATE_NORMAL);
         }
      }
      
      private function setState(param1:int) : void
      {
         this.animateWiggleStop();
         Animate.complete(this.m_view.tileSelect);
         this.m_view.tileBorder.alpha = 0;
         this.m_view.tileDarkBg.alpha = 1;
         this.m_details.visible = false;
         if(param1 == ITEM_STATE_HIGHLIGHTED_SELECTED)
         {
            this.animateWiggle();
            this.m_details.visible = true;
            Animate.to(this.m_view.tileSelect,MenuConstants.HiliteTime,0,{"alpha":1},Animate.Linear);
            MenuUtils.pulsate(this.m_view.tileSelectPulsate,true);
         }
         else if(param1 == ITEM_STATE_HIGHLIGHTED)
         {
            this.animateWiggle();
            MenuUtils.pulsate(this.m_view.tileSelectPulsate,false);
            this.m_view.tileSelectPulsate.alpha = 0.5;
            this.m_view.tileSelect.alpha = 1;
         }
         else if(param1 == ITEM_STATE_NOT_PRESSABLE_SELECTED)
         {
            Animate.to(this.m_view.tileSelect,MenuConstants.HiliteTime,0,{"alpha":1},Animate.Linear);
            MenuUtils.pulsate(this.m_view.tileSelectPulsate,true);
            this.m_view.tileDarkBg.alpha = 0.3;
         }
         else if(param1 == ITEM_STATE_NOT_PRESSABLE)
         {
            this.m_view.tileSelect.alpha = 0;
            MenuUtils.pulsate(this.m_view.tileSelectPulsate,false);
            this.m_view.tileBorder.alpha = 1;
            this.m_view.tileDarkBg.alpha = 0.3;
         }
         else if(param1 == ITEM_STATE_SELECTED)
         {
            this.m_details.visible = true;
            Animate.to(this.m_view.tileSelect,MenuConstants.HiliteTime,0,{"alpha":1},Animate.Linear);
            MenuUtils.pulsate(this.m_view.tileSelectPulsate,true);
         }
         else
         {
            this.m_view.tileSelect.alpha = 0;
            MenuUtils.pulsate(this.m_view.tileSelectPulsate,false);
         }
      }
      
      private function animateWiggle() : void
      {
         Animate.to(this.m_rotationBase,0.15,0,{"rotation":this.m_rot},Animate.SineInOut,this.animateWiggle);
         this.m_rot *= -1;
      }
      
      private function animateWiggleStop() : void
      {
         Animate.kill(this.m_rotationBase);
         this.m_rotationBase.rotation = 0;
         this.m_rot = this.WIGGLE_ROTATION;
      }
      
      override public function onUnregister() : void
      {
         if(this.m_view)
         {
            this.completeAnimations();
            this.destroyImageLoader();
            removeChild(this.m_view);
            this.m_view = null;
         }
         if(this.m_details)
         {
            this.m_details.onUnregister();
            removeChild(this.m_details);
         }
         super.onUnregister();
      }
      
      private function destroyImageLoader() : void
      {
         if(this.m_loader != null)
         {
            this.m_loader.cancelIfLoading();
            this.m_view.removeChild(this.m_loader);
            this.m_loader = null;
         }
      }
      
      private function completeAnimations() : void
      {
         this.animateWiggleStop();
         Animate.complete(this.m_view.tileSelect);
         MenuUtils.pulsate(this.m_view.tileSelectPulsate,false);
      }
      
      private function loadIconImage(param1:MenuImageLoader, param2:String) : void
      {
         var BORDER:int;
         var max_width:Number = NaN;
         var max_height:Number = NaN;
         var imageLoader:MenuImageLoader = param1;
         var rid:String = param2;
         Log.info(Log.ChannelDebug,this,"loadIconImage: " + rid);
         BORDER = 20;
         if(this.m_isSmallView)
         {
            max_width = ITEM_SIZE_SMALL_WIDTH - BORDER;
            max_height = ITEM_SIZE_SMALL_HEIGHT - BORDER;
         }
         else
         {
            max_width = ITEM_SIZE_WIDTH - BORDER;
            max_height = ITEM_SIZE_HEIGHT - BORDER;
         }
         imageLoader.rotation = 0;
         imageLoader.scaleX = imageLoader.scaleY = 1;
         imageLoader.loadImage(rid,function():void
         {
            var _loc1_:Color = new Color();
            var _loc2_:Boolean = false;
            if(imageLoader.width * 1.05 < imageLoader.height)
            {
               imageLoader.rotation = 90;
               _loc2_ = true;
            }
            imageLoader.width = max_width;
            imageLoader.scaleY = imageLoader.scaleX;
            if(imageLoader.height > max_height)
            {
               imageLoader.height = max_height;
               imageLoader.scaleX = imageLoader.scaleY;
            }
            _loc1_.setTint(16777215,1);
            imageLoader.transform.colorTransform = _loc1_;
            imageLoader.alpha = 1;
         });
      }
   }
}
