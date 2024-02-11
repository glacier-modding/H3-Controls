// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.evergreen.CampaignProgress

package hud.evergreen {
import common.BaseControl;

import __AS3__.vec.Vector;

import common.Localization;
import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Animate;

import flash.external.ExternalInterface;

import common.Log;

import __AS3__.vec.*;

public class CampaignProgress extends BaseControl {

	private var m_view:CampaignProgressView = new CampaignProgressView();
	private var m_progressStep:int;
	private var m_showBackground:Boolean = false;
	private var m_slimView:Boolean = false;
	private var m_showMarker:Boolean = false;
	private var m_onMissionEnd:Boolean = false;
	private var m_onFolderScreen:Boolean = false;
	private var m_waitWithAnimation:Boolean = false;
	private var m_campaignLayout:Array = new Array(0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
	private var m_transitionBar:CampaignProgressBarView;
	private var m_transitionFrom:int;
	private var m_transitionTo:int;
	private var m_soundId:String;
	private var m_fadeUps:Vector.<CampaignProgressBarView>;

	public function CampaignProgress() {
		this.m_view.header_txt.text = Localization.get("UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_CAMPAIGNPROGRESS").toUpperCase();
		addChild(this.m_view);
	}

	public function onSetData(_arg_1:Object):void {
		this.m_progressStep = _arg_1.step;
		this.m_onFolderScreen = ((_arg_1.campaignActivatorInUse) && (!(this.m_showBackground)));
		if (this.m_onMissionEnd) {
			this.m_progressStep--;
		}
		;
		this.createBars(_arg_1.campaign, _arg_1.completed, _arg_1.goToExitObjectivesDone, _arg_1.goToExitObjectivesFail);
		if (_arg_1.hardcore) {
			MenuUtils.setColor(this.m_view.holder_mc, MenuConstants.COLOR_RED, false, 10);
		} else {
			MenuUtils.removeColor(this.m_view.holder_mc);
		}
		;
	}

	private function createBars(_arg_1:Array, _arg_2:Array, _arg_3:Boolean = false, _arg_4:Boolean = false):void {
		var _local_15:CampaignProgressBarView;
		var _local_20:CampaignProgressBarView;
		var _local_5:Number = 15;
		var _local_6:int = _arg_1.length;
		var _local_7:int = _arg_2.length;
		var _local_8:int;
		var _local_9:Boolean;
		this.m_fadeUps = new Vector.<CampaignProgressBarView>();
		var _local_10:int;
		var _local_11:int = _local_6;
		var _local_12:int;
		while (_local_12 < _local_6) {
			if (((_arg_1[_local_12] == 1) && (_local_12 < (this.m_progressStep - 1)))) {
				_local_10 = (_local_12 + 1);
				_local_8++;
			}
			;
			if ((((_arg_1[_local_12] == 1) && (_local_12 >= (this.m_progressStep - 1))) && (_local_11 == _local_6))) {
				_local_11 = (_local_12 + 1);
			}
			;
			_local_12++;
		}
		;
		Animate.kill(this.m_transitionBar);
		var _local_13:int = (((this.m_slimView) && (!(this.m_onFolderScreen))) ? _local_10 : 0);
		var _local_14:int = (((this.m_slimView) && (!(this.m_onFolderScreen))) ? _local_11 : _local_6);
		var _local_16:int;
		var _local_17:int = _local_13;
		while (_local_17 < _local_14) {
			if (_local_17 == _local_10) {
				this.m_view.frame_mc.x = (_local_5 - 17);
				_local_5 = (_local_5 + 3);
			}
			;
			if (this.m_view.holder_mc.numChildren <= _local_16) {
				_local_15 = new CampaignProgressBarView();
				this.m_view.holder_mc.addChild(_local_15);
			} else {
				_local_15 = (this.m_view.holder_mc.getChildAt(_local_16) as CampaignProgressBarView);
				Animate.kill(_local_15.flash_mc);
				_local_15.alpha = 1;
				_local_15.scaleX = 1;
				_local_15.scaleY = 1;
				_local_15.visible = true;
			}
			;
			_local_16++;
			if (((this.m_onFolderScreen) && (_local_17 == 0))) {
				_local_9 = true;
			}
			;
			if (_local_9) {
				this.m_fadeUps.push(_local_15);
			}
			;
			switch (_arg_1[_local_17]) {
				case 0:
					_local_15.x = _local_5;
					_local_15.y = 21;
					if ((((_local_17 + 1) == _local_7) && (this.m_onMissionEnd))) {
						this.m_transitionBar = _local_15;
						this.m_transitionFrom = 1;
						this.m_transitionTo = (4 - _arg_2[_local_17]);
						if (this.m_waitWithAnimation) {
							_local_15.gotoAndStop(this.m_transitionFrom);
							this.m_soundId = ((_arg_2[_local_17] == 1) ? "ui_debrief_scorescreen_evergreen_campaign_mildwin" : "ui_debrief_scorescreen_evergreen_campaign_mildfail");
						} else {
							_local_15.gotoAndStop(this.m_transitionTo);
						}
						;
					} else {
						if (_local_17 < _local_7) {
							_local_15.gotoAndStop((4 - _arg_2[_local_17]));
							_local_15.flash_mc.visible = false;
						} else {
							if ((((this.m_progressStep == (_local_17 + 1)) && (!(this.m_onMissionEnd))) && (!(this.m_onFolderScreen)))) {
								if (_arg_3) {
									this.cycleIcon(_local_15, 5, 7);
								} else {
									if (_arg_4) {
										this.cycleIcon(_local_15, 6, 7);
									} else {
										_local_15.gotoAndStop(1);
									}
									;
								}
								;
								this.animateMarker(_local_15);
							} else {
								if (_local_17 < _local_11) {
									_local_15.gotoAndStop(((this.m_onFolderScreen) ? 9 : 1));
								} else {
									_local_15.gotoAndStop(9);
									_local_15.alpha = 0.3;
								}
								;
								_local_15.flash_mc.visible = false;
							}
							;
						}
						;
					}
					;
					_local_5 = (_local_5 + 34);
					break;
				case 1:
					_local_15.x = (_local_5 + 6);
					_local_15.y = 15;
					if ((((_local_17 + 1) == _local_7) && (this.m_onMissionEnd))) {
						this.m_transitionBar = _local_15;
						this.m_transitionFrom = 10;
						this.m_transitionTo = ((_arg_2[_local_17] == 1) ? 12 : 13);
						if (_arg_2[_local_17] == 1) {
							_local_9 = true;
						}
						;
						if (this.m_waitWithAnimation) {
							this.m_soundId = ((_arg_2[_local_17] == 1) ? "ui_debrief_scorescreen_evergreen_campaign_hotwin" : "ui_debrief_scorescreen_evergreen_campaign_hotfail");
							_local_15.gotoAndStop(this.m_transitionFrom);
						} else {
							_local_15.gotoAndStop(this.m_transitionTo);
						}
						;
					} else {
						if (((this.m_progressStep == (_local_17 + 1)) && (!(this.m_onMissionEnd)))) {
							if (_arg_3) {
								this.cycleIcon(_local_15, 14, 16);
							} else {
								if (_arg_4) {
									this.cycleIcon(_local_15, 15, 16);
								} else {
									_local_15.gotoAndStop(10);
								}
								;
							}
							;
						} else {
							if (this.m_progressStep > _local_17) {
								_local_15.gotoAndStop(((_arg_2[_local_17] == 1) ? 12 : 13));
							} else {
								_local_15.gotoAndStop(10);
								_local_9 = false;
								if (_local_17 > (_local_11 - 1)) {
									_local_15.alpha = 0.3;
								}
								;
							}
							;
						}
						;
					}
					;
					if (((this.m_progressStep == (_local_17 + 1)) && (!(this.m_onMissionEnd)))) {
						this.animateMarker(_local_15);
					} else {
						_local_15.flash_mc.visible = false;
					}
					;
					_local_5 = (_local_5 + 47);
					break;
			}
			;
			if (_local_17 == (_local_11 - 1)) {
				this.m_view.frame_mc.campDots_mc.gotoAndStop((_local_8 + 1));
				this.m_view.frame_mc.mid_mc.x = 9;
				this.m_view.frame_mc.mid_mc.width = (34 * (_local_11 - _local_10));
				this.m_view.frame_mc.end_mc.x = (8 + this.m_view.frame_mc.mid_mc.width);
				this.m_view.frame_mc.campDots_mc.x = (10 + (this.m_view.frame_mc.mid_mc.width / 2));
				_local_5 = (_local_5 + 3);
				this.m_view.frame_mc.visible = (!(this.m_onFolderScreen));
			}
			;
			_local_17++;
		}
		;
		this.m_view.back_mc.width = (_local_5 + 18);
		this.m_view.x = (-(_local_5 - 4) / 2);
		if ((((!(this.m_waitWithAnimation)) && (this.m_fadeUps.length > 0)) && (this.m_onMissionEnd))) {
			for each (_local_20 in this.m_fadeUps) {
				_local_20.alpha = 1;
			}
			;
		}
		;
		var _local_18:int = this.m_view.holder_mc.numChildren;
		var _local_19:int = _local_16;
		while (_local_19 < _local_18) {
			_local_15 = (this.m_view.holder_mc.getChildAt(_local_19) as CampaignProgressBarView);
			_local_15.visible = false;
			_local_19++;
		}
		;
	}

	public function doAnimation():void {
		ExternalInterface.call("PlaySound", this.m_soundId);
		this.m_transitionBar.gotoAndStop(this.m_transitionFrom);
		Animate.to(this.m_transitionBar, 0.2, 0, {
			"scaleX": 0.01,
			"scaleY": 1.3
		}, Animate.SineOut, function ():void {
			var _local_1:CampaignProgressBarView;
			m_transitionBar.gotoAndStop(m_transitionTo);
			Animate.to(m_transitionBar, 0.3, 0, {
				"scaleX": 1,
				"scaleY": 1
			}, Animate.SineIn);
			if (((m_fadeUps.length > 0) && (m_onMissionEnd))) {
				for each (_local_1 in m_fadeUps) {
					Animate.to(_local_1, 0.3, 0.3, {"alpha": 1}, Animate.Linear);
				}
				;
			}
			;
		});
		this.m_transitionBar.flash_mc.visible = true;
		this.m_transitionBar.flash_mc.alpha = 1;
		this.m_transitionBar.flash_mc.scaleX = (this.m_transitionBar.flash_mc.scaleY = 1);
		Animate.to(this.m_transitionBar.flash_mc, 0.4, 0.4, {
			"alpha": 0,
			"scaleX": 2,
			"scaleY": 2
		}, Animate.SineOut);
	}

	private function cycleIcon(marker_mc:CampaignProgressBarView, startFrame:int, endFrame:int):void {
		this.m_transitionBar = marker_mc;
		this.m_transitionBar.gotoAndStop(startFrame);
		Animate.to(this.m_transitionBar, 0.1, 1.5, {"scaleX": 0.01}, Animate.SineOut, function ():void {
			m_transitionBar.gotoAndStop(endFrame);
			Animate.to(m_transitionBar, 0.1, 0, {"scaleX": 1}, Animate.SineIn, function ():void {
				cycleIcon(m_transitionBar, endFrame, startFrame);
			});
		});
	}

	private function animateMarker(_arg_1:CampaignProgressBarView):void {
		if (this.m_showMarker) {
			_arg_1.flash_mc.alpha = 1;
			_arg_1.flash_mc.scaleX = (_arg_1.flash_mc.scaleY = 1);
			Animate.to(_arg_1.flash_mc, 0.4, 0.4, {
				"alpha": 0,
				"scaleX": 1.8,
				"scaleY": 1.8
			}, Animate.SineOut, this.animateMarker, _arg_1);
		} else {
			_arg_1.flash_mc.visible = false;
		}
		;
	}

	public function folderAnim():void {
		var _local_1:CampaignProgressBarView;
		Log.xinfo(Log.ChannelDebug, ("CampaingProgress fadeUps length: " + this.m_fadeUps.length));
		if (this.m_onFolderScreen) {
			for each (_local_1 in this.m_fadeUps) {
				if (_local_1.currentFrame == 9) {
					_local_1.gotoAndStop(1);
				}
				;
			}
			;
			this.m_view.frame_mc.visible = true;
			this.m_view.frame_mc.alpha = 0;
			Animate.to(this.m_view.frame_mc, 0.2, 0, {"alpha": 1}, Animate.Linear);
		}
		;
	}

	public function folderAnimReset():void {
		var _local_1:CampaignProgressBarView;
		if (this.m_onFolderScreen) {
			for each (_local_1 in this.m_fadeUps) {
				if (_local_1.currentFrame == 1) {
					_local_1.gotoAndStop(9);
				}
				;
			}
			;
			this.m_view.frame_mc.visible = false;
		}
		;
	}

	public function set showMarker(_arg_1:Boolean):void {
		this.m_showMarker = _arg_1;
	}

	public function set showBackground(_arg_1:Boolean):void {
		this.m_view.back_mc.visible = (this.m_showBackground = _arg_1);
		this.m_view.header_txt.visible = ((this.m_onMissionEnd) || (this.m_showBackground));
	}

	public function set showSlimView(_arg_1:Boolean):void {
		this.m_slimView = _arg_1;
	}

	public function set waitWithAnimation(_arg_1:Boolean):void {
		this.m_waitWithAnimation = _arg_1;
	}

	public function set onMissionEnd(_arg_1:Boolean):void {
		this.m_onMissionEnd = _arg_1;
		this.m_view.header_txt.visible = ((this.m_onMissionEnd) || (this.m_showBackground));
	}

	public function set onFolderScreen(_arg_1:Boolean):void {
		this.m_onFolderScreen = _arg_1;
	}


}
}//package hud.evergreen

