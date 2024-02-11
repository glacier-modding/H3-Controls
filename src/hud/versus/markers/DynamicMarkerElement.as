// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.versus.markers.DynamicMarkerElement

package hud.versus.markers {
import common.BaseControl;

public class DynamicMarkerElement extends BaseControl {

	private static const POSITION_TOP:String = "top";
	private static const POSITION_BOTTOM:String = "bottom";
	private static const POSITION_LEFT:String = "left";
	private static const POSITION_RIGHT:String = "right";

	protected var m_viewTarget:TargetMarkerElementView;
	protected var m_viewMissionObjective:OpponentMarkerElementView;
	protected var m_iconTarget:TargetMarkerIconElementView;
	protected var m_iconMissionObjective:ObjectiveMarkerIconElementView;
	protected var m_distanceView:DistanceMarkerElement;
	private var m_dataForDistance:Object = {
		"distance": 0,
		"direction": DistanceMarkerElement.POSITION_BOTTOM
	};

	public function DynamicMarkerElement() {
		this.m_viewTarget = new TargetMarkerElementView();
		addChild(this.m_viewTarget);
		this.m_viewMissionObjective = new OpponentMarkerElementView();
		this.m_viewMissionObjective.visible = false;
		addChild(this.m_viewMissionObjective);
		this.m_iconTarget = new TargetMarkerIconElementView();
		addChild(this.m_iconTarget);
		this.m_iconMissionObjective = new ObjectiveMarkerIconElementView();
		this.m_iconMissionObjective.visible = false;
		addChild(this.m_iconMissionObjective);
	}

	public function set OmitDistance(_arg_1:Boolean):void {
		if (((_arg_1) && (!(this.m_distanceView == null)))) {
			removeChild(this.m_distanceView);
			this.m_distanceView = null;
		}
		;
		if (((!(_arg_1)) && (this.m_distanceView == null))) {
			this.m_distanceView = new DistanceMarkerElement();
			addChild(this.m_distanceView);
			this.m_distanceView.markerHeight = this.m_viewTarget.bg.height;
			this.m_distanceView.onSetData(this.m_dataForDistance);
		}
		;
	}

	public function onSetData(_arg_1:Object):void {
		this.m_dataForDistance.distance = _arg_1.distance;
		this.m_dataForDistance.direction = _arg_1.direction;
		if (this.m_distanceView != null) {
			this.m_distanceView.onSetData(this.m_dataForDistance);
		}
		;
		this.positionIcon(_arg_1.direction);
	}

	public function ChangeIconType(_arg_1:String):void {
		var _local_2:* = (!(_arg_1 == "missionobjective"));
		this.m_viewTarget.visible = _local_2;
		this.m_iconTarget.visible = _local_2;
		this.m_viewMissionObjective.visible = (!(_local_2));
		this.m_iconMissionObjective.visible = (!(_local_2));
	}

	private function positionIcon(_arg_1:String):void {
		var _local_2:Number = 0;
		switch (_arg_1) {
			case POSITION_TOP:
				_local_2 = -180;
				break;
			case POSITION_BOTTOM:
				_local_2 = 0;
				break;
			case POSITION_LEFT:
				_local_2 = -90;
				break;
			case POSITION_RIGHT:
				_local_2 = 90;
				break;
		}
		;
		this.m_iconTarget.rotation = _local_2;
		this.m_iconMissionObjective.rotation = _local_2;
	}


}
}//package hud.versus.markers

