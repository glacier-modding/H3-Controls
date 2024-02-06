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
   
   public class OutfitAndStatusMarkersVR extends BaseControl
   {
      
      public static const ICON_SEARCHING:int = 1;
      
      public static const ICON_COMPROMISED:int = 2;
      
      public static const ICON_HUNTED:int = 3;
      
      public static const ICON_COMBAT:int = 4;
      
      public static const ICON_SECURITYCAMERA:int = 5;
      
      public static const ICON_HIDDENINLVA:int = 6;
      
      public static const ICON_QUESTIONMARK:int = 7;
      
      public static const ICON_UNCONSCIOUSWITNESS:int = 8;
      
      private static const DX_GAP_TEXTTICKER:Number = 40;
      
      private static const DT_DELAY_TEXTTICKER:Number = 1;
      
      private static const DXPS_SPEED_TEXTTICKER:Number = 100;
       
      
      private var m_statusMarkerView:StatusMarkerViewLean;
      
      private var m_Outfit_txtHeader:TextField;
      
      private var m_Outfit_txtName:TextField;
      
      private var m_Outfit_txtName2:TextField;
      
      private var m_Outfit_offsetName:Sprite;
      
      private var m_Outfit_maskName:MaskView;
      
      private var m_Outfit_image:ImageLoader;
      
      private var m_Outfit_offsetImage:Sprite;
      
      private var m_Outfit_maskImage:MaskView;
      
      private var m_isHitmanSuit:Boolean = false;
      
      private var m_isPlayerLookingAtHand:Boolean = false;
      
      private var m_mask_pxWidth:Number;
      
      private var m_mask_pxHeight:Number;
      
      private var m_mask_pxPadding:Number;
      
      private var m_hitmanSuitCrop_fScale:Number;
      
      public function OutfitAndStatusMarkersVR()
      {
         this.m_statusMarkerView = new StatusMarkerViewLean();
         this.m_Outfit_txtHeader = new TextField();
         this.m_Outfit_txtName = new TextField();
         this.m_Outfit_txtName2 = new TextField();
         this.m_Outfit_offsetName = new Sprite();
         this.m_Outfit_maskName = new MaskView();
         this.m_Outfit_image = new ImageLoader();
         this.m_Outfit_offsetImage = new Sprite();
         this.m_Outfit_maskImage = new MaskView();
         super();
         this.m_Outfit_txtHeader.autoSize = TextFieldAutoSize.LEFT;
         MenuUtils.setupTextUpper(this.m_Outfit_txtHeader,Localization.get("UI_VR_HUD_OUTFITWIDGET_HEADER"),12,MenuConstants.FONT_TYPE_MEDIUM);
         MenuUtils.addDropShadowFilter(this.m_Outfit_txtHeader);
         this.m_Outfit_txtName.autoSize = TextFieldAutoSize.LEFT;
         MenuUtils.setupText(this.m_Outfit_txtName,"...",18,MenuConstants.FONT_TYPE_MEDIUM);
         MenuUtils.addDropShadowFilter(this.m_Outfit_txtName);
         this.m_Outfit_txtName2.autoSize = TextFieldAutoSize.LEFT;
         MenuUtils.setupText(this.m_Outfit_txtName2,"...",18,MenuConstants.FONT_TYPE_MEDIUM);
         MenuUtils.addDropShadowFilter(this.m_Outfit_txtName2);
         this.m_Outfit_offsetName.name = "offsetName";
         this.m_Outfit_offsetName.addChild(this.m_Outfit_txtName);
         this.m_Outfit_offsetName.addChild(this.m_Outfit_txtName2);
         this.m_Outfit_offsetImage.mask = this.m_Outfit_maskImage;
         this.m_Outfit_offsetName.mask = this.m_Outfit_maskName;
         this.m_Outfit_offsetImage.addChild(this.m_Outfit_image);
         var _loc1_:Sprite = new Sprite();
         _loc1_.name = "containerImg";
         _loc1_.addChild(this.m_Outfit_offsetImage);
         _loc1_.addChild(this.m_Outfit_maskImage);
         addChild(_loc1_);
         this.m_statusMarkerView.x = 105;
         this.m_statusMarkerView.y = 105;
         addChild(this.m_statusMarkerView);
         var _loc2_:Sprite = new Sprite();
         _loc2_.name = "containerTxt";
         _loc2_.addChild(this.m_Outfit_txtHeader);
         _loc2_.addChild(this.m_Outfit_offsetName);
         _loc2_.addChild(this.m_Outfit_maskName);
         addChild(_loc2_);
      }
      
      public function set mask_pxWidth(param1:Number) : void
      {
         this.m_mask_pxWidth = param1;
         this.onOutfitPropertiesChanged();
      }
      
      public function set mask_pxHeight(param1:Number) : void
      {
         this.m_mask_pxHeight = param1;
         this.onOutfitPropertiesChanged();
      }
      
      public function set mask_pxPadding(param1:Number) : void
      {
         this.m_mask_pxPadding = param1;
         this.onOutfitPropertiesChanged();
      }
      
      public function set hitmanSuitCrop_fScale(param1:Number) : void
      {
         this.m_hitmanSuitCrop_fScale = param1;
         this.onOutfitPropertiesChanged();
      }
      
      public function set outfit_zOffset(param1:Number) : void
      {
         this.m_Outfit_offsetImage.z = param1;
      }
      
      public function set outfit_fScale(param1:Number) : void
      {
         this.m_Outfit_offsetImage.scaleX = this.m_Outfit_offsetImage.scaleY = param1;
      }
      
      public function updateOutfit(param1:String, param2:String, param3:Boolean, param4:Boolean) : void
      {
         var lstrName:String = param1;
         var ridImage:String = param2;
         var isHitmanSuit:Boolean = param3;
         var isOutfitChange:Boolean = param4;
         this.m_isHitmanSuit = isHitmanSuit;
         this.m_Outfit_image.loadImage(ridImage,function():void
         {
            applyOutfitName(lstrName);
            applyOutfitImageSize();
         },function():void
         {
            applyOutfitName(lstrName);
         });
      }
      
      public function onSetData(param1:Object) : void
      {
         this.m_statusMarkerView.setTrespassing(param1.bTrespassing,param1.bDeepTrespassing);
      }
      
      public function hiddenInCrowd(param1:Boolean) : void
      {
         this.m_statusMarkerView.hiddenInCrowd(param1);
      }
      
      public function hiddenInVegetation(param1:Boolean) : void
      {
         this.m_statusMarkerView.hiddenInVegetation(param1);
      }
      
      public function setTensionMessage(param1:String, param2:int, param3:int) : void
      {
         this.m_statusMarkerView.setTensionMessage(param1,param2,param3);
      }
      
      public function setPlayerLookingAtHand(param1:Boolean) : void
      {
         this.m_isPlayerLookingAtHand = param1;
         if(param1)
         {
            this.resetAndStartTextTicker();
         }
         else
         {
            Animate.kill(this.m_Outfit_txtName);
            Animate.kill(this.m_Outfit_txtName2);
         }
      }
      
      private function applyOutfitName(param1:String) : void
      {
         param1 = param1.toUpperCase();
         this.m_Outfit_txtName.text = param1;
         if(this.m_Outfit_txtName.width <= this.m_mask_pxWidth - 2 * this.m_mask_pxPadding)
         {
            this.m_Outfit_txtName.x = 0;
            if(this.m_Outfit_txtName2.visible)
            {
               this.m_Outfit_txtName2.visible = false;
               Animate.kill(this.m_Outfit_txtName);
               Animate.kill(this.m_Outfit_txtName2);
            }
         }
         else
         {
            this.m_Outfit_txtName2.visible = true;
            this.m_Outfit_txtName2.text = param1;
            if(this.m_isPlayerLookingAtHand)
            {
               this.resetAndStartTextTicker();
            }
         }
      }
      
      private function resetTextTicker() : void
      {
         this.m_Outfit_txtName.x = 0;
         this.m_Outfit_txtName2.x = this.m_Outfit_txtName.width + DX_GAP_TEXTTICKER;
      }
      
      private function resetAndStartTextTicker() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         this.resetTextTicker();
         if(!this.m_Outfit_txtName2.visible)
         {
            return;
         }
         if(this.m_isPlayerLookingAtHand)
         {
            _loc1_ = this.m_Outfit_txtName.width;
            _loc2_ = DX_GAP_TEXTTICKER + _loc1_;
            Animate.fromTo(this.m_Outfit_txtName,_loc2_ / DXPS_SPEED_TEXTTICKER,DT_DELAY_TEXTTICKER,{
               "alpha":1,
               "x":this.m_Outfit_txtName.x
            },{
               "alpha":1,
               "x":-(_loc1_ + DX_GAP_TEXTTICKER)
            },Animate.Linear,this.loopTextTicker,this.m_Outfit_txtName);
            _loc3_ = 2 * DX_GAP_TEXTTICKER + 2 * _loc1_;
            Animate.fromTo(this.m_Outfit_txtName2,_loc3_ / DXPS_SPEED_TEXTTICKER,DT_DELAY_TEXTTICKER,{
               "alpha":1,
               "x":this.m_Outfit_txtName2.x
            },{
               "alpha":1,
               "x":-(_loc1_ + DX_GAP_TEXTTICKER)
            },Animate.Linear,this.loopTextTicker,this.m_Outfit_txtName2);
         }
      }
      
      private function loopTextTicker(param1:TextField) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = param1.width;
         var _loc3_:Number = 2 * DX_GAP_TEXTTICKER + 2 * _loc2_;
         Animate.fromTo(param1,_loc3_ / DXPS_SPEED_TEXTTICKER,0,{
            "alpha":1,
            "x":_loc2_ + DX_GAP_TEXTTICKER
         },{
            "alpha":1,
            "x":-(_loc2_ + DX_GAP_TEXTTICKER)
         },Animate.Linear,this.loopTextTicker,param1);
      }
      
      private function applyOutfitImageSize() : void
      {
         if(!this.m_isHitmanSuit)
         {
            this.m_Outfit_image.height = this.m_mask_pxHeight;
         }
         else
         {
            this.m_Outfit_image.height = this.m_mask_pxHeight * this.m_hitmanSuitCrop_fScale;
         }
         this.m_Outfit_image.scaleX = this.m_Outfit_image.scaleY;
         this.m_Outfit_image.x = -this.m_Outfit_image.width / 2;
         this.m_Outfit_image.y = -this.m_mask_pxHeight / 2;
      }
      
      private function onOutfitPropertiesChanged() : void
      {
         this.m_Outfit_maskImage.width = this.m_mask_pxWidth;
         this.m_Outfit_maskImage.height = this.m_mask_pxHeight;
         this.m_Outfit_maskName.x = this.m_mask_pxPadding;
         this.m_Outfit_maskName.width = this.m_mask_pxWidth - 2 * this.m_mask_pxPadding;
         this.m_Outfit_maskName.height = this.m_mask_pxHeight;
         this.m_Outfit_txtHeader.x = this.m_mask_pxPadding;
         this.m_Outfit_offsetName.x = this.m_mask_pxPadding;
         this.m_Outfit_txtHeader.y = this.m_mask_pxHeight - this.m_mask_pxPadding - this.m_Outfit_txtName.height - this.m_Outfit_txtHeader.height;
         this.m_Outfit_offsetName.y = this.m_mask_pxHeight - this.m_mask_pxPadding - this.m_Outfit_txtName.height;
         this.m_Outfit_offsetImage.x = this.m_mask_pxWidth / 2;
         this.m_Outfit_offsetImage.y = this.m_mask_pxHeight / 2;
         this.applyOutfitImageSize();
      }
   }
}

