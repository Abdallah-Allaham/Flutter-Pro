# الأسبوع الثاني: Flutter Internals & Performance Tuning ⚡

يركز هذا الأسبوع على فهم كواليس محرك Flutter وكيفية تحسين الأداء وتجنب تعليق الواجهات (Jank) ومعالجة تسريبات الذاكرة (Memory Leaks).

---

## 🏛️ الأشجار الثلاثة في Flutter (The Three Trees)

لفهم فلاتر كـ Senior، يجب أن تدرك كيف يقوم برسم العناصر على الشاشة:
1. **Widget Tree**: الشجرة التي يكتبها المطور (Declarative Configuration). هي شجرة خفيفة جداً ويتم تدميرها وإعادة إنشائها باستمرار.
2. **Element Tree**: شجرة الربط والوسيط (Lifecycle Controller). هي الشجرة التي تدير حالة العناصر وتحافظ على موضع الـ Widgets وتحدد ما إذا كان يجب تحديث ال-Render Object أم لا (تستخدم `BuildContext` كعنصر رئيسي).
3. **RenderObject Tree**: شجرة الرسم الفعلي (Layout & Paint). هي الشجرة الثقيلة التي تحسب القياسات وتحدد الأبعاد وترسم الواجهة على الشاشة.

---

## 📜 قوانين تحسين الأداء (Performance Optimization Laws)

### القانون 1: تقليل عمليات إعادة الرسم (Minimize Rebuilds)
* استخدم الكلمة المفتاحية `const` للـ Widgets الثابتة دائماً لمنع إعادة بنائها عند تحديث الصفحة.
* استخدم `RepaintBoundary` لعزل الأجزاء الحركية أو المعقدة (مثل الـ CustomPainters أو الـ Animations) عن بقية الشاشة حتى لا يعاد رسم الشاشة بالكامل عند تحرك جزء صغير.

### القانون 2: تجنب تعليق الـ UI Thread (Avoid Blocking the UI Thread)
* أي عملية حسابية تستغرق أكثر من 16 مللي ثانية (مثل فك ضغط JSON ضخم، معالجة الصور، التشفير المعقد) ستقوم بتعطيل رسم الفريمات وتؤدي لـ Jank.
* **الحل**: استخدم **Isolates** لنقل العمليات الحسابية إلى Thread منفصل. في Flutter الحديث، يمكنك استخدام `Isolate.run()` ببساطة لتشغيل دالة في الخلفية واسترجاع النتيجة.

### القانون 3: تجنب تسريبات الذاكرة (Memory Leak Prevention)
* قم دائماً بإغلاق الـ `StreamController` و الـ `ChangeNotifier` والـ `TextEditingController` والـ `AnimationController` في دالة `dispose()`.
* قم بإلغاء اشتراكات الـ Streams (`Subscription.cancel()`) لمنع استهلاك الذاكرة في الخلفية.

---

## 👨‍🏫 دليل التدريس السريع:
* افتح **Flutter DevTools** أمام الطلاب واشرح لهم شاشة الـ CPU Profiler وكيف يقيس سرعة معالجة الفريمات.
* قم بإنشاء StreamController دون إغلاقه في الـ dispose ودعهم يرون تسريب الذاكرة من خلال الـ Memory Profiler.
