USE [SD-32-company]

---Department Table---------------------------------------

create table Department(
DeptNo varchar(10) NOT NULL PRIMARY Key ,
DeptName varchar(50) NOT NULL,
Location varchar(50) NOT NULL, 
);

insert into Department(DeptNo,DeptName,Location)
values ('d1','Research','NY')
insert into Department(DeptNo,DeptName,Location)
values ('d2','Accounting','DS')
insert into Department(DeptNo,DeptName,Location)
values ('d3','Markiting','KW')

sp_addtype loc,'nchar(2)'

create rule deptRule1 as @x in ('NY','DS','KW')

create default def1 as 'NY'

sp_bindrule deptRule1,loc

sp_bindefault def1,loc

alter table Department
alter column Location loc 
---Employee Table---------------------------------------

create table Employee
(
EmpNo int not null primary key,
EmpFname varchar(50) not null,
EmpLname varchar(50) not null,
Salary int not null unique ,
DeptNo varchar(10) NOT NULL foreign key REFERENCES Department(DeptNo),
);

create rule EmpRule1 as @x <6000

sp_bindrule EmpRule1,'Employee.Salary'

insert into Employee(EmpNo,EmpFname,EmpLname,DeptNo,Salary)
values (10,'Asmaa','khaled','d1',2500)
select * from Employee
-----------Project Table------------------
create table Project(
ProjectNo varchar(10) not null primary key,
ProjectName varchar(50) not null ,
Budget int 
);

select * from Works_On
-----Error!!!!!!!!!!"Cannot insert the value NULL into column 'ProjectNo'---------------
insert into Works_On(EmpNo)
values(11111)
----------------------------------------------------------------------------------------\\
----------Error!!!!!!!!!"The UPDATE statement conflicted with the FOREIGN KEY constraint "FK_Works_On_Employee"---
update Works_On
set EmpNo=11111
where EmpNo=10102
-----------------------------------------------------------------------------------------------------------------------
update Employee
set EmpNo=22222
where EmpNo=10102

-----------------The Same Error---------------------------------------------------------------------------------------
delete from Employee where EmpNo=10102

-----------------------------------------------------------------------------------------------------------------------

alter table Employee
add TelephoneNumber  int 

alter table Employee
drop column TelephoneNumber   

-----Schemas---------------------------
create schema Company 

create schema Human_Resource

alter schema Company transfer Department
alter schema Company transfer Project
alter schema Human_Resource transfer Employee
--------answer Q3--------
----error
select * from sys.tables
sp_helpconstraint 'Employee'
--------------Answer Q4----------------

create synonym Emp
for  Human_Resource.Employee
  
Select * from Employee    --error
Select * from [Human Resource].Employee --error
Select * from Emp                        --true
Select * from [Human Resource].Emp  --error

--------------Answer Q5-----------
create synonym project
for  Company.Project
update project 
set Budget+=(Budget*0.1)
from project
INNER JOIN Works_On ON Works_On.ProjectNo=project.ProjectNo 
where EmpNo=10102

select * from project


-----------Answer Q6------------------------------------
create synonym department
for  Company.Department

update department
set department.DeptName='Sales'
from department
inner join Emp on Emp.DeptNo = department.DeptNo
where Emp.EmpFname='james' or Emp.EmpLname='james'

select * from department

--------------Answer Q7-----------------------------------------
create synonym work
for  dbo.Works_On

update work
set work.Enter_Date='12.12.2007'
from department
inner join Emp on Emp.DeptNo = department.DeptNo

where (department.DeptName='Sales' AND work.ProjectNo='p1')


--------------------Answer Q8--------------------------------------------
delete Works_on from Works_on  , Emp  ,  Company.Department
where  Works_on.EmpNo = Emp.EmpNo and Emp.DeptNo =Company.Department.DeptNo and Company.Department.Location = 'KW'
-------------------------------------------------------------------------