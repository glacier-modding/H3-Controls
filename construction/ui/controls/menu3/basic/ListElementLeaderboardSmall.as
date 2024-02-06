package menu3.basic
{
	import common.Animate;
	import common.CommonUtils;
	import common.Log;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.Sprite;
	import flash.text.TextField;
	import menu3.MenuElementBase;
	import menu3.containers.CollapsableListContainer;
	
	public dynamic class ListElementLeaderboardSmall extends CollapsableListContainer
	{
		
		private var m_view:ListElementLeaderboardSmallView;
		
		private var m_pressable:Boolean = true;
		
		private var m_playernameOrigPosY:Number = 0;
		
		public function ListElementLeaderboardSmall(param1:Object)
		{
			super(param1);
			this.m_view = new ListElementLeaderboardSmallView();
			this.m_view.tileSelect.alpha = 0;
			MenuUtils.setTintColor(this.m_view.tileSelect, MenuUtils.TINT_COLOR_RED, false);
			this.m_view.tileDarkBg.alpha = 0;
			this.m_view.tileBg.alpha = 0;
			this.m_view.vr.visible = false;
			addChild(this.m_view);
			this.m_playernameOrigPosY = this.m_view.playername.y;
			setItemSelected(false);
		}
		
		override public function onSetData(param1:Object):void
		{
			super.onSetData(param1);
			Log.debugData(this, param1);
			this.m_pressable = true;
			if (getNodeProp(this, "pressable") === false)
			{
				this.m_pressable = false;
			}
			if (param1.isPlayer)
			{
				this.addLine(-0.5);
			}
			else
			{
				this.addLine(43.5);
			}
			var _loc2_:String = !!param1.isPlayer ? MenuConstants.FontColorWhite : MenuConstants.FontColorWhite;
			this.m_view.vr.visible = param1.isVR === true;
			if (param1.infotext)
			{
				this.setupTextField(this.m_view.infotext, param1.infotext, _loc2_, false);
				return;
			}
			if (param1.rank != undefined)
			{
				this.setupTextField(this.m_view.rank, MenuUtils.formatNumber(param1.rank), _loc2_, false);
			}
			if (param1.player)
			{
				if (param1.player2 != null)
				{
					this.setupMultipartPlayername(param1.player, param1.player2, _loc2_, true);
				}
				else
				{
					this.setupTextField(this.m_view.playername, param1.player, _loc2_, true);
				}
			}
			if (param1.country)
			{
				this.setupTextField(this.m_view.country, param1.country, _loc2_, false);
			}
			if (param1.score != undefined)
			{
				this.setupTextField(this.m_view.score, MenuUtils.formatNumber(param1.score), _loc2_, false);
			}
			this.handleSelectionChange();
		}
		
		override public function onUnregister():void
		{
			super.onUnregister();
			if (this.m_view)
			{
				Animate.complete(this.m_view.tileSelect);
				removeChild(this.m_view);
				this.m_view = null;
			}
		}
		
		private function setupTextField(param1:TextField, param2:String, param3:String, param4:Boolean = true):void
		{
			MenuUtils.setupText(param1, param2, 20, MenuConstants.FONT_TYPE_MEDIUM, param3);
			CommonUtils.changeFontToGlobalIfNeeded(param1);
			if (param4)
			{
				MenuUtils.truncateTextfield(param1, 1, param3);
			}
			else
			{
				MenuUtils.shrinkTextToFit(param1, param1.width, -1);
			}
		}
		
		private function setupMultipartPlayername(param1:String, param2:String, param3:String, param4:Boolean = true):void
		{
			this.m_view.playername.y = this.m_playernameOrigPosY;
			var _loc5_:String = param1 + MenuConstants.PLAYER_MULTIPLAYER_DELIMITER + param2;
			MenuUtils.setupText(this.m_view.playername, _loc5_, 20, MenuConstants.FONT_TYPE_MEDIUM, param3);
			CommonUtils.changeFontToGlobalIfNeeded(this.m_view.playername);
			if (param4)
			{
				MenuUtils.truncateMultipartTextfield(this.m_view.playername, param1, param2, MenuConstants.PLAYER_MULTIPLAYER_DELIMITER, MenuConstants.PLAYERNAME_MIN_CHAR_COUNT, param3);
			}
			var _loc6_:Number = this.m_view.playername.textHeight;
			MenuUtils.shrinkTextToFit(this.m_view.playername, this.m_view.playername.width, -1);
			var _loc7_:Number;
			if ((_loc7_ = this.m_view.playername.textHeight) < _loc6_)
			{
				this.m_view.playername.y += (_loc6_ - _loc7_) / 2;
			}
		}
		
		private function changeTextColor(param1:TextField, param2:uint):void
		{
			param1.textColor = param2;
		}
		
		private function addLine(param1:Number):void
		{
			var _loc2_:Sprite = new Sprite();
			_loc2_.graphics.clear();
			_loc2_.graphics.lineStyle(0, MenuConstants.COLOR_WHITE, 0.4);
			_loc2_.graphics.moveTo(1, param1);
			_loc2_.graphics.lineTo(this.m_view.tileBg.width - 3, param1);
			this.m_view.addChild(_loc2_);
		}
		
		override public function onAddedAsChild(param1:MenuElementBase):void
		{
			super.onAddedAsChild(param1);
			if (m_parent.getChildElementIndex(this) == 1)
			{
			}
		}
		
		override public function addChild2(param1:Sprite, param2:int = -1):void
		{
			super.addChild2(param1, param2);
			if (getNodeProp(param1, "col") === undefined)
			{
				if (this.getData().direction != "horizontal" && this.getData().direction != "horizontalWrap")
				{
					param1.x = 32;
				}
			}
		}
		
		override public function getView():Sprite
		{
			return this.m_view.tileBg;
		}
		
		override protected function handleSelectionChange():void
		{
			Animate.kill(this.m_view.tileSelect);
			if (m_loading)
			{
				return;
			}
			if (m_isSelected)
			{
				Animate.to(this.m_view.tileSelect, MenuConstants.HiliteTime, 0, {"alpha": 1}, Animate.ExpoOut);
			}
			else
			{
				this.m_view.tileSelect.alpha = 0;
			}
		}
	}
}
