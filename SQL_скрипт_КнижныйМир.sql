CREATE DATABASE IF NOT EXISTS bookworld 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE bookworld;


SET FOREIGN_KEY_CHECKS = 0;


CREATE TABLE roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    login VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    role_id INT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE RESTRICT
);


CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY idx_author_name (name)
);


CREATE TABLE publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY idx_publisher_name (name)
);


CREATE TABLE genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    article VARCHAR(50) NOT NULL UNIQUE,
    title VARCHAR(255) NOT NULL,
    author_id INT NOT NULL,
    genre_id INT NOT NULL,
    publisher_id INT NOT NULL,
    publication_year INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    discount_price DECIMAL(10,2) NULL,
    is_on_discount BOOLEAN DEFAULT FALSE,
    stock_quantity INT DEFAULT 0,
    description TEXT,
    cover_image VARCHAR(255),
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id),
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id)
);

CREATE TABLE pickup_points (
    point_id INT AUTO_INCREMENT PRIMARY KEY,
    address VARCHAR(500) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_number VARCHAR(50) NOT NULL UNIQUE,
    user_id INT NOT NULL,
    order_date DATETIME NOT NULL,
    delivery_date DATETIME NOT NULL,
    pickup_point_id INT NOT NULL,
    customer_name VARCHAR(255) NOT NULL,
    receive_code VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL,
    total_amount DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (pickup_point_id) REFERENCES pickup_points(point_id)
);

CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO roles (name, description) VALUES 
('Администратор', 'Полный доступ ко всем функциям системы'),
('Менеджер', 'Управление заказами и просмотр каталога'),
('Авторизованный клиент', 'Просмотр каталога с поиском и оформление заказов'),
('Гость', 'Просмотр каталога без поиска и фильтрации');


INSERT INTO users (login, password, full_name, role_id) VALUES 
('a.orlova@bookworld.ru', 'Ah7kLp', 'Орлова Алина Викторовна', 1),
('d.volkov@bookworld.ru', 'Bm2qR9', 'Волков Денис Сергеевич', 1),
('i.semenova@bookworld.ru', 'Cn8tWx', 'Семенова Ирина Олеговна', 2),
('m.kozlov@bookworld.ru', 'Df4yUz', 'Козлов Максим Игоревич', 2),
('t.nikolaeva@bookworld.ru', 'Eg6vAs', 'Николаева Татьяна Петровна', 2),
('a.belov@example.com', 'Fh9jQw', 'Белов Алексей Дмитриевич', 3),
('m.sokolova@example.com', 'Gi1kEx', 'Соколова Мария Андреевна', 3),
('i.morozov@example.com', 'Hj2lFy', 'Морозов Иван Павлович', 3),
('o.lebedeva@example.com', 'Kk3mGz', 'Лебедева Ольга Васильевна', 3);


INSERT INTO authors (name) VALUES 
('Михаил Булгаков'),
('Джордж Оруэлл'),
('Федор Достоевский'),
('Эрих Мария Ремарк'),
('Антуан де Сент-Экзюпери'),
('Артур Конан Дойл'),
('Джоан Роулинг'),
('Агата Кристи'),
('Лев Толстой'),
('Пауло Коэльо'),
('Оскар Уайльд'),
('Джером Сэлинджер'),
('Орсон Скотт Кард'),
('Дуглас Адамс'),
('Дэниел Киз');


INSERT INTO genres (name) VALUES 
('Классика'),
('Антиутопия'),
('Детская'),
('Детектив'),
('Фэнтези'),
('Роман'),
('Фантастика'),
('Научная фантастика');


INSERT INTO publishers (name) VALUES 
('Эксмо'),
('АСТ'),
('Азбука'),
('Махаон'),
('София'),
('Иностранка');


