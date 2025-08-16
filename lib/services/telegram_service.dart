import 'dart:convert';

class TelegramService {
  // Проверка доступности Telegram WebApp API
  static bool get isAvailable => false; // Временно отключаем для веб-сборки

  // Получить данные пользователя
  static Map<String, dynamic>? getUserData() {
    return null; // Временно отключаем
  }

  // Проверить, является ли пользователь админом
  static bool isAdmin() {
    return false; // Временно отключаем
  }

  // Получить ID пользователя
  static int? getUserId() {
    return null; // Временно отключаем
  }

  // Показать главное окно
  static void showMainButton() {
    // Временно отключаем
  }

  // Скрыть главное окно
  static void hideMainButton() {
    // Временно отключаем
  }

  // Настроить главное окно
  static void setMainButton({
    required String text,
    required VoidCallback onPressed,
    String? color,
    String? textColor,
  }) {
    // Временно отключаем
  }

  // Показать всплывающее окно
  static void showPopup({
    required String title,
    required String message,
    required List<Map<String, dynamic>> buttons,
  }) {
    // Временно отключаем
  }

  // Показать уведомление
  static void showAlert(String message) {
    // Временно отключаем
  }

  // Показать подтверждение
  static void showConfirm(String message, VoidCallback onConfirm) {
    // Временно отключаем
  }

  // Закрыть приложение
  static void close() {
    // Временно отключаем
  }

  // Расширить приложение
  static void expand() {
    // Временно отключаем
  }

  // Свернуть приложение
  static void collapse() {
    // Временно отключаем
  }

  // Установить заголовок
  static void setHeaderColor(String color) {
    // Временно отключаем
  }

  // Установить цвет фона
  static void setBackgroundColor(String color) {
    // Временно отключаем
  }

  // Получить тему
  static String getTheme() {
    return 'light'; // Временно отключаем
  }

  // Отправить уведомление админу
  static Future<void> sendAdminNotification(String message) async {
    // Временно отключаем
    print('Admin notification: $message');
  }

  // Инициализация приложения
  static void initialize() {
    // Временно отключаем
  }
}

// Тип для callback функции
typedef VoidCallback = void Function();
