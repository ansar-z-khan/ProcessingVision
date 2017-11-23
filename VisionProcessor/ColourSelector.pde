class ColourSelector {
 
  //Button Vectors
  PVector buttonPos;
  PVector buttonSize;
  //Used to determine if button is being pressed
  boolean pressingDown;
  
  private PVector topLeftCorner; 



  ColourSelector() {
    buttonSize = new PVector(800, 300);
    buttonPos = new PVector(width/2-(buttonSize.x/2), height*0.80);
    idealColour = color(idealHue, idealSat, idealBrightness);
    topLeftCorner = new PVector(0, 0);
    /*  if (runType == RunType.ANDROID) {
     topLeftCorner = new PVector(width/2, height/2);
     topLeftCorner.x -= previewCapture.currentImage.width/2;
     topLeftCorner.y -= previewCapture.currentImage.height/2;
     }*/
  }
  //Draws button
  void drawButton() {
    stroke(170, 255, 255);
    if (pressingDown) {
      fill(153, 84, 52);
    } else {
      fill(153, 84, 52, 150);
    }
    rect(buttonPos.x, buttonPos.y, buttonPos.x+buttonSize.x, buttonPos.y+buttonSize.y, 60);
    fill(51, 75, 94);
    textSize(buttonSize.y*0.65);
    text("Proceed", buttonPos.x+35, buttonPos.y+buttonSize.y*0.75);
  }
  //Checks if button has been pressed
  void updateButton() {
    if (mousePressed) {
      if (mouseX>buttonPos.x && mouseX < buttonPos.x + buttonSize.x
        && mouseY > buttonPos.y && mouseY < buttonPos.y+buttonSize.y ) {
        pressingDown  =true;
      }
    }
  }
  //Draws rectangle showing the color that has been selected
  void showColour() {
    fill(idealColour);
    rectMode(CENTER);
    rect(width/2-20, 250, 300, 300);
    rectMode(CORNERS);
  }

  //Checks if an image has been clicked and a color has been selected
  //Requires: PIMage image: Image to check whether or not it has been clicked
  //Sets ideal color to what has been clicked
  void selectColour(PImage image) {
    
    if (runType == RunType.ANDROID) {
      topLeftCorner = new PVector(width/2, height/2);
      topLeftCorner.y -= previewCapture.currentImage.width/2;
      topLeftCorner.x -= previewCapture.currentImage.height/2;
      point(topLeftCorner.x, topLeftCorner.y);
    }

    if (mousePressed) {
      Pixel currentPixel;
      if (runType == RunType.PC) {
        currentPixel = new Pixel(mouseX-width/2, mouseY, image.get(mouseX-width/2, mouseY));
      } else if (runType == RunType.ANDROID) {
        if (!(mouseX > topLeftCorner.x && mouseX < topLeftCorner.x+image.height && mouseY > topLeftCorner.y && mouseY < topLeftCorner.y + image.width) ) {
          return;
        }
        currentPixel = new Pixel(int (image.height-(mouseX-topLeftCorner.x) ), int (mouseY-topLeftCorner.y), image.get(int (mouseY-topLeftCorner.y), int (image.height-(mouseX-topLeftCorner.x) ) ) );
        /*pushMatrix();
        translate(topLeftCorner.x,topLeftCorner.y);
        point(0,0);
        currentPixel = new Pixel(mouseX,mouseY, image.get(mouseX,mouseY));
        popMatrix();*/
      } else {
        currentPixel = new Pixel(5, 5, 5);
      }
      // currentPixel = new Pixel(50,50,(image.get(50,50)));
      stroke(255, 255, 255);
     // strokeWeight(10);
      VisionProcessor.idealHue = currentPixel.getHue();
      idealSat = currentPixel.getSaturation();
      idealBrightness = currentPixel.getBrightness();
      idealColour = color(idealHue/(24.0/17.0), idealSat/(20.0/51.0), idealBrightness/(20.0/51.0));

      println("** ideal: hue = " + idealHue + " sat = " + idealSat + " brightness = " + idealBrightness + " **");
      println(currentPixel.pos.x, currentPixel.pos.y);
      if (runType == RunType.ANDROID) {
        selector.showColour();
      } else if (runType == RunType.PC) {
        step++;
      }
      
      if (frameByFrame) {
        // step++;
      }
    }
  }
}


//Used to change from the preview state to the calculations stage
void changeState() {
 // previewCapture = null;
 println("CALLING CONSTRUCTOR");
  capture = new VideoFinder(WIDTH, HEIGHT); 
  println("******Changing State******");
  step=1;
}

void mouseReleased() {
  println("mouseReleased");
  if (selector.pressingDown && step == 0) {
    println("Calling Change State");
    changeState();
     println("After Change State");
  }
}


//Handles the preview screen for PC mode
void pcPreview () {
  capture.updateImage();//Get New Image From Camera
  capture.drawImage(width/2, 0);//Draw Image
  PImage image = capture.getCurrentImage();
  println("select pixel");
  selector.selectColour(image);
}

//Handles previes screen for andrpoid mode
void androidPreview() {
  previewCapture.updateImage();//Get New Image From Camera
  previewCapture.drawPreviewImage();//Draw Image
  selector.updateButton();
  selector.drawButton();
  selector.showColour();
  selector.selectColour(previewCapture.getCurrentImage());
}