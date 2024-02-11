// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.modal.ModalDialogImageWithText

package menu3.modal {
import flash.text.TextField;
import flash.display.Sprite;

import menu3.MenuImageLoader;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Log;

import flash.display.Bitmap;

public class ModalDialogImageWithText extends ModalDialogFrameInformation {

	public static const FRAME_REST_HEIGHT:Number = 160;
	public static const FRAME_HEIGHT_MIN:Number = 260;
	public static const FRAME_HEIGHT_MAX:Number = 768.223;
	public static const FRAME_WIDTH:Number = 870;

	protected var m_viewTitle:TextField;
	protected var m_viewDescription:TextField;
	protected var m_viewText:TextField;
	protected var m_viewFrame:Sprite;
	protected var m_viewImage:Sprite;
	private var m_imageLoader:MenuImageLoader;
	private var m_imageHolder:Sprite;
	private var m_view:ModalDialogGenericView;
	private var m_imageTextView:ModalDialogContentImageWithText;

	public function ModalDialogImageWithText(_arg_1:Object) {
		_arg_1.dialogWidth = ModalDialogImageWithText.FRAME_WIDTH;
		_arg_1.dialogHeight = ModalDialogImageWithText.FRAME_HEIGHT_MIN;
		super(_arg_1);
		this.createView();
	}

	protected function createView():void {
		this.m_view = new ModalDialogGenericView();
		this.m_viewTitle = this.m_view.title;
		this.m_viewFrame = this.m_view.bg;
		MenuUtils.setColor(this.m_viewFrame, MenuConstants.COLOR_MENU_SOLID_BACKGROUND, true, 1);
		this.m_imageTextView = new ModalDialogContentImageWithText();
		this.m_viewDescription = this.m_imageTextView.description;
		this.m_viewText = this.m_imageTextView.text;
		this.m_viewImage = this.m_imageTextView.image;
		MenuUtils.setColor(this.m_viewImage, MenuConstants.COLOR_MENU_SOLID_BACKGROUND, true, 1);
		this.m_viewDescription.autoSize = "left";
		this.m_viewDescription.text = "";
		this.m_viewText.autoSize = "left";
		this.m_viewText.text = "";
		var _local_1:Number = (m_dialogWidth - this.m_viewFrame.width);
		this.m_viewFrame.width = m_dialogWidth;
		addChild(this.m_view);
		this.m_imageTextView.x = 0;
		this.m_imageTextView.y = this.m_view.description.y;
		this.m_view.addChild(this.m_imageTextView);
	}

	override public function onSetData(_arg_1:Object):void {
		var _local_2:Number = ((_arg_1.hasOwnProperty("frameheightmax")) ? _arg_1.frameheightmax : FRAME_HEIGHT_MAX);
		var _local_3:Number = ((_arg_1.hasOwnProperty("frameheightmin")) ? _arg_1.frameheightmin : FRAME_HEIGHT_MIN);
		var _local_4:Number = this.m_viewDescription.x;
		var _local_5:Number = this.m_viewDescription.y;
		super.onSetData(_arg_1);
		setupTitle(this.m_viewTitle, _arg_1);
		MenuUtils.setupText(this.m_viewDescription, _arg_1.description, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		setupText(this.m_viewText, _arg_1.text);
		this.loadImage(_arg_1.image);
		var _local_6:Number = (Math.ceil(this.m_imageTextView.height) + FRAME_REST_HEIGHT);
		m_dialogHeight = updateDialogHeight(_local_6, _local_3, _local_2);
		if (_local_6 > _local_2) {
			Log.xwarning(Log.ChannelModal, "Content Height is capped by frameHeightMax!");
		}
		;
		this.m_viewFrame.height = m_dialogHeight;
	}

	override public function hide():void {
		this.cleanupImage();
		super.hide();
	}

	private function loadImage(imagePath:String):void {
		var wantedWidth:Number;
		var wantedHeight:Number;
		var wantedX:Number;
		var wantedY:Number;
		this.cleanupImage();
		wantedWidth = this.m_viewImage.width;
		wantedHeight = this.m_viewImage.height;
		wantedX = (this.m_viewImage.x - (wantedWidth / 2));
		wantedY = (this.m_viewImage.y - (wantedHeight / 2));
		this.m_imageLoader = new MenuImageLoader();
		this.m_imageLoader.center = false;
		this.m_imageLoader.loadImage(imagePath, function ():void {
			var _local_1:Bitmap = m_imageLoader.getImage();
			m_imageLoader = null;
			var _local_2:Number = (wantedWidth / _local_1.width);
			var _local_3:Number = wantedWidth;
			var _local_4:Number = (_local_1.height * _local_2);
			_local_1.width = _local_3;
			_local_1.height = _local_4;
			m_imageHolder = new Sprite();
			var _local_5:MaskView = new MaskView();
			_local_5.width = wantedWidth;
			_local_5.height = wantedHeight;
			m_imageHolder.addChild(_local_5);
			m_imageHolder.mask = _local_5;
			m_imageHolder.addChild(_local_1);
			m_imageHolder.x = wantedX;
			m_imageHolder.y = wantedY;
			var _local_6:int = m_imageTextView.getChildIndex(m_viewImage);
			m_imageTextView.addChildAt(m_imageHolder, (_local_6 + 1));
		});
	}

	private function cleanupImage():void {
		if (this.m_imageLoader != null) {
			this.m_imageLoader.cancelIfLoading();
			this.m_imageLoader = null;
		}
		;
		if (this.m_imageHolder != null) {
			this.m_imageTextView.removeChild(this.m_imageHolder);
			this.m_imageHolder = null;
		}
		;
	}


}
}//package menu3.modal

