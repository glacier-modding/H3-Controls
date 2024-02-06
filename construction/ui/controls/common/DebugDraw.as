package common
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getQualifiedSuperclassName;
   
   public class DebugDraw
   {
      
      private static const DEBUG_NODE_NAME:String = "debugDrawSprite";
      
      private static const DEBUG_NODE_MARK:String = "debugDrawMark";
      
      private static var ms_colorTable:Array = null;
      
      private static var ms_colorTableIndex:int = 0;
      
      public static var DIALOG_CLASS_NAMES:Array = ["View","Modal","TextField","MenuImageLoader","DlcMissingInfo"];
       
      
      public function DebugDraw()
      {
         super();
      }
      
      public static function treeByClassNames(param1:DisplayObject, param2:Array, param3:Boolean = false) : void
      {
         var frameCounter:OnFrameCountAction;
         var root:DisplayObject = param1;
         var typeNames:Array = param2;
         var continousUpdate:Boolean = param3;
         if(root == null)
         {
            Log.xerror(Log.ChannelDebug,"DebugDraw.treeByClassNames: root is null");
            return;
         }
         generateColorTable();
         frameCounter = new OnFrameCountAction(root,100,continousUpdate,function():void
         {
            treeBy(root,function(param1:DisplayObject):void
            {
               var _loc2_:* = getQualifiedClassName(param1);
               var _loc3_:* = 0;
               while(_loc3_ < typeNames.length)
               {
                  if(_loc2_.search(typeNames[_loc3_]) != -1)
                  {
                     Log.xinfo(Log.ChannelDebug,"DebugDraw.treeByClassNames: adding node with typeName " + _loc2_);
                     displayObject(param1);
                     return;
                  }
                  _loc3_++;
               }
            });
         });
      }
      
      public static function treeByMarkedNodes(param1:DisplayObject, param2:Boolean = false) : void
      {
         var frameCounter:OnFrameCountAction;
         var root:DisplayObject = param1;
         var continousUpdate:Boolean = param2;
         if(root == null)
         {
            Log.xerror(Log.ChannelDebug,"DebugDraw.treeByMarkedNodes: root is null");
            return;
         }
         generateColorTable();
         frameCounter = new OnFrameCountAction(root,100,continousUpdate,function():void
         {
            treeBy(root,function(param1:DisplayObject):void
            {
               if(param1.hasOwnProperty(DEBUG_NODE_MARK))
               {
                  displayObject(param1);
               }
            });
         });
      }
      
      public static function treeAllSprites(param1:DisplayObject, param2:Boolean = false) : void
      {
         var frameCounter:OnFrameCountAction;
         var root:DisplayObject = param1;
         var continousUpdate:Boolean = param2;
         if(root == null)
         {
            Log.xerror(Log.ChannelDebug,"DebugDraw.treeAllSprites: root is null");
            return;
         }
         generateColorTable();
         frameCounter = new OnFrameCountAction(root,100,continousUpdate,function():void
         {
            treeBy(root,function(param1:DisplayObject):void
            {
               if(param1 is Sprite)
               {
                  displayObject(param1);
               }
            });
         });
      }
      
      public static function treeByCustomView(param1:DisplayObject, param2:String = "View", param3:Boolean = false) : void
      {
         var frameCounter:OnFrameCountAction;
         var root:DisplayObject = param1;
         var viewName:String = param2;
         var continousUpdate:Boolean = param3;
         if(root == null)
         {
            Log.xerror(Log.ChannelDebug,"DebugDraw.treeByCustomView: root is null");
            return;
         }
         generateColorTable();
         frameCounter = new OnFrameCountAction(root,100,continousUpdate,function():void
         {
            treeBy(root,function(param1:DisplayObject):void
            {
               var _loc5_:* = undefined;
               var _loc2_:* = getQualifiedClassName(param1);
               if(_loc2_.search(viewName) != -1)
               {
                  Log.xinfo(Log.ChannelDebug,"DebugDraw.treeByCustomView: class name matched for drawing " + _loc2_);
                  displayObject(param1);
                  return;
               }
               var _loc3_:* = param1;
               var _loc4_:* = "";
               _loc4_ = getQualifiedSuperclassName(param1);
               while(_loc4_ != "Object")
               {
                  if(_loc4_.search(viewName) != -1)
                  {
                     Log.xinfo(Log.ChannelDebug,"DebugDraw.treeByCustomView: superclass name matched for drawing " + _loc4_);
                     displayObject(param1);
                     return;
                  }
                  if((_loc5_ = getDefinitionByName(_loc4_) as Class).prototype == null)
                  {
                     break;
                  }
                  if((_loc4_ = getQualifiedSuperclassName(_loc5_.prototype)) == null)
                  {
                     break;
                  }
               }
            });
         });
      }
      
      private static function treeBy(param1:DisplayObject, param2:Function) : void
      {
         var rootNode:DisplayObject = param1;
         var nodeAction:Function = param2;
         ms_colorTableIndex = 0;
         if(rootNode.parent != null)
         {
            walkTreeActionDF(rootNode.parent,function(param1:DisplayObject):void
            {
               if(param1.name == DEBUG_NODE_NAME && param1.parent != null)
               {
                  Log.xinfo(Log.ChannelDebug,"DebugDraw.treeBy: cleanup - removing debug node (" + getQualifiedClassName(param1) + ") from parent " + param1.parent);
                  param1.parent.removeChild(param1);
               }
            });
         }
         walkTreeActionDF(rootNode,nodeAction);
      }
      
      public static function displayObject(param1:DisplayObject, param2:uint = 0) : void
      {
         if(param2 == 0)
         {
            param2 = uint(ms_colorTable[ms_colorTableIndex]);
            updateColorTableIndex();
         }
         var _loc3_:Sprite = new Sprite();
         _loc3_.name = DEBUG_NODE_NAME;
         _loc3_.graphics.beginFill(param2,0.2);
         _loc3_.graphics.lineStyle(1,16777215,1);
         _loc3_.graphics.drawRect(0,0,param1.width,param1.height);
         _loc3_.graphics.endFill();
         _loc3_.x = param1.x;
         _loc3_.y = param1.y;
         param1.parent.addChild(_loc3_);
      }
      
      private static function walkTreeActionDF(param1:DisplayObject, param2:Function) : void
      {
         var _loc5_:DisplayObject = null;
         var _loc6_:DisplayObjectContainer = null;
         var _loc7_:int = 0;
         var _loc3_:Array = [];
         _loc3_.push(param1);
         var _loc4_:Array = [];
         while(_loc3_.length > 0)
         {
            _loc5_ = _loc3_.shift();
            _loc4_.push(_loc5_);
            if((_loc6_ = _loc5_ as DisplayObjectContainer) != null)
            {
               _loc7_ = 0;
               while(_loc7_ < _loc6_.numChildren)
               {
                  _loc3_.push(_loc6_.getChildAt(_loc7_));
                  _loc7_++;
               }
            }
         }
         while(_loc4_.length > 0)
         {
            _loc5_ = _loc4_.pop();
            param2(_loc5_);
         }
      }
      
      private static function generateColorTable() : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         if(ms_colorTable != null)
         {
            return;
         }
         ms_colorTable = [];
         var _loc1_:int = 32;
         while(_loc1_ <= 255)
         {
            _loc2_ = 0;
            while(_loc2_ < 7)
            {
               _loc3_ = _loc1_ & (_loc2_ >= 3 ? 255 : 0);
               _loc4_ = _loc1_ & ((_loc2_ + 1) % 4 >= 2 ? 255 : 0);
               _loc5_ = _loc1_ & (_loc2_ % 2 == 0 ? 255 : 0);
               _loc6_ = _loc3_ << 16 | _loc4_ << 8 | _loc5_;
               ms_colorTable.push(_loc6_);
               _loc2_++;
            }
            if(_loc1_ < 255 && _loc1_ * 2 > 255)
            {
               _loc1_ = 255;
            }
            else
            {
               _loc1_ *= 2;
            }
         }
         ms_colorTable.reverse();
      }
      
      private static function updateColorTableIndex() : void
      {
         ++ms_colorTableIndex;
         if(ms_colorTableIndex >= ms_colorTable.length)
         {
            ms_colorTableIndex = 0;
         }
      }
   }
}

