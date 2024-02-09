package menu3.basic
{
	import common.menu.MenuConstants;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import hud.InteractionIndicator;
	
	public dynamic class OptionsInfoHoldTogglePreview extends OptionsInfoSlideshowPreview
	{
		
		private var m_buttonsContainer:Sprite;
		
		private var m_triggersPerIndicator:Vector.<Vector.<Trigger>>;
		
		public function OptionsInfoHoldTogglePreview(param1:Object)
		{
			this.m_buttonsContainer = new Sprite();
			this.m_triggersPerIndicator = new Vector.<Vector.<Trigger>>(0);
			super(param1);
			this.m_buttonsContainer.name = "m_buttonsContainer";
			this.m_buttonsContainer.x = 0;
			this.m_buttonsContainer.y = 352;
			getPreviewContentContainer().addChild(this.m_buttonsContainer);
			if (!ControlsMain.isVrModeActive())
			{
				this.m_buttonsContainer.filters = [new DropShadowFilter(2, 90, 0, 1, 8, 8, 1, BitmapFilterQuality.HIGH, false, false, false)];
			}
			this.onSetData(param1);
		}
		
		override public function onSetData(param1:Object):void
		{
			var _loc5_:InteractionIndicator = null;
			super.onSetData(param1);
			var _loc2_:Number = OptionsInfoPreview.PX_PREVIEW_BACKGROUND_WIDTH;
			var _loc3_:int = int(param1.previewData.prompts.length);
			this.m_triggersPerIndicator.length = _loc3_;
			var _loc4_:int = 0;
			while (_loc4_ < _loc3_)
			{
				if (this.m_buttonsContainer.numChildren > _loc4_)
				{
					_loc5_ = InteractionIndicator(this.m_buttonsContainer.getChildAt(_loc4_));
				}
				else
				{
					_loc5_ = new InteractionIndicator();
					this.m_buttonsContainer.addChild(_loc5_);
				}
				_loc5_.onSetData({"m_eState": InteractionIndicator.STATE_AVAILABLE, "m_eTypeId": InteractionIndicator.TYPE_PRESS, "m_nIconId": param1.previewData.prompts[_loc4_].interactionData.m_nIconId, "m_sGlyph": param1.previewData.prompts[_loc4_].interactionData.m_sGlyph, "m_fProgress": 0, "m_sLabel": "", "m_sDescription": "", "m_nFontSize": MenuConstants.INTERACTIONPROMPTSIZE_SMALL});
				this.m_triggersPerIndicator[_loc4_] = Trigger.parseArray(param1.previewData.prompts[_loc4_].triggers);
				_loc5_.x = (_loc4_ + 1) * _loc2_ / (_loc3_ + 1);
				_loc5_.y = 40;
				_loc5_.scaleX = 1.25;
				_loc5_.scaleY = 1.25;
				_loc4_++;
			}
			while (this.m_buttonsContainer.numChildren > _loc3_)
			{
				this.m_buttonsContainer.removeChildAt(_loc3_);
			}
		}
		
		override protected function onPreviewSlideshowEnteredFrameLabel(param1:String):void
		{
			var _loc4_:Trigger = null;
			super.onPreviewSlideshowEnteredFrameLabel(param1);
			var _loc2_:int = int(this.m_triggersPerIndicator.length);
			var _loc3_:int = 0;
			while (_loc3_ < _loc2_)
			{
				for each (_loc4_ in this.m_triggersPerIndicator[_loc3_])
				{
					if (_loc4_.frameLabel == param1)
					{
						if (_loc4_.when == Trigger.When_OnEntered || _loc4_.when == Trigger.When_OnEnteredFwd && dirCurrent == Dir_Forward || _loc4_.when == Trigger.When_OnEnteredBwd && dirCurrent == Dir_Backward)
						{
							_loc4_.runOnIndicator(InteractionIndicator(this.m_buttonsContainer.getChildAt(_loc3_)));
						}
					}
				}
				_loc3_++;
			}
		}
		
		override protected function onPreviewSlideshowExitedFrameLabel(param1:String):void
		{
			var _loc4_:Trigger = null;
			super.onPreviewSlideshowExitedFrameLabel(param1);
			var _loc2_:int = int(this.m_triggersPerIndicator.length);
			var _loc3_:int = 0;
			while (_loc3_ < _loc2_)
			{
				for each (_loc4_ in this.m_triggersPerIndicator[_loc3_])
				{
					if (_loc4_.frameLabel == param1)
					{
						if (_loc4_.when == Trigger.When_OnExited || _loc4_.when == Trigger.When_OnExitedFwd && dirCurrent == Dir_Forward || _loc4_.when == Trigger.When_OnExitedBwd && dirCurrent == Dir_Backward)
						{
							_loc4_.runOnIndicator(InteractionIndicator(this.m_buttonsContainer.getChildAt(_loc3_)));
						}
					}
				}
				_loc3_++;
			}
		}
	}
}

import common.Animate;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import hud.InteractionIndicator;

class Trigger
{
	
	public static const When_OnEntered:int = 0;
	
	public static const When_OnExited:int = 1;
	