import common.Localization;
import common.menu.MenuConstants;
import common.menu.MenuUtils;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.text.TextFormat;

class StatusMarkerViewLean extends Sprite
{
    
   
   private var m_gradientOverlay:MovieClip;
   
   private var m_borderMc:MovieClip;
   
   private var m_gradientOverlayLVA:MovieClip;
   
   private var m_trespassingIndicatorMc:MovieClip;
   
   private var m_tensionIndicatorMc:MovieClip;
   
   private var m_informationBarLVA:MovieClip;
   
   private var m_isHiddenInCrowd:Boolean = false;
   
   private var m_isHiddenInVegetation:Boolean = false;
   
   private const m_lstrHiddenInCrowd:String = Localization.get("UI_MENU_LVA_BLENDING_IN_CROWD").toUpperCase();
   
   private const m_lstrHiddenInVegetation:String = Localization.get("UI_MENU_LVA_HIDDEN").toUpperCase();
   
   private const m_lstrDeepTrespassing:String = Localization.get("EGAME_TEXT_SL_HOSTILEAREA").toUpperCase();
   
   private const m_lstrTrespassing:String = Localization.get("EGAME_TEXT_SL_TRESPASSING_ON").toUpperCase();
   
   public function StatusMarkerViewLean()
   {
      super();
      var _loc1_:StatusMarkerView = new StatusMarkerView();
      this.m_gradientOverlay = _loc1_.gradientOverlay;
      addChild(this.m_gradientOverlay);
      this.m_borderMc = _loc1_.borderMc;
      addChild(this.m_borderMc);
      this.m_gradientOverlayLVA = _loc1_.gradientOverlayLVA;
      addChild(this.m_gradientOverlayLVA);
      this.m_trespassingIndicatorMc = _loc1_.trespassingIndicatorMc;
      addChild(this.m_trespassingIndicatorMc);
      this.m_tensionIndicatorMc = _loc1_.tensionIndicatorMc;
      addChild(this.m_tensionIndicatorMc);
      this.m_informationBarLVA = _loc1_.informationBarLVA;
      addChild(this.m_informationBarLVA);
      this.m_gradientOverlay.alpha = 0.3;
      this.m_gradientOverlayLVA.alpha = 0.6;
      this.m_gradientOverlayLVA.visible = false;
      this.m_trespassingIndicatorMc.visible = false;
      this.m_tensionIndicatorMc.visible = false;
      this.m_informationBarLVA.visible = false;
      var _loc2_:TextFormat = new TextFormat();
      _loc2_.leading = -3.5;
      this.m_trespassingIndicatorMc.bgGradient.alpha = 0.5;
      this.m_trespassingIndicatorMc.y = 105;
      this.m_trespassingIndicatorMc.removeChild(this.m_trespassingIndicatorMc.overlayMc);
      this.m_trespassingIndicatorMc.removeChild(this.m_trespassingIndicatorMc.pulseMc);
      this.m_tensionIndicatorMc.labelTxt.autoSize = "left";
      this.m_tensionIndicatorMc.labelTxt.multiline = true;
      this.m_tensionIndicatorMc.labelTxt.wordWrap = true;
      this.m_tensionIndicatorMc.labelTxt.width = 186;
      this.m_tensionIndicatorMc.labelTxt.text = "...";
      this.m_tensionIndicatorMc.labelTxt.setTextFormat(_loc2_);
      MenuUtils.setupText(this.m_tensionIndicatorMc.unconMc.labelTxt,"",18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraLight);
      this.m_tensionIndicatorMc.bgMc.height = 23;
      this.m_tensionIndicatorMc.bgGradient.alpha = 0.5;
      this.m_tensionIndicatorMc.y = -129;
      this.m_informationBarLVA.iconMc.gotoAndStop(OutfitAndStatusMarkersVR.ICON_HIDDENINLVA);
      this.m_informationBarLVA.labelTxt.autoSize = "left";
      this.m_informationBarLVA.labelTxt.multiline = true;
      this.m_informationBarLVA.labelTxt.wordWrap = true;
      this.m_informationBarLVA.labelTxt.width = 186;
      this.m_informationBarLVA.labelTxt.text = "";
      this.m_informationBarLVA.labelTxt.setTextFormat(_loc2_);
      MenuUtils.setupText(this.m_informationBarLVA.labelTxt,"...",18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraLight);
      this.m_informationBarLVA.y = -105;
   }
   
