// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.versus.markers.DistanceMarkerElement

package hud.versus.markers {
import flash.display.MovieClip;
import flash.text.TextFieldAutoSize;

public class DistanceMarkerElement extends MovieClip {

	public static const POSITION_TOP:String = "top";
	public static const POSITION_BOTTOM:String = "bottom";
	public static const POSITION_LEFT:String = "left";
	public static const POSITION_RIGHT:String = "right";

	private var m_view:DistanceMarkerElementView;
	public var markerHeight:Number;

	public function DistanceMarkerElement() {
		this.m_view = new DistanceMarkerElementView();
		addChild(this.m_view);
	}

	public function onSetData(_arg_1:Object):void {
		var _local_2:int = _arg_1.distance;
		this.m_view.txtLabel.visible = ((_local_2 >= 0) ? true : false);
		this.m_view.txtLabel.text = (_local_2.toString() + "m");
		this.m_view.txtLabel.autoSize = TextFieldAutoSize.CENTER;
		this.positionDistanceMarker(_arg_1.direction);
	}

	private function positionDistanceMarker(_arg_1:String):void {
		var _local_2:Number = 0;
		switch (_arg_1) {
			case POSITION_TOP:
				_local_2 = this.m_view.height;
				this.m_view.rotation = -180;
				break;
			case POSITION_BOTTOM:
				_local_2 = this.m_view.height;
				this.m_view.rotation = 0;
				break;
			case POSITION_LEFT:
				_local_2 = (this.m_view.width + 20);
				this.m_view.rotation = -90;
				break;
			case POSITION_RIGHT:
				_local_2 = (this.m_view.width + 20);
				this.m_view.rotation = 90;
				break;
		}

		this.m_view.y = -((this.markerHeight >> 1) + (_local_2 >> 1));
	}


}
}//package hud.versus.markers

