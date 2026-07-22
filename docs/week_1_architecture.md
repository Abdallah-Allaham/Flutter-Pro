# الأسبوع الأول: Architecture at Scale & Modularization 🏛️

يركز هذا الأسبوع على الانتقال من كتابة تطبيق واحد ضخم (Monolith) إلى نظام حزم برمجية مستقلة (Modular Monorepo) يسهل قيادتها وتوزيع العمل فيها بين أعضاء الفريق. كما سنضع **"القوانين الصارمة"** والخطوات الثابتة التي يجب اتباعها في كل مشروع.

---

## 🗺️ الجزء الأول: هندسة المونو-ريبو (Modular Monorepo using Melos)

### ما هو المونو-ريبو؟
هو عبارة عن مستودع Git واحد يحتوي على عدة مشاريع أو حزم (Packages) منفصلة. بدلاً من وضع كل الكود في تطبيق واحد، نقوم بتقسيمه إلى حزم صغيرة تعتمد على بعضها البعض.

### التقسيم المعياري للحزم (Modular Division):
1. **Core Packages (الحزم المشتركة)**: تحتوي على الأكواد المشتركة التي لا تحتوي على منطق عمل خاص بميزة معينة (Business Logic).
    * `core_network`: لإجراء الاتصالات بالإنترنت (Dio, SSL Pinning, Interceptors).
    * `core_storage`: لإدارة التخزين المحلي المشفر وغير المشفر.
    * `core_ui`: تحتوي على الـ Design System (الألوان، الخطوط، العناصر الرسومية المشتركة مثل الأزرار والـ TextFields المخصصة).
2. **Features Packages (حزم الميزات)**: حزم مستقلة تماماً تحتوي على واجهات ومنطق الميزة (مثل `feat_auth`, `feat_payment`). لا تعتمد ميزة على ميزة أخرى أبداً؛ بل تعتمد فقط على الـ Core.
3. **App (التطبيق الأساسي)**: هو المجلد الذي يجمع كل هذه الحزم ويقوم بتهيئة التطبيق (Initialization) وإعداد الـ Router الرئيسي.

---

## 📜 القانون الأول: خطوات إنشاء ميزة جديدة (Feature Creation Law)

عند طلب إضافة ميزة جديدة في المشروع (مثلاً: ميزة عرض المنتجات `feat_products`)، التزم بالخطوات التالية بالترتيب:

### الخطوة 1: إنشاء حزمة الميزة (Package Initialization)
قم بإنشاء مجلد الحزمة تحت `packages/features/feat_products` بحيث يحتوي على `pubspec.yaml` خاص به يعتمد على حزم الـ `core` اللازمة.

### الخطوة 2: تقسيم المجلدات الداخلي (Clean Architecture Structure)
يجب تقسيم الميزة داخلياً إلى 3 طبقات رئيسية (Data, Domain, Presentation):
```
feat_products/
├── lib/
│   ├── src/
│   │   ├── data/             # طبقة البيانات (أرقام، شبكة، كاش)
│   │   │   ├── datasources/  # Remote & Local Data Sources
│   │   │   ├── models/       # JSON Serialization Models
│   │   │   └── repositories/ # Implementation of Domain Repositories
│   │   ├── domain/           # طبقة منطق الأعمال الأساسي (خالية من أي اعتمادية لـ Flutter)
│   │   │   ├── entities/     # Pure Dart classes for business data
│   │   │   ├── repositories/ # Repositories Interfaces (Contracts)
│   │   │   └── usecases/     # Single-responsibility business actions
│   │   └── presentation/     # طبقة الواجهات الرسومية وإدارة الحالة
│   │       ├── blocs/        # BLoC / Cubit state management
│   │       ├── pages/        # Full screen widgets
│   │       └── widgets/      # Small local reusable widgets
│   └── feat_products.dart    # نقطة التصدير الخارجية للحزمة (Export File)
```

### الخطوة 3: كتابة الـ Contract أولاً (Domain First)
ابدأ بكتابة الـ Entity ثم الـ Repository Interface في طبقة الـ **Domain**. هذه الطبقة لا يجب أن تستورد أي مكتبة خارجية سوى Dart الأساسية. 
* *لماذا؟* لتسهيل اختبارها (Testing) وعدم تأثرها بتغيير قاعدة البيانات أو مكتبة الشبكات لاحقاً.

### الخطوة 4: تنفيذ المستودع وجلب البيانات (Data Implementation)
قم بكتابة الـ DataSource (RemoteDataSource لجلب البيانات من الـ API عبر `core_network` و LocalDataSource للقراءة من الكاش عبر `core_storage`)، ثم قم بكتابة الـ Repository Implementation الذي يقرر من أين يجلب البيانات وماذا يفعل في حال حدوث خطأ.

### الخطوة 5: بناء الـ Use Cases
كل عملية يقوم بها المستخدم يجب أن تكون في كلاس منفصل يسمى **UseCase** (مثلاً: `GetProductsListUseCase`). يحتوي الـ UseCase على دالة واحدة فقط تسمى `call()`.

---

## 📜 القانون الثاني: إدارة الحالة المتقدمة (Advanced State Management Law)

نحن نستخدم **BLoC** للمنطق المعقد الذي يحتوي على تدفق أحداث متعدد ومتزامن، و **Cubit** للعمليات البسيطة (مثل فتح/إغلاق نافذة أو تغيير قيمة متغير واحد).

