package basic
{
	import common.BaseControl;
	
	public class Line extends BaseControl
	{
		
		private var m_isDotted:Boolean = false;
		
		private var m_view:* = null;
		
		private var m_sizeX:Number = 0;
		
		private var m_sizeY:Number = 0;
		
		private var m_isHorizontal:Boolean = true;
		
		private var m_color:uint = 0;
		
		public function Line()
		{
			super();
		}
		
		public function set IsHorizontal(param1:Boolean):void
		{
			if (this.m_isHorizontal == param1)
			{
				return;
			}
			this.m_isHorizontal = param1;
			this.drawLine();
		}
		
		public function set IsDotted(param1:Boolean):void
		{
			if (this.m_isDotted == param1)
			{
				return;
			}
			this.m_isDotted = param1;
			this.drawLine();
		}
		
		public function set Color(param1:String):void
		{
			var _loc2_:Number = parseInt(param1, 16);
			if (!isNaN(_loc2_))
			{
				if (this.m_color == _loc2_)
				{
					return;
				}
				this.m_color = _loc2_;
				this.drawLine();
			}
		}
		
		override public function onSetSize(param1:Number, param2:Number):void
		{
			this.m_sizeX = param1;
			this.m_sizeY = param2;
			this.drawLine();
		}
		
		private function drawLine():void
		{
			if (this.m_view != null)
			{
				removeChild(this.m_view);
			}
			if (this.m_isDotted)
			{
				this.m_view = new DottedLine(this.m_isHorizontal ? this.m_sizeX : this.m_sizeY, this.m_color, this.m_isHorizontal ? "horizontal" : "vertical", this.m_isHorizontal ? this.m_sizeY : this.m_sizeX, this.m_isHorizontal ? this.m_sizeY : this.m_sizeX);
			}
			else
			{
				this.m_view = new SolidLine(this.m_isHorizontal ? this.m_sizeX : this.m_sizeY, this.m_color, this.m_isHorizontal ? this.m_sizeY : this.m_sizeX, this.m_isHorizontal ? "horizontal" : "vertical");
			}
			addChild(this.m_view);
		}
	}
}
