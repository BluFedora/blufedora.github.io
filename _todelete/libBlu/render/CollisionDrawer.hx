package libBlu.render;

import blufedora.editor.layering.CShape.CollisionType;
import libBlu._assetIO.TileObject;
import libBlu.geom.Vec;
import openfl.display.Graphics;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class CollisionDrawer
{
  public static function drawCollision(canvas:Dynamic, tile:TileObject):Void
  {
    switch(tile.collision)
    {
      case CollisionType.NONE: 
      case CollisionType.FULL: canvas.graphics.drawRect(tile.posX, tile.posY, 36, 36);
      case CollisionType.CS:   canvas.graphics.drawRect(tile.posX + 8, tile.posY + 8, 20, 20);
      
      case CollisionType.DR:
        canvas.graphics.moveTo(tile.posX, tile.posY);
        canvas.graphics.lineTo(tile.posX + 36, tile.posY);
        canvas.graphics.lineTo(tile.posX, tile.posY + 36);
        canvas.graphics.lineTo(tile.posX, tile.posY);
      case CollisionType.DL:
        canvas.graphics.moveTo(tile.posX + 36, tile.posY + 36);
        canvas.graphics.lineTo(tile.posX, tile.posY);
        canvas.graphics.lineTo(tile.posX + 36, tile.posY);
        canvas.graphics.lineTo(tile.posX + 36, tile.posY + 36);
        
      case CollisionType.Q3BR:
        canvas.graphics.drawRect(tile.posX, tile.posY, 18, 36);
        canvas.graphics.drawRect(tile.posX + 18, tile.posY, 18, 18);
      case CollisionType.Q3TR:
        canvas.graphics.drawRect(tile.posX, tile.posY, 18, 36);
        canvas.graphics.drawRect(tile.posX + 18, tile.posY + 18, 18, 18);
      case CollisionType.Q3TL:
        canvas.graphics.drawRect(tile.posX + 18, tile.posY, 18, 36);
        canvas.graphics.drawRect(tile.posX, tile.posY + 18, 18, 18);
      case CollisionType.Q3BL:
        canvas.graphics.drawRect(tile.posX + 18, tile.posY, 18, 36);
        canvas.graphics.drawRect(tile.posX, tile.posY, 18, 18);
      
      case CollisionType.HB: canvas.graphics.drawRect(tile.posX, tile.posY + 18, 36, 18);
      case CollisionType.HR: canvas.graphics.drawRect(tile.posX + 18, tile.posY, 18, 36);
      case CollisionType.HL: canvas.graphics.drawRect(tile.posX, tile.posY, 18, 36);
      case CollisionType.HT: canvas.graphics.drawRect(tile.posX, tile.posY, 36, 18);
      
      case CollisionType.QBR: canvas.graphics.drawRect(tile.posX + 18, tile.posY + 18, 18, 18);
      case CollisionType.QBL: canvas.graphics.drawRect(tile.posX, tile.posY + 18, 18, 18);
      case CollisionType.QTR: canvas.graphics.drawRect(tile.posX + 18, tile.posY, 18, 18);
      case CollisionType.QTL: canvas.graphics.drawRect(tile.posX, tile.posY, 18, 18);
      
      case CollisionType.CUSTOM(_): 
        var path:Array<Vec> = Type.enumParameters(tile.collision)[0];
        canvas.graphics.moveTo(path[0].x, path[0].y);
        for (point in path)
        {
          canvas.graphics.lineTo(point.x, point.y);
        }
    }
  }
  
}

// Defines Any Graphics Holder -> a.k.a Shape and Sprite
typedef ICanvas = { 
  var graphics:Graphics;
};