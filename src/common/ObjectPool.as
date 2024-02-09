package common
{
	
	public class ObjectPool
	{
		
		private var m_type:Class;
		
		private var m_onNewObjectAllocated:Function;
		
		private var m_objectsAvailable:Array;
		
		public function ObjectPool(param1:Class, param2:int, param3:Function = null)
		{
			var _loc5_:* = undefined;
			this.m_objectsAvailable = [];
			super();
			this.m_type = param1;
			this.m_onNewObjectAllocated = param3;
			var _loc4_:int = 0;
			while (_loc4_ < param2)
			{
				_loc5_ = new this.m_type();
				if (this.m_onNewObjectAllocated != null)
				{
					this.m_onNewObjectAllocated(_loc5_);
				}
				this.m_objectsAvailable.push(_loc5_);
				_loc4_++;
			}
		}
		
		public function acquireObject():*
		{
			var _loc1_:* = undefined;
			if (this.m_objectsAvailable.length > 0)
			{
				_loc1_ = this.m_objectsAvailable.pop();
			}
			else
			{
				_loc1_ = new this.m_type();
				if (this.m_onNewObjectAllocated != null)
				{
					this.m_onNewObjectAllocated(_loc1_);
				}
			}
			return _loc1_;
		}
		
		public function releaseObject(param1:*):void
		{
			this.m_objectsAvailable.push(param1);
		}
	}
}