INSERT INTO books (article, title, author_id, genre_id, publisher_id, publication_year, price, discount_price, is_on_discount, stock_quantity, description, cover_image) VALUES 
('B112F4', 'Мастер и Маргарита', 1, 1, 1, 2020, 450.00, 380.00, TRUE, 12, 'Бессмертное произведение русской литературы, полное мистики и философских размышлений.', '1.png'),
('F635R4', '1984', 2, 2, 2, 2019, 520.00, NULL, FALSE, 8, 'Знаменитая антиутопия, рассказывающая о тоталитарном обществе под постоянным контролем.', '2.png'),
('H782T5', 'Преступление и наказание', 3, 1, 1, 2021, 480.00, 430.00, TRUE, 15, 'Глубокий психологический роман о преступлении и моральных муках раскаяния.', '3.png'),
('G783F5', 'Три товарища', 4, 1, 3, 2018, 590.00, NULL, FALSE, 7, 'Трогательная история о дружбе и любви на фоне сложного времени в Германии.', '4.png'),
('J384T6', 'Маленький принц', 5, 3, 4, 2022, 380.00, 340.00, TRUE, 20, 'Философская сказка для детей и взрослых, говорящая о самом важном в жизни.', '5.png'),
('D572U8', 'Шерлок Холмс (сборник)', 6, 4, 1, 2020, 650.00, 590.00, TRUE, 9, 'Знаменитые расследования великого сыщика Шерлока Холмса и его друга доктора Ватсона.', '6.png'),
('F572H7', 'Гарри Поттер и философский камень', 7, 5, 4, 2021, 720.00, NULL, FALSE, 14, 'Первая книга культовой серии о юном волшебнике Гарри Поттере.', '7.png'),
('D329H3', 'Убийство в Восточном экспрессе', 8, 4, 1, 2019, 430.00, 390.00, TRUE, 11, 'Одно из самых известных дел Эркюля Пуаро, разворачивающееся в поезде.', '8.png'),
('B320R5', 'Война и мир (том 1)', 9, 1, 2, 2021, 550.00, NULL, FALSE, 6, 'Монументальный роман-эпопея, охватывающий судьбы людей на фоне войны с Наполеоном.', '9.png'),
('G432E4', 'Алхимик', 10, 6, 5, 2020, 480.00, 430.00, TRUE, 18, 'Притча о юном пастухе Сантьяго, отправившемся на поиски своего сокровища и предназначения.', '10.png'),
('S213E3', 'Портрет Дориана Грея', 11, 1, 1, 2018, 460.00, NULL, FALSE, 5, 'История о красоте, разврате и таинственном портрете, стареющем вместо своего владельца.', NULL),
('E482R4', 'Над пропастью во ржи', 12, 1, 3, 2019, 390.00, 350.00, TRUE, 10, 'Роман о подростковом бунте и поиске себя в лицемерном взрослом мире.', NULL),
('S634B5', 'Игра Эндера', 13, 7, 1, 2021, 540.00, NULL, FALSE, 0, 'История одаренного мальчика, готовящегося к защите Земли от инопланетной угрозы.', NULL),
('K345R4', 'Автостопом по галактике', 14, 7, 2, 2020, 510.00, 460.00, TRUE, 13, 'Юмористическая фантастика о невероятных приключениях землянина Артура Дента.', NULL),
('O754F4', 'Цветы для Элджернона', 15, 8, 6, 2021, 470.00, 420.00, TRUE, 8, 'Трогательная история человека, участвующего в эксперименте по повышению интеллекта.', NULL);


