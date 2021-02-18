---------------------Part 1 -----------------------------------------------

--Q1

create view vgetInfoStudent
as 
select St_Fname + ' ' + St_Lname as FullName,Grade,Crs_Name
from dbo.Student
inner join dbo.Stud_Course 
on dbo.Student.St_Id=dbo.Stud_Course.St_Id
inner join dbo.Course
on dbo.Course.Crs_Id=dbo.Stud_Course.Crs_Id
where Grade > 50 

select * from vgetInfoStudent

--Q2

alter view vgetInfoManger
with encryption
as
select Instructor.Ins_Name as MangerName , Topic.Top_Name
from Department
inner join Instructor
on Instructor.Ins_Id=Department.Dept_Manager
inner join Ins_Course
on Instructor.Ins_Id=Ins_Course.Ins_Id
inner join Course
on Ins_Course.Crs_Id=Course.Crs_Id
inner join Topic
on Course.Top_Id=Topic.Top_Id

select * from vgetInfoManger

--Q3
create view vInstructorName
with schemaBinding
as
select Ins_Name
from dbo.Instructor
inner join dbo.Department
on dbo.Department.Dept_Id= dbo.Instructor.Dept_Id
where dbo.Department.Dept_Name='SD' or dbo.Department.Dept_Name='Java'

select * from vInstructorName

--Q4

create view V1
as
select * from dbo.Student
where dbo.Student.St_Address='Cairo' or dbo.Student.St_Address='Alex'

select * from V1

create schema viewSchema

alter schema viewSchema transfer V1

select * from viewSchema.V1

--in this case it is not reached to dbo schema
Update V1 set St_Address='tanta'
Where St_Address='Alex';

--in this case i gift user permessin to avoid updating
Update viewSchema.V1 set St_Address='tanta'
Where St_Address='Alex';

--Q5

create nonclustered index hireDateIndex
on  Department(Manager_hiredate)

select * from Department where Manager_hiredate='2000-01-01'

--What will happen?
----it will create non clustered index that contain pointer for data in harddesk

--Q6

create unique nonclustered index studentAgeIndex
on Student(St_Age)

--What will happen?
--- it is Not run because St_Age Column allow duplicate values

--Q7

create table #Temp(
 empId int,
 empFname varchar(50),
 empLname varchar(50),
 empTask int 
 )

select * from #Temp

--Q8

create view gitEmpInfo
as 
select Company.Project.ProjectName,COUNT(Works_on.EmpNo) as numberOfEmployee
from Company.Project
inner join Works_on on Company.Project.ProjectNo=Works_on.ProjectNo
group by Company.Project.ProjectName

select * from gitEmpInfo

--Q9

create table Daily_Transaction(
userId int,
transactionAmount int
)

go

create table Last_Transaction(
userId int,
transactionAmount int
)

Merge into [dbo].[Daily_Transaction] as T 
using [dbo].[Last_Transaction] as S
On T.[userId]=S.[userId]

When matched then
update set T.transactionAmount=S.transactionAmount

When not matched by target Then 
insert(userId,transactionAmount)
values(S.userId,S.transactionAmount)

When not matched by Source
Then delete

Output $action,inserted.*,deleted.*;