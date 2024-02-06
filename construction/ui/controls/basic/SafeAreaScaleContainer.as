package basic
{
	import common.BaseControl;
	import common.Log;
	import flash.display.Sprite;
	
	public class SafeAreaScaleContainer extends BaseControl
	{
		
		private var m_container:Sprite;
		
		private var m_safeAreaRatio:Number = 1;
		
		private var m_baseSizeX:Number = 1920;
		
		private var m_baseSizeY:Number = 1080;
		
		private var m_SizeX:Number;
		
		private var m_SizeY:Number;
		
		public function SafeAreaScaleContainer()
		{
			this.m_SizeX = this.m_baseSizeX;
			this.m_SizeY = this.m_baseSizeY;
			super();
			this.m_container = new Sprite();
			this.addChild(this.m_container);
			this.update();
		}
		
		override public function getContainer():Sprite
		{
			return this.m_container;
		}
		
		override public function onSetViewport(param1:Number, param2:Number, param3:Number):void
		{
			this.m_SizeX = this.m_baseSizeX * param1;
			this.m_SizeY = this.m_baseSizeY * param2;
			this.m_safeAreaRatio = param3;
			this.update();
		}
		
		private function update():void
		{
			this.getContainer().scaleX = this.m_safeAreaRatio;
			this.getContainer().scaleY = this.m_safeAreaRatio;
			this.getContainer().x = this.m_SizeX * (1 - this.getContainer().scaleX) / 2;
			this.getContainer().y = this.m_SizeY * (1 - this.getContainer().scaleY) / 2;
			Log.xinfo(Log.ChannelContainer, " ScaleContainer " + "getContainer().scaleX " + this.getContainer().scaleX + " getContainer().scaleY " + this.getContainer().scaleY + " getContainer().x " + this.getContainer().x + " getContainer().y " + this.getContainer().y);
		}
	}
}
