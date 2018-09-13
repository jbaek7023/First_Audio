import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;

String[] audio_name = {"1.wav", "2.wav", "3.wav", "4.wav", "5.wav" };

ControlP5 cp5;

SamplePlayer audio_player, effect1, effect2, effect3,effect4, effect0;

//end global variables
Bead musicEndListner;
Glide musicRateGlide;
double music_length;
int state = 0;
void setup() {
  // Setup the window size
  size(320, 240);
  // Setup the audio
  ac = new AudioContext(); //AudioContext ac; is declared in helper_functions 
  effect0 = getSamplePlayer("5.wav");
  effect1 = getSamplePlayer("1.wav");
  effect2 = getSamplePlayer("2.wav");
  effect3 = getSamplePlayer("3.wav");
  effect4 = getSamplePlayer("4.wav");
  
  
  audio_player = getSamplePlayer("audio.wav");
  musicRateGlide = new Glide(ac, 1.0);
  audio_player.setRate(musicRateGlide);
  music_length = audio_player.getSample().getLength();
  ac.out.addInput(effect0);
  ac.out.addInput(effect1);
  ac.out.addInput(effect2);
  ac.out.addInput(effect3);
  ac.out.addInput(effect4);
  ac.out.addInput(audio_player);
  effect0.pause(true);
  effect1.pause(true);
  effect2.pause(true);
  effect3.pause(true);
  effect4.pause(true);
  
  // Set up the end
  musicEndListner = new Bead() {
    public void messageReceived(Bead message) {
      print("hi");
      audio_player.setEndListener(null);
      if (musicRateGlide.getValue() > 0 && audio_player.getPosition() >= music_length) {
        musicRateGlide.setValueImmediately(0);
        audio_player.setToEnd(); // ready to rewind
      }
      
      if (musicRateGlide.getValue() < 0 && audio_player.getPosition() <= 0.0) {
        audio_player.reset();
      }
    }
  };
  
  // UI Setup
  cp5 = new ControlP5(this);
  cp5.addButton("play")
    .setPosition(65,60)
    .setLabel("Play")
  ;
  
  cp5.addButton("stop")
   .setPosition(65, 90)
   .setLabel("Stop")
  ;
  cp5.addButton("fastforward")
   .setPosition(65, 120)
   .setLabel("Fast Forward")
   .setLabel("Fast Forward")
  ;
  cp5.addButton("rewind")
   .setPosition(65, 150)
   .setLabel("Rewind")

  ;
  cp5.addButton("reset")
   .setPosition(65, 180)
   .setLabel("Reset")
  ;
  ac.start();
}

public void playEffect(SamplePlayer sp) {
  sp.reset();
  sp.start();
}

public void playAudio(int index) {
  switch(index) {
    case 0:
      playEffect(effect0);
      break;
    case 1: 
      playEffect(effect1);
      break;
    case 2:
      playEffect(effect2);
      break;
    case 3: 
      playEffect(effect3);
      break;
    case 4:
      playEffect(effect4);
      break;
  }
}

public void play() {
  // play 1 second audio sound (Playing)
  //if (audio_player.getPosition() < music_length) {
  playAudio(0);
  audio_player.setEndListener(musicEndListner);
  musicRateGlide.setValue(1);
  audio_player.start();
}
public void stop() {
  playAudio(1);
  // Stop 1 second audio sound
  audio_player.pause(true);
}
public void fastforward() {
    // Stop 1 second audio sound
    playAudio(2);
    audio_player.setEndListener(musicEndListner);
  musicRateGlide.setValue(2);
}
public void rewind() {
  playAudio(3);
    // Stop 1 second audio sound
    audio_player.setEndListener(musicEndListner);
  musicRateGlide.setValue(-2);
}
public void reset() {
  playAudio(4);
  audio_player.setEndListener(musicEndListner);
  // Stop 1 second audio sound
  audio_player.reset();
  audio_player.pause(true);
}

void draw() {
  background(0);  //fills the canvas with black (0) each frame
}
