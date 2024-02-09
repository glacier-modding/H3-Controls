package hud
{
	import common.BaseControl;
	import common.CommonUtils;
	import common.Log;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.Shape;
	
	public class PlayerNameTag extends BaseControl
	{
		
		private var m_view:PlayerNameTagView;
		
		private var m_teamColor:Shape;
		
		private var m_displayTeamColor:Boolean = true;
		
		private var m_teamIconOffsetX:Number = 0;
		
		private var m_teamIconOffsetY:Number = 0;
		
		private var m_teamIconSize:Number = 30;
		
		public function PlayerNameTag()
		{
			super();
			this.m_view = new PlayerNameTagView();
			this.m_view.bg.alpha = 0.6;
			this.m_view.visible = false;
			addChild(this.m_view);
			this.m_teamColor = new Shape();
			this.updateTeamColor(0);
			this.m_teamColor.visible = false;
			addChild(this.m_teamColor);
		}
		
		public function onSetData(param1:Object):void
		{
			var _loc2_:Number = NaN;
			var _loc3_:Number = NaN;
			var _loc4_:Number = NaN;
			var _loc5_:uint = 0;
			this.updateName(param1.name);
			Log.info(Log.ChannelVideo, this, "PlayerNameTag data:" + param1);
			if (param1.team_color)
			{
				_loc2_ = param1.team_color.r * 255;
				_loc3_ = param1.team_color.g * 255;
				_loc4_ = param1.team_color.b * 255;
				_loc5_ = uint(_loc2_ << 16 | _loc3_ << 8 | _loc4_);
				this.updateTeamColor(_loc5_);
			}
			else
			{
				this.m_teamColor.visible = false;
			}
		}
		
		public function set DisplayTeamColor(param1:Boolean):void
		{
			this.m_displayTeamColor = param1;
			this.m_teamColor.visible = this.m_displayTeamColor;
		}
		
		public function set TeamIconOffsetX(param1:Number):void
		{
			this.m_teamIconOffsetX = param1;
			this.updateTeamColorPos();
		}
		
		public function set TeamIconOffsetY(param1:Number):void
		{
			this.m_teamIconOffsetY = param1;
			this.updateTeamColorPos();
		}
		
		public function set TeamIconSize(param1:Number):void
		{
			this.m_teamIconSize = param1;
			this.updateTeamColorPos();
		}
		
		private function updateName(param1:String):void
		{
			if (param1 == "")
			{
				this.m_view.visible = false;
				return;
			}
			this.m_view.visible = true;
			MenuUtils.setupText(this.m_view.profilename, param1, 22, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGrey);
			CommonUtils.changeFontToGlobalIfNeeded(this.m_view.profilename);
			MenuUtils.truncateTextfieldWithCharLimit(this.m_view.profilename, 1, MenuConstants.PLAYERNAME_MIN_CHAR_COUNT);
			MenuUtils.shrinkTextToFit(this.m_view.profilename, this.m_view.profilename.width, -1);
			this.m_view.bg.width = this.m_view.profilename.textWidth + 10;
		}
		
		private function updateTeamColorPos():void
		{
			this.m_teamColor.x = this.m_teamIconOffsetX;
			this.m_teamColor.y = this.m_teamIconOffsetY;
			this.m_teamColor.x -= this.m_teamIconSize / 4;
			this.m_teamColor.y -= this.m_teamIconSize / 2;
		}
		
		private function updateTeamColor(param1:uint):void
		{
			this.m_teamColor.graphics.clear();
			this.m_teamColor.graphics.lineStyle(1, param1);
			this.m_teamColor.graphics.beginFill(param1);
			this.m_teamColor.graphics.moveTo(this.m_teamIconSize / 2, 0);
			this.m_teamColor.graphics.lineTo(this.m_teamIconSize, this.m_teamIconSize);
			this.m_teamColor.graphics.lineTo(0, this.m_teamIconSize);
			this.m_teamColor.graphics.lineTo(this.m_teamIconSize / 2, 0);
			this.m_teamColor.visible = this.m_displayTeamColor;
			this.updateTeamColorPos();
		}
	}
}
