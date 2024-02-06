package basic
{
	import common.BaseControl;
	import flash.geom.ColorTransform;
	
	public class Quad extends BaseControl
	{
		
		private var m_view:QuadView;
		
		public function Quad()
		{
			super();
			this.m_view = new QuadView();
			addChild(this.m_view);
		}
		
		public function onSetData():void
		{
		}
		
		public function set Color(param1:String):void
		{
			var _loc3_:ColorTransform = null;
			var _loc2_:Number = parseInt(param1, 16);
			if (!isNaN(_loc2_))
			{
				_loc3_ = new ColorTransform();
				_loc3_.color = _loc2_;
				_loc3_.alphaMultiplier = 0;
				_loc3_.alphaOffset = this.m_view.shape_mc.transform.colorTransform.alphaOffset;
				this.m_view.shape_mc.transform.colorTransform = _loc3_;
			}
		}
		
		public function set Alpha(param1:int):void
		{
			var _loc2_:ColorTransform = null;
			if (!isNaN(param1))
			{
				_loc2_ = new ColorTransform();
				_loc2_.color = this.m_view.shape_mc.transform.colorTransform.color;
				_loc2_.alphaMultiplier = 0;
				_loc2_.alphaOffset = param1 * 256 / 100;
				this.m_view.shape_mc.transform.colorTransform = _loc2_;
			}
		}
		
		override public function onSetSize(param1:Number, param2:Number):void
		{
			this.m_view.width = param1;
			this.m_view.height = param2;
		}
	}
}
