package menu3
{
	import common.CommonUtils;
	import common.Localization;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextLineMetrics;
	import mx.utils.StringUtil;
	
	public dynamic class ControllerLayout extends MenuElementBase
	{
		
		private var m_view:ControllerLayoutView;
		
		private var m_labelFontSize:Number = 20;
		
		private var m_labelFontType:String = "$medium";
		
		private var m_labelFontColor:String;
		
		private var m_altLabelFontSize:Number = 19;
		
		private var m_altLabelFontType:String = "$medium";
		
		private var m_altLabelFontColor:String;
		
		public function ControllerLayout(param1:Object)
		{
			this.m_labelFontColor = MenuConstants.FontColorWhite;
			this.m_altLabelFontColor = MenuConstants.FontColorWhite;
			super(param1);
			this.m_view = new ControllerLayoutView();
			addChild(this.m_view);
		}
		
		public static function isHoldModeForWeaponAim():Boolean
		{
			return CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_AIM_TOGGLE") == 0;
		}
		
		public static function isHoldModeForWalkSpeed():Boolean
		{
			return CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_WALK_SPEED_TOGGLE") == 0;
		}
		
		public static function isHoldModeForInstinctActivation():Boolean
		{
			return CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_INSTINCT_ACTIVATION_TOGGLE") == 0;
		}
		
		public static function isHoldModeForPrecisionAim():Boolean
		{
			return CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_PRECISION_AIM_TOGGLE") == 0;
		}
		
		public static function isHoldModeForItemPlacement():Boolean
		{
			return CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_ITEM_PLACEMENT_TOGGLE") == 0;
		}
		
		override public function onSetData(param1:Object):void
		{
			var _loc2_:String = ControlsMain.getControllerType();
			if (_loc2_ == CommonUtils.CONTROLLER_TYPE_PS4 && ControlsMain.isVrModeActive())
			{
				CommonUtils.gotoFrameLabelAndStop(this.m_view, "ps4_vr");
				this.setVrControls(false);
				return;
			}
			if (_loc2_ == CommonUtils.CONTROLLER_TYPE_OCULUSVR)
			{
				CommonUtils.gotoFrameLabelAndStop(this.m_view, _loc2_);
				this.setVrControls(true);
				return;
			}
			CommonUtils.gotoFrameLabelAndStop(this.m_view, _loc2_);
			if (_loc2_ == CommonUtils.CONTROLLER_TYPE_KEY || _loc2_ == CommonUtils.CONTROLLER_TYPE_OPENVR)
			{
				return;
			}
			this.setRegularControls(param1);
		}
		
		private function setVrControls(param1:Boolean):void
		{
			var _loc2_:Object = null;
			var _loc3_:Object = null;
			var _loc4_:TextField = null;
			var _loc5_:TextField = null;
			var _loc6_:Number = NaN;
			var _loc9_:Number = NaN;
			for each (_loc2_ in[{"clip": this.m_view.label0, "lstr": Localization.get("UI_VR_TEXT_BINDING_AIM_ITEMS")}, {"clip": this.m_view.label1, "lstr": Localization.get("UI_VR_TEXT_BINDING_RUN")}, {"clip": this.m_view.label2, "lstr": Localization.get("UI_VR_TEXT_BINDING_INSTINCT")}, {"clip": this.m_view.label3, "lstr": Localization.get("UI_VR_TEXT_BINDING_INVENTORY")}, {"clip": this.m_view.label4, "lstr": Localization.get("UI_VR_TEXT_BINDING_DROP_ITEM")}, {"clip": this.m_view.label5, "lstr": Localization.get("UI_VR_TEXT_BINDING_PLACE_ITEM")}, {"clip": this.m_view.label6, "lstr": Localization.get("UI_VR_TEXT_BINDING_MOVE")}, {"clip": this.m_view.label7, "lstr": Localization.get("UI_VR_TEXT_BINDING_ROTATE")}, {"clip": this.m_view.label8, "lstr": Localization.get("UI_VR_TEXT_BINDING_CROUCH")}, {"clip": this.m_view.label9, "lstr": Localization.get("UI_VR_TEXT_BINDING_SHOOT") + " / " + Localization.get("UI_VR_TEXT_BINDING_THROW_ITEMS")}, {"clip": this.m_view.label10, "lstr": Localization.get("UI_VR_TEXT_BINDING_CLOSE_COMBAT_PRIMING")}, {"clip": this.m_view.label11, "lstr": Localization.get("UI_VR_TEXT_BINDING_GRAB") + " / " + Localization.get("UI_VR_TEXT_BINDING_DROP")}, {"clip": this.m_view.label12, "lstr": Localization.get("UI_VR_TEXT_BINDING_INTERACT")}, {"clip": this.m_view.label13, "lstr": Localization.get("UI_VR_TEXT_BINDING_AGILITY_ACTIONS")}, {"clip": this.m_view.label14, "lstr": Localization.get("UI_VR_TEXT_BINDING_TAKE_DISGUISE")}, {"clip": this.m_view.label15, "lstr": Localization.get("UI_VR_TEXT_BINDING_RELOAD")}, {"clip": this.m_view.label16, "lstr": Localization.get("UI_VR_TEXT_BINDING_MENU")}, {"clip": this.m_view.label17, "lstr": Localization.get("UI_VR_TEXT_BINDING_NOTEBOOK")}, {"clip": this.m_view.label18, "lstr": Localization.get("UI_PREFERENCE_AIM_ASSIST")}, {"clip": this.m_view.label19, "lstr": Localization.get("UI_VR_TEXT_BINDING_INTERACT") + " / " + Localization.get("UI_VR_TEXT_BINDING_RELOAD")}, {"clip": this.m_view.label20, "lstr": Localization.get("UI_VR_TEXT_BINDING_SHOOT")}, {"clip": this.m_view.label23, "lstr": Localization.get("UI_VR_TEXT_BINDING_RECENTER")}])
			{
				if (_loc2_.clip != null)
				{
					MenuUtils.setupText(_loc2_.clip.label_txt, _loc2_.lstr, this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
				}
			}
			for each (_loc3_ in[{"clip": this.m_view.alt_control_instruction0, "lstr": Localization.get("UI_VR_TEXT_BINDING_HOLD")}, {"clip": this.m_view.alt_control_instruction1, "lstr": Localization.get("UI_VR_TEXT_BINDING_HOLD"), "hideIt": !isHoldModeForWalkSpeed()}, {"clip": this.m_view.alt_control_instruction3, "lstr": Localization.get("UI_VR_TEXT_BINDING_HOLD")}, {"clip": this.m_view.alt_control_instruction13, "lstr": Localization.get("UI_VR_TEXT_BINDING_HOLD")}, {"clip": this.m_view.alt_control_instruction19, "lstr": Localization.get("UI_VR_TEXT_BINDING_HOLD")}, {"clip": this.m_view.alt_control_instruction20, "lstr": Localization.get("UI_VR_TEXT_BINDING_HOLD"), "hideIt": !isHoldModeForInstinctActivation()}, {"clip": this.m_view.alt_control_instruction21, "lstr": Localization.get("UI_VR_TEXT_BINDING_PRESS")}, {"clip": this.m_view.alt_control_instruction22, "lstr": Localization.get("UI_VR_TEXT_BINDING_PRESS")}, {"clip": this.m_view.alt_control_instruction23, "lstr": Localization.get("EUI_TEXT_BINDING_SQUEEZE")}, {"clip": this.m_view.alt_control_instruction24, "lstr": Localization.get("UI_VR_TEXT_BINDING_PRESS")}])
			{
				if (_loc3_.clip != null)
				{
					_loc3_.clip.visible = !_loc3_.hideIt;
					MenuUtils.setupTextUpper(_loc3_.clip.alt_label_txt, _loc3_.lstr, this.m_altLabelFontSize, this.m_altLabelFontType, this.m_altLabelFontColor);
				}
			}
			this.setBgColorAndSize([this.m_view.alt_control_instruction0, this.m_view.alt_control_instruction1, this.m_view.alt_control_instruction3, this.m_view.alt_control_instruction13, this.m_view.alt_control_instruction19, this.m_view.alt_control_instruction20, this.m_view.alt_control_instruction21, this.m_view.alt_control_instruction22, this.m_view.alt_control_instruction23, this.m_view.alt_control_instruction24]);
			this.checkOverlaps();
			(_loc4_ = new TextField()).name = "txtMissionStatus";
			addChild(_loc4_);
			MenuUtils.setupText(_loc4_, Localization.get("UI_VR_TEXT_MOTION_MISSION_STATUS"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			_loc4_.autoSize = TextFieldAutoSize.LEFT;
			(_loc5_ = new TextField()).name = "txtLookAtBackOfHand";
			addChild(_loc5_);
			MenuUtils.setupTextUpper(_loc5_, Localization.get("UI_VR_TEXT_MOTION_LOOK_AT_BACK_OF_HAND"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			_loc5_.autoSize = TextFieldAutoSize.LEFT;
			_loc6_ = param1 ? 230 : 700;
			var _loc7_:Number = 630;
			var _loc8_:Number = 6;
			_loc9_ = Math.max(_loc4_.width, _loc5_.width);
			_loc4_.x = _loc6_ - _loc4_.width / 2;
			_loc4_.y = _loc7_ - _loc4_.height - _loc8_ / 2;
			_loc5_.x = _loc6_ - _loc5_.width / 2;
			_loc5_.y = _loc7_ + _loc8_ / 2;
			graphics.beginFill(MenuConstants.COLOR_MENU_TABS_BACKGROUND, MenuConstants.MenuElementBackgroundAlpha);
			graphics.drawRect(_loc5_.x - 3, _loc5_.y, _loc5_.width + 6, _loc5_.height);
			graphics.endFill();
			var _loc10_:Number = _loc6_ - _loc9_ / 2;
			var _loc11_:Number = _loc6_ + _loc9_ / 2;
			graphics.lineStyle(1, 16777215, 0.8);
			graphics.moveTo(_loc11_, _loc7_ - (_loc4_.height - _loc4_.textHeight) / 2);
			graphics.lineTo(_loc10_, _loc7_ - (_loc4_.height - _loc4_.textHeight) / 2);
		}
		
		private function setRegularControls(param1:Object):void
		{
			var _loc2_:Object = null;
			MenuUtils.setupText(this.m_view.label0.label_txt, Localization.get("EUI_TEXT_BINDING_AIM"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			MenuUtils.setupText(this.m_view.label1.label_txt, Localization.get("EUI_TEXT_BINDING_RUN"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			MenuUtils.setupText(this.m_view.label2.label_txt, Localization.get("EUI_TEXT_BINDING_MOVE"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			MenuUtils.setupText(this.m_view.label3.label_txt, Localization.get("EUI_TEXT_BINDING_CAMERA_SHOULDER"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			MenuUtils.setupText(this.m_view.label4.label_txt, Localization.get("EUI_TEXT_BINDING_HOLSTER") + " / " + Localization.get("EUI_TEXT_BINDING_UNHOLSTER"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			MenuUtils.setupText(this.m_view.label5.label_txt, (!!param1.emotesenabled ? Localization.get("EUI_TEXT_BINDING_EMOTE") + " / " : "") + Localization.get("EUI_TEXT_BINDING_INVENTORY"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			MenuUtils.setupText(this.m_view.label6.label_txt, Localization.get("EUI_TEXT_BINDING_PLACE_ITEM"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			MenuUtils.setupText(this.m_view.label7.label_txt, Localization.get("EUI_TEXT_BINDING_MENU"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			MenuUtils.setupText(this.m_view.label8.label_txt, Localization.get("EUI_TEXT_BINDING_NOTEBOOK"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			MenuUtils.setupText(this.m_view.label9.label_txt, Localization.get("EUI_TEXT_BINDING_DROP_ITEM"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			MenuUtils.setupText(this.m_view.label10.label_txt, Localization.get("EUI_TEXT_BINDING_MOVE_CAMERA"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			MenuUtils.setupText(this.m_view.label11.label_txt, Localization.get("EUI_TEXT_BINDING_SHOOT_THROW"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			MenuUtils.setupText(this.m_view.label12.label_txt, Localization.get("EUI_TEXT_BINDING_RELOAD"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			MenuUtils.setupText(this.m_view.label13.label_txt, Localization.get("EUI_TEXT_BINDING_INSTINCT"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			MenuUtils.setupText(this.m_view.label14.label_txt, Localization.get("EUI_TEXT_BINDING_INTERACT"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			MenuUtils.setupText(this.m_view.label15.label_txt, Localization.get("EUI_TEXT_BINDING_PICK_UP"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			MenuUtils.setupText(this.m_view.label16.label_txt, Localization.get("EUI_TEXT_BINDING_TAKE_COVER") + " / " + Localization.get("EUI_TEXT_BINDING_DROP_BODY"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			MenuUtils.setupText(this.m_view.label17.label_txt, Localization.get("EUI_TEXT_BINDING_DRAG_BODY"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			MenuUtils.setupText(this.m_view.label18.label_txt, Localization.get("EUI_TEXT_BINDING_AGILITY_ACTIONS"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			MenuUtils.setupText(this.m_view.label19.label_txt, Localization.get("EUI_TEXT_BINDING_TAKE_DISGUISE"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			MenuUtils.setupText(this.m_view.label20.label_txt, Localization.get("EUI_TEXT_BINDING_MELEE"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			MenuUtils.setupText(this.m_view.label21.label_txt, Localization.get("EUI_TEXT_BINDING_USE_ITEM"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			MenuUtils.setupText(this.m_view.label22.label_txt, Localization.get("EUI_TEXT_BINDING_SNEAK"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			for each (_loc2_ in[{"clip": this.m_view.alt_control_instruction0, "lstr": Localization.get("EUI_TEXT_BINDING_HOLD"), "hideIt": !isHoldModeForWeaponAim()}, {"clip": this.m_view.alt_control_instruction1, "lstr": Localization.get("EUI_TEXT_BINDING_HOLD"), "hideIt": !isHoldModeForWalkSpeed()}, {"clip": this.m_view.alt_control_instruction3, "lstr": Localization.get("EUI_TEXT_BINDING_CLICK")}, {"clip": this.m_view.alt_control_instruction6, "lstr": Localization.get(isHoldModeForItemPlacement() ? "EUI_TEXT_BINDING_HOLD_BOTH" : "EUI_TEXT_BINDING_PRESS_BOTH")}, {"clip": this.m_view.alt_control_instruction13, "lstr": Localization.get("EUI_TEXT_BINDING_HOLD"), "anchor": (isHoldModeForInstinctActivation() ? this.m_view.label13 : this.m_view.label12)}, {"clip": this.m_view.alt_control_instruction15, "lstr": Localization.get("EUI_TEXT_BINDING_HOLD")}, {"clip": this.m_view.alt_control_instruction17, "lstr": Localization.get("EUI_TEXT_BINDING_HOLD")}, {"clip": this.m_view.alt_control_instruction19, "lstr": Localization.get("EUI_TEXT_BINDING_HOLD")}, {"clip": this.m_view.alt_control_instruction21, "lstr": Localization.get("EUI_TEXT_BINDING_HOLD")}, {"clip": this.m_view.alt_control_instruction22, "lstr": Localization.get("EUI_TEXT_BINDING_CLICK")}])
			{
				if (_loc2_.clip != null)
				{
					_loc2_.clip.visible = !_loc2_.hideIt;
					if (_loc2_.anchor != null)
					{
						_loc2_.clip.y = _loc2_.anchor.y - 23;
					}
					MenuUtils.setupTextUpper(_loc2_.clip.alt_label_txt, _loc2_.lstr, this.m_altLabelFontSize, this.m_altLabelFontType, this.m_altLabelFontColor);
				}
			}
			this.setBgColorAndSize([this.m_view.alt_control_instruction0, this.m_view.alt_control_instruction1, this.m_view.alt_control_instruction3, this.m_view.alt_control_instruction6, this.m_view.alt_control_instruction13, this.m_view.alt_control_instruction15, this.m_view.alt_control_instruction17, this.m_view.alt_control_instruction19, this.m_view.alt_control_instruction21, this.m_view.alt_control_instruction22]);
			this.checkOverlaps();
		}
		
		private function setBgColorAndSize(param1:Array):void
		{
			var _loc2_:MovieClip = null;
			for each (_loc2_ in param1)
			{
				if (_loc2_ != null)
				{
					_loc2_.alt_label_txt.autoSize = TextFieldAutoSize.RIGHT;
					_loc2_.alt_label_bg_mc.width = _loc2_.alt_label_txt.width + 5;
					MenuUtils.setColor(_loc2_.alt_label_bg_mc, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
				}
			}
		}
		
		private function checkOverlaps():void
		{
			var _loc4_:SizedItem = null;
			var _loc5_:SizedItem = null;
			var _loc7_:MovieClip = null;
			var _loc8_:Rectangle = null;
			var _loc9_:Number = NaN;
			var _loc10_:TextLineMetrics = null;
			var _loc11_:Number = NaN;
			var _loc12_:Number = NaN;
			var _loc1_:Vector.<SizedItem> = new Vector.<SizedItem>(0);
			var _loc2_:Vector.<SizedItem> = new Vector.<SizedItem>(0);
			var _loc3_:int = 0;
			while (_loc3_ < this.m_view.numChildren)
			{
				if ((_loc7_ = this.m_view.getChildAt(_loc3_) as MovieClip) != null)
				{
					_loc9_ = 16;
					if (_loc7_.name.search(/^label\d+$/) == 0)
					{
						if (!(!_loc7_.visible || StringUtil.trim(_loc7_.label_txt.text).length == 0))
						{
							_loc8_ = _loc7_.label_txt.getBounds(this);
							_loc10_ = _loc7_.label_txt.getLineMetrics(0);
							_loc11_ = 2;
							_loc8_.width *= (2 * _loc11_ + _loc10_.width + 2 * _loc10_.x) / _loc7_.label_txt.width;
							_loc8_.height *= (2 * _loc11_ + _loc10_.height) / _loc7_.label_txt.height;
							_loc8_.width += _loc9_;
							_loc1_.push(new SizedItem(_loc7_, _loc8_));
						}
					}
					else if (_loc7_.name.search(/^alt_control_instruction\d+$/) == 0)
					{
						if (!(!_loc7_.visible || StringUtil.trim(_loc7_.alt_label_txt.text).length == 0))
						{
							_loc8_ = _loc7_.getBounds(this);
							_loc8_.x -= _loc9_;
							_loc8_.width += _loc9_;
							_loc2_.push(new SizedItem(_loc7_, _loc8_));
						}
					}
				}
				_loc3_++;
			}
			var _loc6_:Number = 1;
			for each (_loc4_ in _loc1_)
			{
				for each (_loc5_ in _loc2_)
				{
					if (_loc4_.rect.intersects(_loc5_.rect))
					{
						_loc12_ = (_loc5_.mc.x - _loc4_.mc.x) / (_loc4_.rect.width + _loc5_.rect.width);
						_loc6_ = Math.min(_loc6_, _loc12_);
					}
				}
			}
			for each (_loc4_ in _loc1_)
			{
				_loc4_.mc.scaleX *= _loc6_;
			}
			for each (_loc5_ in _loc2_)
			{
				_loc5_.mc.scaleX *= _loc6_;
			}
		}
		
		override public function onUnregister():void
		{
			if (this.m_view)
			{
				removeChild(this.m_view);
				this.m_view = null;
			}
		}
	}
}

import flash.display.MovieClip;
import flash.geom.Rectangle;

class SizedItem
{
	
	public var mc:MovieClip;
	
	public var rect:Rectangle;
	
	public function SizedItem(param1:MovieClip, param2:Rectangle)
	{
		super();
		this.mc = param1;
		this.rect = param2;
	}
}
