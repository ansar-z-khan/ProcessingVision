class Pixel{
  PVector pos;
  color colour;
  
  Pixel(int x, int y, color c){
    pos = new PVector(x,y);
    colour = c;
  }
  
  PVector getPos(){
    return pos;
  }
  color getColour(){
    return colour;
  }
  float getRed(){
    return red(colour);
  }
  float getGreen(){
    return green(colour);
  }
  float getBlue(){
    return blue(colour);
  }
  float getSquaredRed(){
    return pow(red(colour),2);
  }
  float getSquaredGreen(){
    return pow(green(colour),2);
  }
  float getSquaredBlue(){
    return pow(blue(colour),2);
  }
}