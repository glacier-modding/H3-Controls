package common
{
	import flash.display.MovieClip;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	
	public class AnimateLegacy
	{
		
		public static var Linear:int = 0;
		
		public static var SineIn:int = 1;
		
		public static var SineOut:int = 2;
		
		public static var SineInOut:int = 3;
		
		public static var ExpoIn:int = 4;
		
		public static var ExpoOut:int = 5;
		
		public static var ExpoInOut:int = 6;
		
		public static var BackIn:int = 7;
		
		public static var BackOut:int = 8;
		
		public static var BackInOut:int = 9;
		
		private static var PropertiesMap:Object = {"x": 1, "y": 2, "z": 3, "alpha": 4, "scaleX": 5, "scaleY": 6, "rotation": 7, "rotationX": 8, "rotationY": 9, "frames": 10, "intAnimation": 11};
		
		public function AnimateLegacy()
		{
			super();
		}
		
		public static function to(param1:Object, param2:Number, param3:Number, param4:Object, param5:int, param6:Function = null, ... rest):void
		{
			kill(param1);
			addTo.apply(Animate, [param1, param2, param3, param4, param5, param6].concat(rest));
		}
		
		public static function from(param1:Object, param2:Number, param3:Number, param4:Object, param5:int, param6:Function = null, ... rest):void
		{
			kill(param1);
			addFrom.apply(Animate, [param1, param2, param3, param4, param5, param6].concat(rest));
		}
		
		public static function offset(param1:Object, param2:Number, param3:Number, param4:Object, param5:int, param6:Function = null, ... rest):void
		{
			kill(param1);
			addOffset.apply(Animate, [param1, param2, param3, param4, param5, param6].concat(rest));
		}
		
		public static function fromTo(param1:Object, param2:Number, param3:Number, param4:Object, param5:Object, param6:int, param7:Function = null, ... rest):void
		{
			kill(param1);
			addFromTo.apply(Animate, [param1, param2, param3, param4, param5, param6, param7].concat(rest));
		}
		
		public static function addTo(param1:Object, param2:Number, param3:Number, param4:Object, param5:int, param6:Function = null, ... rest):void
		{
			start.apply(Animate, [false, param1, param2, param3, null, param4, param5, null, null, param6].concat(rest));
		}
		
		public static function addFrom(param1:Object, param2:Number, param3:Number, param4:Object, param5:int, param6:Function = null, ... rest):void
		{
			start.apply(Animate, [false, param1, param2, param3, param4, null, param5, null, null, param6].concat(rest));
		}
		
		public static function addOffset(param1:Object, param2:Number, param3:Number, param4:Object, param5:int, param6:Function = null, ... rest):void
		{
			start.apply(Animate, [true, param1, param2, param3, null, param4, param5, null, null, param6].concat(rest));
		}
		
		public static function addFromTo(param1:Object, param2:Number, param3:Number, param4:Object, param5:Object, param6:int, param7:Function = null, ... rest):void
		{
			start.apply(Animate, [false, param1, param2, param3, param4, param5, param6, null, null, param7].concat(rest));
		}
		
		public static function addFromToExtended(param1:Object, param2:Number, param3:Number, param4:Object, param5:Object, param6:int, param7:String, param8:String, param9:Function = null, ... rest):void
		{
			start.apply(Animate, [false, param1, param2, param3, param4, param5, param6, param7, param8, param9].concat(rest));
		}
		
		public static function legacyTo(param1:Object, param2:Number, param3:Object, param4:int, param5:Function = null, ... rest):void
		{
			kill(param1);
			addTo.apply(Animate, [param1, param2, 0, param3, param4, param5].concat(rest));
		}
		
		public static function legacyFrom(param1:Object, param2:Number, param3:Object, param4:int, param5:Function = null, ... rest):void
		{
			kill(param1);
			addFrom.apply(Animate, [param1, param2, 0, param3, param4, param5].concat(rest));
		}
		
		public static function kill(param1:Object):void
		{
			ExternalInterface.call("StopAllAnimations", param1);
		}
		
		public static function complete(param1:Object):void
		{
			ExternalInterface.call("CompleteAllAnimations", param1);
		}
		
		public static function delay(param1:Object, param2:Number, param3:Function, ... rest):void
		{
			var _loc5_:Function = wrapCallback.apply(Animate, [param3, param1].concat(rest));
			ExternalInterface.call("StartAnimation", param1, _loc5_, 0, 0, param2, 0, 0, 0);
		}
		
		private static function start(param1:Boolean, param2:Object, param3:Number, param4:Number, param5:Object, param6:Object, param7:int, param8:String, param9:String, param10:Function, ... rest):void
		{
			var key:String = null;
			var count:Number = NaN;
			var i:int = 0;
			var anim:Object = null;
			var propId:* = undefined;
			var callAnim:Object = null;
			var finalCallback:Function = null;
			var propID:int = 0;
			var initValue:Number = NaN;
			var targetValue:Number = NaN;
			var isIntAnimation:Boolean = false;
			var wrapped:Function = null;
			var offset:Boolean = param1;
			var target:Object = param2;
			var duration:Number = param3;
			var startDelay:Number = param4;
			var varsFrom:Object = param5;
			var varsTo:Object = param6;
			var easing:int = param7;
			var intAniPrefix:String = param8;
			var intAniPostfix:String = param9;
			var callback:Function = param10;
			var args:Array = rest;
			var animationCalls:Array = [];
			var combinedKeys:Object = new Object();
			collectKeys(varsFrom, combinedKeys);
			collectKeys(varsTo, combinedKeys);
			for (key in combinedKeys)
			{
				anim = {"propID": int, "initValue": Number, "targetValue": Number};
				propId = getPropID(target, key);
				if (propId != null)
				{
					if (!(key == "intAnimation" && (varsFrom == null || varsTo == null || offset)))
					{
						anim.propID = propId;
						anim.initValue = getValueFromVars(target, key, varsFrom);
						anim.targetValue = getValueFromVars(target, key, varsTo);
						if (offset && varsFrom == null && varsTo != null && varsTo[key] != null)
						{
							anim.targetValue = anim.initValue + anim.targetValue;
						}
						animationCalls.push(anim);
					}
				}
			}
			count = animationCalls.length;
			i = 0;
			while (i < animationCalls.length)
			{
				callAnim = animationCalls[i];
				finalCallback = function():void
				{
				};
				count--;
				if (count == 0)
				{
					wrapped = wrapCallback.apply(Animate, [callback, target].concat(args));
					finalCallback = wrapped;
				}
				propID = callAnim["propID"] as int;
				initValue = callAnim["initValue"] as Number;
				targetValue = callAnim["targetValue"] as Number;
				isIntAnimation = propID == PropertiesMap["intAnimation"];
				if (isIntAnimation)
				{
					ExternalInterface.call("StartAnimation", target, finalCallback, initValue, targetValue, duration, startDelay, propID, easing, intAniPrefix, intAniPostfix);
				}
				else
				{
					ExternalInterface.call("StartAnimation", target, finalCallback, initValue, targetValue, duration, startDelay, propID, easing);
				}
				i++;
			}
		}
		
		private static function wrapCallback(param1:Function, param2:Object, ... rest):Function
		{
			var wrapped:Function = null;
			var callback:Function = param1;
			var thisObject:Object = param2;
			var args:Array = rest;
			if (callback == null)
			{
				return function():void
				{
				};
			}
			if (args != null && args.length > 0)
			{
				wrapped = function():void
				{
					callback.apply(thisObject, args);
				};
			}
			else
			{
				wrapped = function():void
				{
					callback.apply(thisObject);
				};
			}
			return wrapped;
		}
		
		private static function getPropID(param1:Object, param2:String):*
		{
			if (param2 == "frames")
			{
				return PropertiesMap["frames"];
			}
			if (param2 == "width")
			{
				return PropertiesMap["scaleX"];
			}
			if (param2 == "height")
			{
				return PropertiesMap["scaleY"];
			}
			if (param2 == "intAnimation" && param1 is TextField)
			{
				return PropertiesMap["intAnimation"];
			}
			if (param1[param2] != null)
			{
				return PropertiesMap[param2];
			}
			return null;
		}
		
		private static function getInitialValueFromTarget(param1:Object, param2:String):*
		{
			var _loc3_:MovieClip = null;
			if (param2 == "frames")
			{
				_loc3_ = param1 as MovieClip;
				return _loc3_.currentFrame;
			}
			if (param2 == "width")
			{
				return param1.scaleX;
			}
			if (param2 == "height")
			{
				return param1.scaleY;
			}
			if (param1[param2] != null)
			{
				return param1[param2] as Number;
			}
			return null;
		}
		
		private static function convertArgsToAnimValue(param1:Object, param2:String, param3:Number):Number
		{
			if (param2 == "width")
			{
				return param1.scaleX * (param3 / param1.width);
			}
			if (param2 == "height")
			{
				return param1.scaleY * (param3 / param1.height);
			}
			return param3;
		}
		
		private static function getValueFromVars(param1:Object, param2:String, param3:Object):Number
		{
			if (param3 != null && param3[param2] != null)
			{
				return convertArgsToAnimValue(param1, param2, param3[param2]);
			}
			return getInitialValueFromTarget(param1, param2);
		}
		
		private static function collectKeys(param1:Object, param2:Object):void
		{
			var _loc3_:String = null;
			if (param1 == null || param2 == null)
			{
				return;
			}
			for (_loc3_ in param1)
			{
				param2[_loc3_] = true;
			}
		}
	}
}
