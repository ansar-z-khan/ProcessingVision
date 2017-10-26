class ColourSelector {
  PVector buttonPos;
  PVector buttonSize;
  boolean pressingDown;


  ColourSelector() {
    buttonSize = new PVector(800, 300);
    buttonPos = new PVector(width/2-(buttonSize.x/2), height*0.80);
  }
  void drawButton() {
    stroke(0, 255, 0);
    if (pressingDown) {
      fill(19, 134, 84);
    } else {
      fill(19, 134, 84, 150);
    }
    rect(buttonPos.x, buttonPos.y, buttonPos.x+buttonSize.x, buttonPos.y+buttonSize.y, 60);
    fill(243, 216, 58);
    textSize(buttonSize.y*0.65);
    text("Proceed", buttonPos.x+35, buttonPos.y+buttonSize.y*0.75);
  }
  void updateButton() {
    if (mousePressed) {
      if (mouseX>buttonPos.x && mouseX < buttonPos.x + buttonSize.x
        && mouseY > buttonPos.y && mouseY < buttonPos.y+buttonSize.y ) {
        pressingDown  =true;
      }
    }
  }
  
  void selectColour(PImage image) {
    if (mousePressed) {
      Pixel currentPixel = new Pixel(mouseX-width/2, mouseY, image.get(mouseX-width/2, mouseY));
      VisionProcessor.idealHue = currentPixel.getHue();
      idealSat = currentPixel.getSaturation();
      idealBrightness = currentPixel.getBrightness();
      println("** ideal: hue = " + idealHue + " sat = " + idealSat + " brightness = " + idealBrightness + " **");
      if (frameByFrame) {
        step++;
      }
    }
  }
  
  
}



void changeState() {
  previewCapture = null;
  capture = new VideoFinder(WIDTH, HEIGHT, true); 
  step++;
}

void mouseReleased() {
  if (selector.pressingDown && step == 0) {
    changeState();
  }
}



void pcPreview () {
  capture.updateImage();//Get New Image From Camera
  capture.drawImage(width/2, 0);//Draw Image
  PImage image = capture.getCurrentImage();
  
  println("select pixel");
  
  selector.selectColour(image);
  
}


void androidPreview() {
  selector.updateButton();
  selector.drawButton();
  previewCapture.updateImage();//Get New Image From Camera
  previewCapture.drawPreviewImage();//Draw Image
  selector.selectColour(new PImage() );
  
}
  