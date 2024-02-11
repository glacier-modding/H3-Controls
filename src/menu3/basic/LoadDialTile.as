// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.LoadDialTile

package menu3.basic {
import menu3.MenuElementBase;

public dynamic class LoadDialTile extends MenuElementBase {

	private var m_loadDialView:loadDialView = new loadDialView();

	public function LoadDialTile(_arg_1:Object) {
		super(_arg_1);
		this.m_loadDialView.scaleX = 2;
		this.m_loadDialView.scaleY = 2;
		addChild(this.m_loadDialView);
		this.m_loadDialView.value.play();
	}

	override public function onUnregister():void {
		this.m_loadDialView.value.stop();
		removeChild(this.m_loadDialView);
		this.m_loadDialView = null;
	}


}
}//package menu3.basic

