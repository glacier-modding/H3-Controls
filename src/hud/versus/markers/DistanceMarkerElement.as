package hud.versus.markers
{
	import flash.display.MovieClip;
	import flash.text.TextFieldAutoSize;
	
	public class DistanceMarkerElement extends MovieClip
	{
		
		public static const POSITION_TOP:String = "top";
		
		public static const POSITION_BOTTOM:String = "bottom";
		
		public static const POSITION_LEFT:String = "left";
		
		public static const POSITION_RIGHT:String = "right";
		
		private var m_view:DistanceMarkerElementView;
		
		public var markerHeight:Number;
		
		public function DistanceMarkerElement()
		{
			super();
			this.m_view = new DistanceMarkerElementView();
			addChild(this.m_view);
		}
		
		public function onSetData(param1:Object):void
		{
			var _loc2_:int = int(param1.distance);
			this.m_view.txtLabel.visible = _loc2_ >= 0 ? true : false;
			this.m_view.txtLabel.text = _loc2_.toString() + "m";
			this.m_view.txtLabel.autoSize = TextFieldAutoSize.CENTER;
			this.positionDistanceMarker(param1.direction);
		}
		
		private function positionDistanceMarker(param1:String):void
		{
			var _loc2_:Number = 0;
			switch (param1)
			{
			case POSITION_TOP: 
				_loc2_ = this.m_view.height;
				this.m_view.rotation = -180;
				break;
			case POSITION_BOTTOM: 
				_loc2_ = this.m_view.height;
				this.m_view.rotation = 0;
				break;
			case POSITION_LEFT: 
				_loc2_ = this.m_view.width + 20;
				this.m_view.rotation = -90;
				break;
			case POSITION_RIGHT: 
				_loc2_ = this.m_view.width + 20;
				this.m_view.rotation = 90;
			}
			this.m_view.y = -((this.markerHeight >> 1) + (_loc2_ >> 1));
		}
	}
}
