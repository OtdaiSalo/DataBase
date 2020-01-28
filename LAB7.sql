USE `kahaniak_12_18`;


-- 1. Забезпечити цілісність значень для структури БД.
DELIMITER //

CREATE TRIGGER BeforeInsertPasswordChekFK
BEFORE INSERT
ON `password` FOR EACH ROW
BEGIN
	IF(new.user_id NOT IN (SELECT id FROM `user`)) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'CHECK error for INSERT: foreign key failure. User doesn`t exist';
	END IF;
    IF (new.user_id IN (SELECT user_id FROM `password`)) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'CHECK error for INSERT: foreign key failure. Password with same user already exists';
    END IF;
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER BeforeUpdatePasswordChekFK
BEFORE UPDATE
ON `password` FOR EACH ROW 
BEGIN
	IF(new.user_id NOT IN (SELECT id FROM `user`)) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'CHECK error for UPDATE: foreign key failure. User with this id doesn`t exist';
	END IF;
    IF (new.user_id IN (SELECT user_id FROM `password`)) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'CHECK error for UPDATE: foreign key failure. Password with same user already exists';
    END IF;
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER BeforDeleteUserChekFK
BEFORE DELETE
ON `user` FOR EACH ROW 
BEGIN
	IF(old.id IN (SELECT user_id FROM `password`)) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'CHECK error for DELETE: foreign key failure. User has password';
	END IF;
    IF(old.id IN (SELECT user_id FROM `bookmark`)) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'CHECK error for DELETE: foreign key failure. User has bookmarks';
	END IF;
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER BeforeInsertBookMarkChekFK
BEFORE INSERT
ON `bookmark` FOR EACH ROW
BEGIN
	IF(new.book_id NOT IN (SELECT id FROM `book`)) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'CHECK error for INSERT: foreign key failure. Book whith this id doesn`t exist';
	END IF;
    IF(new.user_id NOT IN (SELECT id FROM `user`)) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'CHECK error for INSERT: foreign key failure. User whith this id doesn`t exist';
	END IF;
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER BeforeUpdateBookMarkChekFK
BEFORE UPDATE
ON `bookmark` FOR EACH ROW
BEGIN
	IF(new.book_id NOT IN (SELECT id FROM `book`)) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'CHECK error for UPDATE: foreign key failure. Book whith this id doesn`t exist';
	END IF;
    IF(new.user_id NOT IN (SELECT id FROM `user`)) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'CHECK error for UPDATE: foreign key failure. User whith this id doesn`t exist';
	END IF;
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER BeforeDeleteBookCheckFK
BEFORE DELETE
ON `book` FOR EACH ROW
BEGIN
	IF(old.id IN (SELECT book_id FROM `bookmark`)) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'CHECK error for DELETE: Book has bookmarks';
	END IF;
    IF(old.id IN (SELECT book_id FROM `link`)) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'CHECK error for DELETE: Book has links';
	END IF;
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER BeforeInsertLinkChekFK
BEFORE INSERT
ON `link` FOR EACH ROW
BEGIN
	IF(new.book_id NOT IN (SELECT id FROM `book`)) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'CHECK error for INSERT: foreign key failure. Book with this id doesn`t exist';
	END IF;
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER BeforeUpdateLinkChekFK
BEFORE UPDATE
ON `link` FOR EACH ROW
BEGIN
	IF(new.book_id NOT IN (SELECT id FROM `book`)) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'CHECK error for UPDATE: foreign key failure. Book with this id doesn`t exist';
	END IF;
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER BeforeInsertBookChekFK
BEFORE INSERT
ON `book` FOR EACH ROW
BEGIN 
	IF(new.catalog_tree_id NOT IN (SELECT id FROM catalog_tree)) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'CHECK error for INSERT: foreign key failure. Catalog tree with this id doesn`t exist';
	END IF;
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER BeforeUpdateBookChekFK
BEFORE UPDATE
ON `book` FOR EACH ROW
BEGIN 
	IF(new.catalog_tree_id NOT IN (SELECT id FROM catalog_tree)) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'CHECK error for UPDATE: foreign key failure. Catalog tree with this id doesn`t exist';
	END IF;
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER BeforeDeleteCatalogTreeChekFK
BEFORE DELETE
ON `catalog_tree` FOR EACH ROW
BEGIN 
	IF(old.id IN (SELECT catalog_tree_id FROM `book`)) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'CHECK error for DELETE: foreign key failure. Catalog tree has books';
	END IF;
    IF(old.id IN (SELECT catalog_tree_id FROM `catalog_tree`)) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'CHECK error for DELETE: foreign key failure. Catalog tree has others catalog trees';
	END IF;
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER BeforeInsertCatalogTreeChekFK
BEFORE INSERT
ON `catalog_tree` FOR EACH ROW
BEGIN 
	IF(new.catalog_tree_id NOT IN (SELECT id FROM `catalog_tree`)) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'CHECK error for INSERT: foreign key failure. Catalog tree with this id doesn`t exists';
	END IF;
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER BeforeUpdateCatalogTreeChekFK
BEFORE UPDATE
ON `catalog_tree` FOR EACH ROW
BEGIN 
	IF(new.catalog_tree_id NOT IN (SELECT id FROM `catalog_tree`)) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'CHECK error for UPDATE: foreign key failure. Catalog tree with this id doesn`t exists';
	END IF;
END//

DELIMITER ;

-- ЗБЕРЕЖУВАНІ ПРОЦЕДУРИ

-- 1. Забезпечити параметризовану вставку нових значень у таблицю Паролі.
DELIMITER //

