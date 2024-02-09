package hud.versus.markers
{
	import common.BaseControl;
	
	public class DynamicMarkerElement extends BaseControl
	{
		
		private static const POSITION_TOP:String = "top";
		
		private static const POSITION_BOTTOM:String = "bottom";
		
		private static const POSITION_LEFT:String = "left";
		
		private static const POSITION_RIGHT:String = "right";
		
		protected var m_viewTarget:TargetMarkerElementView;
		
		protected var m_viewMissionObjective:OpponentMarkerElementView;
		
		protected var m_iconTarget:TargetMarkerIconElementView;
		
		protected var m_iconMissionObjective:ObjectiveMarkerIconElementView;
		
		protected var m_distanceView:DistanceMarkerElement;
		
		private var m_dataForDistance:Object;
		
		public function DynamicMarkerElement()
		{
			this.m_dataForDistance = {"distance": 0, "direction": DistanceMarkerElement.POSITION_BOTTOM};
			super();
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
		
		public function set OmitDistance(param1:Boolean):void
		{
			if (param1 && this.m_distanceView != null)
			{
				removeChild(this.m_distanceView);
				this.m_distanceView = null;
			}
			if (!param1 && this.m_distanceView == null)
			{
				this.m_distanceView = new DistanceMarkerElement();
				addChild(this.m_distanceView);
				this.m_distanceView.markerHeight = this.m_viewTarget.bg.height;
				this.m_distanceView.onSetData(this.m_dataForDistance);
			}
		}
		
		public function onSetData(param1:Object):void
		{
			this.m_dataForDistance.distance = param1.distance;
			this.m_dataForDistance.direction = param1.direction;
			if (this.m_distanceView != null)
			{
				this.m_distanceView.onSetData(this.m_dataForDistance);
			}
			this.positionIcon(param1.direction);
		}
		
		public function ChangeIconType(param1:String):void
		{
			var _loc2_:* = param1 != "missionobjective";
			this.m_viewTarget.visible = _loc2_;
			this.m_iconTarget.visible = _loc2_;
			this.m_viewMissionObjective.visible = !_loc2_;
			this.m_iconMissionObjective.visible = !_loc2_;
		}
		
		private function positionIcon(param1:String):void
		{
			var _loc2_:Number = 0;
			switch (param1)
			{
			case POSITION_TOP: 
				_loc2_ = -180;
				break;
			case POSITION_BOTTOM: 
				_loc2_ = 0;
				break;
			case POSITION_LEFT: 
				_loc2_ = -90;
				break;
			case POSITION_RIGHT: 
				_loc2_ = 90;
			}
			this.m_iconTarget.rotation = _loc2_;
			this.m_iconMissionObjective.rotation = _loc2_;
		}
	}
}
