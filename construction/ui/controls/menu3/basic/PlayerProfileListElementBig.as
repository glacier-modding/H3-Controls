package menu3.basic
{
	import basic.DottedLine;
	import common.CommonUtils;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.Sprite;
	import flash.text.TextField;
	import menu3.MenuElementTileBase;
	
	public dynamic class PlayerProfileListElementBig extends MenuElementTileBase
	{
		
		private var m_view:*;
		
		private var m_isPressable:Boolean;
		
		private var m_isSelectable:Boolean;
		
		private var m_isHeadline:Boolean;
		
		private var m_dottedLineContainer:Sprite;
		
		public function PlayerProfileListElementBig(param1:Object)
		{
			super(param1);
			this.m_view = this.createView();
			addChild(this.m_view);
		}
		
		protected function createView():*
		{
			var _loc1_:* = new PlayerProfileListElementBigView();
			_loc1_.tileDarkBg.alpha = 0;
			_loc1_.tileBg.alpha = 0;
			return _loc1_;
		}
		
		override public function onSetData(param1:Object):void
		{
			super.onSetData(param1);
			this.m_isHeadline = param1.style == "headline";
			this.m_isPressable = getNodeProp(this, "pressable");
			this.m_isSelectable = getNodeProp(this, "selectable");
			this.setupTextField(this.m_view.title, param1.title);
			this.setupTextField(this.m_view.value1, param1.value1);
			this.setupTextField(this.m_view.value2, param1.value2);
			this.setupTextField(this.m_view.value3, param1.value3);
		}
		
		override public function getView():Sprite
		{
			return this.m_view.tileBg;
		}
		
		private function setupTextField(param1:TextField, param2:String):void
		{
			var _loc3_:String = this.m_isHeadline ? MenuConstants.FONT_TYPE_BOLD : MenuConstants.FONT_TYPE_NORMAL;
			MenuUtils.setupText(param1, param2, 18, _loc3_, MenuConstants.FontColorWhite);
			CommonUtils.changeFontToGlobalIfNeeded(param1);
			if (this.m_isHeadline)
			{
				this.setupHeaderDivider();
			}
		}
		
		private function setupHeaderDivider():void
		{
			if (this.m_dottedLineContainer)
			{
				return;
			}
			this.m_dottedLineContainer = new Sprite();
			this.m_dottedLineContainer.x = this.m_view.title.x;
			this.m_dottedLineContainer.y = this.m_view.tileBg.height;
			var _loc1_:Number = this.m_view.title.width + this.m_view.value1.width + this.m_view.value2.width + this.m_view.value3.width;
			var _loc2_:DottedLine = new DottedLine(_loc1_, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 1, 2);
			this.m_dottedLineContainer.addChild(_loc2_);
			this.m_view.addChild(this.m_dottedLineContainer);
		}
		
		override protected function handleSelectionChange():void
		{
		}
		
		override public function onUnregister():void
		{
			super.onUnregister();
			if (this.m_view)
			{
				removeChild(this.m_view);
				this.m_view = null;
			}
		}
	}
}
