// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.Badge

package menu3.basic {
import flash.display.Sprite;

import common.AnimationContainerBase;

import flash.display.MovieClip;
import flash.utils.getDefinitionByName;

import common.Animate;

import flash.display.DisplayObject;

import common.menu.MenuUtils;

public class Badge extends Sprite implements AnimationContainerBase {

	private const FRAME_LINKAGE_PREFIX:String = "Frame_";
	private const LATIN_NAME_LINKAGE_PREFIX:String = "Latin_";
	private const NUMERAL_LINKAGE_PREFIX:String = "Numeral_";
	private const CENTER_PIECE_LINKAGE_PREFIX:String = "Center_";
	private const ASSET_LINKAGE_CUTOUT_SUFFIX:String = "_cutout";
	private const TINT_COLOR_WHITE:int = 0xFFFFFF;
	private const TINT_COLOR_DARK:int = 4343882;
	private const TINT_COLOR_NONE:int = -1;
	private const SCALE_FACTOR_1:Number = 1;
	private const SCALE_FACTOR_2:Number = 0.89;
	private const SCALE_FACTOR_3:Number = 0.81;
	private const SCALE_FACTOR_4:Number = 0.875;
	private const SCALE_FACTOR_5:Number = 0.79;

	private var m_frameIDSequence:Array = [[1, 1, 1, 1, 1, 2, 2, 2, 2, 2], [3, 3, 3, 3, 3, 3, 3, 4, 5, 6], [7, 7, 7, 7, 8, 9, 9, 10, 11, 12], [13, 13, 13, 13, 14, 15, 15, 16, 17, 18], [19, 19, 19, 19, 20, 21, 21, 22, 23, 24]];
	private var m_centerIDSequence:Array = [[1, 1, 1, 2, 2], [3, 3, 3, 4, 4], [5, 5, 5, 6, 6], [7, 7, 7, 8, 8], [9, 9, 9, 10, 10], [11, 11, 11, 12, 12], [13, 13, 13, 14, 14], [15, 15, 15, 16, 16], [17, 17, 17, 18, 18], [19, 19, 19, 20, 20]];
	private var m_levelsPerRow:int = 50;
	private var m_levelsPerColumn:int = 5;
	private var m_totalLevelsPerGroup:int = 250;
	private var m_levelMIN:int = 1;
	private var m_levelMAX:int = 12500;
	private var m_playerLevel:int = 0;
	private var m_latinLevelChange:int = 2500;
	private var m_latinLevelFrameId:int = 1;
	private var m_latinLevelTotal:int = 3;
	private var m_numeralTotal:int = 5;
	private var m_useAssetCutOut:Boolean = false;
	private var m_shieldColor:int;
	private var m_propsColor:int;
	private var m_numeralColor:int;
	private var m_badgeCenterScaleFactor:Number;
	private var m_latinNameScaleFactor:Number;
	private var m_view:BadgeView = null;
	private var m_badgeFXClip:MovieClip;
	private var m_maxSize:Number = 0;
	private var m_badgeSizeReference:Number = 685;
	private var m_badgeScaleValue:Number = 1;
	private var m_useAnimation:Boolean = true;

	public function Badge() {
		this.m_view = new BadgeView();
		addChild(this.m_view);
		this.m_view.alpha = 0;
		this.m_badgeFXClip = new BadgeFXView();
		this.m_badgeFXClip.fxInner.alpha = 0;
		this.m_badgeFXClip.fxOuter.alpha = 0;
	}

	public function setMaxSize(_arg_1:Number):void {
		this.m_maxSize = _arg_1;
	}

	public function setLevel(_arg_1:int, _arg_2:Boolean, _arg_3:Boolean = false):void {
		this.m_useAnimation = _arg_3;
		if (_arg_1 <= 0) {
			return;
		}

		if (_arg_1 == this.m_playerLevel) {
			return;
		}

		this.m_playerLevel = _arg_1;
		this.createBadge();
		this.updateSize();
		this.showBadge(_arg_2);
	}

	private function updateSize():void {
		if (this.m_maxSize <= 0) {
			return;
		}

		this.m_badgeScaleValue = (this.m_maxSize / this.m_badgeSizeReference);
		trace(("Badge [ updateSize ] end-scale --> " + this.m_badgeScaleValue));
		this.m_view.scaleX = this.m_badgeScaleValue;
		this.m_view.scaleY = this.m_badgeScaleValue;
	}

	private function createBadge():void {
		this.clearBadge();
		this.checkLevelCap();
		var _local_1:String = this.findFrameID(this.m_playerLevel);
		var _local_2:String = this.findFrameLatinID(this.m_playerLevel);
		var _local_3:String = this.findFrameNumeralID(this.m_playerLevel);
		var _local_4:String = this.findCenterID(this.m_playerLevel);
		var _local_5:Class = (getDefinitionByName(_local_1) as Class);
		var _local_6:Object = (getDefinitionByName(_local_2) as Class);
		var _local_7:Class = (getDefinitionByName(_local_3) as Class);
		var _local_8:Class = (getDefinitionByName(_local_4) as Class);
		var _local_9:MovieClip = new (_local_5)();
		var _local_10:Sprite = new (_local_6)();
		var _local_11:Sprite = new (_local_7)();
		var _local_12:Sprite = new (_local_8)();
		this.tintAssets(_local_11, _local_12);
		this.scaleAsset(_local_12, this.m_badgeCenterScaleFactor);
		this.scaleAsset(_local_10, this.m_latinNameScaleFactor);
		_local_9.numeralClip.addChild(_local_11);
		_local_9.latinClip.addChild(_local_10);
		this.m_view.addChild(_local_9);
		this.m_view.addChild(_local_12);
		this.m_view.addChild(this.m_badgeFXClip);
	}

	private function clearBadge():void {
		while (this.m_view.numChildren > 0) {
			this.m_view.removeChildAt(0);
		}

		this.m_view.scaleX = (this.m_view.scaleY = 1);
	}

	private function showBadge(firstTime:Boolean):void {
		var delay:Number;
		Animate.kill(this.m_view);
		Animate.kill(this.m_badgeFXClip.fxInner);
		Animate.kill(this.m_badgeFXClip.fxOuter);
		if (this.m_useAnimation) {
			delay = 0;
			Animate.fromTo(this.m_view, 0.2, delay, {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
			if (firstTime) {
				Animate.addFromTo(this.m_view, 0.3, delay, {
					"scaleX": (this.m_badgeScaleValue + 0.25),
					"scaleY": (this.m_badgeScaleValue + 0.25)
				}, {
					"scaleX": this.m_badgeScaleValue,
					"scaleY": this.m_badgeScaleValue
				}, Animate.BackOut);
			} else {
				Animate.addTo(this.m_view, 0.1, delay, {
					"scaleX": (this.m_badgeScaleValue - 0.2),
					"scaleY": (this.m_badgeScaleValue - 0.2)
				}, Animate.SineIn, function ():void {
					Animate.addTo(m_view, 0.15, 0, {
						"scaleX": m_badgeScaleValue,
						"scaleY": m_badgeScaleValue
					}, Animate.BackOut);
				});
			}

			Animate.fromTo(this.m_badgeFXClip.fxInner, 0.5, (delay + 0.1), {"alpha": 1}, {"alpha": 0}, Animate.SineOut);
			Animate.addFromTo(this.m_badgeFXClip.fxInner, 0.6, (delay + 0.1), {
				"scaleX": 1,
				"scaleY": 1
			}, {
				"scaleX": 2.5,
				"scaleY": 2.5
			}, Animate.SineOut);
			Animate.fromTo(this.m_badgeFXClip.fxOuter, 0.7, (delay + 0.2), {"alpha": 1}, {"alpha": 0}, Animate.SineOut);
			Animate.addFromTo(this.m_badgeFXClip.fxOuter, 0.8, (delay + 0.2), {
				"scaleX": 1,
				"scaleY": 1
			}, {
				"scaleX": 1.5,
				"scaleY": 1.5
			}, Animate.SineOut);
		} else {
			this.m_view.alpha = 1;
		}

	}

	private function findFrameID(_arg_1:int):String {
		while (_arg_1 > this.m_totalLevelsPerGroup) {
			_arg_1 = (_arg_1 - this.m_totalLevelsPerGroup);
		}

		var _local_2:int = int((Math.ceil((_arg_1 / this.m_levelsPerRow)) - 1));
		this.m_useAssetCutOut = false;
		if (((_local_2 == 1) || (_local_2 == 3))) {
			this.m_useAssetCutOut = true;
		}

		var _local_3:int = (_arg_1 - (this.m_levelsPerRow * _local_2));
		var _local_4:int = int((Math.ceil((_local_3 / this.m_levelsPerColumn)) - 1));
		this.m_latinLevelFrameId = Math.min((_local_4 + 1), this.m_latinLevelTotal);
		var _local_5:int = this.m_frameIDSequence[_local_2][_local_4];
		var _local_6:String = (this.FRAME_LINKAGE_PREFIX + _local_5);
		return (_local_6);
	}

	private function findFrameLatinID(_arg_1:int):String {
		var _local_2:int = 1;
		while (_arg_1 > this.m_latinLevelChange) {
			_arg_1 = (_arg_1 - this.m_latinLevelChange);
			_local_2++;
		}

		var _local_3:String = (((this.LATIN_NAME_LINKAGE_PREFIX + _local_2) + "_") + this.m_latinLevelFrameId);
		if (this.m_useAssetCutOut) {
			_local_3 = (_local_3 + this.ASSET_LINKAGE_CUTOUT_SUFFIX);
		}

		return (_local_3);
	}

	private function findFrameNumeralID(_arg_1:int):String {
		var _local_2:int = (_arg_1 % this.m_numeralTotal);
		var _local_3:int = ((_local_2 > 0) ? _local_2 : this.m_numeralTotal);
		var _local_4:String = (this.NUMERAL_LINKAGE_PREFIX + _local_3);
		if (this.m_useAssetCutOut) {
			_local_4 = (_local_4 + this.ASSET_LINKAGE_CUTOUT_SUFFIX);
		}

		return (_local_4);
	}

	private function findCenterID(_arg_1:int):String {
		var _local_2:int;
		var _local_3:int = 10;
		while (_arg_1 > this.m_totalLevelsPerGroup) {
			_arg_1 = (_arg_1 - this.m_totalLevelsPerGroup);
			_local_2 = (_local_2 + 1);
			if (_local_2 >= _local_3) {
				_local_2 = (_local_2 - _local_3);
			}

		}

		var _local_4:int = int((Math.ceil((_arg_1 / this.m_levelsPerRow)) - 1));
		var _local_5:int = (_arg_1 - (this.m_levelsPerRow * _local_4));
		var _local_6:int = int(Math.ceil((_local_5 / this.m_levelsPerColumn)));
		var _local_7:int = this.m_centerIDSequence[_local_2][_local_4];
		this.setTintAndScaleFactor(_local_4, _local_6);
		var _local_8:String = (((this.CENTER_PIECE_LINKAGE_PREFIX + _local_7) + "_") + _local_6);
		return (_local_8);
	}

	private function checkLevelCap():void {
		if ((this.m_playerLevel < this.m_levelMIN)) {
			this.m_playerLevel = this.m_levelMIN;
		} else {
			if ((this.m_playerLevel > this.m_levelMAX)) {
				this.m_playerLevel = this.m_levelMAX;
			} else {
				this.m_playerLevel = this.m_playerLevel;
			}

		}

	}

	private function setTintAndScaleFactor(_arg_1:int, _arg_2:int):void {
		this.m_badgeCenterScaleFactor = this.SCALE_FACTOR_1;
		this.m_latinNameScaleFactor = this.SCALE_FACTOR_1;
		if (_arg_1 >= 2) {
			if (_arg_2 == 5) {
				if (_arg_1 == 2) {
					this.m_badgeCenterScaleFactor = this.SCALE_FACTOR_2;
				}

				this.m_latinNameScaleFactor = this.SCALE_FACTOR_4;
			} else {
				if (_arg_2 > 5) {
					if (_arg_1 == 2) {
						this.m_badgeCenterScaleFactor = this.SCALE_FACTOR_3;
					}

					this.m_latinNameScaleFactor = this.SCALE_FACTOR_5;
				}

			}

		}

		if (_arg_1 == 0) {
			this.m_propsColor = this.TINT_COLOR_WHITE;
			this.m_shieldColor = this.TINT_COLOR_NONE;
			this.m_numeralColor = this.TINT_COLOR_WHITE;
		} else {
			if (_arg_1 == 1) {
				this.m_propsColor = this.TINT_COLOR_WHITE;
				this.m_shieldColor = this.TINT_COLOR_NONE;
				this.m_numeralColor = this.TINT_COLOR_DARK;
			} else {
				if (_arg_1 == 2) {
					this.m_propsColor = this.TINT_COLOR_DARK;
					this.m_shieldColor = this.TINT_COLOR_NONE;
					this.m_numeralColor = this.TINT_COLOR_WHITE;
				} else {
					if (_arg_1 == 3) {
						this.m_propsColor = this.TINT_COLOR_DARK;
						this.m_shieldColor = this.TINT_COLOR_WHITE;
						this.m_numeralColor = this.TINT_COLOR_DARK;
					} else {
						if (_arg_1 == 4) {
							this.m_propsColor = this.TINT_COLOR_WHITE;
							this.m_shieldColor = this.TINT_COLOR_DARK;
							this.m_numeralColor = this.TINT_COLOR_WHITE;
						}

					}

				}

			}

		}

	}

	private function tintAssets(_arg_1:Sprite, _arg_2:Sprite):void {
		var _local_3:DisplayObject;
		var _local_4:int;
		while (_local_4 < _arg_2.numChildren) {
			_local_3 = _arg_2.getChildAt(_local_4);
			if (((_local_3.name == "shield") && (!(this.m_shieldColor == this.TINT_COLOR_NONE)))) {
				MenuUtils.setColor(_local_3, this.m_shieldColor);
			} else {
				if (this.m_propsColor != this.TINT_COLOR_NONE) {
					MenuUtils.setColor(_local_3, this.m_propsColor);
				}

			}

			_local_4++;
		}

	}

	private function scaleAsset(_arg_1:Sprite, _arg_2:Number):void {
		_arg_1.scaleX = (_arg_1.scaleY = _arg_2);
	}


}
}//package menu3.basic

