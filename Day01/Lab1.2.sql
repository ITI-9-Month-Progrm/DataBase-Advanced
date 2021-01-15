create schema newUser 

alter schema newUser transfer Course

alter schema newUser transfer Student

select * from newUser.Course

select * from newUser.Student

update newUser.Student
set St_Fname='Lila'
where St_Id=1