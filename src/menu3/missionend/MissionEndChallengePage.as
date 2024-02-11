// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.missionend.MissionEndChallengePage

package menu3.missionend {
import menu3.MenuElementBase;

import flash.geom.Rectangle;
import flash.display.Sprite;

import common.menu.MenuConstants;

import basic.DottedLine;

import flash.utils.Dictionary;

import common.Animate;

import flash.external.ExternalInterface;

import common.menu.MenuUtils;
import common.Localization;

import flash.geom.Point;

import common.CalcUtil;

public dynamic class MissionEndChallengePage extends MenuElementBase {

	public static const CHALLENGE_STATE_NEW:String = "new";
	public static const CHALLENGE_STATE_NEW_UNLOCKED:String = "unlocked";
	public static const CHALLENGE_STATE_COMPLETE:String = "complete";
	public static const CHALLENGE_STATE_UNCOMPLETE:String = "uncomplete";

	private const IMAGE_REQUEST_MAX:Number = 3;
	private const TILE_GAP:int = 2;

	private var m_view:MissionEndChallengePageView;
	private var m_challengeArea:Rectangle;
	private var m_totalChallengeCount:int = 0;
	private var m_challengeCounter:int = 0;
	private var m_tileWidth:int = 0;
	private var m_tileHeight:int = 0;
	private var m_tileScale:Number = 1;
	private var m_tileCountX:int = 0;
	private var m_challenges:Array = [];
	private var m_challengeImages:Array = [];
	private var m_challengeTiles:Array = [];
	private var m_shuffledTileIndexes:Array = [];
	private var m_loadImageQueue:Array = [];
	private var m_loadImageLoaded:Array = [];
	private var m_stopLoading:Boolean = false;
	private var m_unloadingImagesInProgress:Boolean = false;
	private var m_loadingImagesInProgress:int = 0;
	private var m_gainedXp:int = 0;
	private var m_gainedMultiplier:Number = 0;
	private var m_imageScaleDown:Number = 0.25;
	private var m_dottedLineContainer:Sprite;
	private var m_isTotalXpBgVisible:Boolean = false;
	private var m_tickSoundStarted:Boolean;
	private var m_tilesAppearSoundStarted:Boolean;

	public function MissionEndChallengePage(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new MissionEndChallengePageView();
		this.m_view.x = -(MenuConstants.menuXOffset);
		this.m_view.y = -(MenuConstants.menuYOffset);
		addChild(this.m_view);
		var _local_2:Sprite = this.m_view.challengeArea;
		this.m_challengeArea = new Rectangle(_local_2.x, _local_2.y, _local_2.width, _local_2.height);
		_local_2.visible = false;
		var _local_3:ImageItemView = new ImageItemView();
		this.m_tileWidth = _local_3.getImageWidth();
		this.m_tileHeight = _local_3.getImageHeight();
		_local_3 = null;
		this.m_dottedLineContainer = new Sprite();
		this.m_dottedLineContainer.x = (_local_2.x + 2);
		this.m_dottedLineContainer.y = ((_local_2.y + _local_2.height) + 15);
		var _local_4:DottedLine = new DottedLine(_local_2.width, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 1, 2);
		this.m_dottedLineContainer.addChild(_local_4);
		this.m_view.addChild(this.m_dottedLineContainer);
	}

	override public function onSetData(_arg_1:Object):void {
		var _local_7:String;
		var _local_8:int;
		var _local_9:String;
		var _local_10:int;
		super.onSetData(_arg_1);
		this.m_view.totalXP_bg.scaleX = 0;
		this.m_isTotalXpBgVisible = false;
		this.m_view.totalXP.alpha = 1;
		this.m_dottedLineContainer.alpha = 0;
		var _local_2:Array = _arg_1.Challenges;
		this.m_challenges = _local_2;
		if (_local_2 == null) {
			this.m_challenges = new Array();
		}
		;
		this.m_challengeImages = _arg_1.ChallengeImages;
		if (this.m_challengeImages == null) {
			this.m_challengeImages = new Array();
			this.m_challengeImages.length = this.m_challenges.length;
		}
		;
		var _local_3:Dictionary = new Dictionary();
		var _local_4:int;
		while (_local_4 < this.m_challenges.length) {
			_local_7 = "";
			if (this.m_challenges[_local_4].ChallengeId !== undefined) {
				_local_7 = this.m_challenges[_local_4].ChallengeId;
			} else {
				if (this.m_challenges[_local_4].Id !== undefined) {
					_local_7 = this.m_challenges[_local_4].Id;
				}
				;
			}
			;
			if (_local_7.length > 0) {
				_local_3[_local_7] = _local_4;
			}
			;
			_local_4++;
		}
		;
		var _local_5:Array = _arg_1.NewChallenges;
		var _local_6:Array = _arg_1.NewChallengeImages;
		if (_local_5 != null) {
			if (_local_6 == null) {
				_local_6 = new Array();
			}
			;
			if (_local_6.length != _local_5.length) {
				_local_6.length = _local_5.length;
			}
			;
			_local_8 = 0;
			while (_local_8 < _local_5.length) {
				if (_local_5[_local_8].IsActionReward !== true) {
					_local_9 = _local_5[_local_8].ChallengeId;
					if (_local_3[_local_9] !== undefined) {
						_local_10 = _local_3[_local_9];
						this.m_challenges[_local_10].IsNewChallenge = true;
						this.m_challenges[_local_10].XPGain = _local_5[_local_8].XPGain;
					} else {
						_local_5[_local_8].IsNewChallenge = true;
						this.m_challenges.push(_local_5[_local_8]);
						this.m_challengeImages.push(_local_6[_local_8]);
					}
					;
				}
				;
				_local_8++;
			}
			;
		}
		;
		this.m_totalChallengeCount = this.m_challenges.length;
		if (this.m_totalChallengeCount == 0) {
			return;
		}
		;
		if (this.m_totalChallengeCount > 200) {
			this.m_imageScaleDown = 0.1;
		} else {
			if (this.m_totalChallengeCount > 170) {
				this.m_imageScaleDown = 0.2;
			} else {
				this.m_imageScaleDown = 0.25;
			}
			;
		}
		;
		this.calculateTileScale(1);
		this.createChallengeTiles();
		this.m_stopLoading = false;
	}

	public function startAnimation():void {
		this.m_stopLoading = false;
		if (this.m_loadingImagesInProgress == 0) {
			this.startLoadImageFromQueue();
		}
		;
		this.setTexts("", "");
		this.setXpText(0);
		this.m_gainedXp = 0;
		this.killAllAnimations();
		var _local_1:int;
		while (_local_1 < this.m_challengeTiles.length) {
			this.m_challengeTiles[_local_1].view.setVisible(false);
			_local_1++;
		}
		;
		Animate.to(this.m_dottedLineContainer, 0.4, 0.1, {"alpha": 1}, Animate.ExpoOut);
		Animate.delay(this.m_view, 1, this.showTileGrid);
	}

	public function startLoadImages():void {
		if (this.m_loadingImagesInProgress == 0) {
			this.startLoadImageFromQueue();
		}
		;
	}

	public function unloadImages():void {
		this.unloadImagesFromQueue();
	}

	public function playSound(_arg_1:String):void {
		ExternalInterface.call("PlaySound", _arg_1);
	}

	private function showTileGrid():void {
		var _local_5:Object;
		var _local_6:ImageItemView;
		var _local_7:int;
		this.playSound("ui_debrief_achievement_tiles_appear");
		this.m_tilesAppearSoundStarted = true;
		var _local_1:Number = 0.01;
		var _local_2:Number = 0.01;
		var _local_3:Number = 0.3;
		var _local_4:int;
		while (_local_4 < this.m_shuffledTileIndexes.length) {
			_local_5 = this.m_challengeTiles[this.m_shuffledTileIndexes[_local_4]];
			_local_6 = _local_5.view;
			_local_6.setVisible(true, 0);
			MenuUtils.addColorFilter(_local_6.image, [MenuConstants.COLOR_MATRIX_BW]);
			_local_7 = this.getRandomDir();
			if (_local_7 == 1) {
				Animate.from(_local_6, 0.2, _local_1, {"y": (_local_6.y - 10)}, Animate.ExpoOut);
			} else {
				if (_local_7 == 2) {
					Animate.from(_local_6, 0.2, _local_1, {"y": (_local_6.y + 10)}, Animate.ExpoOut);
				} else {
					if (_local_7 == 3) {
						Animate.from(_local_6, 0.2, _local_1, {"x": (_local_6.x - 10)}, Animate.ExpoOut);
					} else {
						if (_local_7 == 4) {
							Animate.from(_local_6, 0.2, _local_1, {"x": (_local_6.x + 10)}, Animate.ExpoOut);
						}
						;
					}
					;
				}
				;
			}
			;
			Animate.to(_local_6.image, _local_3, _local_1, {"alpha": 0.5}, Animate.ExpoOut);
			_local_1 = (_local_1 + _local_2);
			_local_4++;
		}
		;
		Animate.delay(this, (_local_1 + _local_3), this.animateTile, 0);
	}

	private function animateTile(_arg_1:int):void {
		if (_arg_1 >= this.m_challengeTiles.length) {
			return;
		}
		;
		if (this.m_tilesAppearSoundStarted) {
			this.playSound("ui_debrief_achievement_tiles_appear_stop");
			this.m_tilesAppearSoundStarted = false;
		}
		;
		if (!this.m_tickSoundStarted) {
			this.playSound("ui_debrief_achievement_scorescreen_tick_lp");
			this.m_tickSoundStarted = true;
		}
		;
		var _local_2:Object = this.m_challengeTiles[_arg_1];
		var _local_3:ImageItemView = _local_2.view;
		var _local_4:String = CHALLENGE_STATE_UNCOMPLETE;
		if (_local_2.IsNewChallenge === true) {
			_local_4 = CHALLENGE_STATE_NEW;
		} else {
			if (_local_2.Completed === true) {
				_local_4 = CHALLENGE_STATE_COMPLETE;
			}
			;
		}
		;
		_local_3.animateIn(_local_4);
		if (_local_4 == CHALLENGE_STATE_NEW) {
			this.unlockChallenge(_local_2);
			if (this.m_tickSoundStarted) {
				this.playSound("ui_debrief_achievement_scorescreen_tick_lp_stop");
				this.m_tickSoundStarted = false;
			}
			;
			this.playSound("ui_debrief_achievement_scorescreen_tile_highlight");
			Animate.delay(this.m_view, 1, this.animateTile, (_arg_1 + 1));
		} else {
			Animate.delay(this.m_view, 0.03, this.animateTile, (_arg_1 + 1));
		}
		;
		this.checkChallengeCountCompleted(_local_4);
	}

	private function unlockChallenge(challengeTile:Object):void {
		var multiplier:Number;
		var i:int;
		var headerLoca:String;
		var currentXpReward:int;
		var previousGainedXP:int = this.m_gainedXp;
		if (challengeTile.XPGain !== undefined) {
			this.m_gainedXp = (this.m_gainedXp + challengeTile.XPGain);
			currentXpReward = challengeTile.XPGain;
		}
		;
		multiplier = 0;
		var drops:Array = challengeTile.Drops;
		if (drops != null) {
			i = 0;
			while (i < drops.length) {
				if (drops[i].Type == "challengemultiplier") {
					multiplier = (multiplier + drops[i].Properties.Multiplier);
				}
				;
				i = (i + 1);
			}
			;
		}
		;
		this.m_gainedMultiplier = (this.m_gainedMultiplier + multiplier);
		if (!this.m_isTotalXpBgVisible) {
			this.m_isTotalXpBgVisible = true;
			Animate.to(this.m_view.totalXP_bg, 0.3, 0, {"scaleX": 1}, Animate.ExpoInOut);
		}
		;
		var header:String = "";
		if (multiplier > 0) {
			multiplier = (multiplier + 1);
			header = ((Localization.get("UI_MENU_SCORE_MULTIPLIER_CHALLENGE") + ": ") + multiplier.toFixed(2));
			Animate.to(this.m_view.totalXP, 0.2, 0, {"alpha": 0}, Animate.ExpoIn, function ():void {
				setMultiplierText(multiplier);
				Animate.addTo(m_view.totalXP, 0.3, 0.2, {"alpha": 1}, Animate.ExpoOut);
			});
		} else {
			headerLoca = ((challengeTile.CategoryName != null) ? challengeTile.CategoryName : "UI_DIALOG_TITLE_CHALLENGE_COMPLETED");
			header = Localization.get(headerLoca);
			if (currentXpReward > 0) {
				Animate.addFromTo(this.m_view.totalXP, 0.5, 0.2, {"intAnimation": 0}, {"intAnimation": currentXpReward}, Animate.Linear, this.setXpText, currentXpReward);
				this.playSound("ui_debrief_achievement_scorescreen_tick_xp_lp");
			} else {
				this.setXpText(0);
			}
			;
		}
		;
		var title:String = "";
		if (challengeTile.ChallengeName !== undefined) {
			title = Localization.get(challengeTile.ChallengeName);
		} else {
			title = Localization.get(challengeTile.Name);
		}
		;
		Animate.delay(this.m_view, 0.1, this.setTexts, title, header);
		var imageItemView:ImageItemView = challengeTile.view;
		imageItemView.parent.setChildIndex(imageItemView, (imageItemView.parent.numChildren - 1));
		var originalScale:Point = new Point(imageItemView.scaleX, imageItemView.scaleY);
		var originalPos:Point = new Point(imageItemView.x, imageItemView.y);
		var localBound:Rectangle = imageItemView.getBounds(imageItemView);
		var/*const*/ POPOUT_GAIN_MAX_WIDTH:Number = 60;
		var/*const*/ POPOUT_GAIN_MAX_HEIGHT:Number = 60;
		var animationVars:Object = CalcUtil.createScalingAnimationParameters(originalPos, originalScale, localBound, POPOUT_GAIN_MAX_WIDTH, POPOUT_GAIN_MAX_HEIGHT);
		Animate.to(imageItemView, 0.2, 0, animationVars, Animate.ExpoOut);
		Animate.addFromTo(imageItemView, 0.3, 0.2, animationVars, {
			"x": originalPos.x,
			"y": originalPos.y,
			"scaleX": originalScale.x,
			"scaleY": originalScale.y
		}, Animate.ExpoIn, function (_arg_1:ImageItemView):void {
			_arg_1.animateIn(CHALLENGE_STATE_NEW_UNLOCKED);
		}, imageItemView);
	}

	private function checkChallengeCountCompleted(lastChallengeState:String):void {
		var delay:Number;
		var awardType:String;
		var endTitle:String;
		var endHeader:String;
		var endValue:Number;
		this.m_challengeCounter++;
		if (this.m_challengeCounter == this.m_totalChallengeCount) {
			this.m_challengeCounter = 0;
			this.playSound("ui_debrief_achievement_scorescreen_tick_lp_stop");
			if (((this.m_gainedXp <= 0) && (this.m_gainedMultiplier <= 0))) {
				return;
			}
			;
			delay = ((lastChallengeState == CHALLENGE_STATE_NEW) ? 1 : 0.4);
			awardType = "";
			endTitle = "";
			endHeader = Localization.get("UI_MENU_SCOREOVERVIEW_CHALLENGESCOMPLETED");
			endValue = 0;
			if (this.m_gainedXp > 0) {
				awardType = "xp";
				endTitle = Localization.get("UI_MENU_MISSION_END_SCOREDETAIL_XP_TITLE");
				endValue = this.m_gainedXp;
			} else {
				if (this.m_gainedMultiplier > 0) {
					awardType = "multiplier";
					endTitle = Localization.get("UI_MENU_SCORE_MULTIPLIER_CHALLENGE");
					endValue = (this.m_gainedMultiplier + 1);
				}
				;
			}
			;
			Animate.delay(this.m_view, delay, function ():void {
				m_view.title.alpha = 0;
				m_view.header.alpha = 0;
				m_view.totalXP.alpha = 0;
				setTexts(endTitle, endHeader);
				if (awardType == "xp") {
					setXpText(endValue);
				} else {
					if (awardType == "multiplier") {
						setMultiplierText(endValue);
					}
					;
				}
				;
				Animate.fromTo(m_view.totalXP_bg.inner, 0.4, 0, {
					"scaleX": 0.7,
					"scaleY": 0.7
				}, {
					"scaleX": 1.02,
					"scaleY": 1.1
				}, Animate.BackOut);
				Animate.to(m_view.totalXP, 0.3, 0, {"alpha": 1}, Animate.ExpoIn);
				Animate.to(m_view.header, 0.2, 0.1, {"alpha": 1}, Animate.ExpoOut);
				Animate.addTo(m_view.header, 0.4, 0.1, {"x": (m_view.header.x + 15)}, Animate.ExpoOut);
				Animate.to(m_view.title, 0.2, 0.15, {"alpha": 1}, Animate.ExpoOut);
				Animate.addTo(m_view.title, 0.4, 0.15, {"x": (m_view.title.x + 15)}, Animate.ExpoOut);
				playSound("ui_debrief_achievement_scorescreen_total_xp");
			});
		}
		;
	}

	private function setTexts(_arg_1:String, _arg_2:String):void {
		MenuUtils.setupTextAndShrinkToFitUpper(this.m_view.title, _arg_1, 68, MenuConstants.FONT_TYPE_BOLD, this.m_view.title.width, -1, 30, MenuConstants.FontColorWhite);
		MenuUtils.setupTextUpper(this.m_view.header, _arg_2, 22, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
	}

	private function setXpText(_arg_1:int):void {
		var _local_2:String = ((MenuUtils.formatNumber(_arg_1) + " ") + Localization.get("UI_PERFORMANCE_MASTERY_XP"));
		this.playSound("ui_debrief_achievement_scorescreen_tick_xp_lp_stop");
		if (_arg_1 == 0) {
			_local_2 = "";
		}
		;
		MenuUtils.setupTextAndShrinkToFit(this.m_view.totalXP, _local_2, 70, MenuConstants.FONT_TYPE_MEDIUM, this.m_view.totalXP.width, -1, 50, MenuConstants.FontColorBlack);
	}

	private function setMultiplierText(_arg_1:Number):void {
		MenuUtils.setupTextAndShrinkToFit(this.m_view.totalXP, _arg_1.toFixed(2), 70, MenuConstants.FONT_TYPE_MEDIUM, this.m_view.totalXP.width, -1, 50, MenuConstants.FontColorBlack);
	}

	private function createChallengeTiles():void {
		var _local_4:Object;
		var _local_5:ImageItemView;
		var _local_6:String;
		var _local_7:int;
		var _local_8:Number;
		var _local_9:Number;
		this.m_loadImageQueue = [];
		this.m_challengeTiles.length = 0;
		var _local_1:Number = ((this.m_tileWidth + this.TILE_GAP) * this.m_tileScale);
		var _local_2:Number = ((this.m_tileHeight + this.TILE_GAP) * this.m_tileScale);
		var _local_3:int;
		while (_local_3 < this.m_challenges.length) {
			_local_4 = this.m_challenges[_local_3];
			_local_5 = new ImageItemView();
			_local_6 = this.m_challengeImages[_local_3];
			if (((!(_local_6 == null)) && (_local_6.length > 0))) {
				this.m_loadImageQueue.push({
					"view": _local_5,
					"path": _local_6
				});
			}
			;
			_local_5.scaleX = this.m_tileScale;
			_local_5.scaleY = this.m_tileScale;
			_local_7 = (_local_3 % this.m_tileCountX);
			_local_8 = (_local_7 * _local_1);
			_local_9 = (Math.floor((_local_3 / this.m_tileCountX)) * _local_2);
			_local_5.x = (this.m_challengeArea.x + _local_8);
			_local_5.y = (this.m_challengeArea.y + _local_9);
			this.m_view.addChild(_local_5);
			_local_4.view = _local_5;
			this.m_challengeTiles.push(_local_4);
			this.m_shuffledTileIndexes.push(_local_3);
			_local_3++;
		}
		;
		this.m_shuffledTileIndexes = MenuUtils.shuffleArray(this.m_shuffledTileIndexes);
	}

	private function getRandomDir():int {
		var _local_1:Number = MenuUtils.getRandomInRange(0, 1000);
		if (_local_1 >= 750) {
			return (1);
		}
		;
		if (_local_1 >= 500) {
			return (2);
		}
		;
		if (_local_1 >= 250) {
			return (3);
		}
		;
		return (4);
	}

	private function calculateTileScale(_arg_1:Number):void {
		var _local_8:Boolean;
		var _local_9:int;
		var _local_10:Number;
		var _local_11:Number;
		var _local_2:Number = _arg_1;
		var _local_3:Number = (this.m_challengeArea.width + this.TILE_GAP);
		var _local_4:Number = (this.m_challengeArea.height + this.TILE_GAP);
		var _local_5:Number = (this.m_tileWidth + this.TILE_GAP);
		var _local_6:Number = (this.m_tileHeight + this.TILE_GAP);
		this.m_tileCountX = this.m_totalChallengeCount;
		var _local_7:Number = ((_local_5 * _local_2) * this.m_totalChallengeCount);
		if (_local_7 > _local_3) {
			_local_8 = false;
			this.m_tileCountX = Math.ceil((_local_3 / (_local_5 * _local_2)));
			while ((!(_local_8))) {
				_local_9 = int(Math.ceil((this.m_totalChallengeCount / this.m_tileCountX)));
				_local_2 = (_local_3 / (this.m_tileCountX * _local_5));
				_local_10 = (_local_6 * _local_2);
				_local_11 = (_local_10 * _local_9);
				if (_local_11 > _local_4) {
					this.m_tileCountX = (this.m_tileCountX + 1);
				} else {
					_local_8 = true;
				}
				;
			}
			;
		}
		;
		this.m_tileScale = _local_2;
	}

	private function startLoadImageFromQueue():void {
		var _local_1:int;
		while (_local_1 < Math.min(this.IMAGE_REQUEST_MAX, this.m_loadImageQueue.length)) {
			this.loadImageFromQueue();
			_local_1++;
		}
		;
	}

	private function loadImageFromQueue():void {
		var _local_1:Object;
		if (this.m_stopLoading) {
			return;
		}
		;
		if (this.m_unloadingImagesInProgress) {
			Animate.delay(this.m_view, 0.01, this.loadImageFromQueue);
			return;
		}
		;
		if (this.m_loadImageQueue.length > 0) {
			_local_1 = this.m_loadImageQueue.shift();
			this.m_loadingImagesInProgress++;
			_local_1.view.loadImage(_local_1.path, this.loadImageDone, this.loadImageDone, this.m_imageScaleDown);
			this.m_loadImageLoaded.push(_local_1);
		}
		;
	}

	private function loadImageDone():void {
		this.m_loadingImagesInProgress--;
		this.loadImageFromQueue();
	}

	private function unloadImagesFromQueue():void {
		var _local_1:Object;
		this.m_stopLoading = true;
		this.m_unloadingImagesInProgress = true;
		while (this.m_loadImageLoaded.length > 0) {
			_local_1 = this.m_loadImageLoaded.pop();
			_local_1.view.unloadImage();
			this.m_loadImageQueue.unshift(_local_1);
		}
		;
		this.m_unloadingImagesInProgress = false;
	}

	private function killAllAnimations():void {
		Animate.kill(this.m_view.totalXP_bg);
		Animate.kill(this.m_view.totalXP);
		Animate.kill(this.m_view.header);
		Animate.kill(this.m_view.title);
		Animate.kill(this.m_view);
		Animate.kill(this);
	}

	override public function onUnregister():void {
		this.killAllAnimations();
		var _local_1:int;
		while (_local_1 < this.m_challengeTiles.length) {
			this.m_challengeTiles[_local_1].view.killAnimation();
			_local_1++;
		}
		;
		this.playSound("ui_debrief_achievement_scorescreen_tick_xp_lp_stop");
		this.playSound("ui_debrief_achievement_scorescreen_tick_lp_stop");
		if (this.m_tilesAppearSoundStarted) {
			this.playSound("ui_debrief_achievement_tiles_appear_stop");
			this.m_tilesAppearSoundStarted = false;
		}
		;
		this.unloadImages();
		this.m_challengeTiles.length = 0;
		this.m_view = null;
		super.onUnregister();
	}


}
}//package menu3.missionend

