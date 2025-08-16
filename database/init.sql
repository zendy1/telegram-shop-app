-- Инициализация базы данных для Telegram Shop App

-- Создание таблицы категорий
CREATE TABLE IF NOT EXISTS categories (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  image_url TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Создание таблицы товаров
CREATE TABLE IF NOT EXISTS products (
  id SERIAL PRIMARY KEY,
  category_id INTEGER REFERENCES categories(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL CHECK (price > 0),
  sizes TEXT[] NOT NULL CHECK (array_length(sizes, 1) > 0),
  image_url TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Создание таблицы элементов корзины
CREATE TABLE IF NOT EXISTS cart_items (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  product_id INTEGER REFERENCES products(id) ON DELETE CASCADE,
  size VARCHAR(10) NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Создание таблицы заказов
CREATE TABLE IF NOT EXISTS orders (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  full_name VARCHAR(255) NOT NULL,
  address TEXT NOT NULL,
  phone VARCHAR(20) NOT NULL,
  total_price DECIMAL(10,2) NOT NULL CHECK (total_price > 0),
  status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'shipped', 'delivered', 'cancelled')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Создание таблицы элементов заказа
CREATE TABLE IF NOT EXISTS order_items (
  id SERIAL PRIMARY KEY,
  order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE,
  product_id INTEGER REFERENCES products(id) ON DELETE CASCADE,
  size VARCHAR(10) NOT NULL,
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  price DECIMAL(10,2) NOT NULL CHECK (price > 0)
);

-- Создание индексов для улучшения производительности
CREATE INDEX IF NOT EXISTS idx_products_category_id ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_cart_items_user_id ON cart_items(user_id);
CREATE INDEX IF NOT EXISTS idx_cart_items_product_id ON cart_items(product_id);
CREATE INDEX IF NOT EXISTS idx_orders_user_id ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items(product_id);

-- Вставка тестовых категорий
INSERT INTO categories (name, image_url) VALUES
  ('Обувь', 'https://xjpnayqoceyvtrubrqam.supabase.co/storage/v1/object/public/categories/shoes.jpg'),
  ('Верх', 'https://xjpnayqoceyvtrubrqam.supabase.co/storage/v1/object/public/categories/tops.jpg'),
  ('Низ', 'https://xjpnayqoceyvtrubrqam.supabase.co/storage/v1/object/public/categories/bottoms.jpg'),
  ('Сумки', 'https://xjpnayqoceyvtrubrqam.supabase.co/storage/v1/object/public/categories/bags.jpg'),
  ('Аксессуары', 'https://xjpnayqoceyvtrubrqam.supabase.co/storage/v1/object/public/categories/accessories.jpg')
ON CONFLICT (id) DO NOTHING;

-- Вставка тестовых товаров
INSERT INTO products (category_id, name, description, price, sizes, image_url) VALUES
  (1, 'Кроссовки Nike Air Max', 'Стильные кроссовки для повседневной носки', 8990.00, ARRAY['S', 'M', 'L', 'XL'], 'https://xjpnayqoceyvtrubrqam.supabase.co/storage/v1/object/public/products/nike_air_max.jpg'),
  (1, 'Кеды Converse Chuck Taylor', 'Классические кеды в стиле ретро', 5990.00, ARRAY['S', 'M', 'L'], 'https://xjpnayqoceyvtrubrqam.supabase.co/storage/v1/object/public/products/converse_chuck.jpg'),
  (2, 'Футболка хлопковая', 'Мягкая хлопковая футболка с принтом', 1990.00, ARRAY['S', 'M', 'L', 'XL'], 'https://xjpnayqoceyvtrubrqam.supabase.co/storage/v1/object/public/products/cotton_tshirt.jpg'),
  (2, 'Свитер вязаный', 'Теплый вязаный свитер для холодной погоды', 3990.00, ARRAY['M', 'L', 'XL'], 'https://xjpnayqoceyvtrubrqam.supabase.co/storage/v1/object/public/products/knitted_sweater.jpg'),
  (3, 'Джинсы классические', 'Классические джинсы прямого кроя', 4990.00, ARRAY['S', 'M', 'L', 'XL'], 'https://xjpnayqoceyvtrubrqam.supabase.co/storage/v1/object/public/products/classic_jeans.jpg'),
  (4, 'Рюкзак городской', 'Стильный городской рюкзак с множеством карманов', 2990.00, ARRAY['ONE_SIZE'], 'https://xjpnayqoceyvtrubrqam.supabase.co/storage/v1/object/public/products/urban_backpack.jpg'),
  (5, 'Часы наручные', 'Элегантные наручные часы в классическом стиле', 12990.00, ARRAY['ONE_SIZE'], 'https://xjpnayqoceyvtrubrqam.supabase.co/storage/v1/object/public/products/wristwatch.jpg')
ON CONFLICT (id) DO NOTHING;

-- Настройка RLS (Row Level Security)
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE cart_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- Политики для категорий (чтение доступно всем)
CREATE POLICY "Categories are viewable by everyone" ON categories
  FOR SELECT USING (true);

-- Политики для товаров (чтение доступно всем)
CREATE POLICY "Products are viewable by everyone" ON products
  FOR SELECT USING (true);

-- Политики для корзины (пользователь может управлять только своими товарами)
CREATE POLICY "Users can view own cart items" ON cart_items
  FOR SELECT USING (user_id = current_setting('app.user_id', true)::integer);

CREATE POLICY "Users can insert own cart items" ON cart_items
  FOR INSERT WITH CHECK (user_id = current_setting('app.user_id', true)::integer);

CREATE POLICY "Users can update own cart items" ON cart_items
  FOR UPDATE USING (user_id = current_setting('app.user_id', true)::integer);

CREATE POLICY "Users can delete own cart items" ON cart_items
  FOR DELETE USING (user_id = current_setting('app.user_id', true)::integer);

-- Политики для заказов (пользователь может видеть только свои заказы)
CREATE POLICY "Users can view own orders" ON orders
  FOR SELECT USING (user_id = current_setting('app.user_id', true)::integer);

CREATE POLICY "Users can insert own orders" ON orders
  FOR INSERT WITH CHECK (user_id = current_setting('app.user_id', true)::integer);

-- Политики для элементов заказа (пользователь может видеть только свои)
CREATE POLICY "Users can view own order items" ON order_items
  FOR SELECT USING (
    order_id IN (
      SELECT id FROM orders WHERE user_id = current_setting('app.user_id', true)::integer
    )
  );

CREATE POLICY "Users can insert own order items" ON order_items
  FOR INSERT WITH CHECK (
    order_id IN (
      SELECT id FROM orders WHERE user_id = current_setting('app.user_id', true)::integer
    )
  );

-- Функция для установки user_id
CREATE OR REPLACE FUNCTION set_user_id(user_id integer)
RETURNS void AS $$
BEGIN
  PERFORM set_config('app.user_id', user_id::text, false);
END;
$$ LANGUAGE plpgsql;

-- Комментарии к таблицам
COMMENT ON TABLE categories IS 'Категории товаров магазина';
COMMENT ON TABLE products IS 'Товары магазина с изображениями и размерами';
COMMENT ON TABLE cart_items IS 'Элементы корзины пользователей';
COMMENT ON TABLE orders IS 'Заказы клиентов';
COMMENT ON TABLE order_items IS 'Элементы заказов';

-- Комментарии к колонкам
COMMENT ON COLUMN categories.name IS 'Название категории';
COMMENT ON COLUMN categories.image_url IS 'URL изображения категории';
COMMENT ON COLUMN products.name IS 'Название товара';
COMMENT ON COLUMN products.description IS 'Описание товара';
COMMENT ON COLUMN products.price IS 'Цена товара в рублях';
COMMENT ON COLUMN products.sizes IS 'Массив доступных размеров';
COMMENT ON COLUMN products.image_url IS 'URL изображения товара';
COMMENT ON COLUMN cart_items.user_id IS 'ID пользователя Telegram';
COMMENT ON COLUMN cart_items.size IS 'Выбранный размер товара';
COMMENT ON COLUMN cart_items.quantity IS 'Количество товара';
COMMENT ON COLUMN orders.full_name IS 'ФИО клиента';
COMMENT ON COLUMN orders.address IS 'Адрес доставки';
COMMENT ON COLUMN orders.phone IS 'Телефон клиента';
COMMENT ON COLUMN orders.total_price IS 'Общая стоимость заказа';
COMMENT ON COLUMN orders.status IS 'Статус заказа';
COMMENT ON COLUMN order_items.price IS 'Цена товара на момент заказа';
