// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.statistics.MenuTileStatistics

package menu3.statistics {
import menu3.MenuElementTileBase;

import __AS3__.vec.Vector;

import flash.text.TextField;
import flash.display.MovieClip;

import common.TaskletSequencer;
import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Animate;

import flash.display.Sprite;

import common.Localization;

import __AS3__.vec.*;

public dynamic class MenuTileStatistics extends MenuElementTileBase {

	private static var s_tilesReadyToShow:Vector.<MenuTileStatistics> = new Vector.<MenuTileStatistics>(0);

	private var m_view:MenuTileStatisticsView;
	private var m_locationImages:LocationImage;
	private var m_statBars:StatisticBars;
	private var m_opportunityBarView:StatisticBarSmallView;
	private var m_opportunityBar:StatisticBar;
	private var m_masteryLevelChart:MasteryLevelChart;
	private var m_textfieldCollection:Vector.<TextField>;
	private var m_iconCollection:Vector.<MovieClip>;
	private var m_data:Object = {};
	private var m_isCompleted:Boolean;
	private var m_pressable:Boolean = true;
	private var m_isInitialized:Boolean = false;
	private var m_isAvailable:Boolean = false;
	private var m_isMasteryAvailable:Boolean = false;

	{
		TaskletSequencer.getGlobalInstance().addEventListener(TaskletSequencer.COMPLETE, function ():void {
			if (s_tilesReadyToShow.length > 0) {
				dequeueNextTile(s_tilesReadyToShow);
				s_tilesReadyToShow = new Vector.<MenuTileStatistics>(0);
			}

		});
	}

	public function MenuTileStatistics(_arg_1:Object) {
		super(_arg_1);
		this.m_data = _arg_1;
		this.m_isCompleted = (this.m_data.completionValue == 100);
		this.m_view = new MenuTileStatisticsView();
		this.m_view.tileBg.alpha = 0;
		this.m_view.dropShadow.alpha = 0;
		this.m_view.tileContent.alpha = 0;
		MenuUtils.setColor(this.m_view.tileDarkBg, MenuConstants.COLOR_MENU_BUTTON_TILE_DESELECTED);
		MenuUtils.setupText(this.m_view.tileHeader, "", 12, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_view.tileTitle, "", 26, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_view.tileContent.completionTitle, "", 20, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGrey);
		MenuUtils.setupText(this.m_view.tileContent.completionValue, "", 90, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_view.tileContent.challengesTitle, "", 20, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_view.tileContent.masteryTitle, "", 20, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		addChild(this.m_view);
	}

	private static function dequeueNextTile(_arg_1:Vector.<MenuTileStatistics>):void {
		var _local_2:MenuTileStatistics;
		if (_arg_1.length > 0) {
			_local_2 = _arg_1.shift();
			Animate.to(_local_2.m_view.tileContent, 0.05, 0, {"alpha": 1}, Animate.Linear, dequeueNextTile, _arg_1);
		}

	}


	override public function onSetData(data:Object):void {
		var availableChanged:Boolean;
		var masteryAvailabilityChanged:Boolean;
		var self:MenuTileStatistics;
		super.onSetData(data);
		var ts:TaskletSequencer = TaskletSequencer.getGlobalInstance();
		this.m_data = data;
		var isAvailable:Boolean = this.m_data.isAvailable;
		availableChanged = (!(this.m_isAvailable == isAvailable));
		this.m_isAvailable = isAvailable;
		var isMasteryAvailable:Boolean = (this.m_data.hideMastery === false);
		masteryAvailabilityChanged = (!(this.m_isMasteryAvailable == isMasteryAvailable));
		this.m_isMasteryAvailable = isMasteryAvailable;
		if (!this.m_isAvailable) {
			this.m_data.completionValue = 0;
		}

		this.m_pressable = true;
		if (getNodeProp(this, "pressable") == false) {
			this.m_pressable = false;
		}

		this.m_iconCollection = new <MovieClip>[this.m_view.tileIcon, this.m_view.tileContent.challengesIcon, this.m_view.tileContent.masteryIcon];
		this.m_textfieldCollection = new <TextField>[this.m_view.tileHeader, this.m_view.tileTitle, this.m_view.tileContent.completionTitle, this.m_view.tileContent.completionValue, this.m_view.tileContent.challengesTitle, this.m_view.tileContent.masteryTitle];
		MenuUtils.setupIcon(this.m_view.tileIcon, this.m_data.tileIcon, MenuConstants.COLOR_WHITE, true, false);
		MenuUtils.setupIcon(this.m_view.tileContent.challengesIcon, this.m_data.challenges.challengesIcon, MenuConstants.COLOR_WHITE, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
		MenuUtils.setupIcon(this.m_view.tileContent.masteryIcon, this.m_data.masteryIcon, MenuConstants.COLOR_WHITE, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
		this.m_view.tileHeader.htmlText = this.m_data.tileHeader.toUpperCase();
		this.m_view.tileTitle.htmlText = this.m_data.tileTitle.toUpperCase();
		this.m_view.tileContent.completionTitle.htmlText = this.m_data.completionTitle.toUpperCase();
		this.m_view.tileContent.completionValue.htmlText = (Math.floor(this.m_data.completionValue) + "%");
		this.m_view.tileContent.masteryTitle.htmlText = this.m_data.masteryTitle.toUpperCase();
		ts.addChunk(function ():void {
			if (((!(m_isInitialized)) || (availableChanged))) {
				initImage({"tileImage": m_data.tileImage});
				initStatisticBars(m_data.challenges.statistics);
				initOpportunityBar(m_data.opportunities);
			}

		});
		ts.addChunk(function ():void {
			if ((((!(m_isInitialized)) || (masteryAvailabilityChanged)) || (availableChanged))) {
				initMasteryLevelChart(m_data.mastery);
			}

		});
		ts.addChunk(function ():void {
			if (!m_isCompleted) {
				if (!m_isInitialized) {
					animateIcons(new <MovieClip>[m_view.tileIcon, m_view.tileContent.challengesIcon, m_view.tileContent.masteryIcon]);
					showTexts(new <TextField>[m_view.tileHeader, m_view.tileTitle, m_view.tileContent.challengesTitle, m_view.tileContent.masteryTitle], true);
					if (!m_isAvailable) {
						m_view.tileContent.completionTitle.alpha = 0;
						m_view.tileContent.completionValue.alpha = 0;
					} else {
						showTexts(new <TextField>[m_view.tileContent.completionTitle, m_view.tileContent.completionValue], true);
					}

				}

				if (!m_isAvailable) {
					Animate.kill(m_view.tileContent.completionTitle);
					Animate.kill(m_view.tileContent.completionValue);
					m_view.tileContent.completionTitle.alpha = 0;
					m_view.tileContent.completionValue.alpha = 0;
				}

			} else {
				showTexts(new <TextField>[m_view.tileHeader, m_view.tileTitle, m_view.tileContent.completionTitle, m_view.tileContent.completionValue, m_view.tileContent.challengesTitle, m_view.tileContent.masteryTitle], false);
			}

		});
		self = this;
		ts.addChunk(function ():void {
			handleSelectionChange();
			m_isInitialized = true;
			s_tilesReadyToShow.push(self);
		});
	}

	override public function getView():Sprite {
		return (this.m_view.tileBg);
	}

	override protected function handleSelectionChange():void {
		super.handleSelectionChange();
		if (m_loading) {
			return;
		}

		if (m_isSelected) {
			setPopOutScale(this.m_view, true);
			Animate.to(this.m_view.dropShadow, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
			MenuUtils.setColor(this.m_view.tileSelectionHeader, MenuConstants.COLOR_RED, true, MenuConstants.MenuElementSelectedAlpha);
			MenuUtils.setupIcon(this.m_view.tileIcon, this.m_data.tileIcon, MenuConstants.COLOR_RED, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
		} else {
			setPopOutScale(this.m_view, false);
			Animate.kill(this.m_view.dropShadow);
			this.m_view.dropShadow.alpha = 0;
			MenuUtils.setColor(this.m_view.tileSelectionHeader, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
			MenuUtils.setupIcon(this.m_view.tileIcon, this.m_data.tileIcon, MenuConstants.COLOR_WHITE, true, false);
		}

	}

	override public function onUnregister():void {
		if (this.m_view) {
			this.killAnimations();
			if (this.m_locationImages) {
				this.m_locationImages.destroy();
				this.m_locationImages = null;
			}

			this.removeStatisticBars();
			this.removeMasteryLevelChart();
			this.removeOpportunityBar();
			removeChild(this.m_view);
			this.m_view = null;
		}

		var _local_1:int = s_tilesReadyToShow.indexOf(this);
		if (_local_1 >= 0) {
			s_tilesReadyToShow.splice(_local_1, 1);
		}

		super.onUnregister();
	}

	private function killAnimations():void {
		var _local_1:int;
		if (this.m_iconCollection != null) {
			_local_1 = 0;
			while (_local_1 < this.m_iconCollection.length) {
				Animate.kill(this.m_iconCollection[_local_1]);
				_local_1++;
			}

		}

		if (this.m_textfieldCollection != null) {
			_local_1 = 0;
			while (_local_1 < this.m_textfieldCollection.length) {
				Animate.kill(this.m_textfieldCollection[_local_1]);
				_local_1++;
			}

		}

	}

	private function getAvailabilityAlpha():Number {
		return ((this.m_isAvailable) ? 1 : 0.5);
	}

	private function showTexts(_arg_1:Vector.<TextField>, _arg_2:Boolean = true):void {
		var _local_3:Number = 0;
		var _local_4:int;
		while (_local_4 < _arg_1.length) {
			if (((_arg_2) && (!(this.m_isInitialized)))) {
				_arg_1[_local_4].alpha = 0;
				this.startTextAnimation(_arg_1[_local_4], _local_3);
				_local_3 = (_local_3 + 0.05);
			} else {
				if (((_arg_1[_local_4] == this.m_view.tileHeader) || (_arg_1[_local_4] == this.m_view.tileTitle))) {
					_arg_1[_local_4].alpha = 1;
				} else {
					_arg_1[_local_4].alpha = this.getAvailabilityAlpha();
				}

			}

			_local_4++;
		}

	}

	private function startTextAnimation(_arg_1:TextField, _arg_2:Number):void {
		if (((_arg_1 == this.m_view.tileHeader) || (_arg_1 == this.m_view.tileTitle))) {
			Animate.to(_arg_1, 0.75, _arg_2, {"alpha": 1}, Animate.ExpoOut);
		} else {
			Animate.to(_arg_1, 0.75, _arg_2, {"alpha": this.getAvailabilityAlpha()}, Animate.ExpoOut);
		}

	}

	private function animateIcons(_arg_1:Vector.<MovieClip>):void {
		var _local_2:Number;
		var _local_3:int;
		while (_local_3 < _arg_1.length) {
			if (((!(m_isSelected)) && (!(this.m_isInitialized)))) {
				_local_2 = _arg_1[_local_3].icons.scaleX;
				_arg_1[_local_3].icons.scaleX = (_arg_1[_local_3].icons.scaleY = 0);
				Animate.from(_arg_1[_local_3].bg, 0.3, 0, {
					"scaleX": 0.2,
					"scaleY": 0.2
				}, Animate.ExpoOut);
				Animate.to(_arg_1[_local_3].icons, 0.3, 0.2, {
					"scaleX": _local_2,
					"scaleY": _local_2
				}, Animate.ExpoOut);
			}

			_local_3++;
		}

	}

	private function initImage(_arg_1:Object):void {
		_arg_1.completionValue = this.m_data.completionValue;
		this.m_locationImages = new LocationImage(_arg_1);
		this.m_locationImages.x = 16;
		this.m_locationImages.y = 295;
		this.m_view.tileContent.addChild(this.m_locationImages);
	}

	private function initStatisticBars(_arg_1:Object):void {
		_arg_1.completionValue = this.m_data.completionValue;
		_arg_1.isAvailable = this.m_isAvailable;
		this.removeStatisticBars();
		this.m_statBars = new StatisticBars(_arg_1);
		this.m_statBars.x = 16;
		this.m_statBars.y = 370;
		this.m_view.tileContent.addChild(this.m_statBars);
	}

	private function removeStatisticBars():void {
		if (this.m_statBars == null) {
			return;
		}

		this.m_view.tileContent.removeChild(this.m_statBars);
		this.m_statBars.destroy();
		this.m_statBars = null;
	}

	private function initOpportunityBar(_arg_1:Object):void {
		this.removeOpportunityBar();
		if ((((_arg_1 == null) || (_arg_1.total == null)) || (_arg_1.completed == null))) {
			return;
		}

		var _local_2:Number = _arg_1.total;
		if (_local_2 <= 0) {
			return;
		}

		var _local_3:Boolean = this.m_isAvailable;
		var _local_4:Number = _arg_1.completed;
		this.m_opportunityBarView = new StatisticBarSmallView();
		this.m_opportunityBarView.x = 425;
		this.m_opportunityBarView.y = 270;
		this.m_view.tileContent.addChild(this.m_opportunityBarView);
		this.m_opportunityBar = new StatisticBar(this.m_opportunityBarView, _local_3);
		this.m_opportunityBar.init(_arg_1.title, _local_4, _local_2);
		this.m_opportunityBar.show(0);
	}

	private function removeOpportunityBar():void {
		if (this.m_opportunityBar != null) {
			this.m_opportunityBar.destroy();
			this.m_opportunityBar = null;
		}

		if (this.m_opportunityBarView != null) {
			this.m_view.tileContent.removeChild(this.m_opportunityBarView);
			this.m_opportunityBarView = null;
		}

	}

	private function initMasteryLevelChart(_arg_1:Object):void {
		_arg_1.isAvailable = this.m_isAvailable;
		this.removeMasteryLevelChart();
		if (this.m_isMasteryAvailable) {
			this.m_masteryLevelChart = new MasteryLevelChart(_arg_1);
			this.m_masteryLevelChart.x = 548;
			this.m_masteryLevelChart.y = 460;
			this.m_view.tileContent.addChild(this.m_masteryLevelChart);
			this.m_view.tileContent.noMasteryTitle.text = "";
		} else {
			this.m_view.tileContent.noMasteryTitle.alpha = this.getAvailabilityAlpha();
			this.m_view.tileContent.noMasteryTitle.text = Localization.get("UI_MENU_PAGE_PROFILE_MASTERY_NOT_AVAILABLE");
			MenuUtils.setColor(this.m_view.tileContent.noMasteryTitle, MenuConstants.COLOR_GREY);
		}

	}

	private function removeMasteryLevelChart():void {
		if (this.m_masteryLevelChart == null) {
			return;
		}

		this.m_view.tileContent.removeChild(this.m_masteryLevelChart);
		this.m_masteryLevelChart.destroy();
		this.m_masteryLevelChart = null;
	}


}
}//package menu3.statistics

