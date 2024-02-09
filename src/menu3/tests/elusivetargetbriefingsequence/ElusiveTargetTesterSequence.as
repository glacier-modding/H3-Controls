package menu3.tests.elusivetargetbriefingsequence
{
   import common.Animate;
   import common.menu.MenuConstants;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import menu3.MenuImageLoader;
   import menu3.basic.TextTickerUtil;
   
   public dynamic class ElusiveTargetTesterSequence extends ElusiveTargetTesterSequenceBase
   {
       
      
      private var m_baseContainer:Sprite;
      
      private var m_containerForSequences:Sprite;
      
      private var m_sequenceContainer01:Sprite;
      
      private var m_sequenceContainer02:Sprite;
      
      private var m_containerForTextBlocks:Sprite;
      
      private var m_textBlockContainer01:Sprite;
      
      private var m_textBlockContainer02:Sprite;
      
      private var m_background:Sprite;
      
      private var m_testAlignmentGrid:Sprite;
      
      private var m_loader01:MenuImageLoader;
      
      private var m_loader02:MenuImageLoader;
      
      private var m_textTickerUtil:TextTickerUtil;
      
      private var m_sequencesArray:Array;
      
      private var m_sequenceContainerArray:Array;
      
      private var m_textBlockContainerArray:Array;
      
      private var m_isUnregistering:Boolean;
      
      public function ElusiveTargetTesterSequence(param1:Object)
      {
         this.m_textTickerUtil = new TextTickerUtil();
         super(param1);
         this.m_sequencesArray = new Array();
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         this.m_sequencesArray = param1.elusiveContractSequence;
         var _loc2_:Number = (MenuConstants.BaseHeight - MenuConstants.ElusiveContractsBriefingHeight) / 2;
         this.m_background = new Sprite();
         this.m_background.name = "m_background";
         this.m_background.graphics.clear();
         this.m_background.graphics.beginFill(2171169,1);
         this.m_background.graphics.drawRect(-MenuConstants.menuXOffset,-MenuConstants.menuYOffset + _loc2_,MenuConstants.BaseWidth,MenuConstants.ElusiveContractsBriefingHeight);
         this.m_background.graphics.endFill();
         addChild(this.m_background);
         this.m_baseContainer = new Sprite();
         this.m_baseContainer.name = "m_baseContainer";
         this.m_baseContainer.x = -MenuConstants.menuXOffset;
         this.m_baseContainer.y = -MenuConstants.menuYOffset;
         addChild(this.m_baseContainer);
         this.m_baseContainer.mask = this.m_background;
         this.m_testAlignmentGrid = new Sprite();
         this.m_testAlignmentGrid.name = "m_testAlignmentGrid";
         this.m_testAlignmentGrid.x = -MenuConstants.menuXOffset;
         this.m_testAlignmentGrid.y = -MenuConstants.menuYOffset;
         this.m_testAlignmentGrid.graphics.clear();
         this.m_testAlignmentGrid.graphics.lineStyle(1,15461355,0.1);
         this.m_testAlignmentGrid.graphics.moveTo(0,0);
         this.m_testAlignmentGrid.graphics.lineTo(0,MenuConstants.BaseHeight);
         this.m_testAlignmentGrid.graphics.moveTo(m_unitWidth * 1,0);
         this.m_testAlignmentGrid.graphics.lineTo(m_unitWidth * 1,MenuConstants.BaseHeight);
         this.m_testAlignmentGrid.graphics.moveTo(m_unitWidth * 2,0);
         this.m_testAlignmentGrid.graphics.lineTo(m_unitWidth * 2,MenuConstants.BaseHeight);
         this.m_testAlignmentGrid.graphics.moveTo(m_unitWidth * 3,0);
         this.m_testAlignmentGrid.graphics.lineTo(m_unitWidth * 3,MenuConstants.BaseHeight);
         this.m_testAlignmentGrid.graphics.moveTo(m_unitWidth * 4,0);
         this.m_testAlignmentGrid.graphics.lineTo(m_unitWidth * 4,MenuConstants.BaseHeight);
         this.m_testAlignmentGrid.graphics.moveTo(m_unitWidth * 5,0);
         this.m_testAlignmentGrid.graphics.lineTo(m_unitWidth * 5,MenuConstants.BaseHeight);
         this.m_testAlignmentGrid.graphics.moveTo(m_unitWidth * 6,0);
         this.m_testAlignmentGrid.graphics.lineTo(m_unitWidth * 6,MenuConstants.BaseHeight);
         this.m_testAlignmentGrid.graphics.moveTo(m_unitWidth * 7,0);
         this.m_testAlignmentGrid.graphics.lineTo(m_unitWidth * 7,MenuConstants.BaseHeight);
         this.m_testAlignmentGrid.graphics.moveTo(m_unitWidth * 8,0);
         this.m_testAlignmentGrid.graphics.lineTo(m_unitWidth * 8,MenuConstants.BaseHeight);
         this.m_testAlignmentGrid.graphics.moveTo(m_unitWidth * 9,0);
         this.m_testAlignmentGrid.graphics.lineTo(m_unitWidth * 9,MenuConstants.BaseHeight);
         this.m_testAlignmentGrid.graphics.moveTo(m_unitWidth * 10,0);
         this.m_testAlignmentGrid.graphics.lineTo(m_unitWidth * 10,MenuConstants.BaseHeight);
         this.m_testAlignmentGrid.graphics.moveTo(0,0);
         this.m_testAlignmentGrid.graphics.lineTo(MenuConstants.BaseWidth,m_unitHeight * 0);
         this.m_testAlignmentGrid.graphics.moveTo(0,m_unitHeight * 1);
         this.m_testAlignmentGrid.graphics.lineTo(MenuConstants.BaseWidth,m_unitHeight * 1);
         this.m_testAlignmentGrid.graphics.moveTo(0,m_unitHeight * 2);
         this.m_testAlignmentGrid.graphics.lineTo(MenuConstants.BaseWidth,m_unitHeight * 2);
         this.m_testAlignmentGrid.graphics.moveTo(0,m_unitHeight * 3);
         this.m_testAlignmentGrid.graphics.lineTo(MenuConstants.BaseWidth,m_unitHeight * 3);
         this.m_testAlignmentGrid.graphics.moveTo(0,m_unitHeight * 4);
         this.m_testAlignmentGrid.graphics.lineTo(MenuConstants.BaseWidth,m_unitHeight * 4);
         this.m_testAlignmentGrid.graphics.moveTo(0,m_unitHeight * 5);
         this.m_testAlignmentGrid.graphics.lineTo(MenuConstants.BaseWidth,m_unitHeight * 5);
         this.m_testAlignmentGrid.graphics.moveTo(0,m_unitHeight * 6);
         this.m_testAlignmentGrid.graphics.lineTo(MenuConstants.BaseWidth,m_unitHeight * 6);
         addChild(this.m_testAlignmentGrid);
         this.m_containerForSequences = new Sprite();
         this.m_containerForSequences.name = "m_containerForSequences";
         this.m_baseContainer.addChild(this.m_containerForSequences);
         this.m_sequenceContainer01 = new Sprite();
         this.m_sequenceContainer01.name = "m_sequenceContainer01";
         this.m_containerForSequences.addChild(this.m_sequenceContainer01);
         this.m_sequenceContainer02 = new Sprite();
         this.m_sequenceContainer02.name = "m_sequenceContainer02";
         this.m_containerForSequences.addChild(this.m_sequenceContainer02);
         this.m_sequenceContainerArray = new Array(this.m_sequenceContainer02,this.m_sequenceContainer01);
         this.m_containerForTextBlocks = new Sprite();
         this.m_containerForTextBlocks.name = "m_containerForTextBlocks";
         this.m_baseContainer.addChild(this.m_containerForTextBlocks);
         this.m_textBlockContainer01 = new Sprite();
         this.m_textBlockContainer01.name = "m_textBlockContainer01";
         this.m_containerForTextBlocks.addChild(this.m_textBlockContainer01);
         this.m_textBlockContainer02 = new Sprite();
         this.m_textBlockContainer02.name = "m_textBlockContainer02";
         this.m_containerForTextBlocks.addChild(this.m_textBlockContainer02);
         this.m_textBlockContainerArray = new Array(this.m_textBlockContainer02,this.m_textBlockContainer01);
         this.showSequencePart();
      }
      
      private function showSequencePart() : void
      {
         var _loc1_:Object = null;
         trace(">>>>>>>>>>>>>>>> ElusiveTargetTesterSequence | showSequencePart");
         if(!this.m_isUnregistering)
         {
            this.cleanUpOldContainers(this.m_sequenceContainerArray[0],this.m_textBlockContainerArray[0]);
            this.m_sequenceContainerArray.reverse();
            this.m_containerForSequences.setChildIndex(this.m_sequenceContainerArray[0],this.m_containerForSequences.numChildren - 1);
            this.m_sequenceContainerArray[0].alpha = 0;
            this.m_textBlockContainerArray.reverse();
            this.m_containerForTextBlocks.setChildIndex(this.m_textBlockContainerArray[0],this.m_containerForTextBlocks.numChildren - 1);
            if(this.m_sequencesArray.length <= 0)
            {
               return;
            }
            _loc1_ = this.m_sequencesArray.shift();
            this.goSequence(_loc1_,this.m_sequenceContainerArray[0],this.m_textBlockContainerArray[0]);
         }
      }
      
      private function goSequence(param1:Object, param2:Sprite, param3:Sprite) : void
      {
         var _loc4_:Sprite = null;
         var _loc5_:Sprite = null;
         var _loc6_:int = 0;
         var _loc7_:Sprite = null;
         if(param1.image)
         {
            (_loc4_ = new Sprite()).name = "imageContainer";
            _loc4_.graphics.clear();
            _loc4_.graphics.beginFill(65280,1);
            _loc4_.graphics.drawRect(0,0,MenuConstants.BaseWidth,MenuConstants.BaseHeight);
            _loc4_.graphics.endFill();
            param2.addChild(_loc4_);
            this.loadImage(param1.image,param1.sequence.totalduration);
         }
         if(param1.redoverlay)
         {
            (_loc5_ = new Sprite()).name = "redOverlayContainer";
            param2.addChild(_loc5_);
            createRedOverlay(param1.redoverlay,param1.sequence.totalduration,_loc5_);
         }
         if(param1.textblocks)
         {
            _loc6_ = 0;
            while(_loc6_ < param1.textblocks.length)
            {
               (_loc7_ = new Sprite()).name = "textFieldContainer_" + _loc6_;
               param3.addChild(_loc7_);
               insertTextBlock(param1.textblocks[_loc6_],param1.sequence.totalduration,_loc7_);
               _loc6_++;
            }
         }
         animateSequenceContainer(param1,param2);
         Animate.delay(this.m_baseContainer,param1.sequence.totalduration,this.showSequencePart,null);
      }
      
      private function loadImage(param1:Object, param2:Number) : void
      {
         var daImageContainer:DisplayObjectContainer = null;
         var animateImageDuration:Number = NaN;
         var data:Object = param1;
         var sequenceDuration:Number = param2;
         if(this.m_sequenceContainerArray[0].getChildByName("imageContainer"))
         {
            daImageContainer = this.m_sequenceContainerArray[0].getChildByName("imageContainer") as DisplayObjectContainer;
            if(this.m_sequenceContainerArray[0].name == "m_sequenceContainer01")
            {
               if(this.m_loader01 != null)
               {
                  this.m_loader01.cancelIfLoading();
                  daImageContainer.removeChild(this.m_loader01);
                  this.m_loader01 = null;
               }
               this.m_loader01 = new MenuImageLoader();
               daImageContainer.addChild(this.m_loader01);
               this.m_loader01.center = false;
               this.m_loader01.loadImage(data.path,function():void
               {
                  daImageContainer.cacheAsBitmap = true;
                  if(data.animateimage)
                  {
                     animateImageDuration = !!data.animateimage.duration ? Number(data.animateimage.duration) : sequenceDuration;
                     animateImageContainer(daImageContainer,daImageContainer.width,daImageContainer.height,animateImageDuration,data.animateimage.startpos,data.animateimage.endpos,data.animateimage.startscale,data.animateimage.endscale,data.animateimage.easing);
                  }
               });
            }
            else if(this.m_sequenceContainerArray[0].name == "m_sequenceContainer02")
            {
               if(this.m_loader02 != null)
               {
                  this.m_loader02.cancelIfLoading();
                  daImageContainer.removeChild(this.m_loader02);
                  this.m_loader02 = null;
               }
               this.m_loader02 = new MenuImageLoader();
               daImageContainer.addChild(this.m_loader02);
               this.m_loader02.center = false;
               this.m_loader02.loadImage(data.path,function():void
               {
                  daImageContainer.cacheAsBitmap = true;
                  if(data.animateimage)
                  {
                     animateImageDuration = !!data.animateimage.duration ? Number(data.animateimage.duration) : sequenceDuration;
                     animateImageContainer(daImageContainer,daImageContainer.width,daImageContainer.height,animateImageDuration,data.animateimage.startpos,data.animateimage.endpos,data.animateimage.startscale,data.animateimage.endscale,data.animateimage.easing);
                  }
               });
            }
            return;
         }
      }
      
      override public function getView() : Sprite
      {
         return this.m_background;
      }
      
      private function cleanUpOldContainers(param1:Sprite, param2:Sprite) : void
      {
         var oldSequenceContainer:Sprite = param1;
         var oldTextBlockContainer:Sprite = param2;
         trace("XXXXXXXXXXXXX ElusiveTargetTesterSequence | cleanUpOldContainers");
         Animate.kill(this);
         trace("XXXXXX ElusiveTargetTesterSequence | cleanUpOldContainers | Animate.kill(this)");
         Animate.kill(this.m_baseContainer);
         trace("XXXXXX ElusiveTargetTesterSequence | cleanUpOldContainers | Animate.kill(m_baseContainer)");
         Animate.delay(this,2,function():void
         {
            delayRemoveChildrenFromOldContainers(oldSequenceContainer,oldTextBlockContainer);
         });
      }
      
      private function delayRemoveChildrenFromOldContainers(param1:Sprite, param2:Sprite) : void
      {
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         trace("XXX ElusiveTargetTesterSequence | delayRemoveChildrenFromOldContainers");
         if(!this.m_isUnregistering)
         {
            Animate.kill(this);
            trace("XXX ElusiveTargetTesterSequence | delayRemoveChildrenFromOldContainers | Animate.kill(this)");
            if(param1.getChildByName("imageContainer"))
            {
               _loc3_ = param1.getChildByName("imageContainer") as DisplayObjectContainer;
               if(param1.name == "m_sequenceContainer01")
               {
                  trace("XXX ElusiveTargetTesterSequence | delayRemoveChildrenFromOldContainers | oldSequenceContainer.name: " + param1.name + " | oldImageContainer.removeChild(m_loader01)");
                  _loc3_.removeChild(this.m_loader01);
               }
               else if(param1.name == "m_sequenceContainer02")
               {
                  trace("XXX ElusiveTargetTesterSequence | delayRemoveChildrenFromOldContainers | oldSequenceContainer.name: " + param1.name + " | oldImageContainer.removeChild(m_loader02)");
                  _loc3_.removeChild(this.m_loader02);
               }
            }
            while(param1.numChildren > 0)
            {
               _loc4_ = param1.getChildAt(0);
               while(_loc4_.numChildren > 0)
               {
                  _loc5_ = _loc4_.getChildAt(0);
                  trace("XXX ElusiveTargetTesterSequence | delayRemoveChildrenFromOldContainers | oldSequenceContainer.name: " + param1.name + " | remove & Animate.complete(" + _loc5_.name + ")");
                  Animate.complete(_loc5_);
                  _loc4_.removeChild(_loc5_);
               }
               trace("XXX ElusiveTargetTesterSequence | delayRemoveChildrenFromOldContainers | oldSequenceContainer.name: " + param1.name + " | remove & Animate.complete(" + _loc4_.name + ")");
               Animate.kill(_loc4_);
               param1.removeChild(_loc4_);
            }
            while(param2.numChildren > 0)
            {
               _loc6_ = param2.getChildAt(0);
               while(_loc6_.numChildren > 0)
               {
                  _loc7_ = _loc6_.getChildAt(0);
                  trace("XXX ElusiveTargetTesterSequence | delayRemoveChildrenFromOldContainers | oldTextBlockContainer.name: " + param2.name + " | remove & Animate.complete(" + _loc7_.name + ")");
                  Animate.complete(_loc7_);
                  _loc6_.removeChild(_loc7_);
               }
               trace("XXX ElusiveTargetTesterSequence | delayRemoveChildrenFromOldContainers | oldTextBlockContainer.name: " + param2.name + " | remove & Animate.complete(" + _loc6_.name + ")");
               Animate.kill(_loc6_);
               param2.removeChild(_loc6_);
            }
         }
      }
      
      override public function onUnregister() : void
      {
         var _loc1_:DisplayObjectContainer = null;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         this.m_isUnregistering = true;
         super.onUnregister();
         Animate.kill(this);
         Animate.kill(this.m_baseContainer);
         Animate.kill(this.m_sequenceContainer01);
         Animate.kill(this.m_sequenceContainer02);
         if(this.m_loader01)
         {
            this.m_loader01.cancelIfLoading();
            if(this.m_sequenceContainerArray[0].getChildByName("imageContainer"))
            {
               _loc1_ = this.m_sequenceContainerArray[0].getChildByName("imageContainer") as DisplayObjectContainer;
               _loc1_.removeChild(this.m_loader01);
               trace("XXX ElusiveTargetTesterSequence | onUnregister | removing m_loader01 from: " + _loc1_.name);
            }
            this.m_loader01 = null;
         }
         if(this.m_loader02)
         {
            this.m_loader02.cancelIfLoading();
            if(this.m_sequenceContainerArray[0].getChildByName("imageContainer"))
            {
               _loc1_ = this.m_sequenceContainerArray[0].getChildByName("imageContainer") as DisplayObjectContainer;
               _loc1_.removeChild(this.m_loader02);
               trace("XXX ElusiveTargetTesterSequence | onUnregister | removing m_loader02 from: " + _loc1_.name);
            }
            this.m_loader02 = null;
         }
         while(this.m_baseContainer.numChildren > 0)
         {
            _loc2_ = this.m_baseContainer.getChildAt(0);
            while(_loc2_.numChildren > 0)
            {
               _loc3_ = _loc2_.getChildAt(0);
               while(_loc3_.numChildren > 0)
               {
                  _loc4_ = _loc3_.getChildAt(0);
                  while(_loc4_.numChildren > 0)
                  {
                     _loc5_ = _loc4_.getChildAt(0);
                     trace("XXX ElusiveTargetTesterSequence | onUnregister | remove/kill: m_baseContiainer." + _loc2_.name + "." + _loc3_.name + "." + _loc4_.name + "." + _loc5_.name);
                     Animate.kill(_loc5_);
                     _loc4_.removeChild(_loc5_);
                  }
                  trace("XXX ElusiveTargetTesterSequence | onUnregister | remove/kill: m_baseContiainer." + _loc2_.name + "." + _loc3_.name + "." + _loc4_.name);
                  Animate.kill(_loc4_);
                  _loc3_.removeChild(_loc4_);
               }
               trace("XXX ElusiveTargetTesterSequence | onUnregister | remove/kill: m_baseContiainer." + _loc2_.name + "." + _loc3_.name);
               Animate.kill(_loc3_);
               _loc2_.removeChild(_loc3_);
            }
            trace("XXX ElusiveTargetTesterSequence | onUnregister | remove/kill: m_baseContiainer." + _loc2_.name);
            Animate.kill(_loc2_);
            this.m_baseContainer.removeChild(_loc2_);
         }
         trace("XXX ElusiveTargetTesterSequence | onUnregister | remove/kill: m_baseContiainer");
         removeChild(this.m_baseContainer);
         this.m_sequencesArray = [];
         if(this.m_background)
         {
            removeChild(this.m_background);
            this.m_background = null;
         }
         if(this.m_testAlignmentGrid)
         {
            removeChild(this.m_testAlignmentGrid);
            this.m_testAlignmentGrid = null;
         }
      }
   }
}
