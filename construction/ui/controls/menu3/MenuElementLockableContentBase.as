package menu3
{
	import common.Animate;
	import common.menu.MenuConstants;
	import menu3.indicator.IIndicator;
	
	public dynamic class MenuElementLockableContentBase extends MenuElementAvailabilityBase
	{
		
		public function MenuElementLockableContentBase(param1:Object)
		{
			super(param1);
		}
		
		override protected function handleSelectionChange():void
		{
			var _loc2_:* = false;
			super.handleSelectionChange();
			if (m_infoIndicator == null)
			{
				return;
			}
			Animate.complete(m_infoIndicator);
			if (m_loading)
			{
				return;
			}
			if (m_isSelected)
			{
				Animate.to(m_infoIndicator, MenuConstants.HiliteTime, 0, {"alpha": 1}, Animate.Linear);
			}
			else
			{
				m_infoIndicator.alpha = 0;
			}
			var _loc1_:IIndicator = getIndicator(EEscalationLevelIndicator);
			if (_loc1_ != null)
			{
				_loc2_ = m_isSelected == false;
				_loc1_.setVisible(_loc2_);
			}
		}
	}
}
