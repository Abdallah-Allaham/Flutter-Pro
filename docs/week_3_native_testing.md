# الأسبوع الثالث: Native Integration, Security & Testing Strategy 🛡️

يركز هذا الأسبوع على سد الفجوة بين Flutter والنظام الأساسي (Android/iOS)، وحماية التطبيقات من الهندسة العكسية، وضمان جودة الكود من خلال استراتيجية فحص صارمة.

---

## 🔌 الاتصال المتقدم بالـ Native (Platform Channels & Pigeon)

بدلاً من كتابة الـ Platform Channels يدوياً والتعرض لأخطاء كتابية في أسماء الدوال والـ Types (Runtime Errors)، نستخدم **Pigeon**.
* **Pigeon**: أداة توليد كود آمن النوع (Type-safe) لتعريف الواجهات البرمجية بين Dart و Swift/Kotlin. نقوم بكتابة Interface في Dart ثم نولد كود الـ Native تلقائياً.

---

## 🔒 القوانين الأمنية للتطبيقات (Enterprise Security Laws)

### القانون 1: حماية بيانات الشبكة (SSL/TLS Pinning)
* لمنع هجمات رجل المنتصف (Man-in-the-Middle) وسرقة البيانات عن طريق برامج مثل Charles or Fiddler.
* **الحل**: حقن شهادة الـ SSL الخاصة بالسيرفر داخل حزمة الشبكة (`core_network`) ومقارنة الـ SHA-256 fingerprint الخاص بها مع شهادة السيرفر قبل إتمام أي اتصال.

### القانون 2: حماية البيانات المخزنة (Encrypted Storage)
* لا تقم أبداً بتخزين كلمات المرور، Tokens، أو البيانات الحساسة للمستخدم في `SharedPreferences` أو `Hive` العادي.
* **الحل**: استخدم `flutter_secure_storage` الذي يعتمد على Keychain في iOS و Keystore في Android لتشفير البيانات على مستوى الهاردوير.

### القانون 3: تشفير الكود (Obfuscation)
* عند عمل build للتطبيق، استخدم خيار الـ `--obfuscate` لإخفاء أسماء الكلاسات والمتغيرات وتشفيرها لجعل عملية الهندسة العكسية (Reverse Engineering) بالغة الصعوبة.

---

## 🧪 استراتيجية الفحص (The Testing Pyramid)

1. **Unit Testing**: لفحص الـ Use Cases والـ Repositories والمنطق الحسابي النقي (تغطية كود > 80%).
2. **Widget (Component) Testing**: لفحص تفاعل الواجهات المستقلة (مثل فحص عمل زر تسجيل الدخول عند الضغط عليه).
3. **Golden (Visual) Testing**: للتأكد من أن شكل العناصر والصفحات لا يتغير بصورة غير مقصودة عبر مقارنة لقطات شاشة (Screenshots) مولدة برمجياً مع التصميم الأصلي.
4. **Integration Testing**: فحص التطبيق بالكامل من البداية للنهاية على محاكٍ (Emulator) حقيقي للسيناريوهات الحساسة مثل (الدفع، التسجيل).
