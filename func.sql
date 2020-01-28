drop function if exists fetchStudents;

create function detailed(user_id int) returns varchar(100)
begin
    return (select group_concat(concat(name, ' ', surname) separator ';')
    from users where id = user_id);
end;

select detailed(4);

select * from references inner join group g on student.group_id = g.id
where (concat(name, number)) = fetchStudents(1);