CREATE PROCEDURE ParInsertPassword( IN password VARCHAR(45) )
BEGIN
    INSERT INTO `password`(`password`, `user_id`)
    VALUES (password, 5);
END //

CALL ParInsertPassword('starchak')//

DELIMITER ;


-- 2. Створити пакет, який вставляє 10 стрічок в таблицю Книги у
-- форматі < Noname+No> , наприклад: Noname5, Noname6,
-- Noname7 і т.д. Решта полів можуть бути однаковими.
DELIMITER //

CREATE PROCEDURE Insert10RowBook()
BEGIN
    DECLARE num int;
    SET num = 1;
    WHILE num != 11 DO
		INSERT INTO `book`(`name`, `udk`, `rate`, `catalog_tree_id`, `author`) 
        VALUES(CONCAT('Noname', num), 100, 100, 1, 'Default Author');
        
        SET num = num + 1;
	END WHILE;
END //

CALL Insert10RowBook()//

DELIMITER ;


-- 3. Використовуючи курсор, забезпечити динамічне створення БД
-- з іменами Книг, з випадковою кількістю таблиць для кожної БД
-- (від 1 до 9). Структура таблиць довільна. Імена таблиць
-- відповідають імені Книги з порядковим номером від 1 до 9.
DELIMITER //

CREATE DEFINER=`root`@`localhost` PROCEDURE CreateNewDataBases()
BEGIN

DECLARE rand int;
DECLARE N int;
DECLARE done int DEFAULT false;
DECLARE name_book VARCHAR(45);

DECLARE book_cursor CURSOR
FOR SELECT name FROM `book`;
DECLARE CONTINUE HANDLER
FOR NOT FOUND SET done = true;

OPEN book_cursor;
myLoop: LOOP

 FETCH book_cursor INTO name_book;

 IF done=true THEN LEAVE myLoop;
 END IF;
 SET @temp_query_db = CONCAT('CREATE DATABASE `', name_book ,'`;');
 SET rand = RAND()*8 + 1;
 SET N = 1;
	
    PREPARE myquery FROM @temp_query_db;
	EXECUTE myquery;
     DEALLOCATE PREPARE myquery;

	WHILE N <= rand DO
		SET @temp_query_table = CONCAT('CREATE TABLE IF NOT EXISTS `', name_book,'`.`', name_book, N, '`(`name` VARCHAR(45) NOT NULL, `code` VARCHAR(45) NOT NULL, PRIMARY KEY (`name`));');
 		SET N = N + 1;
        
        PREPARE myquery_table FROM @temp_query_table;
		EXECUTE myquery_table;
		DEALLOCATE PREPARE myquery_table;
 	END WHILE;
END LOOP;

CLOSE book_cursor;

END//

CALL CreateNewDataBases//

DELIMITER ;


-- КОРИСТУВАЦЬКІ ФУНКЦІЇ

-- 1. Для таблиці Користувачі написати функцію як буде шукати
-- AVG стовпця Рейтинг . Потім зробити вибірку даних (SELECT)
-- більших за середнє значення, використовуючи дану функцію.
DELIMITER //

CREATE FUNCTION FuncUserFindAVGRate()
RETURNS decimal(10, 1)
DETERMINISTIC
BEGIN
	DECLARE N decimal(10, 1);
	SELECT AVG(rate) INTO N FROM User;
	RETURN N;
END//

SELECT * FROM User WHERE rate > FuncUserFindAVGRate()//

DELIMITER ;


-- 2. Написати функцію, яка витягує за ключем між таблицями
-- Паролі та Користувачі значення поля Пароль . Потім зробити
-- вибірку усіх даних (SELECT) з таблиці Користувачі,
-- використовуючи дану функцію.
DELIMITER //

CREATE FUNCTION FuncUserIDPassword(password_id int)
RETURNS nvarchar(45)
DETERMINISTIC
BEGIN
	RETURN (SELECT password FROM password WHERE id = password_id);
END//

SELECT *, FuncUserIDPassword(2) AS password FROM user//

DELIMITER ;


-- ТРИГЕРИ

-- 2. Користувачі → Прізвище не може починатися на букву 'Ю' чи 'Я' ;
DELIMITER //

CREATE TRIGGER UserChek
	BEFORE INSERT
    ON user FOR EACH ROW
BEGIN
	IF (new.surname RLIKE('^Я') OR new.surname RLIKE('^Ю')) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'Can\'t insert this surname with Ю, Я';
	END IF;
END//

DELIMITER ;


-- 3. у полі Користувачі→Місце народження допускається ввід
-- лише таких значень: 'Харків', 'Вінниця', 'Дніпро' та
-- 'Ужгород' .
DELIMITER //

CREATE TRIGGER CityChek
	BEFORE INSERT
    ON user FOR EACH ROW
BEGIN
	IF (new.birth_place NOT RLIKE("Харків") OR new.birth_place NOT RLIKE("Вінниця") OR new.birth_place NOT RLIKE("Дніпро") OR new.birth_place NOT RLIKE("Ужгород")) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'Can\'t insert this';
	END IF;
END//

DELIMITER ;

-- 4. Забезпечити максимальну кардинальність 5 стрічок для
-- таблиці Паролі.
DELIMITER //

CREATE TRIGGER PasswordCardinalityMax5 
	BEFORE INSERT
    ON password FOR EACH ROW
BEGIN
IF ((SELECT COUNT(*) FROM password) >= 5) THEN
    SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'CHECK error for Password: cardinality is > 5';
END IF;
END//

DELIMITER ;

