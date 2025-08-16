# Telegram Mini App - Магазин Одежды

Telegram Mini App для магазина одежды с красно-чёрным дизайном, созданный на Flutter/Dart с интеграцией Supabase и Telegram WebApp API.

## 🚀 Возможности

- **Главная страница** с категориями товаров
- **Страница категории** с товарами и админ-панелью
- **Страница товара** с детальной информацией и добавлением в корзину
- **Корзина** с управлением товарами
- **Оформление заказа** с формой доставки
- **Админ-панель** для управления товарами (только для @ramil_slonikov)

## 🛠 Технологии

- **Frontend**: Flutter/Dart
- **Backend**: Supabase (PostgreSQL + Storage)
- **API**: Telegram WebApp API
- **Платформа**: Web (Telegram Mini App)

## 📋 Требования

- Flutter SDK 3.0.0+
- Dart SDK 3.0.0+
- Supabase аккаунт
- Telegram Bot

## 🚀 Установка и запуск

### 1. Клонирование репозитория

```bash
git clone <repository-url>
cd telegram_shop_app
```

### 2. Установка зависимостей

```bash
flutter pub get
```

### 3. Настройка Supabase

1. Создайте проект в [Supabase](https://supabase.com)
2. Создайте таблицы согласно схеме:

```sql
-- Таблица категорий
CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  image_url TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Таблица товаров
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  category_id INTEGER REFERENCES categories(id),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  sizes TEXT[] NOT NULL,
  image_url TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Таблица элементов корзины
CREATE TABLE cart_items (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  product_id INTEGER REFERENCES products(id),
  size VARCHAR(10) NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Таблица заказов
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  full_name VARCHAR(255) NOT NULL,
  address TEXT NOT NULL,
  phone VARCHAR(20) NOT NULL,
  total_price DECIMAL(10,2) NOT NULL,
  status VARCHAR(50) DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Таблица элементов заказа
CREATE TABLE order_items (
  id SERIAL PRIMARY KEY,
  order_id INTEGER REFERENCES orders(id),
  product_id INTEGER REFERENCES products(id),
  size VARCHAR(10) NOT NULL,
  quantity INTEGER NOT NULL,
  price DECIMAL(10,2) NOT NULL
);
```

3. Создайте бакеты в Storage:
   - `categories` - для изображений категорий
   - `products` - для изображений товаров

4. Обновите конфигурацию в `lib/services/supabase_service.dart`:
   ```dart
   static const String _url = 'YOUR_SUPABASE_URL';
   static const String _anonKey = 'YOUR_SUPABASE_ANON_KEY';
   ```

### 4. Настройка Telegram Bot

1. Создайте бота через [@BotFather](https://t.me/botfather)
2. Настройте WebApp для бота
3. Установите username `@ramil_slonikov` для доступа к админ-панели

### 5. Запуск приложения

```bash
# Для веб-платформы
flutter run -d chrome

# Для мобильных платформ
flutter run
```

## 📱 Структура проекта

```
lib/
├── main.dart                 # Главный файл приложения
├── models/                   # Модели данных
│   ├── category.dart
│   ├── product.dart
│   └── cart_item.dart
├── pages/                    # Страницы приложения
│   ├── home_page.dart        # Главная страница
│   ├── category_page.dart    # Страница категории
│   ├── product_page.dart     # Страница товара
│   ├── cart_page.dart        # Корзина
│   └── checkout_page.dart    # Оформление заказа
├── services/                 # Сервисы
│   ├── supabase_service.dart # Работа с Supabase
│   └── telegram_service.dart # Интеграция с Telegram
└── widgets/                  # Виджеты
    ├── category_card.dart    # Карточка категории
    ├── product_card.dart     # Карточка товара
    └── admin_panel.dart      # Админ-панель
```

## 🎨 Дизайн

Приложение использует красно-чёрную цветовую схему:
- **Фон**: Чёрный (#000000)
- **Основной цвет**: Красный (#FF0000)
- **Текст**: Белый (#FFFFFF)
- **Акценты**: Красный (#FF0000)

## 🔐 Админ-панель

Админ-панель доступна только пользователю с username `@ramil_slonikov` и включает:
- Добавление новых товаров
- Загрузка изображений в Supabase Storage
- Управление размерами товаров
- Редактирование и удаление товаров

## 📊 База данных

### Таблицы

- **categories**: Категории товаров
- **products**: Товары с изображениями и размерами
- **cart_items**: Корзина пользователей
- **orders**: Заказы клиентов
- **order_items**: Элементы заказов

### Storage

- **categories**: Изображения категорий
- **products**: Изображения товаров

## 🚀 Развертывание

### Supabase

1. Запустите миграции базы данных
2. Настройте RLS (Row Level Security) политики
3. Проверьте доступность Storage бакетов

### Telegram WebApp

1. Загрузите приложение на хостинг
2. Настройте WebApp URL в BotFather
3. Протестируйте интеграцию

## 🐛 Устранение неполадок

### Проблемы с Supabase

- Проверьте правильность URL и ключей
- Убедитесь, что таблицы созданы корректно
- Проверьте RLS политики

### Проблемы с Telegram API

- Убедитесь, что приложение запущено в Telegram
- Проверьте консоль браузера на ошибки
- Убедитесь, что Telegram WebApp API доступен

## 📝 Лицензия

Этот проект создан для демонстрации возможностей Flutter и интеграции с Telegram WebApp API.

## 🤝 Поддержка

При возникновении проблем создайте issue в репозитории или обратитесь к разработчику.
