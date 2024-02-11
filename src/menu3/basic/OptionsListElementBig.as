// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.OptionsListElementBig

package menu3.basic {
public dynamic class OptionsListElementBig extends OptionsListElementBase {

	public function OptionsListElementBig(_arg_1:Object) {
		super(_arg_1);
	}

	override protected function createView():* {
		var _local_1:* = new OptionsListElementBigView();
		_local_1.tileSelect.alpha = 0;
		_local_1.tileDarkBg.alpha = 0;
		_local_1.tileBg.alpha = 0;
		return (_local_1);
	}


}
}//package menu3.basic

