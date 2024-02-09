package menu3
{
	
	public dynamic class ImageElement extends MenuElementBase
	{
		
		private var m_loader:MenuImageLoader;
		
		public function ImageElement(param1:Object)
		{
			var data:Object = param1;
			super(data);
			this.m_loader = new MenuImageLoader();
			addChild(this.m_loader);
			this.m_loader.center = false;
			this.m_loader.loadImage(data.url, function():void
			{
				m_loader.width = data.width;
				m_loader.height = data.height;
			});
		}
		
		override public function onUnregister():void
		{
			if (this.m_loader != null)
			{
				this.m_loader.cancelIfLoading();
				removeChild(this.m_loader);
				this.m_loader = null;
			}
		}
	}
}
