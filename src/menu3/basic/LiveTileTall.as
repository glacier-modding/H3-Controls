// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.LiveTileTall

package menu3.basic {
import flash.display.Sprite;

import common.MouseUtil;
import common.Animate;
import common.menu.MenuConstants;

public dynamic class LiveTileTall extends MenuTileTall {

	private static const DotIndicatorX:Number = 170.5;
	private static const DotIndicatorY:Number = 16;

	private var m_dotIndicators:Sprite;
	private var m_dots:Array = new Array();
	private var m_timerdot:DotIndicatorTimerView;
	private var m_tileCount:int;
	private var m_timeremain:Number = 0;
	private var m_dotAnimationStarted:Boolean = false;

	public function LiveTileTall(_arg_1:Object) {
		super(_arg_1);
		m_mouseWheelMode = MouseUtil.MODE_WHEEL_GROUP;
		this.m_dotIndicators = new Sprite();
		this.m_dotIndicators.x = DotIndicatorX;
		this.m_dotIndicators.y = DotIndicatorY;
		m_view.indicator.addChild(this.m_dotIndicators);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		Animate.complete(m_view.tileIcon.icons);
		m_view.tileIcon.icons.alpha = 0;
		m_view.tileIcon.icons.gotoAndStop(_arg_1.icon);
		Animate.legacyTo(m_view.tileIcon.icons, MenuConstants.HiliteTime, {"alpha": 1}, Animate.Linear);
		this.setIndexIndicator(getNodeProp(this, "livetileindex"), getNodeProp(this, "livetilecount"), getNodeProp(this, "lifetimeinterval"), getNodeProp(this, "lifetimeremaining"));
	}

	public function startDotAnimation(_arg_1:Object):void {
		this.m_dotAnimationStarted = true;
		this.animateDots(_arg_1);
	}

	private function setIndexIndicator(_arg_1:int, _arg_2:int, _arg_3:Number, _arg_4:Number):void {
		var _local_5:int;
		var _local_6:DotIndicatorView;
		var _local_7:Number;
		var _local_8:int;
		var _local_9:int;
		this.removeTimerDot();
		if (_arg_2 != this.m_tileCount) {
			this.removeDots();
			this.m_tileCount = _arg_2;
			if (this.m_tileCount > 1) {
				_local_5 = 0;
				while (_local_5 < this.m_tileCount) {
					_local_6 = new DotIndicatorView();
					_local_6.x = (_local_5 * 15);
					_local_6.alpha = 0.5;
					this.m_dots.push(_local_6);
					this.m_dotIndicators.addChild(_local_6);
					this.m_dotIndicators.x = ((m_view.tileDarkBg.width / 2) + (_local_5 * (15 / -2)));
					_local_5++;
				}
				;
			}
			;
		}
		;
		if (this.m_dots.length) {
			this.m_timerdot = new DotIndicatorTimerView();
			this.m_timerdot.width = (this.m_timerdot.height = 10);
			this.m_timerdot.x = this.m_dots[_arg_1].x;
			this.m_dotIndicators.addChild(this.m_timerdot);
			_local_7 = Math.max(_arg_4, _arg_3);
			_local_8 = int((100 / _local_7));
			this.m_timeremain = _arg_4;
			_local_9 = (_local_8 * this.m_timeremain);
			this.m_timerdot.gotoAndStop((100 - _local_9));
			this.animateDots(null);
		}
		;
	}

	private function removeTimerDot():void {
		if (this.m_timerdot) {
			Animate.kill(this.m_timerdot);
			this.m_dotIndicators.removeChild(this.m_timerdot);
			this.m_timerdot = null;
		}
		;
	}

	private function removeDots():void {
		var _local_2:DotIndicatorView;
		var _local_1:int;
		while (_local_1 < this.m_dots.length) {
			_local_2 = this.m_dots[_local_1];
			this.m_dotIndicators.removeChild(_local_2);
			_local_1++;
		}
		;
		this.m_dots = [];
	}

	private function animateDots(data:Object):void {
		var reset:Boolean;
		reset = ((!(data == null)) && (data.reset === true));
		if (((this.m_dots.length) && (this.m_dotAnimationStarted))) {
			if (reset) {
				this.m_timerdot.gotoAndStop(0);
			}
			;
			Animate.to(this.m_timerdot, this.m_timeremain, 0, {"frames": 100}, Animate.Linear, function ():void {
				if (reset) {
					m_dotAnimationStarted = false;
				}
				;
			});
		}
		;
	}

	override public function onUnregister():void {
		if (m_view) {
			this.completeDotAnimations();
			this.removeTimerDot();
			this.removeDots();
			m_view.indicator.removeChild(this.m_dotIndicators);
			this.m_dotIndicators = null;
		}
		;
		super.onUnregister();
	}

	private function completeDotAnimations():void {
		var _local_1:int;
		if (this.m_dots.length) {
			_local_1 = 0;
			while (_local_1 < this.m_dots.length) {
				Animate.complete(this.m_dots[_local_1]);
				_local_1++;
			}
			;
		}
		;
		Animate.complete(m_view.tileIcon.icons);
	}


}
}//package menu3.basic

