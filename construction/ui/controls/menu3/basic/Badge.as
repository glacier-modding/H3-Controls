package menu3.basic
{
   import common.Animate;
   import common.AnimationContainerBase;
   import common.menu.MenuUtils;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.getDefinitionByName;
   
   public class Badge extends Sprite implements AnimationContainerBase
   {
       
      
      private var m_frameIDSequence:Array;
      
      private var m_centerIDSequence:Array;
      
      private var m_levelsPerRow:int = 50;
      
      private var m_levelsPerColumn:int = 5;
      
      private var m_totalLevelsPerGroup:int = 250;
      
      private var m_levelMIN:int = 1;
      
      private var m_levelMAX:int = 12500;
      
      private var m_playerLevel:int = 0;
      
      private var m_latinLevelChange:int = 2500;
      
      private var m_latinLevelFrameId:int = 1;
      
      private var m_latinLevelTotal:int = 3;
      
      private var m_numeralTotal:int = 5;
      
      private var m_useAssetCutOut:Boolean = false;
      
      private const FRAME_LINKAGE_PREFIX:String = "Frame_";
      
      private const LATIN_NAME_LINKAGE_PREFIX:String = "Latin_";
      
      private const NUMERAL_LINKAGE_PREFIX:String = "Numeral_";
      
      private const CENTER_PIECE_LINKAGE_PREFIX:String = "Center_";
      
      private const ASSET_LINKAGE_CUTOUT_SUFFIX:String = "_cutout";
      
      private const TINT_COLOR_WHITE:int = 16777215;
      
      private const TINT_COLOR_DARK:int = 4343882;
      
      private const TINT_COLOR_NONE:int = -1;
      
      private var m_shieldColor:int;
      
      private var m_propsColor:int;
      
      private var m_numeralColor:int;
      
      private const SCALE_FACTOR_1:Number = 1;
      
      private const SCALE_FACTOR_2:Number = 0.89;
      
      private const SCALE_FACTOR_3:Number = 0.81;
      
      private const SCALE_FACTOR_4:Number = 0.875;
      
      private const SCALE_FACTOR_5:Number = 0.79;
      
      private var m_badgeCenterScaleFactor:Number;
      
      private var m_latinNameScaleFactor:Number;
      
      private var m_view:BadgeView = null;
      
      private var m_badgeFXClip:MovieClip;
      
      private var m_maxSize:Number = 0;
      
      private var m_badgeSizeReference:Number = 685;
      
      private var m_badgeScaleValue:Number = 1;
      
      private var m_useAnimation:Boolean = true;
      
      public function Badge()
      {
         this.m_frameIDSequence = [[1,1,1,1,1,2,2,2,2,2],[3,3,3,3,3,3,3,4,5,6],[7,7,7,7,8,9,9,10,11,12],[13,13,13,13,14,15,15,16,17,18],[19,19,19,19,20,21,21,22,23,24]];
         this.m_centerIDSequence = [[1,1,1,2,2],[3,3,3,4,4],[5,5,5,6,6],[7,7,7,8,8],[9,9,9,10,10],[11,11,11,12,12],[13,13,13,14,14],[15,15,15,16,16],[17,17,17,18,18],[19,19,19,20,20]];
         super();
         this.m_view = new BadgeView();
         addChild(this.m_view);
         this.m_view.alpha = 0;
         this.m_badgeFXClip = new BadgeFXView();
         this.m_badgeFXClip.fxInner.alpha = 0;
         this.m_badgeFXClip.fxOuter.alpha = 0;
      }
      
      public function setMaxSize(param1:Number) : void
      {
         this.m_maxSize = param1;
      }
      
      public function setLevel(param1:int, param2:Boolean, param3:Boolean = false) : void
      {
         this.m_useAnimation = param3;
         if(param1 <= 0)
         {
            return;
         }
         if(param1 == this.m_playerLevel)
         {
            return;
         }
         this.m_playerLevel = param1;
         this.createBadge();
         this.updateSize();
         this.showBadge(param2);
      }
      
      private function updateSize() : void
      {
         if(this.m_maxSize <= 0)
         {
            return;
         }
         this.m_badgeScaleValue = this.m_maxSize / this.m_badgeSizeReference;
         trace("Badge [ updateSize ] end-scale --> " + this.m_badgeScaleValue);
         this.m_view.scaleX = this.m_badgeScaleValue;
         this.m_view.scaleY = this.m_badgeScaleValue;
      }
      
      private function createBadge() : void
      {
         this.clearBadge();
         this.checkLevelCap();
         var _loc1_:String = this.findFrameID(this.m_playerLevel);
         var _loc2_:String = this.findFrameLatinID(this.m_playerLevel);
         var _loc3_:String = this.findFrameNumeralID(this.m_playerLevel);
         var _loc4_:String = this.findCenterID(this.m_playerLevel);
         var _loc5_:Class = getDefinitionByName(_loc1_) as Class;
         var _loc6_:Object = getDefinitionByName(_loc2_) as Class;
         var _loc7_:Class = getDefinitionByName(_loc3_) as Class;
         var _loc8_:Class = getDefinitionByName(_loc4_) as Class;
         var _loc9_:MovieClip = new _loc5_();
         var _loc10_:Sprite = new _loc6_();
         var _loc11_:Sprite = new _loc7_();
         var _loc12_:Sprite = new _loc8_();
         this.tintAssets(_loc11_,_loc12_);
         this.scaleAsset(_loc12_,this.m_badgeCenterScaleFactor);
         this.scaleAsset(_loc10_,this.m_latinNameScaleFactor);
         _loc9_.numeralClip.addChild(_loc11_);
         _loc9_.latinClip.addChild(_loc10_);
         this.m_view.addChild(_loc9_);
         this.m_view.addChild(_loc12_);
         this.m_view.addChild(this.m_badgeFXClip);
      }
      
      private function clearBadge() : void
      {
         while(this.m_view.numChildren > 0)
         {
            this.m_view.removeChildAt(0);
         }
         this.m_view.scaleX = this.m_view.scaleY = 1;
      }
      
      private function showBadge(param1:Boolean) : void
      {
         var delay:Number = NaN;
         var firstTime:Boolean = param1;
         Animate.kill(this.m_view);
         Animate.kill(this.m_badgeFXClip.fxInner);
         Animate.kill(this.m_badgeFXClip.fxOuter);
         if(this.m_useAnimation)
         {
            delay = 0;
            Animate.fromTo(this.m_view,0.2,delay,{"alpha":0},{"alpha":1},Animate.ExpoOut);
            if(firstTime)
            {
               Animate.addFromTo(this.m_view,0.3,delay,{
                  "scaleX":this.m_badgeScaleValue + 0.25,
                  "scaleY":this.m_badgeScaleValue + 0.25
               },{
                  "scaleX":this.m_badgeScaleValue,
                  "scaleY":this.m_badgeScaleValue
               },Animate.BackOut);
            }
            else
            {
               Animate.addTo(this.m_view,0.1,delay,{
                  "scaleX":this.m_badgeScaleValue - 0.2,
                  "scaleY":this.m_badgeScaleValue - 0.2
               },Animate.SineIn,function():void
               {
                  Animate.addTo(m_view,0.15,0,{
                     "scaleX":m_badgeScaleValue,
                     "scaleY":m_badgeScaleValue
                  },Animate.BackOut);
               });
            }
            Animate.fromTo(this.m_badgeFXClip.fxInner,0.5,delay + 0.1,{"alpha":1},{"alpha":0},Animate.SineOut);
            Animate.addFromTo(this.m_badgeFXClip.fxInner,0.6,delay + 0.1,{
               "scaleX":1,
               "scaleY":1
            },{
               "scaleX":2.5,
               "scaleY":2.5
            },Animate.SineOut);
            Animate.fromTo(this.m_badgeFXClip.fxOuter,0.7,delay + 0.2,{"alpha":1},{"alpha":0},Animate.SineOut);
            Animate.addFromTo(this.m_badgeFXClip.fxOuter,0.8,delay + 0.2,{
               "scaleX":1,
               "scaleY":1
            },{
               "scaleX":1.5,
               "scaleY":1.5
            },Animate.SineOut);
         }
         else
         {
            this.m_view.alpha = 1;
         }
      }
      
      private function findFrameID(param1:int) : String
      {
         while(param1 > this.m_totalLevelsPerGroup)
         {
            param1 -= this.m_totalLevelsPerGroup;
         }
         var _loc2_:int = Math.ceil(param1 / this.m_levelsPerRow) - 1;
         this.m_useAssetCutOut = false;
         if(_loc2_ == 1 || _loc2_ == 3)
         {
            this.m_useAssetCutOut = true;
         }
         var _loc3_:int = param1 - this.m_levelsPerRow * _loc2_;
         var _loc4_:int = Math.ceil(_loc3_ / this.m_levelsPerColumn) - 1;
         this.m_latinLevelFrameId = Math.min(_loc4_ + 1,this.m_latinLevelTotal);
         var _loc5_:int = int(this.m_frameIDSequence[_loc2_][_loc4_]);
         return this.FRAME_LINKAGE_PREFIX + _loc5_;
      }
      
      private function findFrameLatinID(param1:int) : String
      {
         var _loc2_:int = 1;
         while(param1 > this.m_latinLevelChange)
         {
            param1 -= this.m_latinLevelChange;
            _loc2_++;
         }
         var _loc3_:String = this.LATIN_NAME_LINKAGE_PREFIX + _loc2_ + "_" + this.m_latinLevelFrameId;
         if(this.m_useAssetCutOut)
         {
            _loc3_ += this.ASSET_LINKAGE_CUTOUT_SUFFIX;
         }
         return _loc3_;
      }
      
      private function findFrameNumeralID(param1:int) : String
      {
         var _loc2_:int = param1 % this.m_numeralTotal;
         var _loc3_:int = _loc2_ > 0 ? _loc2_ : this.m_numeralTotal;
         var _loc4_:String = this.NUMERAL_LINKAGE_PREFIX + _loc3_;
         if(this.m_useAssetCutOut)
         {
            _loc4_ += this.ASSET_LINKAGE_CUTOUT_SUFFIX;
         }
         return _loc4_;
      }
      
      private function findCenterID(param1:int) : String
      {
         var _loc2_:int = 0;
         var _loc3_:int = 10;
         while(param1 > this.m_totalLevelsPerGroup)
         {
            param1 -= this.m_totalLevelsPerGroup;
            _loc2_ += 1;
            if(_loc2_ >= _loc3_)
            {
               _loc2_ -= _loc3_;
            }
         }
         var _loc4_:int = Math.ceil(param1 / this.m_levelsPerRow) - 1;
         var _loc5_:int = param1 - this.m_levelsPerRow * _loc4_;
         var _loc6_:int = Math.ceil(_loc5_ / this.m_levelsPerColumn);
         var _loc7_:int = int(this.m_centerIDSequence[_loc2_][_loc4_]);
         this.setTintAndScaleFactor(_loc4_,_loc6_);
         return this.CENTER_PIECE_LINKAGE_PREFIX + _loc7_ + "_" + _loc6_;
      }
      
      private function checkLevelCap() : void
      {
         if(this.m_playerLevel < this.m_levelMIN)
         {
            this.m_playerLevel = this.m_levelMIN;
         }
         else if(this.m_playerLevel > this.m_levelMAX)
         {
            this.m_playerLevel = this.m_levelMAX;
         }
         else
         {
            this.m_playerLevel = this.m_playerLevel;
         }
      }
      
      private function setTintAndScaleFactor(param1:int, param2:int) : void
      {
         this.m_badgeCenterScaleFactor = this.SCALE_FACTOR_1;
         this.m_latinNameScaleFactor = this.SCALE_FACTOR_1;
         if(param1 >= 2)
         {
            if(param2 == 5)
            {
               if(param1 == 2)
               {
                  this.m_badgeCenterScaleFactor = this.SCALE_FACTOR_2;
               }
               this.m_latinNameScaleFactor = this.SCALE_FACTOR_4;
            }
            else if(param2 > 5)
            {
               if(param1 == 2)
               {
                  this.m_badgeCenterScaleFactor = this.SCALE_FACTOR_3;
               }
               this.m_latinNameScaleFactor = this.SCALE_FACTOR_5;
            }
         }
         if(param1 == 0)
         {
            this.m_propsColor = this.TINT_COLOR_WHITE;
            this.m_shieldColor = this.TINT_COLOR_NONE;
            this.m_numeralColor = this.TINT_COLOR_WHITE;
         }
         else if(param1 == 1)
         {
            this.m_propsColor = this.TINT_COLOR_WHITE;
            this.m_shieldColor = this.TINT_COLOR_NONE;
            this.m_numeralColor = this.TINT_COLOR_DARK;
         }
         else if(param1 == 2)
         {
            this.m_propsColor = this.TINT_COLOR_DARK;
            this.m_shieldColor = this.TINT_COLOR_NONE;
            this.m_numeralColor = this.TINT_COLOR_WHITE;
         }
         else if(param1 == 3)
         {
            this.m_propsColor = this.TINT_COLOR_DARK;
            this.m_shieldColor = this.TINT_COLOR_WHITE;
            this.m_numeralColor = this.TINT_COLOR_DARK;
         }
         else if(param1 == 4)
         {
            this.m_propsColor = this.TINT_COLOR_WHITE;
            this.m_shieldColor = this.TINT_COLOR_DARK;
            this.m_numeralColor = this.TINT_COLOR_WHITE;
         }
      }
      
      private function tintAssets(param1:Sprite, param2:Sprite) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:int = 0;
         while(_loc4_ < param2.numChildren)
         {
            _loc3_ = param2.getChildAt(_loc4_);
            if(_loc3_.name == "shield" && this.m_shieldColor != this.TINT_COLOR_NONE)
            {
               MenuUtils.setColor(_loc3_,this.m_shieldColor);
            }
            else if(this.m_propsColor != this.TINT_COLOR_NONE)
            {
               MenuUtils.setColor(_loc3_,this.m_propsColor);
            }
            _loc4_++;
         }
      }
      
      private function scaleAsset(param1:Sprite, param2:Number) : void
      {
         param1.scaleX = param1.scaleY = param2;
      }
   }
}
