
float dt=0.5;
float ndt=-dt;
float scl=0.01;
float dx=5;
float dy=5;
float[] currentr;
float[] currentg;
float[] currentb;
void setup() {
  size(500, 500);
  background(0);
  loadPixels();
  for (int x=1; x<width-1; x++) {
    for (int y=1; y<height-1; y++) {
      float r=map(noise(x*scl, y*scl), 0, 1, 0, 255);
      float g=map(noise(x*scl, y*scl+10000), 0, 1, 0, 255);
      float b=map(noise(x*scl+10000, y*scl), 0, 1, 0, 255);
      pixels[index(x, y)]=color(r, g, b);
    }
  }
  currentr=red2grey(pixels);
  currentg=green2grey(pixels);
  currentb=blue2grey(pixels);
  //println(currentr.length,currentg.length);
  updatePixels();
}

void draw() {
  loadPixels();
  currentr=nextframe(currentr);
  currentg=nextframe(currentg);
  currentb=nextframe(currentb);
  arrayCopy(grey2rgb(currentr, currentg, currentb), pixels);

  //no idea why I need to do this but it doesn't work if I don't
  arrayCopy(red2grey(pixels), currentr); 
  arrayCopy(green2grey(pixels), currentg);
  arrayCopy(blue2grey(pixels), currentb);

  updatePixels();
}

void mouseDragged() {
  strokeWeight(5);
  stroke(map(noise(mouseX, mouseY), 0, 1, 0, 255));
  line(mouseX, mouseY, pmouseX, pmouseY);
  loadPixels();
  arrayCopy(red2grey(pixels), currentr);
}

float[] color2grey(color[] input) {
  float[] op=new float[input.length];
  for (int i=0; i<input.length; i++) {
    op[i]=brightness(input[i]);
  }
  return op;
}

float[] red2grey(color[] input) {
  float[] op=new float[input.length];
  for (int i=0; i<input.length; i++) {
    op[i]=red(input[i]);
  }
  return op;
}

float[] green2grey(color[] input) {
  float[] op=new float[input.length];
  for (int i=0; i<input.length; i++) {
    op[i]=green(input[i]);
  }
  return op;
}

float[] blue2grey(color[] input) {
  float[] op=new float[input.length];
  for (int i=0; i<input.length; i++) {
    op[i]=blue(input[i]);
  }
  return op;
}

color[] grey2color(float[] input) {
  color[] op=new color[input.length];
  for (int i=0; i<input.length; i++) {
    op[i]=color(input[i], input[i], input[i]);
  }
  return op;
}

color[] grey2rgb(float[] inputr, float[] inputg, float[] inputb) {
  color[] op=new color[inputr.length];
  for (int i=0; i<inputr.length; i++) {
    op[i]=color(inputr[i], inputg[i], inputb[i]);
  }
  return op;
}

int index(int x, int y) {
  return x+width*y;
}

float[] nextframe(float[] input) {
  float[] next = new float[width*height];

  for (int x=0; x<width; x++) {
    for (int y=0; y<height; y++) {
      int i=index(x, y);
      if (x==0 || x==int(width)-1 || y==0 || y==int(height)-1) {
        next[i]=0;
        continue;
      } else {

        float b0=input[i];
        float b1=input[index(x, y-1)];
        float b2=input[index(x-1, y)];
        float b3=input[index(x+1, y)];
        float b4=input[index(x, y+1)];
        float bnew=(1-2*dt/(dx*dx)-2*dt/(dy*dy))*b0+dt*((b2+b3)/(dx*dx)+(b1+b4)/(dy*dy));
        next[i]=bnew;
      }
    }
  }

  return next;
}
