class AppLocalizations {
  static const Map<String, Map<String, String>> _strings = {
    'en': {
      'app_title': 'App Hub',
      'welcome': 'Welcome back',
      'login': 'Sign In',
      'register': 'Create Account',
      'email': 'Email',
      'password': 'Password',
      'name': 'Full Name',
      'age': 'Age',
      'forgot_password': 'Forgot password?',
      'no_account': "Don't have an account? Sign up",
      'have_account': 'Already have an account? Sign in',
      'logout': 'Logout',
      'create_account': 'Create Account',
      'sign_in_to_continue': 'Sign in to continue',
      'my_apps': 'My Apps',
      'profile': 'Profile',
      'settings': 'Settings',
      'language': 'Language',
      'theme': 'Appearance',
      'light_mode': 'Light',
      'dark_mode': 'Dark',
      'add_app': 'Add App',
      'remove': 'Remove',
      'edit': 'Edit',
      'done': 'Done',
      'error': 'Error',
      'success': 'Success',
      'invalid_credentials': 'Invalid email or password',
      'email_exists': 'This email is already registered',
      'registration_success': 'Account created successfully',
      'edit_profile': 'Edit Profile',
      'change_password': 'Change Password',
      'account_created': 'Member since',
      'last_login': 'Last login',
      'no_apps_yet': 'No apps yet',
      'add_apps_hint': 'Tap + to add apps from your phone',
      'popular_apps': 'Popular Apps',
      'add_custom_app': 'Add Custom App',
    },
    'tk': {
      'app_title': 'Programmalar',
      'welcome': 'Hoş geldiňiz',
      'login': 'Giriş',
      'register': 'Hasap dörediň',
      'email': 'Email',
      'password': 'Parol',
      'name': 'At Familýa',
      'age': 'Ýaş',
      'forgot_password': 'Paroly unutdyňyzmy?',
      'no_account': 'Hasabyňyz ýokmy? Hasaba alyň',
      'have_account': 'Hasabyňyz barmy? Giriň',
      'logout': 'Çykmak',
      'create_account': 'Hasap Dörediň',
      'sign_in_to_continue': 'Dowam etmek üçin giriň',
      'my_apps': 'Programmalarym',
      'profile': 'Profil',
      'settings': 'Sazlamalar',
      'language': 'Dil',
      'theme': 'Görünüş',
      'light_mode': 'Ýagty',
      'dark_mode': 'Garaňky',
      'add_app': 'Programma goş',
      'remove': 'Aýyr',
      'edit': 'Üýtget',
      'done': 'Taýýar',
      'error': 'Ýalňyşlyk',
      'success': 'Üstünlikli',
      'invalid_credentials': 'Email ýa-da parol nädogry',
      'email_exists': 'Bu email eýýäm hasaba alyndy',
      'registration_success': 'Hasap üstünlikli döredildi',
      'edit_profile': 'Profili üýtget',
      'change_password': 'Paroly üýtget',
      'account_created': 'Hasap döredilen',
      'last_login': 'Soňky giriş',
      'no_apps_yet': 'Heniz programma ýok',
      'add_apps_hint': '+ basyp programma goşuň',
      'popular_apps': 'Meşhur programmalar',
      'add_custom_app': 'Öz programmaňy goş',
    },
    'ru': {
      'app_title': 'Хаб приложений',
      'welcome': 'Добро пожаловать',
      'login': 'Войти',
      'register': 'Создать аккаунт',
      'email': 'Электронная почта',
      'password': 'Пароль',
      'name': 'Полное имя',
      'age': 'Возраст',
      'forgot_password': 'Забыли пароль?',
      'no_account': 'Нет аккаунта? Зарегистрируйтесь',
      'have_account': 'Уже есть аккаунт? Войти',
      'logout': 'Выйти',
      'create_account': 'Создать аккаунт',
      'sign_in_to_continue': 'Войдите чтобы продолжить',
      'my_apps': 'Мои приложения',
      'profile': 'Профиль',
      'settings': 'Настройки',
      'language': 'Язык',
      'theme': 'Оформление',
      'light_mode': 'Светлая',
      'dark_mode': 'Темная',
      'add_app': 'Добавить приложение',
      'remove': 'Удалить',
      'edit': 'Редактировать',
      'done': 'Готово',
      'error': 'Ошибка',
      'success': 'Успешно',
      'invalid_credentials': 'Неверный email или пароль',
      'email_exists': 'Email уже зарегистрирован',
      'registration_success': 'Аккаунт успешно создан',
      'edit_profile': 'Редактировать',
      'change_password': 'Изменить пароль',
      'account_created': 'Участник с',
      'last_login': 'Последний вход',
      'no_apps_yet': 'Нет приложений',
      'add_apps_hint': 'Нажмите + чтобы добавить приложения',
      'popular_apps': 'Популярные приложения',
      'add_custom_app': 'Добавить своё приложение',
    },
  };

  static String translate(String key, String locale) {
    return _strings[locale]?[key] ?? _strings['en']?[key] ?? key;
  }

  static List<String> get supportedLocales => ['en', 'tk', 'ru'];

  static String getLanguageName(String locale) {
    switch (locale) {
      case 'en': return 'EN';
      case 'tk': return 'TK';
      case 'ru': return 'RU';
      default: return 'EN';
    }
  }

  static String getFullLanguageName(String locale) {
    switch (locale) {
      case 'en': return 'English';
      case 'tk': return 'Türkmençe';
      case 'ru': return 'Русский';
      default: return 'English';
    }
  }
}
