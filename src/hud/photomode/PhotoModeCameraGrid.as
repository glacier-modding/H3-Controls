package hud.photomode
{
	import common.BaseControl;
	import common.menu.MenuConstants;
	import flash.display.Sprite;
	
	public class PhotoModeCameraGrid extends BaseControl
	{
		
		private var m_view:Sprite;
		
		private var m_sizeX:Number;
		
		private var m_sizeY:Number;
		
		private var m_offsetXPercent:Number;
		
		private var m_offsetYPercent:Number;
		
		public function PhotoModeCameraGrid()
		{
			super();
			this.m_view = new Sprite();
			this.m_view.visible = false;
			addChild(this.m_view);
		}
		
		override public function onSetSize(param1:Number, param2:Number):void
		{
			super.onSetSize(param1, param2);
			this.m_sizeX = param1;
			this.m_sizeY = param2;
			this.drawGrid();
		}
		
		private function drawGrid():void
		{
			var _loc1_:Number = this.m_sizeY * this.m_offsetYPercent;
			var _loc2_:Number = this.m_sizeY * (1 - this.m_offsetYPercent);
			var _loc3_:Number = this.m_sizeX * this.m_offsetXPercent;
			var _loc4_:Number = this.m_sizeX * (1 - this.m_offsetXPercent);
			this.m_view.graphics.clear();
			this.m_view.graphics.lineStyle(1, MenuConstants.COLOR_GREY_LIGHT, 1);
			this.m_view.graphics.moveTo(0, _loc1_);
			this.m_view.graphics.lineTo(this.m_sizeX, _loc1_);
			this.m_view.graphics.moveTo(0, _loc2_);
			this.m_view.graphics.lineTo(this.m_sizeX, _loc2_);
			this.m_view.graphics.moveTo(_loc3_, 0);
			this.m_view.graphics.lineTo(_loc3_, this.m_sizeY);
			this.m_view.graphics.moveTo(_loc4_, 0);
			this.m_view.graphics.lineTo(_loc4_, this.m_sizeY);
		}
		
		public function set horizontalOffsetPercent(param1:Number):void
		{
			this.m_offsetXPercent = param1;
			this.drawGrid();
		}
		
		public function set verticalOffsetPercent(param1:Number):void
		{
			this.m_offsetYPercent = param1;
			this.drawGrid();
		}
		
		public function Show():void
		{
			this.m_view.visible = true;
		}
		
		public function Hide():void
		{
			this.m_view.visible = false;
		}
	}
}
