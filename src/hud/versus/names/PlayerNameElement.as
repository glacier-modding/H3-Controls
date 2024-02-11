// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.versus.names.PlayerNameElement

package hud.versus.names {
public class PlayerNameElement extends BaseNameElement {

	public function PlayerNameElement() {
		m_view = new PlayerNameElementView();
		addChild(m_view);
	}

	public function onSetData(_arg_1:Object):void {
	}


}
}//package hud.versus.names

