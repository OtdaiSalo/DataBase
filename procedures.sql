use bookdb;
drop procedure if exists addUser;
drop procedure if exists getUsersBookRelation;


create procedure addUser(
    IN login_param varchar(20),
    IN surname_param varchar(20),
    IN name_param varchar(20),
    IN birth_date_param varchar(20),
    IN address_param varchar(20),
    IN rating_param int)
begin
    insert into users
    (login, surname, name, birth_date, address, rating)
    values
    (login_param, surname_param, name_param, birth_date_param, address_param, rating_param)
end;

create procedure getUsersBookRelation(
    IN user_id_param int(11),
    IN book_id_param int(11)
)
begin
    select users.name, users.surname, group_concat(books.name)
        from users_book
        where users_book.user_id = user_id_param and users_book.book_id = book_id_param
end;