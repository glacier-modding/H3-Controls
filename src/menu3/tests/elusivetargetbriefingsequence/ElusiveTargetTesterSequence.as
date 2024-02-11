// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.tests.elusivetargetbriefingsequence.ElusiveTargetTesterSequence

package menu3.tests.elusivetargetbriefingsequence {
import flash.display.Sprite;

import menu3.MenuImageLoader;
import menu3.basic.TextTickerUtil;

import common.menu.MenuConstants;
import common.Animate;

import flash.display.DisplayObjectContainer;

public dynamic class ElusiveTargetTesterSequence extends ElusiveTargetTesterSequenceBase {

	private var m_baseContainer:Sprite;
	private var m_containerForSequences:Sprite;
	private var m_sequenceContainer01:Sprite;
	private var m_sequenceContainer02:Sprite;
	private var m_containerForTextBlocks:Sprite;
	private var m_textBlockContainer01:Sprite;
	private var m_textBlockContainer02:Sprite;
	private var m_background:Sprite;
	private var m_testAlignmentGrid:Sprite;
	private var m_loader01:MenuImageLoader;
	private var m_loader02:MenuImageLoader;
	private var m_textTickerUtil:TextTickerUtil = new TextTickerUtil();
	private var m_sequencesArray:Array;
	private var m_sequenceContainerArray:Array;
	private var m_textBlockContainerArray:Array;
	private var m_isUnregistering:Boolean;

	public function ElusiveTargetTesterSequence(_arg_1:Object) {
		super(_arg_1);
		this.m_sequencesArray = [];
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		this.m_sequencesArray = _arg_1.elusiveContractSequence;
		var _local_2:Number = ((MenuConstants.BaseHeight - MenuConstants.ElusiveContractsBriefingHeight) / 2);
		this.m_background = new Sprite();
		this.m_background.name = "m_background";
		this.m_background.graphics.clear();
		this.m_background.graphics.beginFill(0x212121, 1);
		this.m_background.graphics.drawRect(-(MenuConstants.menuXOffset), (-(MenuConstants.menuYOffset) + _local_2), MenuConstants.BaseWidth, MenuConstants.ElusiveContractsBriefingHeight);
		this.m_background.graphics.endFill();
		addChild(this.m_background);
		this.m_baseContainer = new Sprite();
		this.m_baseContainer.name = "m_baseContainer";
		this.m_baseContainer.x = -(MenuConstants.menuXOffset);
		this.m_baseContainer.y = -(MenuConstants.menuYOffset);
		addChild(this.m_baseContainer);
		this.m_baseContainer.mask = this.m_background;
		this.m_testAlignmentGrid = new Sprite();
		this.m_testAlignmentGrid.name = "m_testAlignmentGrid";
		this.m_testAlignmentGrid.x = -(MenuConstants.menuXOffset);
		this.m_testAlignmentGrid.y = -(MenuConstants.menuYOffset);
		this.m_testAlignmentGrid.graphics.clear();
		this.m_testAlignmentGrid.graphics.lineStyle(1, 0xEBEBEB, 0.1);
		this.m_testAlignmentGrid.graphics.moveTo(0, 0);
		this.m_testAlignmentGrid.graphics.lineTo(0, MenuConstants.BaseHeight);
		this.m_testAlignmentGrid.graphics.moveTo((m_unitWidth * 1), 0);
		this.m_testAlignmentGrid.graphics.lineTo((m_unitWidth * 1), MenuConstants.BaseHeight);
		this.m_testAlignmentGrid.graphics.moveTo((m_unitWidth * 2), 0);
		this.m_testAlignmentGrid.graphics.lineTo((m_unitWidth * 2), MenuConstants.BaseHeight);
		this.m_testAlignmentGrid.graphics.moveTo((m_unitWidth * 3), 0);
		this.m_testAlignmentGrid.graphics.lineTo((m_unitWidth * 3), MenuConstants.BaseHeight);
		this.m_testAlignmentGrid.graphics.moveTo((m_unitWidth * 4), 0);
		this.m_testAlignmentGrid.graphics.lineTo((m_unitWidth * 4), MenuConstants.BaseHeight);
		this.m_testAlignmentGrid.graphics.moveTo((m_unitWidth * 5), 0);
		this.m_testAlignmentGrid.graphics.lineTo((m_unitWidth * 5), MenuConstants.BaseHeight);
		this.m_testAlignmentGrid.graphics.moveTo((m_unitWidth * 6), 0);
		this.m_testAlignmentGrid.graphics.lineTo((m_unitWidth * 6), MenuConstants.BaseHeight);
		this.m_testAlignmentGrid.graphics.moveTo((m_unitWidth * 7), 0);
		this.m_testAlignmentGrid.graphics.lineTo((m_unitWidth * 7), MenuConstants.BaseHeight);
		this.m_testAlignmentGrid.graphics.moveTo((m_unitWidth * 8), 0);
		this.m_testAlignmentGrid.graphics.lineTo((m_unitWidth * 8), MenuConstants.BaseHeight);
		this.m_testAlignmentGrid.graphics.moveTo((m_unitWidth * 9), 0);
		this.m_testAlignmentGrid.graphics.lineTo((m_unitWidth * 9), MenuConstants.BaseHeight);
		this.m_testAlignmentGrid.graphics.moveTo((m_unitWidth * 10), 0);
		this.m_testAlignmentGrid.graphics.lineTo((m_unitWidth * 10), MenuConstants.BaseHeight);
		this.m_testAlignmentGrid.graphics.moveTo(0, 0);
		this.m_testAlignmentGrid.graphics.lineTo(MenuConstants.BaseWidth, (m_unitHeight * 0));
		this.m_testAlignmentGrid.graphics.moveTo(0, (m_unitHeight * 1));
		this.m_testAlignmentGrid.graphics.lineTo(MenuConstants.BaseWidth, (m_unitHeight * 1));
		this.m_testAlignmentGrid.graphics.moveTo(0, (m_unitHeight * 2));
		this.m_testAlignmentGrid.graphics.lineTo(MenuConstants.BaseWidth, (m_unitHeight * 2));
		this.m_testAlignmentGrid.graphics.moveTo(0, (m_unitHeight * 3));
		this.m_testAlignmentGrid.graphics.lineTo(MenuConstants.BaseWidth, (m_unitHeight * 3));
		this.m_testAlignmentGrid.graphics.moveTo(0, (m_unitHeight * 4));
		this.m_testAlignmentGrid.graphics.lineTo(MenuConstants.BaseWidth, (m_unitHeight * 4));
		this.m_testAlignmentGrid.graphics.moveTo(0, (m_unitHeight * 5));
		this.m_testAlignmentGrid.graphics.lineTo(MenuConstants.BaseWidth, (m_unitHeight * 5));
		this.m_testAlignmentGrid.graphics.moveTo(0, (m_unitHeight * 6));
		this.m_testAlignmentGrid.graphics.lineTo(MenuConstants.BaseWidth, (m_unitHeight * 6));
		addChild(this.m_testAlignmentGrid);
		this.m_containerForSequences = new Sprite();
		this.m_containerForSequences.name = "m_containerForSequences";
		this.m_baseContainer.addChild(this.m_containerForSequences);
		this.m_sequenceContainer01 = new Sprite();
		this.m_sequenceContainer01.name = "m_sequenceContainer01";
		this.m_containerForSequences.addChild(this.m_sequenceContainer01);
		this.m_sequenceContainer02 = new Sprite();
		this.m_sequenceContainer02.name = "m_sequenceContainer02";
		this.m_containerForSequences.addChild(this.m_sequenceContainer02);
		this.m_sequenceContainerArray = [this.m_sequenceContainer02, this.m_sequenceContainer01];
		this.m_containerForTextBlocks = new Sprite();
		this.m_containerForTextBlocks.name = "m_containerForTextBlocks";
		this.m_baseContainer.addChild(this.m_containerForTextBlocks);
		this.m_textBlockContainer01 = new Sprite();
		this.m_textBlockContainer01.name = "m_textBlockContainer01";
		this.m_containerForTextBlocks.addChild(this.m_textBlockContainer01);
		this.m_textBlockContainer02 = new Sprite();
		this.m_textBlockContainer02.name = "m_textBlockContainer02";
		this.m_containerForTextBlocks.addChild(this.m_textBlockContainer02);
		this.m_textBlockContainerArray = [this.m_textBlockContainer02, this.m_textBlockContainer01];
		this.showSequencePart();
	}

	private function showSequencePart():void {
		var _local_1:Object;
		trace(">>>>>>>>>>>>>>>> ElusiveTargetTesterSequence | showSequencePart");
		if (!this.m_isUnregistering) {
			this.cleanUpOldContainers(this.m_sequenceContainerArray[0], this.m_textBlockContainerArray[0]);
			this.m_sequenceContainerArray.reverse();
			this.m_containerForSequences.setChildIndex(this.m_sequenceContainerArray[0], (this.m_containerForSequences.numChildren - 1));
			this.m_sequenceContainerArray[0].alpha = 0;
			this.m_textBlockContainerArray.reverse();
			this.m_containerForTextBlocks.setChildIndex(this.m_textBlockContainerArray[0], (this.m_containerForTextBlocks.numChildren - 1));
			if (this.m_sequencesArray.length <= 0) {
				return;
			}

			_local_1 = this.m_sequencesArray.shift();
			this.goSequence(_local_1, this.m_sequenceContainerArray[0], this.m_textBlockContainerArray[0]);
		}

	}

	private function goSequence(_arg_1:Object, _arg_2:Sprite, _arg_3:Sprite):void {
		var _local_4:Sprite;
		var _local_5:Sprite;
		var _local_6:int;
		var _local_7:Sprite;
		if (_arg_1.image) {
			_local_4 = new Sprite();
			_local_4.name = "imageContainer";
			_local_4.graphics.clear();
			_local_4.graphics.beginFill(0xFF00, 1);
			_local_4.graphics.drawRect(0, 0, MenuConstants.BaseWidth, MenuConstants.BaseHeight);
			_local_4.graphics.endFill();
			_arg_2.addChild(_local_4);
			this.loadImage(_arg_1.image, _arg_1.sequence.totalduration);
		}

		if (_arg_1.redoverlay) {
			_local_5 = new Sprite();
			_local_5.name = "redOverlayContainer";
			_arg_2.addChild(_local_5);
			createRedOverlay(_arg_1.redoverlay, _arg_1.sequence.totalduration, _local_5);
		}

		if (_arg_1.textblocks) {
			_local_6 = 0;
			while (_local_6 < _arg_1.textblocks.length) {
				_local_7 = new Sprite();
				_local_7.name = ("textFieldContainer_" + _local_6);
				_arg_3.addChild(_local_7);
				insertTextBlock(_arg_1.textblocks[_local_6], _arg_1.sequence.totalduration, _local_7);
				_local_6++;
			}

		}

		animateSequenceContainer(_arg_1, _arg_2);
		Animate.delay(this.m_baseContainer, _arg_1.sequence.totalduration, this.showSequencePart, null);
	}

	private function loadImage(data:Object, sequenceDuration:Number):void {
		var daImageContainer:DisplayObjectContainer;
		var animateImageDuration:Number;
		if (this.m_sequenceContainerArray[0].getChildByName("imageContainer")) {
			daImageContainer = (this.m_sequenceContainerArray[0].getChildByName("imageContainer") as DisplayObjectContainer);
		} else {
			return;
		}

		if (this.m_sequenceContainerArray[0].name == "m_sequenceContainer01") {
			if (this.m_loader01 != null) {
				this.m_loader01.cancelIfLoading();
				daImageContainer.removeChild(this.m_loader01);
				this.m_loader01 = null;
			}

			this.m_loader01 = new MenuImageLoader();
			daImageContainer.addChild(this.m_loader01);
			this.m_loader01.center = false;
			this.m_loader01.loadImage(data.path, function ():void {
				daImageContainer.cacheAsBitmap = true;
				if (data.animateimage) {
					animateImageDuration = ((data.animateimage.duration) ? data.animateimage.duration : sequenceDuration);
					animateImageContainer(daImageContainer, daImageContainer.width, daImageContainer.height, animateImageDuration, data.animateimage.startpos, data.animateimage.endpos, data.animateimage.startscale, data.animateimage.endscale, data.animateimage.easing);
				}

			});
		} else {
			if (this.m_sequenceContainerArray[0].name == "m_sequenceContainer02") {
				if (this.m_loader02 != null) {
					this.m_loader02.cancelIfLoading();
					daImageContainer.removeChild(this.m_loader02);
					this.m_loader02 = null;
				}

				this.m_loader02 = new MenuImageLoader();
				daImageContainer.addChild(this.m_loader02);
				this.m_loader02.center = false;
				this.m_loader02.loadImage(data.path, function ():void {
					daImageContainer.cacheAsBitmap = true;
					if (data.animateimage) {
						animateImageDuration = ((data.animateimage.duration) ? data.animateimage.duration : sequenceDuration);
						animateImageContainer(daImageContainer, daImageContainer.width, daImageContainer.height, animateImageDuration, data.animateimage.startpos, data.animateimage.endpos, data.animateimage.startscale, data.animateimage.endscale, data.animateimage.easing);
					}

				});
			}

		}

	}

	override public function getView():Sprite {
		return (this.m_background);
	}

	private function cleanUpOldContainers(oldSequenceContainer:Sprite, oldTextBlockContainer:Sprite):void {
		trace("XXXXXXXXXXXXX ElusiveTargetTesterSequence | cleanUpOldContainers");
		Animate.kill(this);
		trace("XXXXXX ElusiveTargetTesterSequence | cleanUpOldContainers | Animate.kill(this)");
		Animate.kill(this.m_baseContainer);
		trace("XXXXXX ElusiveTargetTesterSequence | cleanUpOldContainers | Animate.kill(m_baseContainer)");
		Animate.delay(this, 2, function ():void {
			delayRemoveChildrenFromOldContainers(oldSequenceContainer, oldTextBlockContainer);
		});
	}

	private function delayRemoveChildrenFromOldContainers(_arg_1:Sprite, _arg_2:Sprite):void {
		var _local_3:DisplayObjectContainer;
		var _local_4:*;
		var _local_5:*;
		var _local_6:*;
		var _local_7:*;
		trace("XXX ElusiveTargetTesterSequence | delayRemoveChildrenFromOldContainers");
		if (!this.m_isUnregistering) {
			Animate.kill(this);
			trace("XXX ElusiveTargetTesterSequence | delayRemoveChildrenFromOldContainers | Animate.kill(this)");
			if (_arg_1.getChildByName("imageContainer")) {
				_local_3 = (_arg_1.getChildByName("imageContainer") as DisplayObjectContainer);
				if (_arg_1.name == "m_sequenceContainer01") {
					trace((("XXX ElusiveTargetTesterSequence | delayRemoveChildrenFromOldContainers | oldSequenceContainer.name: " + _arg_1.name) + " | oldImageContainer.removeChild(m_loader01)"));
					_local_3.removeChild(this.m_loader01);
				} else {
					if (_arg_1.name == "m_sequenceContainer02") {
						trace((("XXX ElusiveTargetTesterSequence | delayRemoveChildrenFromOldContainers | oldSequenceContainer.name: " + _arg_1.name) + " | oldImageContainer.removeChild(m_loader02)"));
						_local_3.removeChild(this.m_loader02);
					}

				}

			}

			while (_arg_1.numChildren > 0) {
				_local_4 = _arg_1.getChildAt(0);
				while (_local_4.numChildren > 0) {
					_local_5 = _local_4.getChildAt(0);
					trace((((("XXX ElusiveTargetTesterSequence | delayRemoveChildrenFromOldContainers | oldSequenceContainer.name: " + _arg_1.name) + " | remove & Animate.complete(") + _local_5.name) + ")"));
					Animate.complete(_local_5);
					_local_4.removeChild(_local_5);
				}

				trace((((("XXX ElusiveTargetTesterSequence | delayRemoveChildrenFromOldContainers | oldSequenceContainer.name: " + _arg_1.name) + " | remove & Animate.complete(") + _local_4.name) + ")"));
				Animate.kill(_local_4);
				_arg_1.removeChild(_local_4);
			}

			while (_arg_2.numChildren > 0) {
				_local_6 = _arg_2.getChildAt(0);
				while (_local_6.numChildren > 0) {
					_local_7 = _local_6.getChildAt(0);
					trace((((("XXX ElusiveTargetTesterSequence | delayRemoveChildrenFromOldContainers | oldTextBlockContainer.name: " + _arg_2.name) + " | remove & Animate.complete(") + _local_7.name) + ")"));
					Animate.complete(_local_7);
					_local_6.removeChild(_local_7);
				}

				trace((((("XXX ElusiveTargetTesterSequence | delayRemoveChildrenFromOldContainers | oldTextBlockContainer.name: " + _arg_2.name) + " | remove & Animate.complete(") + _local_6.name) + ")"));
				Animate.kill(_local_6);
				_arg_2.removeChild(_local_6);
			}

		}

	}

	override public function onUnregister():void {
		var _local_1:DisplayObjectContainer;
		var _local_2:*;
		var _local_3:*;
		var _local_4:*;
		var _local_5:*;
		this.m_isUnregistering = true;
		super.onUnregister();
		Animate.kill(this);
		Animate.kill(this.m_baseContainer);
		Animate.kill(this.m_sequenceContainer01);
		Animate.kill(this.m_sequenceContainer02);
		if (this.m_loader01) {
			this.m_loader01.cancelIfLoading();
			if (this.m_sequenceContainerArray[0].getChildByName("imageContainer")) {
				_local_1 = (this.m_sequenceContainerArray[0].getChildByName("imageContainer") as DisplayObjectContainer);
				_local_1.removeChild(this.m_loader01);
				trace(("XXX ElusiveTargetTesterSequence | onUnregister | removing m_loader01 from: " + _local_1.name));
			}

			this.m_loader01 = null;
		}

		if (this.m_loader02) {
			this.m_loader02.cancelIfLoading();
			if (this.m_sequenceContainerArray[0].getChildByName("imageContainer")) {
				_local_1 = (this.m_sequenceContainerArray[0].getChildByName("imageContainer") as DisplayObjectContainer);
				_local_1.removeChild(this.m_loader02);
				trace(("XXX ElusiveTargetTesterSequence | onUnregister | removing m_loader02 from: " + _local_1.name));
			}

			this.m_loader02 = null;
		}

		while (this.m_baseContainer.numChildren > 0) {
			_local_2 = this.m_baseContainer.getChildAt(0);
			while (_local_2.numChildren > 0) {
				_local_3 = _local_2.getChildAt(0);
				while (_local_3.numChildren > 0) {
					_local_4 = _local_3.getChildAt(0);
					while (_local_4.numChildren > 0) {
						_local_5 = _local_4.getChildAt(0);
						trace(((((((("XXX ElusiveTargetTesterSequence | onUnregister | remove/kill: m_baseContiainer." + _local_2.name) + ".") + _local_3.name) + ".") + _local_4.name) + ".") + _local_5.name));
						Animate.kill(_local_5);
						_local_4.removeChild(_local_5);
					}

					trace(((((("XXX ElusiveTargetTesterSequence | onUnregister | remove/kill: m_baseContiainer." + _local_2.name) + ".") + _local_3.name) + ".") + _local_4.name));
					Animate.kill(_local_4);
					_local_3.removeChild(_local_4);
				}

				trace(((("XXX ElusiveTargetTesterSequence | onUnregister | remove/kill: m_baseContiainer." + _local_2.name) + ".") + _local_3.name));
				Animate.kill(_local_3);
				_local_2.removeChild(_local_3);
			}

			trace(("XXX ElusiveTargetTesterSequence | onUnregister | remove/kill: m_baseContiainer." + _local_2.name));
			Animate.kill(_local_2);
			this.m_baseContainer.removeChild(_local_2);
		}

		trace("XXX ElusiveTargetTesterSequence | onUnregister | remove/kill: m_baseContiainer");
		removeChild(this.m_baseContainer);
		this.m_sequencesArray = [];
		if (this.m_background) {
			removeChild(this.m_background);
			this.m_background = null;
		}

		if (this.m_testAlignmentGrid) {
			removeChild(this.m_testAlignmentGrid);
			this.m_testAlignmentGrid = null;
		}

	}


}
}//package menu3.tests.elusivetargetbriefingsequence