	public static const When_OnEnteredFwd:int = 2;
	
	public static const When_OnEnteredBwd:int = 3;
	
	public static const When_OnExitedFwd:int = 4;
	
	public static const When_OnExitedBwd:int = 5;
	
	public static const What_AnimatePress:int = 0;
	
	public static const What_AnimateHoldOn:int = 1;
	
	public static const What_AnimateHoldOff:int = 2;
	
	public static const What_AnimateHoldOffSubtle:int = 3;
	
	public var frameLabel:String;
	
	public var when:int;
	
	public var what:int;
	
	public function Trigger()
	{
		super();
	}
	
	public static function parseArray(param1:Array):Vector.<Trigger>
	{
		var _loc3_:Object = null;
		var _loc4_:Trigger = null;
		var _loc2_:Vector.<Trigger> = new Vector.<Trigger>(0);
		for each (_loc3_ in param1)
		{
			(_loc4_ = new Trigger()).frameLabel = _loc3_.frameLabel;
			if (!_loc4_.frameLabel)
			{
				trace("error: missing triggerData.frameLabel");
			}
			switch (_loc3_.when)
			{
			case "OnEntered": 
				_loc4_.when = When_OnEntered;
				break;
			case "OnExited": 
				_loc4_.when = When_OnExited;
				break;
			case "OnEnteredFwd": 
				_loc4_.when = When_OnEnteredFwd;
				break;
			case "OnEnteredBwd": 
				_loc4_.when = When_OnEnteredBwd;
				break;
			case "OnExitedFwd": 
				_loc4_.when = When_OnExitedFwd;
				break;
			case "OnExitedBwd": 
				_loc4_.when = When_OnExitedBwd;
				break;
			default: 
				trace("error: unrecognized triggerData.when: " + _loc3_.when);
			}
			switch (_loc3_.what)
			{
			case "AnimatePress": 
				_loc4_.what = What_AnimatePress;
				break;
			case "AnimateHoldOn": 
				_loc4_.what = What_AnimateHoldOn;
				break;
			case "AnimateHoldOff": 
				_loc4_.what = What_AnimateHoldOff;
				break;
			case "AnimateHoldOffSubtle": 
				_loc4_.what = What_AnimateHoldOffSubtle;
				break;
			default: 
				trace("error: unrecognized triggerData.what: " + _loc3_.what);
				break;
			}
			_loc2_.push(_loc4_);
		}
		return _loc2_;
	}
	
	public function runOnIndicator(param1:InteractionIndicator):void
	{
		var _loc2_:InteractionIndicatorView = InteractionIndicatorView(param1.getContainer().getChildAt(0));
		var _loc3_:DisplayObjectContainer = _loc2_.hold_mc;
		var _loc4_:DisplayObject = _loc2_.promptHolder_mc.getChildAt(0);
		_loc3_.visible = true;
		_loc3_.getChildAt(0).alpha = 1;
		switch (this.what)
		{
		case What_AnimatePress: 
			_loc3_.alpha = 0;
			Animate.fromTo(_loc3_, 0.5, 0.1, {"scaleX": 0.8, "scaleY": 0.8, "alpha": 1}, {"scaleX": 2.5, "scaleY": 2.5, "alpha": 0}, Animate.ExpoOut);
			Animate.fromTo(_loc4_, 0.1, 0, {"scaleX": 1, "scaleY": 1}, {"scaleX": 0.8, "scaleY": 0.8}, Animate.Linear, Animate.to, _loc4_, 0.2, 0, {"scaleX": 1, "scaleY": 1}, Animate.SineOut);
			break;
		case What_AnimateHoldOn: 
			_loc3_.alpha = 0;
			Animate.fromTo(_loc3_, 0.2, 0, {"scaleX": 2, "scaleY": 2, "alpha": 0}, {"scaleX": 0.9, "scaleY": 0.9, "alpha": 1}, Animate.SineOut, Animate.fromTo, _loc3_, 3, 0, {"scaleX": 0.9, "scaleY": 0.9, "alpha": 0.85}, {"scaleX": 0.8, "scaleY": 0.8, "alpha": 0.85}, Animate.Linear);
			Animate.fromTo(_loc4_, 0.1, 0, {"scaleX": 1, "scaleY": 1}, {"scaleX": 0.8, "scaleY": 0.8}, Animate.Linear);
			break;
		case What_AnimateHoldOff: 
		case What_AnimateHoldOffSubtle: 
			Animate.fromTo(_loc3_, 0.5, 0, this.what != What_AnimateHoldOffSubtle ? {"scaleX": 0.9, "scaleY": 0.9, "alpha": 1} : {"scaleX": 0.9, "scaleY": 0.9, "alpha": 0.85}, this.what != What_AnimateHoldOffSubtle ? {"scaleX": 2.5, "scaleY": 2.5, "alpha": 0} : {"scaleX": 1.5, "scaleY": 1.5, "alpha": 0}, Animate.ExpoOut);
			Animate.fromTo(_loc4_, 0.1, 0, {"scaleX": 0.8, "scaleY": 0.8}, {"scaleX": 1, "scaleY": 1}, Animate.Linear);
		}
	}
}