   public function setTrespassing(param1:Boolean, param2:Boolean) : void
   {
      var _loc3_:String = null;
      var _loc4_:Number = NaN;
      var _loc5_:Number = NaN;
      if(param1 || param2)
      {
         _loc3_ = param2 ? String(this.m_lstrDeepTrespassing) : String(this.m_lstrTrespassing);
         _loc4_ = -1;
         _loc5_ = 9;
         MenuUtils.setupTextAndShrinkToFitUpper(this.m_trespassingIndicatorMc.labelTxt,_loc3_,18,MenuConstants.FONT_TYPE_MEDIUM,184,_loc4_,_loc5_,MenuConstants.FontColorGreyUltraDark);
         this.m_trespassingIndicatorMc.visible = true;
      }
      else
      {
         this.m_trespassingIndicatorMc.visible = false;
      }
   }
   
   public function hiddenInCrowd(param1:Boolean) : void
   {
      this.m_isHiddenInCrowd = param1;
      this.applyLVA();
   }
   
   public function hiddenInVegetation(param1:Boolean) : void
   {
      this.m_isHiddenInVegetation = param1;
      this.applyLVA();
   }
   
   private function applyLVA() : void
   {
      if(this.m_isHiddenInCrowd)
      {
         this.m_informationBarLVA.labelTxt.text = this.m_lstrHiddenInCrowd;
         this.m_informationBarLVA.visible = true;
         this.m_gradientOverlayLVA.visible = true;
      }
      else if(this.m_isHiddenInVegetation)
      {
         this.m_informationBarLVA.labelTxt.text = this.m_lstrHiddenInVegetation;
         this.m_informationBarLVA.visible = true;
         this.m_gradientOverlayLVA.visible = true;
      }
      else
      {
         this.m_informationBarLVA.visible = false;
         this.m_gradientOverlayLVA.visible = false;
      }
   }
   
