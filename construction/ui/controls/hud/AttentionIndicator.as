package hud
{
	import common.BaseControl;
	import flash.display.Sprite;
	import scaleform.gfx.Extensions;
	
	public class AttentionIndicator extends BaseControl
	{
		
		private var m_hContainer:Sprite;
		
		private var m_aWedges:Array;
		
		private var i:int;
		
		public function AttentionIndicator()
		{
			this.m_hContainer = new Sprite();
			this.m_aWedges = new Array();
			super();
			addChild(this.m_hContainer);
			this.ensureWedgesCount(10);
		}
		
		public function getWedges():Array
		{
			return this.m_aWedges;
		}
		
		public function ensureWedgesCount(param1:int):void
		{
			var _loc2_:AttentionWedge = null;
			while (param1 > this.m_aWedges.length)
			{
				_loc2_ = new AttentionWedge();
				_loc2_.visible = false;
				this.m_aWedges.push(_loc2_);
				this.m_hContainer.addChild(_loc2_);
			}
		}
		
		override public function onSetSize(param1:Number, param2:Number):void
		{
			var _loc3_:Number = 1;
			if (!ControlsMain.isVrModeActive())
			{
				_loc3_ = Extensions.visibleRect.height / 1080;
			}
			this.m_hContainer.scaleX = this.m_hContainer.scaleY = _loc3_;
		}
	}
}
