drop trigger if exists login_check_length;

create trigger login_check_length before insert on users 
for each row 
begin
    if LENGTH(NEW.login) < 6 
    then signal sqlstate '45000' set MESSAGE_TEXT = 'TriggerError: Login must be longer than 6';
    end if;
end;

drop trigger if exists login_check_name;
create trigger login_check_name before insert on users for each row begin
    if (NEW.login REGEXP '^[0-9]') then
        signal sqlstate '45000' set MESSAGE_TEXT = 'TriggerError: Login should start from alpha-symbols'
    end if;
end;

insert into users values (12235441, 'aa124asdawdddda', 'aaa', 'aaa', '22-06-2001', 'Lviv', 2);