INSERT INTO pickup_points (address) VALUES 
('г. Москва, ул. Тверская, д. 10'),
('г. Москва, пр-т Мира, д. 25'),
('г. Санкт-Петербург, Невский пр-т, д. 45'),
('г. Санкт-Петербург, ул. Садовая, д. 12'),
('г. Екатеринбург, ул. Ленина, д. 33'),
('г. Новосибирск, Красный пр-т, д. 20'),
('г. Казань, ул. Баумана, д. 15'),
('г. Нижний Новгород, ул. Большая Покровская, д. 5'),
('г. Ростов-на-Дону, ул. Большая Садовая, д. 8'),
('г. Челябинск, ул. Кирова, д. 78'),
('г. Омск, ул. Ленина, д. 10'),
('г. Самара, ул. Куйбышева, д. 95'),
('г. Уфа, пр-т Октября, д. 25'),
('г. Красноярск, ул. Карла Маркса, д. 48'),
('г. Воронеж, ул. Плехановская, д. 10'),
('г. Пермь, ул. Ленина, д. 35'),
('г. Волгоград, пр-т Ленина, д. 25'),
('г. Краснодар, ул. Красная, д. 100'),
('г. Саратов, ул. Московская, д. 5'),
('г. Тюмень, ул. Республики, д. 50'),
('г. Ижевск, ул. Пушкинская, д. 150'),
('г. Барнаул, ул. Ленина, д. 30'),
('г. Иркутск, ул. Литвинова, д. 16'),
('г. Ульяновск, ул. Гончарова, д. 25'),
('г. Хабаровск, ул. Муравьева-Амурского, д. 5'),
('г. Ярославль, ул. Кирова, д. 10'),
('г. Владивосток, ул. Светланская, д. 25'),
('г. Махачкала, ул. Даниялова, д. 30'),
('г. Томск, пр-т Ленина, д. 50'),
('г. Кемерово, пр-т Советский, д. 35'),
('г. Рязань, ул. Почтовая, д. 45'),
('г. Астрахань, ул. Советская, д. 15'),
('г. Набережные Челны, пр-т Мира, д. 20'),
('г. Пенза, ул. Московская, д. 50'),
('г. Липецк, пр-т Победы, д. 25'),
('г. Киров, ул. Воровского, д. 40');


INSERT INTO orders (order_number, user_id, order_date, delivery_date, pickup_point_id, customer_name, receive_code, status) VALUES 
('1001', 6, '2025-02-15 00:00:00', '2025-02-20 00:00:00', 3, 'Белов Алексей Дмитриевич', 'Z1X9Y2', 'Доставлен'),
('1002', 7, '2025-02-16 00:00:00', '2025-02-21 00:00:00', 7, 'Соколова Мария Андреевна', 'A3B4C5', 'Доставлен'),
('1003', 8, '2025-02-18 00:00:00', '2025-02-23 00:00:00', 12, 'Морозов Иван Павлович', 'D6E7F8', 'Доставлен'),
('1004', 9, '2025-02-20 00:00:00', '2025-02-25 00:00:00', 5, 'Лебедева Ольга Васильевна', 'G9H0I1', 'Доставлен'),
('1005', 6, '2025-03-01 00:00:00', '2025-03-06 00:00:00', 18, 'Белов Алексей Дмитриевич', 'J2K3L4', 'В обработке'),
('1006', 7, '2025-03-02 00:00:00', '2025-03-07 00:00:00', 22, 'Соколова Мария Андреевна', 'M5N6O7', 'В обработке'),
('1007', 8, '2025-03-03 00:00:00', '2025-03-08 00:00:00', 9, 'Морозов Иван Павлович', 'P8Q9R0', 'В обработке'),
('1008', 9, '2025-03-04 00:00:00', '2025-03-09 00:00:00', 31, 'Лебедева Ольга Васильевна', 'S1T2U3', 'В обработке'),
('1009', 6, '2025-03-05 00:00:00', '2025-03-10 00:00:00', 14, 'Белов Алексей Дмитриевич', 'V4W5X6', 'Новый'),
('1010', 7, '2025-03-06 00:00:00', '2025-03-11 00:00:00', 27, 'Соколова Мария Андреевна', 'Y7Z8A9', 'Новый');


INSERT INTO order_items (order_id, book_id, quantity, unit_price) VALUES 
-- Заказ 1001: B112F4, 1, F635R4, 2
(1, (SELECT book_id FROM books WHERE article = 'B112F4'), 1, (SELECT discount_price FROM books WHERE article = 'B112F4')),
(1, (SELECT book_id FROM books WHERE article = 'F635R4'), 2, (SELECT price FROM books WHERE article = 'F635R4')),

-- Заказ 1002: H782T5, 1, G783F5, 1
(2, (SELECT book_id FROM books WHERE article = 'H782T5'), 1, (SELECT discount_price FROM books WHERE article = 'H782T5')),
(2, (SELECT book_id FROM books WHERE article = 'G783F5'), 1, (SELECT price FROM books WHERE article = 'G783F5')),

