--Q4 
 
create procedure displayStudentNumber 
with encryption
as
	select Department.Dept_Name,COUNT(Student.Dept_Id) as "StudentNumbers"
	from Department
	inner join Student on Department.Dept_Id=Student.Dept_Id
	group by Department.Dept_Name

--Execution
displayStudentNumber

--Q5 
--create view for displaying FName,LName of Employee
create view displayEmployeeInfo
with encryption
as
	select emp.EmpFname,emp.EmpLname
	from Company.Project p
	inner join Works_on w on p.ProjectNo=w.ProjectNo
	inner join HR.Employee emp on emp.EmpNo=w.EmpNo

create proc CheckEmpNum
with encryption
as
	declare @res int
	select @res = count(emp.EmpNo) 
	from Company.Project  p
	inner join Works_on work on p.ProjectNo=work.ProjectNo
	inner join HR.Employee emp on emp.EmpNo=work.EmpNo
	where p.ProjectNo='p1'
	group by(p.ProjectNo)

	if(@res > 3)
		begin
			select 'The number of employees in the project p1 is 3 or more'
			select * from displayEmployeeInfo
		end
	else
		begin
			select 'The following employees work for the project p1'
			select * from displayEmployeeInfo
		end
--Execution
CheckEmpNum

--Q6 
alter procedure updateEmployeeInfo @oldEmpNum int, @newEmpNum int, @projectNum varchar(5)
with encryption
as
	update Works_on
	set Works_on.EmpNo=@newEmpNum,Works_on.Enter_Date=getdate()
	where Works_on.EmpNo=@oldEmpNum and .Works_on.ProjectNo=@projectNum
--Execution
updateEmployeeInfo 18316,26348,'p1'

--Q7
--Create an Audit table
create table Audit(
	ProjectNo varchar(5),
	UserName  varchar(25),
	ModifiedDate date,
	Budget_Old int,
	Budget_New int
)

--create Procedure for insertion
create proc insertAuditData @ProjectNo varchar(5),@UserName  varchar(20),@ModifiedDate date,@Budget_Old int,@Budget_New int
with encryption
as
	insert into Audit values( @ProjectNo, @UserName, @ModifiedDate, @Budget_Old, @Budget_New)

--Excution
insertAuditData 'p2','Dbo','2008-01-31',95000,200000
select * from Audit
--create Trigger
alter trigger Company.budgetUpdate 
on Company.Project
after update
as
  if UPDATE(Budget)
	  begin
		declare @oldValue int
		select  @oldValue = Budget from deleted
		declare @newValue int
		declare @projectNo varchar(5)
		select  @newValue = Budget from inserted
		select @projectNo = ProjectNo from inserted
		declare @date date
		set @date=getdate()
		
		insert into dbo.Audit values( @projectNo,USER_NAME(),@date, @oldValue, @newValue)
		select 'Updates Done' as resultUpdate
	  end
update Company.Project
set Budget=240000
where ProjectNo='p1'
go
select * from Company.Project 

select * from Audit

--Q8
create trigger insertionDept
on Department
instead of insert
as 
	select 'You can’t insert a new record in that table'

select * from Department

insert into Department values(101,'SD','System Development','Smart',1,GETDATE())

--Q9

create trigger insertionEmp
on HR.Employee
instead of insert
as
   select 'You can’t insert a new record in that table'

select * from HR.Employee

insert into HR.Employee values(11111,'d2',2500,'Asmaa','Khaled')

--Q10
create table studentAudit(
server_user_name varchar(30),
UserName varchar(20),
Date date,
Note varchar(50)
) 


create trigger insertAudit 
on Student
after insert
as
	declare @userName varchar(20)
	select @userName = St_Fname from inserted
	declare @note varchar(50) 
	set @note = 'Awsime-Giza'
	insert into studentAudit values(SUSER_NAME(),@userName,GETDATE(),@note)


insert into Student values(1111,'Asmaa','Khaled','Giza',22,10,1)

select * from studentAudit

--Q11
alter trigger insertAuditWhenDelete 
on Student
instead of delete
as
	declare @userName varchar(20)
	select @userName = St_Fname from deleted
	declare @note varchar(50) 
	set @note = 'try to delete Row with Key'
	insert into studentAudit values(SUSER_NAME(),@userName,GETDATE(),@note)

delete from Student where St_Id=1111

select * from studentAudit