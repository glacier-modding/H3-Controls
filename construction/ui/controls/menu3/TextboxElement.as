package menu3
{
	import common.menu.MenuUtils;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public dynamic class TextboxElement extends MenuElementBase
	{
		
		private var m_view:LabelView;
		
		private var m_textfield:TextField;
		
		private var m_textformat:TextFormat;
		
		private var m_useDynamicTextBounds:Boolean = false;
		
		public function TextboxElement(param1:Object)
		{
			super(param1);
			this.m_view = new LabelView();
			this.m_textfield = this.m_view.m_textfield;
			addChild(this.m_view);
		}
		
		override public function onSetData(param1:Object):void
		{
			super.onSetData(param1);
			var _loc2_:String = String(String(param1.text) || "");
			this.m_textfield.htmlText = _loc2_;
			var _loc3_:String = String(String(param1.font) || "$normal");
			if (_loc3_.length > 0 && _loc3_.charAt(0) != "$")
			{
				_loc3_ = "$" + _loc3_;
			}
			var _loc4_:String;
			if ((_loc4_ = String(String(param1.color) || "#FFFFFF")) != null && _loc4_.length > 0 && _loc4_.charAt(0) != "#")
			{
				_loc4_ = "#" + _loc4_;
			}
			var _loc5_:int = int(int(param1.size) || 18);
			this.m_textfield.antiAliasType = AntiAliasType.ADVANCED;
			var _loc6_:Boolean = Boolean(param1.multiline) || true;
			this.m_textfield.multiline = _loc6_;
			this.m_textfield.wordWrap = _loc6_;
			this.m_textfield.autoSize = "left";
			this.m_textfield.width = Number(param1.width) || 1;
			this.m_textfield.height = Number(param1.height) || 1;
			if (param1.visible != null)
			{
				this.visible = param1.visible;
			}
			if (param1.toUpper === true)
			{
				MenuUtils.setupTextUpper(this.m_textfield, _loc2_, _loc5_, _loc3_, _loc4_);
			}
			else
			{
				MenuUtils.setupText(this.m_textfield, _loc2_, _loc5_, _loc3_, _loc4_);
			}
			if (param1.align != undefined)
			{
				this.m_textformat = this.m_textfield.getTextFormat();
				this.m_textformat.align = param1.align;
				this.m_textfield.setTextFormat(this.m_textformat);
			}
			this.m_useDynamicTextBounds = param1.useDynamicTextBounds === true;
			if (param1.dropShadow === true)
			{
				MenuUtils.addDropShadowFilter(this.m_textfield);
			}
		}
		
		override public function getHeight():Number
		{
			return Number(getData().height) || this.m_textfield.textHeight;
		}
		
		override public function getVisualBounds(param1:MenuElementBase):Rectangle
		{
			var _loc2_:Rectangle = super.getVisualBounds(param1);
			if (this.m_useDynamicTextBounds)
			{
				_loc2_.width = this.m_textfield.textWidth;
				_loc2_.height = this.m_textfield.textHeight;
			}
			return _loc2_;
		}
		
		override public function onUnregister():void
		{
			if (this.m_view)
			{
				this.m_textfield = null;
				this.m_textformat = null;
				removeChild(this.m_view);
				this.m_view = null;
			}
		}
	}
}
