#define TRIG_PIN 11
#define ECHO_PIN 3
#define TIME_OUT 5000
#define SPEED 255

#include <Servo.h>
#include <AFMotor.h>

AF_DCMotor motor3(3);
AF_DCMotor motor4(4);

bool stop;

Servo myServo;

float GetDistance()
{
  long duration, distanceCm;

  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);

  duration = pulseIn(ECHO_PIN, HIGH, TIME_OUT);

  // convert to distance
  distanceCm = duration / 29.1 / 2;

  return distanceCm;
}

void setup() {
  Serial.begin(9600);

  // turn on motor
  motor3.setSpeed(SPEED);
  motor3.run(RELEASE);

  motor4.setSpeed(SPEED);
  motor4.run(RELEASE);

  myServo.attach(10);

  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);

  stop = false;
}


void Tien() {
  motor3.setSpeed(SPEED);
  motor4.setSpeed(SPEED);
  motor3.run(FORWARD);
  motor4.run(BACKWARD);
}

void Lui() {
  motor3.setSpeed(SPEED);
  motor4.setSpeed(SPEED);
  motor3.run(BACKWARD);
  motor4.run(FORWARD);
}

void ReTrai() {
  motor3.setSpeed(SPEED);
  motor4.setSpeed(SPEED);
  motor3.run(BACKWARD);
  motor4.run(BACKWARD);
}

void RePhai() {
  motor3.setSpeed(SPEED);
  motor4.setSpeed(SPEED);
  motor3.run(FORWARD);
  motor4.run(FORWARD);
}


void Dung() {
  motor3.setSpeed(0);
  motor4.setSpeed(0);
  stop = true;
}

void loop() {

  myServo.write(90);

  if (stop == false) {
    Tien();

    long distance = GetDistance();

    if (distance <= 0)
    {
      Serial.println("Echo time out !!");
    }
    else
    {
      Serial.print("Distance to nearest obstacle (cm): ");
      Serial.println(distance);

      if (distance <= 20)
      {
        stop = true;
        Lui();
        for (int i = SPEED; i >= 0; i--) {
          motor3.setSpeed(i);
          motor4.setSpeed(i);
          delay(5);
        }
        Dung();
      }
    }
    delay(150);
  }
}
