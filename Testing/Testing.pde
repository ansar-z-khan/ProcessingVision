/*
Pseudocode
 - pixel class
   - takes in 2d array of pixels
   - properties:
     - green threshold
     - frequency
     - ArrayList of green pixels
   - methods
     - getGreenPixels
     - isGreen

for (int i = 0; i < pixels.length; i += frequency) {
  for (int j = 0; j < pixels[i].length; j += frequency) {
    if (isGreen(pixels[i][j]) ) {
      greenPixels.add(new PVector(i, j) );
    }
  }
}


public boolean isGreen(color c) {
  int [] rgb = new int [3];
  
  if (c.getGreen() < c.getRed() || c.getGreen() < c.getBlue() ) {
    return false;
  }
  
  rgb[0] = Math.pow(c.getRed(), 2);
  rgb[1] = Math.pow(c.getGreen(), 2);
  rgb[2] = Math.pow(c.getBlue(), 2);

  return (rgb[1]/rgb[0] >= theshold/100 && rgb[1]/rgb[2] >= theshold/100);
}


*/

PImage image;
int [] colours;
ArrayList <Pixel> greenPixels = new ArrayList<Pixel>();

void setup() {
  size(200, 200);
  image = loadImage("TestImage.jpg");
  //image.resize(100, 100);
  image.loadPixels();
  colours = image.pixels;
   for (int i = 0; i<image.width; i++){
    for(int j = 0; j<image.height; j++){
      if (isGreen(image.get(i,j))){
        greenPixels.add(new Pixel(i,j,image.get(i,j)));
      }
    }
  }
  
  displayGreen(greenPixels);
}

public int threshold = 199;

void draw() {  
  //rect(200,200,50,50);

  
}



public void displayGreen(ArrayList <Pixel> pixels){
  for (Pixel p:pixels){
    stroke(p.getColour());
    point(p.getPos().x, p.getPos().y);
    println(p.getRed() + ", "+p.getGreen() + ", " + p.getBlue());
    
  }
  
}


public boolean isGreen(color c) {
  double [] rgb = new double [3];
  
  
  
  if (green(c) < red(c) || green(c) < blue(c) || green(c)<80) {
    return false;
  }
  
  //println("__________________________________________");
  //println(red(c) + ", " + green(c) + ", " + blue(c));
  rgb[0] = Math.pow(red(c), 2);
  rgb[1] = Math.pow(green(c), 2);
  rgb[2] = Math.pow(blue(c), 2);

  //println(rgb[0] + " " + rgb[1] + " " + rgb[2]);
  //println(rgb[1]/rgb[0] + ", " + rgb[1]/rgb[2]);
  //println(rgb[1]/rgb[0] >= threshold/100 && rgb[1]/rgb[2] >= threshold/100);

  return (rgb[1]/rgb[0] >= threshold/100 && rgb[1]/rgb[2] >= threshold/100);
}