package common
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class ObjectUtils
	{
		
		public function ObjectUtils()
		{
			super();
		}
		
		public static function cloneObject(param1:Object):Object
		{
			var _loc2_:String = JSON.stringify(param1);
			return JSON.parse(_loc2_);
		}
		
		public static function cloneDeep(param1:Object):*
		{
			var _loc2_:ByteArray = new ByteArray();
			_loc2_.writeObject(param1);
			_loc2_.position = 0;
			return _loc2_.readObject();
		}
		
		public static function cloneDictionary(param1:Dictionary):Dictionary
		{
			var _loc3_:Object = null;
			var _loc2_:Dictionary = new Dictionary();
			for (_loc3_ in param1)
			{
				_loc2_[_loc3_] = param1[_loc3_];
			}
			return _loc2_;
		}
		
		public static function compare(param1:Object, param2:Object):Boolean
		{
			var value1:String = null;
			var value2:String = null;
			var obj1:Object = param1;
			var obj2:Object = param2;
			try
			{
				value1 = JSON.stringify(obj1);
				value2 = JSON.stringify(obj2);
			}
			catch (e:Error)
			{
				trace("[ERROR] ObjectUtil.compare() - " + e.message);
				return false;
			}
			return value1 === value2;
		}
	}
}
