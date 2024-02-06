package hud
{
   import common.Animate;
   import common.BaseControl;
   import common.ImageLoader;
   import common.Localization;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class OutfitWidgetVR extends BaseControl
   {
      
      private static const DT_ANIMDURATION:Number = 0.5;
      
      private static const DT_ANIMDELAY:Number = 0.1;
       
      
      private var m_txtHeader:TextField;
      
      private var m_txtOutfitName:TextField;
      
      private var m_container:Sprite;
      
      private var m_imgOutfit:ImageLoader;
      
      private var m_mask:MaskView;
      
      private var m_isHitmanSuit:Boolean = false;
      
      private var m_mask_pxWidth:Number;
      
      private var m_mask_pxHeight:Number;
      
      private var m_hitmanSuitCrop_fScale:Number;
      
      public function OutfitWidgetVR()
      {
         this.m_txtHeader = new TextField();
         this.m_txtOutfitName = new TextField();
         this.m_container = new Sprite();
         this.m_imgOutfit = new ImageLoader();
         this.m_mask = new MaskView();
         super();
         this.m_container.alpha = 0;
         this.m_txtHeader.alpha = 0;
         this.m_txtOutfitName.alpha = 0;
         this.m_txtHeader.autoSize = TextFieldAutoSize.LEFT;
         MenuUtils.setupTextUpper(this.m_txtHeader,Localization.get("UI_VR_HUD_OUTFITWIDGET_HEADER"),20,MenuConstants.FONT_TYPE_MEDIUM);
         MenuUtils.addDropShadowFilter(this.m_txtHeader);
         this.m_txtOutfitName.autoSize = TextFieldAutoSize.LEFT;
         MenuUtils.setupText(this.m_txtOutfitName,"",34,MenuConstants.FONT_TYPE_BOLD);
         MenuUtils.addDropShadowFilter(this.m_txtOutfitName);
         this.m_txtOutfitName.y = this.m_txtHeader.height;
         this.m_imgOutfit.mask = this.m_mask;
         this.m_container.addChild(this.m_imgOutfit);
         this.m_container.addChild(this.m_mask);
         addChild(this.m_container);
         addChild(this.m_txtHeader);
         addChild(this.m_txtOutfitName);
      }
      
      public function set mask_pxWidth(param1:Number) : void
      {
         this.m_mask_pxWidth = param1;
         this.onPropertiesChanged();
      }
      
      public function set mask_pxHeight(param1:Number) : void
      {
         this.m_mask_pxHeight = param1;
         this.onPropertiesChanged();
      }
      
      public function set hitmanSuitCrop_fScale(param1:Number) : void
      {
         this.m_hitmanSuitCrop_fScale = param1;
         this.onPropertiesChanged();
      }
      
      public function onTCMovementBegun() : void
      {
         Animate.kill(this.m_container);
         Animate.kill(this.m_txtHeader);
         Animate.kill(this.m_txtOutfitName);
         this.m_container.alpha = 0;
         this.m_txtHeader.alpha = 0;
         this.m_txtOutfitName.alpha = 0;
      }
      
      public function updateOutfit(param1:String, param2:String, param3:Boolean, param4:Boolean) : void
      {
         var lstrName:String = param1;
         var ridImage:String = param2;
         var isHitmanSuit:Boolean = param3;
         var isOutfitChange:Boolean = param4;
         this.m_isHitmanSuit = isHitmanSuit;
         this.m_imgOutfit.loadImage(ridImage,function():void
         {
            m_txtOutfitName.text = lstrName.toUpperCase();
            applyImageSize();
            repositionImage(isOutfitChange);
            repositionTextFields(isOutfitChange);
         },function():void
         {
            m_txtOutfitName.text = lstrName.toUpperCase();
            repositionTextFields(isOutfitChange);
         });
      }
      
      private function applyImageSize() : void
      {
         if(!this.m_isHitmanSuit)
         {
            this.m_imgOutfit.height = this.m_mask_pxHeight;
         }
         else
         {
            this.m_imgOutfit.height = this.m_mask_pxHeight * this.m_hitmanSuitCrop_fScale;
         }
         this.m_imgOutfit.scaleX = this.m_imgOutfit.scaleY;
         this.m_imgOutfit.x = -this.m_imgOutfit.width + (this.m_imgOutfit.width - this.m_mask_pxWidth) / 2;
      }
      
      private function repositionImage(param1:Boolean) : void
      {
         if(param1)
         {
            Animate.fromTo(this.m_container,DT_ANIMDURATION,DT_ANIMDELAY + 0.5,{
               "x":-50,
               "alpha":0
            },{
               "x":0,
               "alpha":1
            },Animate.ExpoOut);
         }
         else
         {
            this.m_container.x = 0;
            this.m_container.alpha = 1;
         }
      }
      
      private function repositionTextFields(param1:Boolean) : void
      {
         if(param1)
         {
            Animate.fromTo(this.m_txtHeader,DT_ANIMDURATION,DT_ANIMDELAY + 0.8,{
               "x":50,
               "alpha":0
            },{
               "x":8,
               "alpha":1
            },Animate.ExpoOut);
            Animate.fromTo(this.m_txtOutfitName,DT_ANIMDURATION,DT_ANIMDELAY + 1,{
               "x":50,
               "alpha":0
            },{
               "x":8,
               "alpha":1
            },Animate.ExpoOut);
         }
         else
         {
            this.m_txtHeader.x = 8;
            this.m_txtOutfitName.x = 8;
            this.m_txtHeader.alpha = 1;
            this.m_txtOutfitName.alpha = 1;
         }
      }
      
      private function onPropertiesChanged() : void
      {
         this.m_mask.width = this.m_mask_pxWidth;
         this.m_mask.height = this.m_mask_pxHeight;
         this.m_mask.x = -this.m_mask_pxWidth;
         this.applyImageSize();
      }
   }
}
