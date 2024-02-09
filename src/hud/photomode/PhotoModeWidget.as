package hud.photomode
{
	import basic.ButtonPromptImage;
	import common.BaseControl;
	import common.menu.MenuUtils;
	
	public class PhotoModeWidget extends BaseControl
	{
		
		public static const VIEWFINDERSTYLE_NONE:int = 0;
		
		public static const VIEWFINDERSTYLE_CAMERAITEM:int = 1;
		
		public static const VIEWFINDERSTYLE_PHOTOOPP:int = 2;
		
		public static const VIEWFINDERSTYLE_SPYCAM:int = 3;
		
		private static const DY_HEIGHT_ENTRY:int = 21;
		
		private static const DY_GAP_BETWEEN_ENTRIES:int = 1;
		
		private static const DY_HEIGHT_BGMARGIN:int = 68;
		
		private static const DY_HEIGHT_BG_COLLAPSED:int = 37;
		
		private static const DX_GAP_BETWEEN_PROMPTIMAGE:int = 6;
		
		private static const DX_GAP_BETWEEN_PROMPTS:int = 24;
		
		private var m_view:PhotoModeWidgetView;
		
		private var m_entriesVisible:Vector.<PhotoModeEntry>;
		
		private var m_promptsVisible:Vector.<PromptData>;
		
		private var m_entriesAvailable:Vector.<PhotoModeEntry>;
		
		private var m_promptsAvailable:Vector.<PromptData>;
		
		private var m_buttonPromptImagesAvailable:Vector.<ButtonPromptImage>;
		
		public function PhotoModeWidget()
		{
			var _loc6_:ButtonPromptImage = null;
			this.m_entriesVisible = new Vector.<PhotoModeEntry>();
			this.m_promptsVisible = new Vector.<PromptData>();
			this.m_entriesAvailable = new Vector.<PhotoModeEntry>();
			this.m_promptsAvailable = new Vector.<PromptData>();
			this.m_buttonPromptImagesAvailable = new Vector.<ButtonPromptImage>();
			super();
			this.m_view = new PhotoModeWidgetView();
			addChild(this.m_view);
			this.m_view.visible = false;
			this.m_view.bg_mc.alpha = 0.4;
			var _loc1_:Array = [];
			var _loc2_:int = 4;
			while (_loc1_.length < _loc2_)
			{
				_loc1_.push(this.acquirePhotoModeEntry());
			}
			while (_loc1_.length > 0)
			{
				this.releasePhotoModeEntry(_loc1_.pop());
			}
			var _loc3_:int = 34;
			while (_loc1_.length < _loc3_)
			{
				_loc1_.push(this.acquirePrompt());
			}
			while (_loc1_.length > 0)
			{
				this.releasePrompt(_loc1_.pop());
			}
			var _loc4_:int = 4;
			var _loc5_:String = ControlsMain.getControllerType();
			while (_loc1_.length < _loc4_)
			{
				(_loc6_ = this.acquireButtonPromptImage()).platform = _loc5_;
				_loc1_.push(_loc6_);
			}
			while (_loc1_.length > 0)
			{
				this.releaseButtonPromptImage(_loc1_.pop());
			}
		}
		
		public function onSetData(param1:Object):void
		{
			if (param1 == null)
			{
				return;
			}
			if (!param1.bIsVisible)
			{
				this.m_view.visible = false;
				return;
			}
			this.m_view.visible = true;
			this.adjustNumVisibleEntries(param1.aMenuEntries.length);
			this.feedDataToEntries(param1.aMenuEntries);
			this.adjustNumVisiblePrompts(param1.aPrompts.length);
			this.feedDataToPrompts(param1.sInputPlatform, param1.aPrompts);
		}
		
		private function adjustNumVisibleEntries(param1:uint):void
		{
			var _loc2_:PhotoModeEntry = null;
			while (param1 > this.m_entriesVisible.length)
			{
				_loc2_ = this.acquirePhotoModeEntry();
				_loc2_.y = -(DY_HEIGHT_ENTRY + DY_GAP_BETWEEN_ENTRIES) * this.m_entriesVisible.length;
				this.m_entriesVisible.unshift(_loc2_);
			}
			while (param1 < this.m_entriesVisible.length)
			{
				this.releasePhotoModeEntry(this.m_entriesVisible.shift());
			}
			this.m_view.bg_mc.height = this.m_entriesVisible.length > 0 ? DY_HEIGHT_BGMARGIN + (DY_HEIGHT_ENTRY + DY_GAP_BETWEEN_ENTRIES) * this.m_entriesVisible.length : DY_HEIGHT_BG_COLLAPSED;
			this.m_view.bg_mc.y = -this.m_view.bg_mc.height;
		}
		
		private function feedDataToEntries(param1:Array):void
		{
			var _loc2_:int = 0;
			while (_loc2_ < param1.length)
			{
				this.m_entriesVisible[_loc2_].onSetData(param1[_loc2_]);
				_loc2_++;
			}
		}
		
		private function adjustNumVisiblePrompts(param1:uint):void
		{
			while (param1 > this.m_promptsVisible.length)
			{
				this.m_promptsVisible.push(this.acquirePrompt());
			}
			while (param1 < this.m_promptsVisible.length)
			{
				this.releasePrompt(this.m_promptsVisible.pop());
			}
		}
		
		private function feedDataToPrompts(param1:String, param2:Array):void
		{
			var _loc5_:Number = NaN;
			var _loc6_:PromptData = null;
			var _loc7_:Array = null;
			var _loc8_:int = 0;
			var _loc9_:ButtonPromptImage = null;
			var _loc3_:Number = 10;
			var _loc4_:int = 0;
			while (_loc4_ < param2.length)
			{
				_loc5_ = !!param2[_loc4_].bIsEnabled ? 1 : 0.3;
				_loc6_ = this.m_promptsVisible[_loc4_];
				_loc7_ = param2[_loc4_].aIcons;
				while (_loc6_.images.length < _loc7_.length)
				{
					_loc6_.images.push(this.acquireButtonPromptImage());
				}
				while (_loc6_.images.length > _loc7_.length)
				{
					this.releaseButtonPromptImage(_loc6_.images.pop());
				}
				_loc8_ = 0;
				while (_loc8_ < _loc7_.length)
				{
					if ((_loc9_ = _loc6_.images[_loc8_]).platform != param1)
					{
						_loc9_.platform = param1;
					}
					_loc9_.alpha = _loc5_;
					if (_loc7_[_loc8_] is Number)
					{
						_loc9_.button = _loc7_[_loc8_];
					}
					else if (_loc7_[_loc8_] is String)
					{
						_loc9_.customKey = _loc7_[_loc8_];
					}
					_loc9_.x = _loc3_ + _loc9_.width / 2;
					_loc3_ += _loc9_.width + 2;
					_loc8_++;
				}
				_loc6_.labelTextField.text = param2[_loc4_].sLabel;
				_loc6_.labelTextField.alpha = _loc5_;
				_loc6_.labelTextField.x = _loc3_ + DX_GAP_BETWEEN_PROMPTIMAGE;
				_loc3_ += DX_GAP_BETWEEN_PROMPTIMAGE + _loc6_.labelTextField.width + DX_GAP_BETWEEN_PROMPTS;
				_loc4_++;
			}
			if (_loc3_ > 535)
			{
				this.m_view.bg_mc.width = _loc3_;
			}
			else
			{
				this.m_view.bg_mc.width = 535;
			}
		}
		
		public function triggerTestHUD():void
		{
			this.onSetData({"bIsVisible": true, "aMenuEntries": [{"eType": PhotoModeEntry.TYPE_TOGGLE, "sLabel": "Selfie cam", "bIsEnabled": MenuUtils.getRandomBoolean(), "bIsHighlighted": MenuUtils.getRandomBoolean(), "bIsToggledOn": MenuUtils.getRandomBoolean(), "sCurrentValue": "maybe"}, {"eType": PhotoModeEntry.TYPE_SLIDER, "sLabel": "DOF", "bIsEnabled": MenuUtils.getRandomBoolean(), "bIsHighlighted": MenuUtils.getRandomBoolean(), "fSliderPerc": MenuUtils.getRandomInRange(0, 100, true), "sCurrentValue": "xx%"}, {"eType": PhotoModeEntry.TYPE_LIST, "sLabel": "Filter", "bIsEnabled": MenuUtils.getRandomBoolean(), "bIsHighlighted": MenuUtils.getRandomBoolean(), "sCurrentValue": "Sepia"}], "sInputPlatform": ["xboxone", "ps4", "key", "pc"][MenuUtils.getRandomInRange(0, 3, true)], "aPrompts": MenuUtils.shuffleArray([{"bIsEnabled": true, "aIcons": [5, 7, 6, 8], "sLabel": "Navigate"}, {"bIsEnabled": true, "aIcons": [10], "sLabel": "Take Photo"}, {"bIsEnabled": true, "aIcons": [1], "sLabel": "Accept"}, {"bIsEnabled": true, "aIcons": [4], "sLabel": "Cancel"}, {"bIsEnabled": true, "aIcons": [], "sLabel": "Nothin\'"}]).slice(MenuUtils.getRandomInRange(0, 5, true))});
		}
		
		private function acquirePhotoModeEntry():PhotoModeEntry
		{
			var _loc1_:PhotoModeEntry = null;
			if (this.m_entriesAvailable.length > 0)
			{
				_loc1_ = this.m_entriesAvailable.pop();
				_loc1_.visible = true;
			}
			else
			{
				_loc1_ = new PhotoModeEntry();
				this.m_view.entryholder_mc.addChild(_loc1_);
			}
			return _loc1_;
		}
		
		private function releasePhotoModeEntry(param1:PhotoModeEntry):void
		{
			param1.visible = false;
			this.m_entriesAvailable.push(param1);
		}
		
		private function acquirePrompt():PromptData
		{
			var _loc1_:PromptData = null;
			if (this.m_promptsAvailable.length > 0)
			{
				_loc1_ = this.m_promptsAvailable.pop();
				_loc1_.labelTextField.visible = true;
			}
			else
			{
				_loc1_ = new PromptData();
				this.m_view.addChild(_loc1_.labelTextField);
			}
			return _loc1_;
		}
		
		private function releasePrompt(param1:PromptData):void
		{
			while (param1.images.length > 0)
			{
				this.releaseButtonPromptImage(param1.images.pop());
			}
			param1.labelTextField.visible = false;
			this.m_promptsAvailable.push(param1);
		}
		
		private function acquireButtonPromptImage():ButtonPromptImage
		{
			var _loc1_:ButtonPromptImage = null;
			if (this.m_buttonPromptImagesAvailable.length > 0)
			{
				_loc1_ = this.m_buttonPromptImagesAvailable.pop();
				_loc1_.visible = true;
			}
			else
			{
				_loc1_ = new ButtonPromptImage();
				_loc1_.y = -19;
				_loc1_.scaleX = _loc1_.scaleY = 0.6;
				this.m_view.addChild(_loc1_);
			}
			return _loc1_;
		}
		
		private function releaseButtonPromptImage(param1:ButtonPromptImage):void
		{
			param1.visible = false;
			this.m_buttonPromptImagesAvailable.push(param1);
		}
	}
}

import basic.ButtonPromptImage;
import common.menu.MenuConstants;
import common.menu.MenuUtils;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

class PromptData
{
	
	public var images:Vector.<ButtonPromptImage>;
	
	public var labelTextField:TextField;
	
	public function PromptData()
	{
		this.images = new Vector.<ButtonPromptImage>();
		this.labelTextField = new TextField();
		super();
		this.labelTextField.autoSize = TextFieldAutoSize.LEFT;
		this.labelTextField.y = -30;
		MenuUtils.setupText(this.labelTextField, "", 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
	}
}
