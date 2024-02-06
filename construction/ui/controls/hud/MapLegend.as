package hud
{
   import common.BaseControl;
   import common.Localization;
   import common.TaskletSequencer;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   
   public class MapLegend extends BaseControl
   {
      
      private static const Y_START:Number = 77;
       
      
      private var m_container:Sprite;
      
      private var m_background_mc:MapLegendView;
      
      private var m_headerLine:MapLegendListItemView;
      
      private var m_rowByControlName:Object;
      
      public function MapLegend()
      {
         this.m_rowByControlName = {};
         super();
         this.m_container = new Sprite();
         this.m_container.visible = false;
         addChild(this.m_container);
         this.m_background_mc = new MapLegendView();
         MenuUtils.setColor(this.m_background_mc.back_mc,MenuConstants.COLOR_MENU_TABS_BACKGROUND,true,MenuConstants.MenuElementBackgroundAlpha);
         this.m_container.addChild(this.m_background_mc);
         MenuUtils.setupTextUpper(this.m_background_mc.info_mapname_txt,"",24,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
         this.m_headerLine = new MapLegendListItemView();
         this.m_headerLine.gotoAndStop(2);
         this.m_headerLine.y = Y_START;
         this.m_container.addChild(this.m_headerLine);
         this.getOrCreateRow("hud.maptrackers.NpcMapTracker").visible = false;
         this.getOrCreateRow("hud.maptrackers.SuitcaseMapTracker").visible = false;
         this.getOrCreateRow("hud.maptrackers.AreaUndiscoveredMapTracker").visible = false;
         this.getOrCreateRow("hud.maptrackers.PlayerHeroMapTracker").visible = false;
         this.getOrCreateRow("hud.maptrackers.StairDownMapTracker").visible = false;
         this.getOrCreateRow("hud.maptrackers.StairUpMapTracker").visible = false;
         this.getOrCreateRow("hud.maptrackers.StairUpDownMapTracker").visible = false;
      }
      
      private function getOrCreateRow(param1:String) : MapLegendRow
      {
         var _loc2_:MapLegendRow = this.m_rowByControlName[param1];
         if(_loc2_ == null)
         {
            _loc2_ = new MapLegendRow(param1);
            this.m_rowByControlName[param1] = _loc2_;
            this.m_container.addChild(_loc2_);
         }
         return _loc2_;
      }
      
      public function onMapChanged(param1:Object) : void
      {
         this.onSetData(param1);
      }
      
      public function onSetData(param1:Object) : void
      {
         var data:Object = param1;
         if(data == null)
         {
            this.m_container.visible = false;
            return;
         }
         TaskletSequencer.getGlobalInstance().addChunk(function():void
         {
            var _loc2_:MapLegendRow = null;
            var _loc3_:Object = null;
            m_container.visible = true;
            m_background_mc.visible = true;
            m_background_mc.info_mapname_txt.htmlText = data.lstrLocation != null && data.lstrLocation != "" ? String(data.lstrLocation) : (data.Location != null && data.Location != "" ? Localization.get("UI_" + data.Location + "_CITY") : "");
            var _loc1_:Number = Y_START;
            for each(_loc2_ in m_rowByControlName)
            {
               _loc2_.visible = false;
            }
            for each(_loc3_ in data.LegendTrackers)
            {
               _loc2_ = getOrCreateRow(_loc3_.ControlName);
               _loc2_.visible = true;
               _loc2_.y = _loc1_;
               _loc1_ += _loc2_.dyTotal;
            }
            _loc1_ += 10;
            m_background_mc.back_mc.height = _loc1_;
         });
      }
   }
}

import common.Localization;
import common.menu.MenuConstants;
import common.menu.MenuUtils;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.utils.getDefinitionByName;
import hud.maptrackers.BaseMapTracker;

class MapLegendRow extends Sprite
{
   
   private static const Y_SPACING:Number = 50;
    
   
   public var dyTotal:Number = 0;
   
   public function MapLegendRow(param1:String)
   {
      var _loc2_:DisplayObject = null;
      var _loc3_:Array = null;
      var _loc4_:String = null;
      var _loc5_:Class = null;
      var _loc6_:String = null;
      super();
      this.name = "row_" + param1;
      if(param1 == "hud.maptrackers.NpcMapTracker")
      {
         _loc2_ = new minimapBlipTargetView();
         _loc3_ = [Localization.get("UI_MAP_TARGET")];
      }
      else
      {
         _loc2_ = new (_loc5_ = getDefinitionByName(param1) as Class)();
         if((_loc6_ = BaseMapTracker(_loc2_).getTextForLegend()) == "")
         {
            _loc3_ = [];
         }
         else
         {
            _loc3_ = _loc6_.split(";");
         }
      }
      if(param1 == "hud.maptrackers.PlayerHeroMapTracker")
      {
         _loc2_.scaleX = _loc2_.scaleY = 0.7;
         _loc2_.x = -7;
      }
      else
      {
         _loc2_.scaleX = _loc2_.scaleY = 0.769;
      }
      for each(_loc4_ in _loc3_)
      {
         this.addMapLegendListItemView(_loc4_,_loc2_);
      }
   }
   
   private function addMapLegendListItemView(param1:String, param2:DisplayObject) : void
   {
      var _loc3_:MapLegendListItemView = new MapLegendListItemView();
      if(param1 == "DIVIDERLINE")
      {
         _loc3_.gotoAndStop(2);
         this.dyTotal += 10;
         _loc3_.y = this.dyTotal;
      }
      else
      {
         _loc3_.gotoAndStop(1);
         _loc3_.label_txt.visible = true;
         MenuUtils.setupTextUpper(_loc3_.label_txt,param1 || "",16,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         _loc3_.label_txt.y = 29 - Math.floor(_loc3_.label_txt.textHeight / 2);
         _loc3_.icon_mc.addChild(param2);
         _loc3_.y = this.dyTotal;
         this.dyTotal += Y_SPACING;
      }
      addChild(_loc3_);
   }
}