### القواعد الذهبية للـ BLoC/Cubit:
1. **ولاية الحالة (State Immutability)**: يجب أن تكون جميع الـ States عبارة عن كلاسات غير قابلة للتعديل (`immutable`) مع استخدام دالة `copyWith` لتوليد حالات جديدة.
2. **عزل الواجهات**: لا يجب للـ UI أن يعرف كيف تم جلب البيانات؛ مهمته فقط إرسال الأحداث (Events) والاستماع للحالات (States) باستخدام `BlocBuilder` أو `BlocConsumer`.
3. **منع إعادة البناء العشوائي**: استخدم `buildWhen` و `listenWhen` لتصفية الحالات وتجنب إعادة بناء الواجهات دون داعٍ.

### التحكم في التزامن (Event Concurrency & Transformers):
عندما يضغط المستخدم على زر "تحميل المزيد" بشكل متكرر وسريع جداً، قد يتسبب ذلك في إرسال طلبات شبكة متعددة متطابقة. لحل هذه المشكلة كـ Senior، نستخدم **Event Transformers**:

* `droppable()`: تتجاهل أي حدث جديد يتم إرساله طالما أن الحدث الحالي ما زال قيد المعالجة (ممتاز لعملية تسجيل الدخول أو إرسال طلب شراء).
* `restartable()`: تلغي العملية الحالية فوراً وتبدأ بالعملية الجديدة (ممتاز لعمليات البحث أثناء الكتابة - Search Auto-complete).

#### مثال برمجى لاستخدام Transformers:
```dart
import 'package:bloc_concurrency/bloc_concurrency.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProductsListUseCase _getProductsList;

  ProductsBloc(this._getProductsList) : super(ProductsInitial()) {
    // نستخدم transformer: droppable() لمنع تكرار جلب البيانات أثناء التحميل
    on<FetchProductsEvent>(
      _onFetchProducts,
      transformer: droppable(),
    );
  }

  Future<void> _onFetchProducts(FetchProductsEvent event, Emitter<ProductsState> emit) async {
    emit(ProductsLoading());
    final result = await _getProductsList();
    result.fold(
      (failure) => emit(ProductsError(failure.message)),
      (products) => emit(ProductsLoaded(products)),
    );
  }
}
```

---

## 📜 القانون الثالث: حقن التبعيات المتقدم (Dependency Injection Law)

لتجنب تمرير الكائنات باليد (Prop Drilling) ولتسهيل الـ Mocking أثناء الاختبارات، نستخدم **GetIt** بالتعاون مع **Injectable** لتوليد الأكواد تلقائياً.

### خطوات إعداد الـ DI في المشروع:
1. **تسجيل المكونات الخارجية**: ننشئ كلاس تهيئة يحتوي على `@module` لتسجيل الحزم الخارجية التي لا نملك الكود الخاص بها (مثل `Dio` أو `SharedPreferences`).
2. **استخدام `@injectable` أو `@singleton`**: نضع هذه العلامات فوق الكلاسات التي نقوم بكتابتها ليقوم الـ generator بتسجيلها تلقائياً.
3. **بيئات العمل (Environments)**: نستخدم `@prod` للإنتاج و `@dev` للتطوير و `@test` للاختبارات للتحكم في الكلاسات التي يتم حقنها (مثلاً: استخدام MockApi في بيئة الـ Test و RealApi في الـ Prod).

#### مثال برمجي للـ DI:
```dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // الدالة التي سيتم توليدها
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() => getIt.init();
```

---

## 📜 القانون الرابع: التنقل وإدارة المسارات (GoRouter & Nested Navigation Law)

لإدارة الانتقال بين الصفحات بكفاءة ودعم الـ Deep Linking، نستخدم **GoRouter**. كـ Senior، يجب أن تدعم تصميم التنقل المتداخل (Nested Navigation) مثل الـ Bottom Navigation Bar دون إعادة تحميل الصفحات عند التنقل بينها. لهذا نستخدم `StatefulShellRoute`.

### خطوات إعداد StatefulShellRoute:
1. **تعريف الـ Shell**: ننشئ واجهة تحتوي على الـ Navigation Bar والـ `StatefulNavigationShell` التي تمثل المحتوى المتغير.
2. **تعريف الفروع (Branches)**: كل علامة تبويب (Tab) تعتبر فرعاً مستقل بـ Navigator خاص به (يحافظ على حالة الصفحة والـ stack الخاص بها عند الانتقال لتبويب آخر والعودة).

#### مثال هيكلي لـ GoRouter:
```dart
final goRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // الـ ShellWidget هو ويدجت يحتوي على BottomNavigationBar
        // ويمرر الـ navigationShell في الجسم (body)
        return MainShellWidget(navigationShell: navigationShell);
      },
      branches: [
        // الفرع الأول: الرئيسية
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        // الفرع الثاني: الملف الشخصي
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
```

---

## 👨‍🏫 نصائح لتدريس هذا الأسبوع للطلاب:
1. **ابدأ بالرسم**: ارسم الأشجار الثلاثة أو ارسم تدفق البيانات في الـ Clean Architecture على سبورة تفاعلية قبل كتابة أي سطر كود.
2. **مقارنة الـ Monolith بالـ Monorepo**: اطلب منهم إنشاء تطبيق بسيط ثم ناقش معهم ماذا يحدث لو عمل 10 مطورين على نفس التطبيق في نفس الوقت (Conflicts، تداخل الكود). هنا سيفهمون قيمة الـ Monorepo فوراً.
3. **تطبيق حي على Concurrency**: اجعلهم يضغطون على زر يرسل طلب شبكة بسرعة 10 مرات متتالية، ودعهم يرون الـ Console logs وهي تطبع 10 طلبات متكررة. ثم أضف الـ `droppable` transformer واجعلهم يرون كيف تم تقليصها لطلب واحد فقط. سيعشقون هذا الدرس!
