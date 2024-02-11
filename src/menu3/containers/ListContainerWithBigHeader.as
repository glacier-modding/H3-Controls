// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.containers.ListContainerWithBigHeader

package menu3.containers {
import common.menu.textTicker;
import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Animate;

public dynamic class ListContainerWithBigHeader extends ListContainerWithHeader {

	private const STATE_UNDEFINED:int = -1;
	private const STATE_NORMAL:int = 0;
	private const STATE_SELECTED:int = 1;

	private var m_currentState:int = -1;
	private var m_originalViewPositionX:Number = 0;
	private var m_originalViewPositionRightX:Number = 0;
	private var m_textObj:Object = {};
	private var m_textTicker:textTicker;

	public function ListContainerWithBigHeader(_arg_1:Object) {
		super(_arg_1);
		if (_arg_1.headlinetitle) {
			if (((m_direction == "vertical") && (!(m_headLineVerticalView == null)))) {
				MenuUtils.setupText(m_headLineVerticalView.title, _arg_1.headlinetitle, 38, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
				MenuUtils.setupText(m_headLineVerticalView.detail, _arg_1.headlinedetail, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
				this.m_textObj.detail = m_headLineVerticalView.detail.htmlText;
				MenuUtils.truncateTextfield(m_headLineVerticalView.detail, 1);
				this.m_originalViewPositionX = m_headLineVerticalView.title.x;
				this.m_originalViewPositionRightX = (m_headLineVerticalView.title.x + m_headLineVerticalView.title.width);
			}

		}

		this.updateStates();
	}

	override protected function createHeadLineVerticalView():* {
		return (new ListContainerHeadlineBigVerticalView());
	}

	override protected function handleSelectionChange():void {
		super.handleSelectionChange();
		this.updateStates();
	}

	override protected function handleChildSelectionChange():void {
		super.handleChildSelectionChange();
		this.updateStates();
	}

	private function updateStates():void {
		if ((((m_isChildSelected) || (m_isGroupSelected)) || (m_isSelected))) {
			this.setState(this.STATE_SELECTED);
		} else {
			this.setState(this.STATE_NORMAL);
		}

	}

	private function setState(_arg_1:int):void {
		if (_arg_1 != this.m_currentState) {
			this.m_currentState = _arg_1;
			this.updateVisualState(this.m_currentState);
		}

	}

	private function updateVisualState(_arg_1:int):void {
		var _local_2:Number;
		Animate.kill(this);
		Animate.kill(m_headLineVerticalView.title);
		Animate.kill(m_headLineVerticalView.detail);
		if (_arg_1 == this.STATE_SELECTED) {
			Animate.to(this, 0.1, 0, {"alpha": 1}, Animate.Linear);
			m_headLineVerticalView.title.scaleX = 1;
			m_headLineVerticalView.title.scaleY = 1;
			m_headLineVerticalView.title.x = this.m_originalViewPositionX;
			Animate.to(m_headLineVerticalView.detail, 0.1, 0.15, {"alpha": 1}, Animate.Linear);
			this.callTextTicker(true);
		} else {
			Animate.to(this, 0.1, 0, {"alpha": 0.5}, Animate.Linear);
			m_headLineVerticalView.title.scaleX = 0.65;
			m_headLineVerticalView.title.scaleY = 0.65;
			_local_2 = (m_headLineVerticalView.title.x + m_headLineVerticalView.title.width);
			m_headLineVerticalView.title.x = (m_headLineVerticalView.title.x + (this.m_originalViewPositionRightX - _local_2));
			m_headLineVerticalView.detail.alpha = 0;
			this.callTextTicker(false);
		}

	}

	protected function callTextTicker(_arg_1:Boolean):void {
		if (!this.m_textTicker) {
			this.m_textTicker = new textTicker();
		}

		if (_arg_1) {
			this.m_textTicker.startTextTickerHtml(m_headLineVerticalView.detail, this.m_textObj.detail, null, 2000);
		} else {
			this.m_textTicker.stopTextTicker(m_headLineVerticalView.detail, this.m_textObj.detail);
			MenuUtils.truncateTextfield(m_headLineVerticalView.detail, 1);
		}

	}


}
}//package menu3.containers

