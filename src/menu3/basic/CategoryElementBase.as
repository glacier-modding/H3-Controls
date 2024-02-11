// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.CategoryElementBase

package menu3.basic {
import menu3.containers.CollapsableListContainer;

import flash.display.Sprite;

public dynamic class CategoryElementBase extends CollapsableListContainer implements ICategoryElement {

	protected const STATE_DEFAULT:int = 0;
	protected const STATE_SELECTED:int = 1;
	protected const STATE_HOVER:int = 2;

	protected var m_isCategorySelected:Boolean = false;

	public function CategoryElementBase(_arg_1:Object) {
		super(_arg_1);
	}

	override public function addChild2(_arg_1:Sprite, _arg_2:int = -1):void {
		super.addChild2(_arg_1, _arg_2);
		if (getNodeProp(_arg_1, "col") === undefined) {
			if (((!(this.getData().direction == "horizontal")) && (!(this.getData().direction == "horizontalWrap")))) {
				_arg_1.x = 32;
			}

		}

	}

	public function enableSpacer():void {
	}

	public function disableSpacer():void {
	}

	override protected function handleSelectionChange():void {
	}

	public function setCategorySelected(_arg_1:Boolean):void {
		this.m_isCategorySelected = _arg_1;
		var _local_2:int = ((_arg_1) ? this.STATE_SELECTED : this.STATE_DEFAULT);
		this.setSelectedAnimationState(_local_2);
		if (_arg_1) {
			bubbleEvent("categorySelected", this);
		}

	}

	public function setItemHover(_arg_1:Boolean):void {
		if (this.m_isCategorySelected) {
			return;
		}

		var _local_2:int = ((_arg_1) ? this.STATE_HOVER : this.STATE_DEFAULT);
		this.setSelectedAnimationState(_local_2);
	}

	protected function setSelectedAnimationState(_arg_1:int):void {
	}

	override public function setItemSelected(_arg_1:Boolean):void {
		super.setItemSelected(_arg_1);
		if (getNodeProp(this, "ismenusystem") != true) {
			return;
		}

		this.m_isCategorySelected = _arg_1;
		var _local_2:int = ((_arg_1) ? this.STATE_SELECTED : this.STATE_DEFAULT);
		this.setSelectedAnimationState(_local_2);
	}


}
}//package menu3.basic

