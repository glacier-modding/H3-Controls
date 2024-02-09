package basic
{
	import common.BaseControl;
	
	public class Mask extends BaseControl
	{
		
		private var m_view:MaskView;
		
		public function Mask()
		{
			super();
			this.m_view = new MaskView();
			addChild(this.m_view);
		}
		
		override public function onChildrenAttached():void
		{
			var _loc1_:uint = 0;
			while (_loc1_ < this.numChildren)
			{
				if (this.getChildAt(_loc1_) != this.m_view)
				{
					this.getChildAt(_loc1_).mask = this.m_view;
				}
				_loc1_++;
			}
		}
		
		override public function onSetSize(param1:Number, param2:Number):void
		{
			this.m_view.width = param1;
			this.m_view.height = param2;
		}
	}
}
