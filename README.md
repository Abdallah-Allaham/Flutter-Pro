# مسار التأهيل لمنصب Flutter Senior & Team Lead 🚀

مرحباً بك في مستودعك الخاص المخصص للتعلم الشامل والتجهيز للانتقال لمستوى **Senior** و **Team Lead** في تطوير تطبيقات Flutter خلال **شهر واحد**!

يحتوي هذا المستودع على شروحات تفصيلية باللغة العربية، وأكواد جاهزة (Boilerplates)، وتطبيق هيكلية مونو-ريبو (Monorepo) متكاملة باستخدام **Melos**، تم تصميمها لتكون مرجعك السريع أثناء التطوير، التدريس، أو العمل الحر (Freelance).

---

## 🗺️ خريطة الطريق الأسبوعية (Roadmap)

### [الأسبوع الأول: Architecture at Scale & Modularization](docs/week_1_architecture.md)
* **المواضيع**: بنية المونو-ريبو (Modular Monorepo)، الـ Clean Architecture القائمة على الميزات، تفاصيل الـ BLoC/Cubit المتقدمة والتحكم في التزامن (Concurrency)، وحقن التبعيات (GetIt + Injectable)، والتنقل المتقدم (GoRouter - StatefulShellRoute).
* **الأكواد المتوفرة**: هيكلية الحزم المخصصة (Core & Features) تحت مجلد `packages`.

### [الأسبوع الثاني: Flutter Internals & Performance Tuning](docs/week_2_performance.md)
* **المواضيع**: محرك الفلاتر (Widget vs Element vs RenderObject Trees)، أدوات الـ DevTools للـ Profiling، حل مشاكل تسريب الذاكرة (Memory Leaks)، والتعامل مع العمليات الخلفية والـ Isolates.

### [الأسبوع الثالث: Native Integration, Security & Testing Strategy](docs/week_3_native_testing.md)
* **المواضيع**: الربط مع الأنظمة الأساسية باستخدام Pigeon، التشفير وحماية البيانات (SSL Pinning, Obfuscation, Secure Storage)، واستراتيجيات الفحص (Unit, Mocking, Golden, Integration).

### [الأسبوع الرابع: Team Lead, DevOps & System Design](docs/week_4_devops_lead.md)
* **المواضيع**: أتمتة الـ CI/CD (GitHub Actions + Fastlane)، تصميم النظم المتقدمة (Offline-First)، معايير كتابة الكود و مراجعة الأكواد (Code Review Standards).

---

## 🏛️ هيكلية المستودع (Monorepo Structure)

```
├── .github/workflows/          # أتمتة الـ CI/CD (أسبوع 4)
├── docs/                       # ملفات الشروحات لكل أسبوع
│   ├── week_1_architecture.md
│   ├── week_2_performance.md
│   ├── week_3_native_testing.md
│   └── week_4_devops_lead.md
├── packages/                   # الحزم البرمجية المنفصلة (الأسبوع 1)
│   ├── core/                   # الحزم المشتركة
│   │   ├── core_network/       # معالجة الشبكات (Dio + SSL Pinning)
│   │   ├── core_storage/       # التخزين المحلّي (Isar / Secure Storage)
│   │   └── core_ui/            # نظام التصميم المشترك (UI Kit / Design System)
│   └── features/               # الميزات المستقلة
│       └── feat_auth/          # ميزة تسجيل الدخول (Clean Architecture Example)
├── apps/                       # التطبيقات الفعلية
│   └── main_app/               # التطبيق الأساسي الذي يربط الحزم ببعضها
├── melos.yaml                  # إعدادات أداة Melos للمونو-ريبو
├── analysis_options.yaml       # قواعد كتابة الكود وتوحيده لضمان الجودة
└── pubspec.yaml                # ملف pubspec للجذر
```

---

## 🛠️ كيفية تشغيل المشروع

1. قم بتثبيت أداة **Melos** عالمياً إذا لم تكن مثبتة:
   ```bash
   dart pub global activate melos
   ```
2. قم بتثبيت التبعيات لجميع الحزم وربطها ببعضها (Bootstrap):
   ```bash
   melos bootstrap
   ```
3. لتشغيل الفحص الثابت للأكواد في جميع الحزم:
   ```bash
   melos run analyze
   ```
4. لتشغيل الـ Code Generator (مثل build_runner) لجميع الحزم:
   ```bash
   melos run build_all
   ```

*حظاً موفقاً في رحلتك نحو القمة! هذا المستودع ملكك، يمكنك نسخ الأكواد وتعديلها واستخدامها لشرح الدروس لطلابك بثقة تامة.*
