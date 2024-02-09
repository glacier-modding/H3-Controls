package hud.sniper
{
	import basic.BoundsExtender;
	import common.BaseControl;
	import flash.external.ExternalInterface;
	import scaleform.gfx.Extensions;
	
	public class AIMarkElement extends BaseControl
	{
		
		private var m_container:BoundsExtender;
		
		private var m_aMarks:Array;
		
		private var m_counter:int = 0;
		
		private var m_scaleMod:Number = 1;
		
		public function AIMarkElement()
		{
			var _loc2_:AIMarkElementView = null;
			this.m_container = new BoundsExtender();
			this.m_aMarks = new Array();
			super();
			addChild(this.m_container);
			var _loc1_:int = 0;
			while (_loc1_ < 2)
			{
				_loc2_ = new AIMarkElementView();
				_loc2_.localState = -1;
				this.m_container.addChild(_loc2_);
				_loc2_.visible = false;
				this.m_aMarks.push(_loc2_);
				_loc1_++;
			}
		}
		
		public function SetMarkState(param1:Boolean, param2:Boolean, param3:Number, param4:Number, param5:Number, param6:Boolean, param7:Boolean):void
		{
			if (this.m_counter >= 2)
			{
				this.m_counter = 0;
			}
			if (param7)
			{
				if (Boolean(this.m_aMarks[this.m_counter].visible) && param2)
				{
					if (this.m_aMarks[this.m_counter].localState == 1)
					{
						this.playSound("Mark_Local");
					}
					else if (this.m_aMarks[this.m_counter].localState == 2)
					{
						this.playSound("Mark_Remote");
					}
				}
			}
			if (param2)
			{
				if (!this.m_aMarks[this.m_counter].visible)
				{
					this.m_aMarks[this.m_counter].visible = param2;
				}
				if ((param5 *= this.m_scaleMod) != this.m_aMarks[this.m_counter].scaleX)
				{
					this.m_aMarks[this.m_counter].scaleX = param5;
					this.m_aMarks[this.m_counter].scaleY = param5;
				}
				this.m_aMarks[this.m_counter].x = param3;
				this.m_aMarks[this.m_counter].y = param4;
				if (param1 && this.m_aMarks[this.m_counter].localState != 1)
				{
					this.m_aMarks[this.m_counter].localState = 1;
					this.playSound("Mark_Local");
					this.m_aMarks[this.m_counter].gotoAndStop(1);
				}
				if (!param1 && this.m_aMarks[this.m_counter].localState != 2)
				{
					this.m_aMarks[this.m_counter].localState = 2;
					this.playSound("Mark_Remote");
					this.m_aMarks[this.m_counter].gotoAndStop(2);
				}
			}
			else if (this.m_aMarks[this.m_counter].visible)
			{
				this.m_aMarks[this.m_counter].visible = param2;
				if (this.m_aMarks[this.m_counter].localState == 1)
				{
					this.playSound("Unmark_Local");
				}
				if (this.m_aMarks[this.m_counter].localState == 2)
				{
					this.playSound("Unmark_Remote");
				}
				this.m_aMarks[this.m_counter].localState = -1;
			}
			++this.m_counter;
		}
		
		private function playSound(param1:String):void
		{
			ExternalInterface.call("PlaySound", param1);
		}
		
		override public function onSetSize(param1:Number, param2:Number):void
		{
			if (ControlsMain.isVrModeActive())
			{
				this.m_scaleMod = 1;
			}
			else
			{
				this.m_scaleMod = Extensions.visibleRect.height / 1080;
			}
		}
	}
}
