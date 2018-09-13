import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;

//declare global variables at the top of your sketch
//AudioContext ac; is declared in helper_functions
ControlP5 cp5;

Glide filterGlide;
float filterAmount;
BiquadFilter filter; //new

Glide gainGlide;
float gainAmount;
Gain gain;

Glide duckGainGlide;
float duckGainAmount;
Gain duckGain;

Glide musicGlide;
float musicGainAmount;
Gain musicGain;


SamplePlayer loop;
SamplePlayer v1;
SamplePlayer v2;


//end global variables

//runs once when the Play button above is pressed
void setup() {
  size(320, 240); //size(width, height) must be the first line in setup()
  ac = new AudioContext(); //AudioContext ac; is declared in helper_functions 
  loop = getSamplePlayer("audio.wav");
  loop.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  
  v1 = getSamplePlayer("voice2.wav"); // I just like the first music better
  v1.pause(true);
  
  v1.setEndListener(
    new Bead() {
      public void messageReceived(Bead mess) {
        v1.setToLoopStart();
        v1.pause(true);  
        musicGlide.setValue(0.8);
        filterAmount = determineFilterFreq();
        filterGlide.setValue(filterAmount);
        duckGainGlide.setValue(1.0);
      }
    }
  );
  
  v2 = getSamplePlayer("voice1.wav");
  v2.pause(true);
  v2.setEndListener(
    new Bead() {
      public void messageReceived(Bead mess) {
        v2.setToLoopStart();
        v2.pause(true);
        musicGlide.setValue(0.8);
        filterAmount = determineFilterFreq();
        filterGlide.setValue(filterAmount);
        duckGainGlide.setValue(1.0);
      }
    }
  ); 
  
  // CP5
  cp5 = new ControlP5(this);
  
  gainGlide = new Glide(ac, 1, 250);
  gain = new Gain(ac, 1, gainGlide);
  
  duckGainGlide = new Glide(ac, 1, 500);
  duckGain = new Gain(ac, 1, duckGainAmount);
  
  musicGlide = new Glide(ac, 1, 500);
  musicGain = new Gain(ac, 1, musicGlide);
  musicGain.addInput(loop);
  
  filterGlide = new Glide(ac, 0, 250);
  filter = new BiquadFilter(ac, BiquadFilter.Type.HP, filterGlide, 0.7);
  
  // To-DO
  cp5.addButton("voice1")
    .setPosition(65,180)
  ;
  
  cp5.addButton("voice2")
   .setPosition(65, 120)
  ;
  
  cp5.addSlider("gainSlider")
   .setPosition(125, 70)
   .setWidth(100)
   .setHeight(20)
   .setRange(0, 100)
   .setValue(80)
   .setLabel("Gain Glide");
  ;
  
  //// Gain
  filter.addInput(loop);
  duckGain.addInput(filter);
  gain.addInput(duckGain);
  gain.addInput(v1);
  gain.addInput(v2);

  ac.out.addInput(gain);
  ac.out.addInput(musicGain);
  ac.start();
}

public void play(SamplePlayer sp) {
  sp.setToLoopStart();
  sp.start();
}

public void voice1() {
  v2.pause(true);
  play(v1);
  musicGlide.setValue(0.12);
  
  filterAmount = determineFilterFreq();
  filterGlide.setValue(filterAmount);
  duckGainGlide.setValue(0.5);
}

void voice2() {
  v1.pause(true);
  play(v2);
  musicGlide.setValue(0.12);
  filterAmount = determineFilterFreq();
  filterGlide.setValue(filterAmount);
  duckGainGlide.setValue(0.5);
}

boolean isVoicePlaying() {
  return !v1.isPaused() || !v2.isPaused();
}

float determineFilterFreq() {
  if (isVoicePlaying()) {
    return 0.2;
  } else {
   return 0.1; 
  }
}

// Change music and voice volume (Overall)
public void gainSlider(int newGain) {
  musicGlide.setValue(newGain/100.0);
  gainGlide.setValue(newGain/100.0);
  println(newGain);
}

void draw() {
  background(0);  //fills the canvas with black (0) each frame
}
