package hud
{
	import basic.ButtonPromptImage;
	import common.BaseControl;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.MovieClip;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import mx.utils.StringUtil;
	
	public class HUDActionPrompts extends BaseControl
	{
		
		private const INVISIBLE_ICON_INDEX:int = 65535;
		
		private const IDX_FIRST_EXTRA_PROMPT:int = 4;
		
		private const MAX_PROMPTS:int = 7;
		
		private var m_view:HUDActionPromptsView;
		
		private var m_buttonClips:Vector.<MovieClip>;
		
		private var m_buttonFontSize:Vector.<int>;
		
		public function HUDActionPrompts()
		{
			var _loc1_:ButtonPromptImage = null;
			var _loc4_:MovieClip = null;
			var _loc5_:* = false;
			var _loc6_:String = null;
			var _loc7_:int = 0;
			var _loc8_:Object = null;
			this.m_buttonClips = new Vector.<MovieClip>();
			this.m_buttonFontSize = new Vector.<int>();
			super();
			this.m_view = new HUDActionPromptsView();
			addChild(this.m_view);
			var _loc2_:String = ControlsMain.getControllerType();
			var _loc3_:int = 0;
			while (_loc3_ < this.MAX_PROMPTS)
			{
				_loc4_ = this.getButtonClip(_loc3_);
				_loc1_ = new ButtonPromptImage();
				_loc4_.prompt = _loc4_.promptHolder_mc.addChild(_loc1_);
				_loc4_.prompt.platform = _loc2_;
				if (_loc3_ <= 3)
				{
					_loc4_.prompt.button = _loc3_;
				}
				_loc4_.visible = false;
				_loc5_ = _loc3_ == 3;
				_loc4_.prompt_mc.label_txt.width = 500;
				_loc4_.prompt_mc.desc_txt.width = 500;
				_loc6_ = _loc5_ ? TextFieldAutoSize.RIGHT : TextFieldAutoSize.LEFT;
				_loc4_.prompt_mc.label_txt.autoSize = _loc6_;
				_loc4_.prompt_mc.desc_txt.autoSize = _loc6_;
				this.m_buttonClips.push(_loc4_);
				_loc7_ = MenuConstants.INTERACTIONPROMPTSIZE_DEFAULT;
				this.m_buttonFontSize.push(_loc7_);
				_loc8_ = MenuConstants.InteractionIndicatorFontSpecs[_loc7_];
				MenuUtils.setupText(_loc4_.prompt_mc.label_txt, "", _loc8_.fontSizeLabel, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				MenuUtils.setupText(_loc4_.prompt_mc.desc_txt, "", _loc8_.fontSizeDesc, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
				_loc3_++;
			}
		}
		
		private function setupFontSize(param1:int, param2:int):void
		{
			if (this.m_buttonFontSize[param1] == param2)
			{
				return;
			}
			this.m_buttonFontSize[param1] = param2;
			var _loc3_:MovieClip = this.m_buttonClips[param1];
			var _loc4_:Object = MenuConstants.InteractionIndicatorFontSpecs[param2];
			var _loc5_:TextFormat;
			(_loc5_ = new TextFormat()).size = _loc4_.fontSizeLabel;
			_loc3_.prompt_mc.label_txt.defaultTextFormat = _loc5_;
			var _loc6_:TextFormat;
			(_loc6_ = new TextFormat()).size = _loc4_.fontSizeDesc;
			_loc3_.prompt_mc.desc_txt.defaultTextFormat = _loc6_;
		}
		
		public function set ShowExtraButtonsBelow(param1:Boolean):void
		{
			var _loc4_:Number = NaN;
			var _loc2_:Number = this.m_buttonClips[1].y;
			var _loc3_:int = this.IDX_FIRST_EXTRA_PROMPT;
			while (_loc3_ < this.MAX_PROMPTS)
			{
				_loc4_ = Math.abs(this.m_buttonClips[_loc3_].y - _loc2_);
				this.m_buttonClips[_loc3_].y = _loc2_ + _loc4_ * (param1 ? 1 : -1);
				_loc3_++;
			}
		}
		
		public function onSetData(param1:Object):void
		{
			var _loc7_:MovieClip = null;
			var _loc8_:Object = null;
			var _loc9_:int = 0;
			var _loc10_:* = false;
			var _loc2_:String = null;
			var _loc3_:Number = ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL ? 1.25 : 1;
			var _loc4_:Object = null;
			var _loc5_:Array = param1 as Array;
			var _loc6_:int = 0;
			_loc6_ = 0;
			while (_loc6_ < _loc5_.length && _loc6_ < this.MAX_PROMPTS)
			{
				_loc7_ = this.m_buttonClips[_loc6_];
				_loc8_ = _loc5_[_loc6_];
				_loc7_.visible = _loc8_.m_bActive;
				_loc7_.scaleX = _loc3_;
				_loc7_.scaleY = _loc3_;
				if (_loc8_.m_bActive)
				{
					_loc9_ = !!_loc8_.m_nFontSize ? int(_loc8_.m_nFontSize) : MenuConstants.INTERACTIONPROMPTSIZE_DEFAULT;
					_loc4_ = MenuConstants.InteractionIndicatorFontSpecs[_loc9_];
					_loc7_.scaleX *= _loc4_.fScaleIndividual;
					_loc7_.scaleY *= _loc4_.fScaleIndividual;
					this.setupFontSize(_loc6_, _loc9_);
					if (_loc2_ == null)
					{
						_loc2_ = ControlsMain.getControllerType();
					}
					_loc10_ = _loc6_ == 3;
					this.showActionButton(_loc7_, _loc8_, _loc10_, _loc2_);
				}
				_loc6_++;
			}
			if (_loc4_ != null)
			{
				this.m_view.scaleX = _loc4_.fScaleGroup;
				this.m_view.scaleY = _loc4_.fScaleGroup;
			}
		}
		
		private function showActionButton(param1:MovieClip, param2:Object, param3:Boolean, param4:String):void
		{
			var _loc17_:Number = NaN;
			var _loc18_:int = 0;
			var _loc19_:int = 0;
			var _loc5_:int = int(param2.m_nIconId);
			var _loc6_:String = String(param2.m_sLabel);
			var _loc7_:String = String(param2.m_sDescription);
			var _loc8_:Boolean = Boolean(param2.m_bIllegalItem);
			var _loc9_:Boolean = Boolean(param2.m_bSuspiciousItem);
			var _loc10_:Number = Number(param2.m_fProgress);
			var _loc11_:Boolean = Boolean(param2.m_bNoActionAvailable);
			var _loc12_:Number = Number(param2.m_eTypeId);
			var _loc13_:String = String(param2.m_sGlyph);
			var _loc14_:Boolean = Boolean(param2.m_bDropTempHolsterableItems);
			if (param2.m_bShowWarning)
			{
				_loc8_ = true;
			}
			if (_loc5_ == this.INVISIBLE_ICON_INDEX)
			{
				param1.visible = false;
				return;
			}
			var _loc15_:Object = MenuConstants.InteractionIndicatorFontSpecs[!!param2.m_nFontSize ? param2.m_nFontSize : MenuConstants.INTERACTIONPROMPTSIZE_DEFAULT];
			var _loc16_:int = _loc8_ || _loc9_ ? 81 : 1;
			if (_loc8_ || _loc9_)
			{
				_loc17_ = 0.46;
				_loc18_ = 58;
				_loc19_ = !!param1.hold_mc.visible ? 39 : 35;
				if (param2.m_nFontSize == MenuConstants.INTERACTIONPROMPTSIZE_MEDIUM)
				{
					_loc17_ = 0.52;
					_loc18_ = 60;
					_loc19_ = !!param1.hold_mc.visible ? 40 : 36;
				}
				else if (param2.m_nFontSize >= MenuConstants.INTERACTIONPROMPTSIZE_LARGE)
				{
					_loc17_ = 0.65;
					_loc18_ = 67;
					_loc19_ = !!param1.hold_mc.visible ? 44 : 40;
				}
				param1.illegalIcon_mc.x = param3 ? -_loc19_ : _loc19_;
				param1.illegalIcon_mc.scaleX = param1.illegalIcon_mc.scaleY = _loc17_;
				param1.prompt_mc.x = param3 ? -_loc18_ : _loc18_;
			}
			else
			{
				param1.prompt_mc.x = param3 ? -28 : 28;
			}
			param1.prompt.alpha = _loc11_ ? 0.33 : 1;
			param1.prompt_mc.label_txt.htmlText = _loc6_.toUpperCase();
			if ((Boolean(_loc7_ = StringUtil.trim(_loc7_))) && _loc7_.length > 0)
			{
				param1.prompt_mc.desc_txt.visible = true;
				param1.prompt_mc.desc_txt.htmlText = _loc7_.toUpperCase();
				param1.prompt_mc.label_txt.y = _loc15_.yOffsetLabel;
				param1.prompt_mc.desc_txt.y = _loc15_.yOffsetDesc;
			}
			else
			{
				param1.prompt_mc.desc_txt.visible = false;
				param1.prompt_mc.desc_txt.text = "";
				param1.prompt_mc.label_txt.y = _loc15_.yOffsetLabelSolo;
			}
			if (_loc9_)
			{
				param1.illegalIcon_mc.visible = true;
				param1.illegalIcon_mc.gotoAndStop("susarmed");
			}
			else if (_loc8_)
			{
				param1.illegalIcon_mc.visible = true;
				param1.illegalIcon_mc.gotoAndStop("visarmed");
			}
			else
			{
				param1.illegalIcon_mc.visible = false;
			}
			param1.prompt.scaleX = param1.prompt.scaleY = param4 == "key" ? 0.8 : 1;
			if (_loc5_ == -1)
			{
				param1.prompt.customKey = _loc13_;
			}
			else
			{
				param1.prompt.platform = param4;
				param1.prompt.button = _loc5_;
			}
			if (_loc12_ == 2 || _loc12_ == 3)
			{
				if (_loc10_ > 0)
				{
					param1.hold_mc.gotoAndStop(Math.ceil(_loc10_ * 60) + _loc16_);
				}
				else
				{
					param1.hold_mc.gotoAndStop(_loc16_);
				}
				param1.hold_mc.visible = true;
				param1.tap_mc.visible = false;
			}
			else if (_loc12_ == 4)
			{
				param1.tap_mc.visible = true;
				param1.tap_mc.play();
			}
			else
			{
				param1.tap_mc.visible = false;
				param1.hold_mc.visible = false;
			}
			if (param1.hold_mc.visible)
			{
				param1.prompt_mc.label_txt.x = param3 ? 1 - param1.prompt_mc.label_txt.textWidth : -3;
				param1.prompt_mc.desc_txt.x = param3 ? 1 - param1.prompt_mc.desc_txt.textWidth : -3;
			}
			else
			{
				param1.prompt_mc.label_txt.x = param3 ? 5 - param1.prompt_mc.label_txt.textWidth : -7;
				param1.prompt_mc.desc_txt.x = param3 ? 5 - param1.prompt_mc.desc_txt.textWidth : -7;
			}
		}
		
		private function getButtonClip(param1:int):MovieClip
		{
			return this.m_view.getChildByName("button0" + String(param1 + 1) + "_button_mc") as MovieClip;
		}
	}
}