-- Заказ 1003: J384T6, 1, D572U8, 1
(3, (SELECT book_id FROM books WHERE article = 'J384T6'), 1, (SELECT discount_price FROM books WHERE article = 'J384T6')),
(3, (SELECT book_id FROM books WHERE article = 'D572U8'), 1, (SELECT discount_price FROM books WHERE article = 'D572U8')),

-- Заказ 1004: F572H7, 1, D329H3, 1
(4, (SELECT book_id FROM books WHERE article = 'F572H7'), 1, (SELECT price FROM books WHERE article = 'F572H7')),
(4, (SELECT book_id FROM books WHERE article = 'D329H3'), 1, (SELECT discount_price FROM books WHERE article = 'D329H3')),

-- Заказ 1005: B112F4, 2, F635R4, 1
(5, (SELECT book_id FROM books WHERE article = 'B112F4'), 2, (SELECT discount_price FROM books WHERE article = 'B112F4')),
(5, (SELECT book_id FROM books WHERE article = 'F635R4'), 1, (SELECT price FROM books WHERE article = 'F635R4')),

-- Заказ 1006: H782T5, 1, G783F5, 2
(6, (SELECT book_id FROM books WHERE article = 'H782T5'), 1, (SELECT discount_price FROM books WHERE article = 'H782T5')),
(6, (SELECT book_id FROM books WHERE article = 'G783F5'), 2, (SELECT price FROM books WHERE article = 'G783F5')),

-- Заказ 1007: J384T6, 3, D572U8, 1
(7, (SELECT book_id FROM books WHERE article = 'J384T6'), 3, (SELECT discount_price FROM books WHERE article = 'J384T6')),
(7, (SELECT book_id FROM books WHERE article = 'D572U8'), 1, (SELECT discount_price FROM books WHERE article = 'D572U8')),

-- Заказ 1008: F572H7, 1, D329H3, 2
(8, (SELECT book_id FROM books WHERE article = 'F572H7'), 1, (SELECT price FROM books WHERE article = 'F572H7')),
(8, (SELECT book_id FROM books WHERE article = 'D329H3'), 2, (SELECT discount_price FROM books WHERE article = 'D329H3')),

-- Заказ 1009: B320R5, 1, G432E4, 1
(9, (SELECT book_id FROM books WHERE article = 'B320R5'), 1, (SELECT price FROM books WHERE article = 'B320R5')),
(9, (SELECT book_id FROM books WHERE article = 'G432E4'), 1, (SELECT discount_price FROM books WHERE article = 'G432E4')),

-- Заказ 1010: S213E3, 1, E482R4, 1
(10, (SELECT book_id FROM books WHERE article = 'S213E3'), 1, (SELECT price FROM books WHERE article = 'S213E3')),
(10, (SELECT book_id FROM books WHERE article = 'E482R4'), 1, (SELECT discount_price FROM books WHERE article = 'E482R4'));


UPDATE orders o
SET total_amount = (
    SELECT SUM(subtotal) 
    FROM order_items oi 
    WHERE oi.order_id = o.order_id
);

CREATE VIEW book_catalog AS
SELECT 
    b.book_id,
    b.article,
    b.title,
    a.name as author_name,
    g.name as genre_name,
    p.name as publisher_name,
    b.publication_year,
    b.price,
    b.discount_price,
    b.is_on_discount,
    b.stock_quantity,
    b.description,
    b.cover_image,
    b.is_available
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN genres g ON b.genre_id = g.genre_id
JOIN publishers p ON b.publisher_id = p.publisher_id;

CREATE VIEW order_details AS
SELECT 
    o.order_id,
    o.order_number,
    o.order_date,
    o.delivery_date,
    u.full_name as customer_name,
    u.login as customer_email,
    pp.address as pickup_address,
    o.receive_code,
    o.status,
    o.total_amount,
    COUNT(oi.order_item_id) as items_count
