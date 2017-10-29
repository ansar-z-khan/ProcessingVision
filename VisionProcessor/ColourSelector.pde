class ColourSelector {
  PVector buttonPos;
  PVector buttonSize;
  boolean pressingDown;
  private PVector topLeftCorner = new PVector(0, 0);



  ColourSelector() {
    buttonSize = new PVector(800, 300);
    buttonPos = new PVector(width/2-(buttonSize.x/2), height*0.80);
    idealColour = color(idealHue, idealSat, idealBrightness);
    /*  if (runType == RunType.ANDROID) {
     topLeftCorner = new PVector(width/2, height/2);
     topLeftCorner.x -= previewCapture.currentImage.width/2;
     topLeftCorner.y -= previewCapture.currentImage.height/2;
     }*/
  }
  void drawButton() {
    stroke(120, 99, 99);
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
  void updateButton() {
    if (mousePressed) {
      if (mouseX>buttonPos.x && mouseX < buttonPos.x + buttonSize.x
        && mouseY > buttonPos.y && mouseY < buttonPos.y+buttonSize.y ) {
        pressingDown  =true;
      }
    }
  }

  void showColour(Pixel p) {
    fill(p.colour);
    rect(width/2-20, 30, width/2+300, 30+300);
  }

  void selectColour(PImage image) {

    if (runType == RunType.ANDROID) {
      topLeftCorner = new PVector(width/2, height/2);
      topLeftCorner.y -= previewCapture.currentImage.width/2;
      topLeftCorner.x -= previewCapture.currentImage.height/2;
    }

    if (mousePressed) {
      Pixel currentPixel;
      if (runType == RunType.PC) {
        currentPixel = new Pixel(mouseX-width/2, mouseY, image.get(mouseX-width/2, mouseY));
      } else if (runType == RunType.ANDROID) {
        currentPixel = new Pixel(int (mouseX-topLeftCorner.x), int (mouseY-topLeftCorner.y), image.get(int (mouseY-topLeftCorner.y), int (mouseX-topLeftCorner.x)));
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
      strokeWeight(10);
      point(currentPixel.pos.x, currentPixel.pos.y);
      VisionProcessor.idealHue = currentPixel.getHue();
      idealSat = currentPixel.getSaturation();
      idealBrightness = currentPixel.getBrightness();
      idealColour = color(idealHue, idealSat, idealBrightness);

      println("** ideal: hue = " + idealHue + " sat = " + idealSat + " brightness = " + idealBrightness + " **");
      println(currentPixel.pos.x, currentPixel.pos.y);
      selector.showColour(currentPixel);
      if (frameByFrame) {
        // step++;
      }
    }
  }
}



void changeState() {
  previewCapture = null;
  capture = new VideoFinder(WIDTH, HEIGHT, true); 
  println("******Changing State******");
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
  previewCapture.updateImage();//Get New Image From Camera
  previewCapture.drawPreviewImage();//Draw Image
  selector.updateButton();
  selector.drawButton();
  //selector.showColour();
  selector.selectColour(previewCapture.getCurrentImage());
}