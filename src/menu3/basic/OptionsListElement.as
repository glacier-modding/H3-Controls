package menu3.basic
{
	
	public dynamic class OptionsListElement extends OptionsListElementBase
	{
		
		public function OptionsListElement(param1:Object)
		{
			super(param1);
		}
		
		override protected function createView():*
		{
			var _loc1_:* = new OptionsListElementView();
			_loc1_.tileSelect.alpha = 0;
			_loc1_.tileDarkBg.alpha = 0;
			_loc1_.tileBg.alpha = 0;
			return _loc1_;
		}
	}
}
