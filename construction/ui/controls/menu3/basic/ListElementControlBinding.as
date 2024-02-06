package menu3.basic
{
	import common.Animate;
	import common.CommonUtils;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import common.menu.textTicker;
	import fl.motion.Color;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import menu3.containers.CollapsableListContainer;
	
	public dynamic class ListElementControlBinding extends CollapsableListContainer
	{
		
		private var m_view:ListElementControlBindingView;
		
		private var m_textObj:Object;
		
		private var m_textTicker:textTicker;
		
		private var m_font:String;
		
		public function ListElementControlBinding(param1:Object)
		{
			this.m_textObj = new Object();
			super(param1);
			this.m_view = new ListElementControlBindingView();
			this.m_view.tileSelect.alpha = 0;
			this.m_view.tileSelectPulsate.alpha = 0;
			this.m_view.tileSelected.alpha = 0;
			this.m_view.tileDarkBg.alpha = 0.08;
			this.m_view.tileBg.alpha = 0;
			addChild(this.m_view);
		}
		
		override public function onSetData(param1:Object):void
		{
			this.setupTextField(param1.title);
			MenuUtils.setTintColor(this.m_view.tileSelect, MenuUtils.TINT_COLOR_MAGENTA_DARK, false);
			if (getNodeProp(this, "pressable") == false)
			{
				MenuUtils.setTintColor(this.m_view.tileSelect, MenuUtils.TINT_COLOR_GREY, false);
				MenuUtils.setTintColor(this.m_view.tileSelectPulsate, MenuUtils.TINT_COLOR_GREY, false);
			}
			if (getNodeProp(this, "selectable") == false)
			{
				MenuUtils.setTintColor(this.m_view.tileDarkBg, MenuUtils.TINT_COLOR_GREY, false);
				this.changeTextColor(this.m_view.title, MenuConstants.COLOR_GREY_DARK);
			}
		}
		
		override public function getView():Sprite
		{
			return this.m_view.tileBg;
		}
		
		private function setupTextField(param1:String):void
		{
			this.m_textObj.title = param1;
			MenuUtils.setupText(this.m_view.title, param1, 28, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			if (m_isSelected)
			{
				this.changeTextColor(this.m_view.title, MenuConstants.COLOR_WHITE);
			}
			MenuUtils.truncateTextfield(this.m_view.title, 1);
			CommonUtils.changeFontToGlobalIfNeeded(this.m_view.title);
			this.callTextTicker(true);
		}
		
		private function callTextTicker(param1:Boolean):void
		{
			if (!this.m_textTicker)
			{
				this.m_textTicker = new textTicker();
			}
			if (param1)
			{
				this.m_textTicker.startTextTicker(this.m_view.title, this.m_textObj.title, CommonUtils.changeFontToGlobalIfNeeded);
			}
			else
			{
				this.m_textTicker.stopTextTicker(this.m_view.title, this.m_textObj.title);
				MenuUtils.truncateTextfield(this.m_view.title, 1);
			}
		}
		
		private function changeTextColor(param1:TextField, param2:uint):void
		{
			param1.textColor = param2;
			if (!this.m_textTicker)
			{
				this.m_textTicker = new textTicker();
			}
			this.m_textTicker.setTextColor(param2);
		}
		
		override public function addChild2(param1:Sprite, param2:int = -1):void
		{
			super.addChild2(param1, param2);
			if (getNodeProp(param1, "col") === undefined)
			{
				if (this.getData().direction != "horizontal" && this.getData().direction != "horizontalWrap")
				{
					param1.x = 32;
				}
			}
		}
		
		override protected function handleSelectionChange():void
		{
			Animate.kill(this.m_view.tileSelect);
			MenuUtils.pulsate(this.m_view.tileSelectPulsate, false);
			Animate.kill(this.m_view.tileSelected);
			if (m_loading)
			{
				return;
			}
			if (m_isSelected)
			{
				Animate.legacyTo(this.m_view.tileSelect, MenuConstants.HiliteTime, {"alpha": 1}, Animate.Linear);
				this.m_view.tileSelected.alpha = 0;
				Animate.legacyTo(this.m_view.tileSelected, MenuConstants.HiliteTime, {"alpha": 1}, Animate.ExpoOut);
				this.changeTextColor(this.m_view.title, MenuConstants.COLOR_WHITE);
				this.callTextTicker(true);
			}
			else
			{
				this.m_view.tileSelect.alpha = 0;
				Animate.legacyTo(this.m_view.tileSelected, MenuConstants.HiliteTime, {"alpha": 0}, Animate.ExpoOut);
				this.callTextTicker(false);
				this.changeTextColor(this.m_view.title, MenuConstants.COLOR_WHITE);
			}
		}
		
		private function setItemTint(param1:Object, param2:int, param3:Boolean = true):void
		{
			var _loc4_:Number = NaN;
			if (!param3)
			{
				_loc4_ = Number(param1.alpha);
			}
			var _loc5_:Color;
			(_loc5_ = new Color()).setTint(MenuConstants.COLOR_GREY_ULTRA_LIGHT, 1);
			DisplayObject(param1).transform.colorTransform = _loc5_;
			if (!param3)
			{
				param1.alpha = _loc4_;
			}
		}
		
		override public function onUnregister():void
		{
			super.onUnregister();
			if (this.m_view)
			{
				Animate.kill(this.m_view.tileSelect);
				MenuUtils.pulsate(this.m_view.tileSelectPulsate, false);
				Animate.kill(this.m_view.tileSelected);
				if (this.m_textTicker)
				{
					this.m_textTicker.stopTextTicker(this.m_view.title, this.m_textObj.title);
					this.m_textTicker = null;
				}
				removeChild(this.m_view);
				this.m_view = null;
			}
		}
	}
}
