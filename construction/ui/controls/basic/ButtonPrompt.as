package basic
{
	import common.CommonUtils;
	import common.Log;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	
	public class ButtonPrompt extends Sprite
	{
		
		private var m_promptWidth:Number = 0;
		
		private var m_buttonPromptImage:ButtonPromptImage;
		
		public function ButtonPrompt(param1:Object, param2:Boolean, param3:Function, param4:Number, param5:Boolean = false)
		{
			var prompt:MenuButtonLegendView;
			var buttonPromptWidth:Number = NaN;
			var data:Object = param1;
			var tabsnavigation:Boolean = param2;
			var mouseCallback:Function = param3;
			var xOffset:Number = param4;
			var calculateWidth:Boolean = param5;
			super();
			prompt = new MenuButtonLegendView();
			this.m_buttonPromptImage = ButtonPromptImage.AcquireInstance();
			this.m_buttonPromptImage.y = 39;
			this.m_buttonPromptImage.alpha = 0.8;
			this.m_buttonPromptImage.platform = String(data.platform) || ControlsMain.getControllerType();
			this.setupSymbol(data, this.m_buttonPromptImage);
			if (mouseCallback != null)
			{
				prompt.addEventListener(MouseEvent.MOUSE_UP, function(param1:MouseEvent):void
				{
					param1.stopPropagation();
					mouseCallback(data.actiontype);
				}, false, 0, false);
			}
			prompt.addChild(this.m_buttonPromptImage);
			prompt.x = xOffset;
			if (tabsnavigation)
			{
				prompt.y = 10;
			}
			prompt.header.autoSize = TextFieldAutoSize.LEFT;
			MenuUtils.setupText(prompt.header, data.actionlabel, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			if (calculateWidth == false)
			{
				this.m_buttonPromptImage.x = 27;
			}
			else
			{
				buttonPromptWidth = this.m_buttonPromptImage.getWidth();
				this.setPromptPositions(prompt, this.m_buttonPromptImage, buttonPromptWidth);
				this.m_promptWidth = this.getPromptWidth(prompt, buttonPromptWidth);
			}
			if (tabsnavigation && data.actiontype == "lb")
			{
				prompt.indicator.arrowleft.visible = true;
				prompt.indicator.arrowright.visible = false;
				prompt.indicator.indicatorline.visible = false;
				prompt.indicator.visible = true;
			}
			else if (tabsnavigation && data.actiontype == "rb")
			{
				prompt.indicator.arrowleft.visible = false;
				prompt.indicator.arrowright.visible = true;
				prompt.indicator.indicatorline.visible = false;
				prompt.indicator.visible = true;
			}
			else
			{
				prompt.indicator.arrowleft.visible = false;
				prompt.indicator.arrowright.visible = false;
				prompt.indicator.indicatorline.visible = true;
				prompt.indicator.visible = false;
				if (data.hideIndicator === false)
				{
					prompt.indicator.visible = true;
				}
			}
			if (data.hidePrompt)
			{
				prompt.visible = false;
			}
			if (data.transparentPrompt)
			{
				this.m_buttonPromptImage.alpha = 1;
				prompt.alpha = 0.4;
				prompt.indicator.visible = true;
				prompt.visible = true;
			}
			if (data.disabledPrompt)
			{
				prompt.alpha = 0.2;
			}
			addChild(prompt);
			if (!calculateWidth)
			{
				this.m_promptWidth = this.width;
			}
		}
		
		public static function shouldSkipPrompt(param1:Object):Boolean
		{
			var _loc3_:String = null;
			var _loc4_:String = null;
			if (param1 == null)
			{
				return false;
			}
			var _loc2_:Object = param1.customplatform;
			if (_loc2_ != null)
			{
				_loc3_ = String(String(param1.platform) || ControlsMain.getControllerType());
				if ((_loc4_ = _loc2_.platform as String) != null && _loc4_ == _loc3_)
				{
					if (_loc2_.hide === true)
					{
						return true;
					}
				}
			}
			return false;
		}
		
		private static function getPlatform(param1:Object):String
		{
			if (param1 != null && param1.platform != null)
			{
				return param1.platform;
			}
			return ControlsMain.getControllerType();
		}
		
		public function getWidth():Number
		{
			return this.m_promptWidth;
		}
		
		private function getPromptWidth(param1:MenuButtonLegendView, param2:Number):Number
		{
			return param1.header.x + param1.header.width;
		}
		
		private function setPromptPositions(param1:MenuButtonLegendView, param2:ButtonPromptImage, param3:Number):void
		{
			var _loc4_:Number = 0;
			var _loc5_:Number = 5;
			var _loc6_:Number = param3 / 2 + _loc4_;
			param2.x = Math.ceil(_loc6_);
			param1.header.x = Math.ceil(_loc4_ + param3 + _loc5_);
		}
		
		public function onUnregister():void
		{
			this.m_buttonPromptImage.parent.removeChild(this.m_buttonPromptImage);
			removeChildren();
			if (this.m_buttonPromptImage != null)
			{
				ButtonPromptImage.ReleaseInstance(this.m_buttonPromptImage);
			}
		}
		
		private function setupSymbol(param1:Object, param2:ButtonPromptImage):void
		{
			var _loc4_:String = null;
			if (param1.actionglyph != null && param1.actionglyph.length > 0)
			{
				param2.customKey = param1.actionglyph;
			}
			else if (param1.actiontype != null && param1.actiontype.length > 0)
			{
				param2.action = param1.actiontype;
			}
			else
			{
				Log.xerror(Log.ChannelButtonPrompt, "neither actionglyph nor actiontype were specified");
			}
			var _loc3_:Object = param1.customplatform;
			if (_loc3_ == null)
			{
				if (CommonUtils.getPlatformString() == CommonUtils.PLATFORM_STADIA && param2.platform == CommonUtils.CONTROLLER_TYPE_KEY && param1.actiontype == "cancel")
				{
					_loc3_ = new Object();
					_loc3_.platform = CommonUtils.CONTROLLER_TYPE_KEY;
					_loc3_.actiontype = "kb_tab";
				}
			}
			if (_loc3_ != null)
			{
				if ((_loc4_ = _loc3_.platform as String) != null && _loc4_ == param2.platform)
				{
					if (_loc3_.actionglyph != null && _loc3_.actionglyph.length > 0)
					{
						param2.customKey = _loc3_.actionglyph;
					}
					else if (_loc3_.actiontype != null && _loc3_.actiontype.length > 0)
					{
						param2.action = _loc3_.actiontype;
					}
					else
					{
						Log.xerror(Log.ChannelButtonPrompt, "data.customplatform specified, but property \'actiontype\' or \'actionglyph\' not set");
					}
				}
				else if (_loc4_ == null || _loc4_.length == 0)
				{
					Log.xerror(Log.ChannelButtonPrompt, "data.customplatform specified, but property \'platform\' not set");
				}
			}
		}
	}
}
