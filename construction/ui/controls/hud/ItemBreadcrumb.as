package hud
{
	import common.Animate;
	import common.BaseControl;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import scaleform.gfx.Extensions;
	
	public class ItemBreadcrumb extends BaseControl
	{
		
		private var m_view:ItemBreadcrumbView;
		
		private var m_scaleMod:Number = 1;
		
		private var m_state:int = 0;
		
		private var m_duration:Number = 0;
		
		public function ItemBreadcrumb()
		{
			super();
			this.m_view = new ItemBreadcrumbView();
			this.m_view.distance_txt.height *= 2;
			this.m_view.visible = false;
			addChild(this.m_view);
		}
		
		public function onSetData(param1:Object):void
		{
			var _loc3_:int = 0;
			var _loc4_:int = 0;
			if (param1.id == "distance")
			{
				_loc3_ = int(param1.distance);
				this.m_view.distance_txt.visible = _loc3_ > 0 ? true : false;
				_loc4_ = ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL ? 24 : 12;
				MenuUtils.setupText(this.m_view.distance_txt, _loc3_.toString() + "m", _loc4_, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			}
			var _loc2_:Number = 1;
			if (!ControlsMain.isVrModeActive())
			{
				_loc2_ = Extensions.visibleRect.height / 1080;
			}
			if (this.m_scaleMod != _loc2_)
			{
				this.onSetSize(0, 0);
			}
		}
		
		private function pulsateAttentionOutline(param1:Boolean):void
		{
			Animate.kill(this.m_view.attentionoutline);
			this.m_view.attentionoutline.alpha = 0;
			if (param1)
			{
				this.pulsateAttentionOutlineIn();
			}
		}
		
		private function pulsateAttentionOutlineIn():void
		{
			this.m_view.attentionoutline.scaleX = this.m_view.attentionoutline.scaleY = 0.44;
			this.m_view.attentionoutline.alpha = 0;
			Animate.to(this.m_view.attentionoutline, 0.2, 0, {"alpha": 1, "scaleX": 0.6, "scaleY": 0.6}, Animate.ExpoIn, this.pulsateAttentionOutlineOut);
		}
		
		private function pulsateAttentionOutlineOut():void
		{
			Animate.to(this.m_view.attentionoutline, 0.3, 0, {"alpha": 0, "scaleX": 0.66, "scaleY": 0.66}, Animate.ExpoOut, this.pulsateAttentionOutlineIn);
		}
		
		public function attachedToNpc(param1:Boolean):void
		{
			this.m_view.visible = param1;
			if (param1 == true && this.m_duration > 0)
			{
				this.pulsateAttentionOutline(true);
			}
		}
		
		public function reset():void
		{
			this.pulsateAttentionOutline(false);
			this.m_view.visible = false;
		}
		
		public function set Duration(param1:Number):void
		{
			this.m_duration = param1 / 1000;
		}
		
		override public function onSetSize(param1:Number, param2:Number):void
		{
			var _loc3_:Number = 1;
			if (!ControlsMain.isVrModeActive())
			{
				_loc3_ = Extensions.visibleRect.height / 1080;
			}
			this.m_scaleMod = this.m_view.scaleX = this.m_view.scaleY = _loc3_;
		}
	}
}