import common.Log;
import flash.display.DisplayObject;
import flash.events.Event;

class OnFrameCountAction
{
    
   
   private var m_func:Function;
   
   private var m_onNthFrame:int;
   
   private var m_currentFrameCount:int = 0;
   
   private var m_removed:Boolean = false;
   
   public function OnFrameCountAction(param1:DisplayObject, param2:int, param3:Boolean, param4:Function)
   {
      super();
      this.m_func = param4;
      this.m_onNthFrame = param2;
      this.m_currentFrameCount = param2;
      if(param3)
      {
         param1.addEventListener(Event.ENTER_FRAME,this.onFrameUpdate);
         param1.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         Log.xinfo(Log.ChannelDebug,"OnFrameCountAction added to stage");
      }
      else
      {
         Log.xinfo(Log.ChannelDebug,"OnFrameCountAction one shot");
         this.m_func();
      }
   }
   
   private function onFrameUpdate(param1:Event) : void
   {
      if(this.m_removed)
      {
         return;
      }
      ++this.m_currentFrameCount;
      if(this.m_currentFrameCount >= this.m_onNthFrame)
      {
         this.m_currentFrameCount = 0;
         Log.xinfo(Log.ChannelDebug,"OnFrameCountAction calling update");
         this.m_func();
      }
   }
   
   private function onRemovedFromStage(param1:Event) : void
   {
      var _loc2_:DisplayObject = param1.currentTarget as DisplayObject;
      _loc2_.removeEventListener(Event.ENTER_FRAME,this.onRemovedFromStage);
      _loc2_.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      Log.xinfo(Log.ChannelDebug,"OnFrameCountAction removed from stage");
      this.m_removed = true;
   }
}
