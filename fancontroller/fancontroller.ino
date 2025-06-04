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
const float Rmax = 20000.0f;
constexpr float R25 = 10000.0f;
constexpr float R50 = 4157.0f;
const float Rmin = 1000.0f;

// const float A = 2.68437e-3;
// const float B = 2.86e-4;
// const float C = 9e-7;
// TODO: T = 1 / (A + B ln R + C (ln R)³) - 273.15
constexpr float k = (R50 - R25) / 25.0f;
inline float temp(float r) {
  return 25.0f + (r - R25) / k;
}

const float R_comp = 10000.0f;
inline float resistance(int adc) {
  float v = (float)adc / (float)(1 << ADC_BITS); // ratio from ADC reading
  // U_comp = v * U_ref
  // U_ref = I * (R + R_comp)
  // R = U / U_ref * R_tot = ((U_ref - (v * U_ref)) / U_ref) * (R + R_comp)
  // R = (1 - v) * (R + R_comp)
  // R = (1 - v) * R_comp / v    | idfk what my CAS did
  float r = (1.0f - v) * R_comp / v;
  return r > Rmax ? Rmax : r < Rmin ? Rmin : r;
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
  delay(1);
  int adc = analogRead(PROBE_PIN);
  float r = resistance(adc);
  digitalWrite(U_REF_PIN, LOW);
  float t = temp(r);
  float d = duty(t);
  int pwm = (int)(d * 256.0f);
  Serial.printf("%8.1f Ω (%04x)    %.2f ℃    %.2f%% (%d)\n", r, adc, t, d, pwm);
  analogWrite(FAN_PIN, pwm);
  delay(42);
}
