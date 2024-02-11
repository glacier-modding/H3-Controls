// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.missionend.LevelInfo

package menu3.missionend {
public class LevelInfo {

	private var m_levelPointsAccum:Array;
	private var m_levelPointsOffset:int = 0;


	public function init(_arg_1:Array, _arg_2:int):void {
		if (_arg_1 != null) {
			this.m_levelPointsAccum = _arg_1;
			this.m_levelPointsOffset = _arg_2;
		}
		;
	}

	public function getLevelFromList(_arg_1:Number):Number {
		if (!this.m_levelPointsAccum) {
			return (1);
		}
		;
		var _local_2:Number = 0;
		var _local_3:int;
		while (_local_3 < this.m_levelPointsAccum.length) {
			if (_arg_1 > this.m_levelPointsAccum[_local_3]) {
				_local_2 = (_local_3 + this.m_levelPointsOffset);
			} else {
				break;
			}
			;
			_local_3++;
		}
		;
		var _local_4:int = (this.m_levelPointsOffset + this.m_levelPointsAccum.length);
		var _local_5:int = (_local_2 - this.m_levelPointsOffset);
		var _local_6:Number = (_arg_1 - this.m_levelPointsAccum[_local_5]);
		var _local_7:Number = 0;
		if (_local_2 < (_local_4 - 1)) {
			_local_7 = (_local_6 / (this.m_levelPointsAccum[(_local_5 + 1)] - this.m_levelPointsAccum[_local_5]));
		}
		;
		return ((_local_2 + 1) + _local_7);
	}

	public function isLevelMaxed(_arg_1:Number):Boolean {
		var _local_2:int = (this.m_levelPointsAccum.length - 1);
		if (_arg_1 >= this.m_levelPointsAccum[_local_2]) {
			return (true);
		}
		;
		return (false);
	}

	public function getMaxLevel():int {
		return (this.m_levelPointsAccum.length);
	}


}
}//package menu3.missionend