   public function setTensionMessage(param1:String, param2:int, param3:int) : void
   {
      var _loc4_:String = null;
      if(param1 == "")
      {
         this.m_tensionIndicatorMc.visible = false;
      }
      else
      {
         this.m_tensionIndicatorMc.iconMc.gotoAndStop(param2 > 0 ? param2 : 1);
         this.m_tensionIndicatorMc.labelTxt.text = param1.toUpperCase();
         this.m_tensionIndicatorMc.bgMc.height = 23 + (this.m_tensionIndicatorMc.labelTxt.numLines - 1) * 19;
         this.m_tensionIndicatorMc.y = -129 - (this.m_tensionIndicatorMc.labelTxt.numLines - 1) * 19;
         if(param3 >= 1)
         {
            this.m_tensionIndicatorMc.iconMc.gotoAndStop(OutfitAndStatusMarkersVR.ICON_UNCONSCIOUSWITNESS);
            if(param3 >= 2)
            {
               _loc4_ = String(param3);
               this.m_tensionIndicatorMc.unconMc.labelTxt.text = _loc4_;
               this.m_tensionIndicatorMc.unconMc.bgMc.width = 29 + _loc4_.length * 12;
               this.m_tensionIndicatorMc.unconMc.bgMc.height = this.m_tensionIndicatorMc.bgMc.height;
            }
         }
         this.m_tensionIndicatorMc.visible = true;
         this.m_tensionIndicatorMc.unconMc.visible = param3 >= 2;
      }
   }
}