FROM orders o
JOIN users u ON o.user_id = u.user_id
JOIN pickup_points pp ON o.pickup_point_id = pp.point_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id;


CREATE VIEW manager_orders AS
SELECT 
    o.order_id,
    o.order_number,
    o.order_date,
    o.status,
    o.total_amount,
    o.customer_name,
    pp.address as pickup_point,
    o.receive_code
FROM orders o
JOIN pickup_points pp ON o.pickup_point_id = pp.point_id;


DELIMITER //


CREATE PROCEDURE SearchBooks(
    IN search_term VARCHAR(255),
    IN genre_filter INT,
    IN author_filter INT,
    IN publisher_filter INT,
    IN min_price DECIMAL(10,2),
    IN max_price DECIMAL(10,2),
    IN on_discount_only BOOLEAN,
    IN in_stock_only BOOLEAN
)
BEGIN
    SELECT *
    FROM book_catalog
    WHERE (search_term IS NULL OR title LIKE CONCAT('%', search_term, '%') OR author_name LIKE CONCAT('%', search_term, '%'))
    AND (genre_filter IS NULL OR genre_id = genre_filter)
    AND (author_filter IS NULL OR author_id = author_filter)
    AND (publisher_filter IS NULL OR publisher_id = publisher_filter)
    AND (min_price IS NULL OR price >= min_price)
    AND (max_price IS NULL OR price <= max_price)
    AND (NOT on_discount_only OR is_on_discount = TRUE)
    AND (NOT in_stock_only OR stock_quantity > 0)
    AND is_available = TRUE
    ORDER BY title;
END//

CREATE PROCEDURE CreateOrder(
    IN p_user_id INT,
    IN p_pickup_point_id INT,
    IN p_customer_name VARCHAR(255),
    IN p_receive_code VARCHAR(50),
    OUT p_order_id INT
)
BEGIN
    DECLARE order_num VARCHAR(50);

    SET order_num = CONCAT('ORD-', YEAR(NOW()), '-', LPAD((SELECT COUNT(*) + 1 FROM orders WHERE YEAR(order_date) = YEAR(NOW())), 4, '0'));
    
    INSERT INTO orders (order_number, user_id, order_date, delivery_date, pickup_point_id, customer_name, receive_code, status)
    VALUES (order_num, p_user_id, NOW(), DATE_ADD(NOW(), INTERVAL 5 DAY), p_pickup_point_id, p_customer_name, p_receive_code, 'Новый');
    
    SET p_order_id = LAST_INSERT_ID();
END//

DELIMITER ;

CREATE INDEX idx_books_search ON books(title, article);
CREATE INDEX idx_books_availability ON books(is_available, stock_quantity);
CREATE INDEX idx_books_discount ON books(is_on_discount, price);
CREATE INDEX idx_orders_dates ON orders(order_date, status);
CREATE INDEX idx_orders_customer ON orders(customer_name);
CREATE INDEX idx_users_role ON users(role_id, is_active);

SHOW TABLES;

SELECT 
    (SELECT COUNT(*) FROM users) as total_users,
    (SELECT COUNT(*) FROM books) as total_books,
    (SELECT COUNT(*) FROM orders) as total_orders,
    (SELECT COUNT(*) FROM order_items) as total_order_items;

SELECT 
    r.name as role,
    COUNT(u.user_id) as users_count
FROM roles r
LEFT JOIN users u ON r.role_id = u.role_id
GROUP BY r.role_id, r.name;

SELECT 'База данных "Книжный Мир" успешно создана и заполнена!' as result;
SELECT 'Доступы для тестирования:' as info;
SELECT 'Администраторы: a.orlova@bookworld.ru / d.volkov@bookworld.ru' as admin_access;
SELECT 'Менеджеры: i.semenova@bookworld.ru / m.kozlov@bookworld.ru / t.nikolaeva@bookworld.ru' as manager_access;
SELECT 'Клиенты: a.belov@example.com / m.sokolova@example.com / i.morozov@example.com / o.lebedeva@example.com' as client_access;
SELECT 'Пароли: как указано в Excel-файле' as password_note;
