class Blob {

  ArrayList <Pixel> pixels = new ArrayList<Pixel>();
  PVector size;
  PVector center;
  PVector minBounds;
  PVector maxBounds;


  Blob(Pixel p) {
    pixels.add(p);
    center = pixels.get(pixels.size()/2).pos;
    minBounds = new PVector(p.pos.x, p.pos.y);
    maxBounds = new PVector(p.pos.x, p.pos.y);
  }

  boolean isPartOf (Pixel p) {
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
   if (this.contains(p)) {
      return false;
    }
    Pixel topLeft = pixels.get(0);
    Pixel bottomRight = pixels.get(pixels.size()-1);
    double dist = dist(center.x, center.y, p.pos.x, p.pos.y);
    //println("dist = " + dist + " top left = " + topLeft.pos + " bottom right = " + bottomRight.pos);
    //return dist <  5 * ((dist(bottomRight.pos.x,bottomRight.pos.y, topLeft.pos.x, topLeft.pos.y)));
    return dist<30;
    
    
  }

  boolean contains(Pixel p) {
    return pixels.contains(p);
  }
  void clear() {
    pixels.clear();
  }
  void setSize() {
    Pixel topLeft = pixels.get(0);
    Pixel bottomRight = pixels.get(pixels.size()-1);
    size.x = bottomRight.pos.x - topLeft.pos.x;
    size.y = bottomRight.pos.y - topLeft.pos.y;
  }

  void addToBlob(Pixel p) {
    pixels.add(p);
    center = pixels.get(pixels.size()/2).pos;
    if(p.pos.x < minBounds.x){
      minBounds.x = p.pos.x;
    }
    if(p.pos.y < minBounds.y){
      minBounds.y = p.pos.y;
    }
    if(p.pos.x > maxBounds.x){
      maxBounds.x = p.pos.x;
    }
    if(p.pos.y > maxBounds.y){
      maxBounds.y = p.pos.y;
    }

    
  }

  void show() {
    Pixel topLeft = pixels.get(0);
    Pixel bottomRight = pixels.get(pixels.size()-1);
    rect(minBounds.x, minBounds.y, maxBounds.x, maxBounds.y);
  }
  
    
}