package menu3.basic
{
   import common.CommonUtils;
   import common.Localization;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import menu3.containers.CollapsableListContainer;
   
   public dynamic class OptionsListElementBase extends CollapsableListContainer
   {
       
      
      private var m_view:*;
      
      private var m_textTickerUtilTitle:TextTickerUtil;
      
      private var m_textTickerUtilValue:TextTickerUtil;
      
      private const OPTION_NONE:int = 0;
      
      private const OPTION_TOGGLE:int = 1;
      
      private const OPTION_SLIDER:int = 2;
      
      private var m_optionType:int = 0;
      
      private var m_titleWidthNoOptions:Number = 440;
      
      private var m_valueWidthNoOptions:Number = 205;
      
      private var m_titleWidthSliderOption:Number = 356;
      
      private var m_valueWidthSliderOption:Number = 94;
      
      private var m_titleWidthToggleOption:Number = 511;
      
      private var m_valueWidthToggleOption:Number = 94;
      
      private var m_titleWidthMAX:Number;
      
      private var m_edgePadding:Number = 21;
      
      private var m_hasSlider:Boolean = false;
      
      private var m_sliderDragActive:Boolean = false;
      
      private var m_sliderRange:Rectangle;
      
      private var m_sliderClickRange:Rectangle;
      
      private var m_pressable:Boolean;
      
      private var m_selectable:Boolean;
      
      private var m_firstTimeOnly:Boolean;
      
      private var m_isTextScrollingEnabled:Boolean;
      
      private var m_solidStyle:Boolean = false;
      
      protected const STATE_DEFAULT:int = 0;
      
      protected const STATE_SELECTED:int = 1;
      
      protected const STATE_GROUP_SELECTED:int = 2;
      
      protected const STATE_HOVER:int = 3;
      
      public function OptionsListElementBase(param1:Object)
      {
         this.m_textTickerUtilTitle = new TextTickerUtil();
         this.m_textTickerUtilValue = new TextTickerUtil();
         super(param1);
         this.m_firstTimeOnly = true;
         this.m_view = this.createView();
         addChild(this.m_view);
      }
      
      protected function createView() : *
      {
         return null;
      }
      
      override public function onSetData(param1:Object) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:* = false;
         var _loc5_:Number = NaN;
         var _loc6_:Rectangle = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         this.m_pressable = getNodeProp(this,"pressable");
         this.m_selectable = getNodeProp(this,"selectable");
         this.m_solidStyle = param1.solidstyle === true;
         if(this.m_firstTimeOnly)
         {
            this.m_titleWidthMAX = this.m_view.tileDarkBg.width - this.m_edgePadding * 2;
         }
         if(param1.toggle)
         {
            this.m_optionType = this.OPTION_TOGGLE;
            if(this.m_firstTimeOnly)
            {
               this.m_view.optionsIndicator.gotoAndStop("Toggle");
            }
            _loc3_ = param1.oldTechUpdate != null ? Boolean(param1.oldTechUpdate) : false;
            _loc4_ = param1.value == true || param1.value == 1;
            if(param1.invertToggle === true)
            {
               _loc4_ = !_loc4_;
            }
            if(_loc4_)
            {
               if(_loc3_)
               {
                  param1.displayValue = String("[" + Localization.get("UI_AID_VALUE_ON") + "]");
               }
               this.m_view.optionsIndicator.toggleIndicator.gotoAndStop(2);
            }
            else
            {
               if(_loc3_)
               {
                  param1.displayValue = String("[" + Localization.get("UI_AID_VALUE_OFF") + "]");
               }
               this.m_view.optionsIndicator.toggleIndicator.gotoAndStop(1);
            }
         }
         else if(param1.slider)
         {
            this.m_optionType = this.OPTION_SLIDER;
            this.m_hasSlider = true;
            if(this.m_firstTimeOnly)
            {
               this.m_view.optionsIndicator.gotoAndStop("Slider");
            }
            if(this.m_sliderRange == null || this.m_sliderClickRange == null)
            {
               _loc6_ = this.m_view.optionsIndicator.slideIndicator.getBounds(this.m_view);
               this.m_sliderRange = new Rectangle(_loc6_.x,_loc6_.y,MenuConstants.OptionsListElementSliderWidth,MenuConstants.OptionsListElementSliderHeight);
               this.m_sliderRange.inflate(this.m_sliderRange.height * -0.5,0);
               this.m_sliderClickRange = this.m_sliderRange.clone();
               this.m_sliderClickRange.inflate(20,20);
            }
            _loc5_ = Number(param1.value);
            if(param1.sliderconfig)
            {
               param1.propertyValue = param1.displayValue;
               _loc7_ = Number(param1.sliderconfig.valuerangemin);
               _loc8_ = Number(param1.sliderconfig.valuerangemax);
               _loc5_ = (param1.propertyValue - _loc7_) / (_loc8_ - _loc7_) * 100;
               param1.value = _loc5_;
            }
            this.m_view.optionsIndicator.slideIndicator.gotoAndStop(_loc5_);
            if(param1.formattedValue != undefined)
            {
               param1.displayValue = "[" + String(param1.formattedValue).toUpperCase() + "]";
            }
            else if(param1.displayValueDecimals != undefined)
            {
               param1.displayValue = String("[" + MenuUtils.formatNumber(Number(param1.propertyValue),true,Number(param1.displayValueDecimals)) + "]");
            }
            else
            {
               param1.displayValue = String("[" + MenuUtils.formatNumber(Number(param1.propertyValue),true,2) + "]");
            }
         }
         if(this.m_firstTimeOnly)
         {
            this.setupTextField(this.m_view.title,param1.title);
         }
         this.setupTextField(this.m_view.value,param1.displayValue);
         this.setTextfieldWidths();
         this.m_isTextScrollingEnabled = !!param1.force_scroll ? true : false;
         var _loc2_:int = m_isSelected ? this.STATE_SELECTED : this.STATE_DEFAULT;
         this.setSelectedAnimationState(_loc2_);
         if(this.m_selectable == false || this.m_pressable == false)
         {
            this.changeTextColor(MenuConstants.COLOR_GREY);
            if(this.m_solidStyle)
            {
               MenuUtils.setColor(this.m_view.tileSelect,MenuConstants.COLOR_MENU_SOLID_BACKGROUND,false);
               MenuUtils.removeDropShadowFilter(this.m_view.title);
               MenuUtils.removeDropShadowFilter(this.m_view.value);
               this.m_view.tileSelect.alpha = 1;
            }
            else
            {
               MenuUtils.addDropShadowFilter(this.m_view.title);
               MenuUtils.addDropShadowFilter(this.m_view.value);
               this.m_view.tileSelect.alpha = 0;
            }
            this.m_view.optionsIndicator.alpha = 0.25;
            if(this.m_isTextScrollingEnabled)
            {
               this.callTextTicker(true);
            }
         }
         else
         {
            this.m_view.optionsIndicator.alpha = 1;
         }
         this.m_firstTimeOnly = false;
      }
      
      private function setupTextField(param1:TextField, param2:String) : void
      {
         MenuUtils.setupTextUpper(param1,param2,26,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         CommonUtils.changeFontToGlobalIfNeeded(param1);
         if(param1 == this.m_view.title)
         {
            this.m_textTickerUtilTitle.addTextTicker(this.m_view.title,this.m_view.title.htmlText);
         }
         if(param1 == this.m_view.value)
         {
            this.m_textTickerUtilValue.addTextTicker(this.m_view.value,this.m_view.value.htmlText);
         }
         MenuUtils.truncateTextfield(param1,1,null,CommonUtils.changeFontToGlobalIfNeeded(param1));
      }
      
      private function changeTextColor(param1:int) : void
      {
         this.m_view.title.textColor = param1;
         this.m_view.value.textColor = param1;
      }
      
      private function setTextfieldWidths() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         this.m_view.title.autoSize = TextFieldAutoSize.NONE;
         this.m_view.value.autoSize = TextFieldAutoSize.NONE;
         switch(this.m_optionType)
         {
            case this.OPTION_NONE:
               _loc1_ = this.m_view.value.text == "" ? this.m_titleWidthMAX : this.m_titleWidthNoOptions;
               _loc2_ = this.m_valueWidthNoOptions;
               break;
            case this.OPTION_TOGGLE:
               _loc1_ = this.m_titleWidthToggleOption;
               _loc2_ = this.m_valueWidthToggleOption;
               break;
            case this.OPTION_SLIDER:
               _loc1_ = this.m_titleWidthSliderOption;
               _loc2_ = this.m_valueWidthSliderOption;
               break;
            default:
               trace("unhandled case in " + this + " setTextfieldWidths() : " + this.m_optionType);
         }
         this.m_view.title.width = _loc1_;
         this.m_view.value.width = _loc2_;
         this.m_view.value.x = this.m_view.tileDarkBg.width - this.m_view.value.width - this.m_edgePadding;
      }
      
      private function callTextTicker(param1:Boolean) : void
      {
         this.m_textTickerUtilTitle.callTextTicker(param1,this.m_view.title.textColor);
         this.m_textTickerUtilValue.callTextTicker(param1,this.m_view.value.textColor);
      }
      
      override public function getView() : Sprite
      {
         return this.m_view.tileBg;
      }
      
      override public function addChild2(param1:Sprite, param2:int = -1) : void
      {
         super.addChild2(param1,param2);
         if(getNodeProp(param1,"col") === undefined)
         {
            if(this.getData().direction != "horizontal" && this.getData().direction != "horizontalWrap")
            {
               param1.x = 32;
            }
         }
      }
      
      public function setItemHover(param1:Boolean) : void
      {
         if(m_isSelected || m_isGroupSelected)
         {
            return;
         }
         var _loc2_:int = param1 ? this.STATE_HOVER : this.STATE_DEFAULT;
         this.setSelectedAnimationState(_loc2_);
      }
      
      override protected function handleSelectionChange() : void
      {
         var _loc1_:int = this.STATE_DEFAULT;
         if(m_isSelected)
         {
            _loc1_ = this.STATE_SELECTED;
         }
         else if(m_isGroupSelected)
         {
            _loc1_ = this.STATE_GROUP_SELECTED;
         }
         this.setSelectedAnimationState(_loc1_);
      }
      
      protected function setSelectedAnimationState(param1:int) : void
      {
         if(m_loading)
         {
            return;
         }
         if(this.m_selectable == false)
         {
            this.callTextTicker(false);
            return;
         }
         if(param1 == this.STATE_SELECTED)
         {
            if(this.m_pressable)
            {
               this.changeTextColor(MenuConstants.COLOR_WHITE);
               MenuUtils.setColor(this.m_view.tileSelect,MenuConstants.COLOR_RED,true,MenuConstants.MenuElementSelectedAlpha);
            }
            else
            {
               this.changeTextColor(MenuConstants.COLOR_GREY);
               MenuUtils.setColor(this.m_view.tileSelect,MenuConstants.COLOR_MENU_TABS_BACKGROUND,true,MenuConstants.MenuElementBackgroundAlpha);
            }
            MenuUtils.removeDropShadowFilter(this.m_view.title);
            MenuUtils.removeDropShadowFilter(this.m_view.value);
            this.callTextTicker(true);
         }
         else if(param1 == this.STATE_GROUP_SELECTED)
         {
            this.changeTextColor(MenuConstants.COLOR_GREY);
            if(this.m_solidStyle)
            {
               MenuUtils.setColor(this.m_view.tileSelect,MenuConstants.COLOR_MENU_SOLID_BACKGROUND,true,MenuConstants.MenuElementBackgroundAlpha);
            }
            else
            {
               MenuUtils.setColor(this.m_view.tileSelect,MenuConstants.COLOR_MENU_SOLID_BACKGROUND,true,0);
            }
            MenuUtils.removeDropShadowFilter(this.m_view.title);
            MenuUtils.removeDropShadowFilter(this.m_view.value);
            this.callTextTicker(true);
         }
         else if(param1 == this.STATE_HOVER)
         {
            if(this.m_pressable)
            {
               this.changeTextColor(MenuConstants.COLOR_WHITE);
               MenuUtils.setColor(this.m_view.tileSelect,MenuConstants.COLOR_RED,true,MenuConstants.MenuElementSelectedAlpha);
            }
            else
            {
               this.changeTextColor(MenuConstants.COLOR_GREY);
               MenuUtils.setColor(this.m_view.tileSelect,MenuConstants.COLOR_MENU_TABS_BACKGROUND,true,MenuConstants.MenuElementBackgroundAlpha);
            }
            MenuUtils.removeDropShadowFilter(this.m_view.title);
            MenuUtils.removeDropShadowFilter(this.m_view.value);
            this.callTextTicker(true);
         }
         else
         {
            if(this.m_pressable)
            {
               this.changeTextColor(MenuConstants.COLOR_WHITE);
            }
            else
            {
               this.changeTextColor(MenuConstants.COLOR_GREY);
            }
            if(this.m_solidStyle)
            {
               MenuUtils.setColor(this.m_view.tileSelect,MenuConstants.COLOR_MENU_SOLID_BACKGROUND,false);
               MenuUtils.removeDropShadowFilter(this.m_view.title);
               MenuUtils.removeDropShadowFilter(this.m_view.value);
               this.m_view.tileSelect.alpha = 1;
            }
            else
            {
               MenuUtils.addDropShadowFilter(this.m_view.title);
               MenuUtils.addDropShadowFilter(this.m_view.value);
               this.m_view.tileSelect.alpha = 0;
            }
            this.callTextTicker(false);
         }
      }
      
      override public function onUnregister() : void
      {
         super.onUnregister();
         if(this.m_view)
         {
            this.m_textTickerUtilTitle.onUnregister();
            this.m_textTickerUtilTitle = null;
            this.m_textTickerUtilValue.onUnregister();
            this.m_textTickerUtilValue = null;
            removeChild(this.m_view);
            this.m_view = null;
         }
      }
      
      override public function handleMouseDown(param1:Function, param2:MouseEvent) : void
      {
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         if(this.m_hasSlider && this.m_selectable)
         {
            if(!m_isSelected)
            {
               if(this["_nodedata"])
               {
                  _loc5_ = this["_nodedata"]["id"] as int;
                  param1("onElementClick",_loc5_);
               }
            }
            _loc3_ = new Point(param2.stageX,param2.stageY);
            _loc4_ = this.m_view.globalToLocal(_loc3_);
            if(this.m_sliderClickRange.containsPoint(_loc4_))
            {
               param2.stopImmediatePropagation();
               _loc6_ = this.calculateSliderValueFromLocalPoint(_loc4_);
               this.sendDragValueToEngine(param1,_loc6_);
               this.setMouseDragActive(true);
               return;
            }
         }
         super.handleMouseDown(param1,param2);
      }
      
      public function handleMouseMove(param1:MouseEvent) : void
      {
         if(!this.m_sliderDragActive)
         {
            return;
         }
         param1.stopImmediatePropagation();
         var _loc2_:Point = new Point(param1.stageX,param1.stageY);
         var _loc3_:Point = this.m_view.globalToLocal(_loc2_);
         var _loc4_:Number = this.calculateSliderValueFromLocalPoint(_loc3_);
         this.sendDragValueToEngine(m_sendEventWithValue,_loc4_);
      }
      
      override public function handleMouseUp(param1:Function, param2:MouseEvent) : void
      {
         super.handleMouseUp(param1,param2);
         param2.stopImmediatePropagation();
         this.setMouseDragActive(false);
      }
      
      override public function handleMouseRollOut(param1:Function, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         super.handleMouseRollOut(param1,param2);
         param2.stopImmediatePropagation();
         this.setMouseDragActive(false);
         if(this.m_selectable)
         {
            if(this["_nodedata"])
            {
               _loc3_ = this["_nodedata"]["id"] as int;
               _loc4_ = new Array(_loc3_,false);
               param1("onElementHover",_loc4_);
            }
         }
      }
      
      override public function handleMouseOver(param1:Function, param2:MouseEvent) : void
      {
         if(m_isSelected)
         {
            param2.stopImmediatePropagation();
            return;
         }
         super.handleMouseOver(param1,param2);
      }
      
      private function calculateSliderValueFromLocalPoint(param1:Point) : Number
      {
         var _loc2_:Number = (param1.x - this.m_sliderRange.x) / this.m_sliderRange.width;
         _loc2_ = Math.max(_loc2_,0);
         _loc2_ = Math.min(_loc2_,1);
         return _loc2_ * 100;
      }
      
      private function setMouseDragActive(param1:Boolean) : void
      {
         if(this.m_sliderDragActive == param1)
         {
            return;
         }
         this.m_sliderDragActive = param1;
         if(this.m_sliderDragActive)
         {
            addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove,false,0,false);
         }
         else
         {
            removeEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove,false);
         }
      }
      
      private function sendDragValueToEngine(param1:Function, param2:Number) : void
      {
         var _loc4_:Array = null;
         var _loc3_:int = 0;
         if(this["_nodedata"])
         {
            _loc3_ = this["_nodedata"]["id"] as int;
            _loc4_ = new Array(_loc3_,param2);
            param1("onPreferenceSetValue",_loc4_);
         }
      }
   }
}
