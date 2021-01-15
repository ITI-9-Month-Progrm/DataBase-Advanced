-------------------------Part 1 -----------
--Q1
create function getMonth (@date date) returns varchar(10)
			begin
			declare @monthName varchar(10)
			select @monthName = FORMAT(@date,'MMMM')
			return @monthName
			end

declare @d date
set @d='2021.1.11'
select dbo.getMonth(@d) as nameOfMonth

--Q2
create function getRange(@num1 int ,@num2 int) returns @range table( numValue int )
		as
			begin  
			while @num1!= @num2-1
				begin
				     set @num1+=1
					insert into @range
					select @num1
				end
				return 
			end
	
select * from dbo.getRange(1,10)

--Q3
alter function getDeptInfo(@studNum int)returns table
as
return(
  select Dept_Name,St_Fname+' '+St_Lname as fullName
  from Student
  inner join dbo.Department on dbo.Department.Dept_Id=Student.Dept_Id
  where Student.St_Id=@studNum
)

select * from dbo.getDeptInfo(1)

--Q4

alter function displayMessage(@studId int) returns varchar(100)
			begin
				declare @Fname varchar(10)
				declare @Lname varchar(10)
				declare @message varchar(100)
				select @Fname=Student.St_Fname,@Lname=Student.St_Lname
				from Student
				where Student.St_Id=@studId
					if @Fname = null and @Lname = null
					   set @message='First name & last name are null'
					if @Fname = null and @Lname != null
					   set @message= 'first name is null'
					if @Fname != null and @Lname = null
					    set @message= 'last name is null'
					if @Fname != null and @Lname != null
					   set @message= 'First name & last name are not null'
			return @message
			end

select  dbo.displayMessage(11) as Message

--Q5

create function getInfo(@hd date) returns table
as return(
select Department.Dept_Name,Instructor.Ins_Name as Manager_Name ,Department.Manager_hiredate
from Department
inner join Instructor on Department.Dept_Id=Instructor.Dept_Id
where Department.Manager_hiredate=@hd
)
select * from dbo.getInfo('2000.01.01')

--Q6

create function getStudentName(@format nvarchar(50)) 
returns @t table
		(
		
		 student_name nvarchar(50)
		)
as
begin
	if @format='full name'
		insert @t
		select isnull(St_Fname,'Fname is empty')+' '+isnull(St_Lname,'Lname is empty') 
		from Student
	else
	if @format='first name'
		insert  into @t
		select isnull(St_Fname,'Fname is empty')
		from Student
	else
	if @format='last name'
		insert  into @t
		select isnull(St_Lname,'Lname is empty') 
		from Student
return
end

select * from dbo.getStudentName('full name')

--Q7

create function getStudInfo() returns 
@t table(
   student_number int,
   student_name nvarchar(50)
)
as
	begin
		insert into @t
		select St_Id,SUBSTRING(St_Fname, 1, LEN(St_Fname)-1) from Student
	return
	end
select * from dbo.getStudInfo()

--Q8

declare @col varchar(1) 
set @col = '*'
declare @t varchar(50)
set @t = 'Student'
execute ('select ' + @col + 'from ' + @t)

---------------------------Part 2 WithOut Bouns----------------------

--Q1

create function getEmployees(@projectNum varchar(5)) returns table
as return(
	select HR.Employee.EmpFname+' '+HR.Employee.EmpLname as EmpName
	from dbo.Works_on
	inner join HR.Employee on dbo.Works_on.EmpNo = HR.Employee.EmpNo
	where dbo.Works_on.ProjectNo=@projectNum
	)


select * from dbo.getEmployees('p1')


