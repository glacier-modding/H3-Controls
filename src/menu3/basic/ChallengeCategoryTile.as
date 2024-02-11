// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.ChallengeCategoryTile

package menu3.basic {
import menu3.MenuElementTileBase;
import menu3.MenuImageLoader;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

import flash.display.Sprite;

import common.Animate;

public dynamic class ChallengeCategoryTile extends MenuElementTileBase {

	private const m_iconScale:Number = 0.8;
	private const m_iconPositionX:Number = 32;
	private const m_iconPositionY:Number = 495;

	private var m_view:ChallengeCategoryTileView;
	private var m_loader:MenuImageLoader;
	private var m_iconSprite:iconsAll40x40View = null;

	public function ChallengeCategoryTile(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new ChallengeCategoryTileView();
		MenuUtils.setColorFilter(this.m_view.image);
		this.m_view.tileSelect.alpha = 0;
		this.m_view.tileSelectPulsate.alpha = 0;
		this.m_view.tileBg.alpha = 0;
		this.m_view.tileDarkBg.alpha = 0.3;
		addChild(this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		MenuUtils.setupIcon(this.m_view.tileIcon, _arg_1.icon, MenuConstants.COLOR_WHITE, true, true, MenuConstants.COLOR_BLACK, 0.15);
		this.setupTextFields(_arg_1.title, _arg_1.totalcount, _arg_1.totalcompleted);
		this.changeTextColor(MenuConstants.COLOR_WHITE);
		if (_arg_1.image) {
			this.loadImage(_arg_1.image);
		}

		var _local_2:int = int(_arg_1.totalcount);
		var _local_3:int = int(_arg_1.totalcompleted);
		if (_local_2 == _local_3) {
			this.m_iconSprite = new iconsAll40x40View();
			this.m_iconSprite.x = this.m_iconPositionX;
			this.m_iconSprite.y = this.m_iconPositionY;
			this.m_iconSprite.scaleX = (this.m_iconSprite.scaleY = this.m_iconScale);
			MenuUtils.setupIcon(this.m_iconSprite, "check", MenuConstants.COLOR_GREY_DARK, false, true, MenuConstants.COLOR_WHITE);
			addChild(this.m_iconSprite);
		}

	}

	override public function onUnregister():void {
		if (this.m_view) {
			this.killAnimations();
			if (this.m_loader != null) {
				this.m_loader.cancelIfLoading();
				this.m_view.image.removeChild(this.m_loader);
				this.m_loader = null;
			}

			if (this.m_iconSprite) {
				removeChild(this.m_iconSprite);
				this.m_iconSprite = null;
			}

			removeChild(this.m_view);
			this.m_view = null;
		}

		super.onUnregister();
	}

	override public function getView():Sprite {
		return (this.m_view.tileBg);
	}

	public function setSelectedState(_arg_1:Boolean):void {
		Animate.complete(this.m_view.tileSelect);
		MenuUtils.pulsate(this.m_view.tileSelectPulsate, false);
		if (_arg_1) {
			MenuUtils.setColorFilter(this.m_view.image, "selected");
			Animate.legacyTo(this.m_view.tileSelect, MenuConstants.HiliteTime, {"alpha": 1}, Animate.Linear);
			MenuUtils.pulsate(this.m_view.tileSelectPulsate, true);
		} else {
			MenuUtils.setColorFilter(this.m_view.image);
			this.m_view.tileSelect.alpha = 0;
			MenuUtils.pulsate(this.m_view.tileSelectPulsate, false);
		}

	}

	override protected function handleSelectionChange():void {
		this.setSelectedState(m_isSelected);
	}

	private function setupTextFields(_arg_1:String, _arg_2:String, _arg_3:String):void {
		var _local_4:* = (((("<font size='28' >" + _arg_3) + "</font><font size='16'>/") + _arg_2) + "</font>");
		MenuUtils.setupText(this.m_view.completionIndicator.header, _local_4, 28, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_view.title, _arg_1, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
		MenuUtils.truncateTextfield(this.m_view.title, 1);
	}

	private function changeTextColor(_arg_1:uint):void {
		this.m_view.title.textColor = _arg_1;
	}

	private function loadImage(imagePath:String):void {
		if (this.m_loader != null) {
			this.m_loader.cancelIfLoading();
			this.m_view.image.removeChild(this.m_loader);
			this.m_loader = null;
		}

		this.m_loader = new MenuImageLoader();
		this.m_view.image.addChild(this.m_loader);
		this.m_loader.center = true;
		this.m_loader.loadImage(imagePath, function ():void {
			Animate.legacyTo(m_view.tileDarkBg, 0.3, {"alpha": 0}, Animate.Linear);
			MenuUtils.trySetCacheAsBitmap(m_view.image, true);
			m_view.image.height = MenuConstants.MenuTileLargeHeight;
			m_view.image.scaleX = m_view.image.scaleY;
			if (m_view.image.width < MenuConstants.MenuTileTallWidth) {
				m_view.image.width = MenuConstants.MenuTileTallWidth;
				m_view.image.scaleY = m_view.image.scaleX;
			}

		});
	}

	private function killAnimations():void {
		Animate.kill(this.m_view.tileSelect);
		MenuUtils.pulsate(this.m_view.tileSelectPulsate, false);
		Animate.kill(this.m_view.tileDarkBg);
	}

	private function completeAnimations():void {
		Animate.complete(this.m_view.tileSelect);
		MenuUtils.pulsate(this.m_view.tileSelectPulsate, false);
		Animate.complete(this.m_view.tileDarkBg);
	}


}
}//package menu3.basic

