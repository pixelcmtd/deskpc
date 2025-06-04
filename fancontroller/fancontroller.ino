#define ADC_BITS 16
#define PROBE_PIN 14
#define U_REF_PIN 15
#define FAN_PIN 20
#define PUMP_PIN 23
#define PUMP_POWER 110

// NOTE: all the code could be "manually compiled" to operate on ints instead of
//       floats, which would probably yield a big performance improvement. however,
//       there's no need to worry about that since the μc is orders of magnitude
//       faster than what we need.
//       (the compiler won't do it because of precision, edge cases, untapped
//        potential, or all of the above)

// https://download.alphacool.com/legacy/kOhm_Sensor_Table_Alphacool.pdf
constexpr float R25 = 10000.0f;
constexpr float R50 = 4157.0f;

// TODO: https://en.wikipedia.org/wiki/Steinhart–Hart_equation
constexpr float k = (R50 - R25) / 25.0f;
inline float temp(float r) {
  return 25.0f + (r - R25) / k;
}

const float R_comp = 10000.0f;
inline float resistance(int adc) {
  float v = (float)adc / (float)(1 << ADC_BITS); // ratio from ADC reading
  // U = v * U_ref
  // U_ref = I * (R + R_comp)
  // R = ((v * U_ref) / U_ref) * (R + R_comp)
  // R = v * (R + R_comp) = v * R + v * R_romp
  // R * (1 - v) = v * R_comp
  // R = v * R_comp / (1 - v)
  return v * R_comp / (1.0f - v);
}

inline float duty(float t) {
  if(t <= 30) return 0.1f;
  if(t >= 45) return 1.0f;
  return 0.1f + (t - 30) * (0.9f/15.0f);
}

void setup() {
  // could be changed to INTERNAL or whatever
  analogReference(DEFAULT);
  analogReadResolution(ADC_BITS);
  pinMode(PROBE_PIN, INPUT);
  pinMode(U_REF_PIN, OUTPUT);
  pinMode(FAN_PIN, OUTPUT);
  pinMode(PUMP_PIN, OUTPUT);
  // see Intel 4-pin spec, or Noctua whitepaper
  analogWriteFrequency(FAN_PIN, 25000);
  analogWriteFrequency(PUMP_PIN, 25000);
  analogWrite(FAN_PIN, 128);
  analogWrite(PUMP_PIN, PUMP_POWER);
}

void loop() {
  digitalWrite(U_REF_PIN, HIGH);
  delay(10);
  float r = resistance(analogRead(PROBE_PIN));
  digitalWrite(U_REF_PIN, LOW);
  float t = temp(r);
  float d = duty(t);
  int pwm = (int)(d * 256.0f);
  Serial.printf("%.2f Ω, %.2f ℃, %.2f%% (%d)\n", r, t, d, pwm);
  analogWrite(FAN_PIN, pwm);
  delay(42);
}
