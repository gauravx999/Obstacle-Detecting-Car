#include <Servo.h>

// Ultrasonic Sensor Pins
int trigPin = 9;
int echoPin = 10;

// Motor Pins (H-Bridge Motor Controller)
int in1 = 2;
int in2 = 3;
int in3 = 4;
int in4 = 5;

// Buzzer Pin
int buzzerPin = 6;  // Connect the positive leg of the buzzer to this pin

// Servo
Servo myservo;

// Variables
long duration;
int distance;
boolean goesForward = false;
const int MAX_SPEED = 255;

void setup() {
  // Motor Pins Setup
  pinMode(in1, OUTPUT);
  pinMode(in2, OUTPUT);
  pinMode(in3, OUTPUT);
  pinMode(in4, OUTPUT);

  // Buzzer Pin Setup
  pinMode(buzzerPin, OUTPUT);
  digitalWrite(buzzerPin, LOW);  // Buzzer starts OFF

  // Ultrasonic Sensor Setup
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  // Servo Setup
  myservo.attach(11);
  myservo.write(115);  // Start with servo looking straight ahead
  delay(2000);

  // Initial Distance Check
  distance = readPing();
  delay(100);
}

void loop() {
  distance = readPing();

  if (distance <= 15) {  // If an object is detected within 15 cm
    digitalWrite(buzzerPin, HIGH);  // Turn on the buzzer
    moveBackward();
    delay(300);  // Move backward for a short time
    moveStop();
    delay(200);  // Brief stop before turning
    digitalWrite(buzzerPin, LOW);  // Turn off the buzzer

    int distanceR = lookRight();
    delay(200);
    int distanceL = lookLeft();
    delay(200);

    if (distanceR >= distanceL) {
      turnRight();
    } else {
      turnLeft();
    }
  }

  // Always move forward
  moveForward();  
}

// Function to look right with servo
int lookRight() {
  myservo.write(50);  // Turn servo to the right
  delay(500);
  int distance = readPing();
  delay(100);
  myservo.write(115);  // Return to center position
  return distance;
}

// Function to look left with servo
int lookLeft() {
  myservo.write(170);  // Turn servo to the left
  delay(500);
  int distance = readPing();
  delay(100);
  myservo.write(115);  // Return to center position
  return distance;
}

// Function to read distance using ultrasonic sensor
int readPing() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  duration = pulseIn(echoPin, HIGH);
  int cm = (duration * 0.034) / 2;
  if (cm == 0) {
    cm = 250;  // Assume no object detected within max range
  }
  return cm;
}

// Function to stop motors
void moveStop() {
  digitalWrite(in1, LOW);
  digitalWrite(in2, LOW);
  digitalWrite(in3, LOW);
  digitalWrite(in4, LOW);
}

// Function to move forward
void moveForward() {
  digitalWrite(in1, HIGH);  // Right motor forward
  digitalWrite(in2, LOW);
  digitalWrite(in3, HIGH);  // Left motor forward
  digitalWrite(in4, LOW);
}

// Function to move backward
void moveBackward() {
  digitalWrite(in1, LOW);  // Right motor backward
  digitalWrite(in2, HIGH);
  digitalWrite(in3, LOW);  // Left motor backward
  digitalWrite(in4, HIGH);
}

// Function to turn right
void turnRight() {
  digitalWrite(in1, HIGH);  // Right motor forward
  digitalWrite(in2, LOW);
  digitalWrite(in3, LOW);   // Left motor backward
  digitalWrite(in4, HIGH);
  delay(500);
}

// Function to turn left
void turnLeft() {
  digitalWrite(in1, LOW);   // Right motor backward
  digitalWrite(in2, HIGH);
  digitalWrite(in3, HIGH);  // Left motor forward
  digitalWrite(in4, LOW);
  delay(500);
}