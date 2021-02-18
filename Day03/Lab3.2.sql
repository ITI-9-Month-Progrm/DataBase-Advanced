
--------------------------Part 2 ----------------------

--Q1

create view v_clerk 
as
select HR.Employee.EmpFname+' '+ HR.Employee.EmpLname as FullName,Company.Project.ProjectName,Works_on.Enter_Date
from HR.Employee
inner join Works_on on HR.Employee.EmpNo=Works_on.EmpNo
inner join Company.Project on Company.Project.ProjectNo=Works_on.ProjectNo
where Works_on.Job = 'Clerk'

select * from v_clerk

--Q2

create view v_withoutBudget
as
select ProjectNo,ProjectName
from Company.Project

select * from v_withoutBudget

--Q3

create view v_count
as
select ProjectName,COUNT(Works_on.Job) as NumberOfProject
from Company.Project
inner join Works_on on Company.Project.ProjectNo=Works_on.ProjectNo
group by ProjectName

select * from v_count

--Q4

alter view v_project_p2
as
select Company.Project.ProjectNo,COUNT(Works_on.EmpNo) as numberOfEmp
from Company.Project
inner join Works_on on Company.Project.ProjectNo=Works_on.ProjectNo
group by Company.Project.ProjectNo
having Company.Project.ProjectNo='p2'

select * from v_project_p2

--Q5
create view v_without_budget 
as
select ProjectNo  ,ProjectName 
from Company.Project where ProjectNo ='p1' or ProjectNo ='p2' 

select*from v_without_budget

--Q6
drop view v_clerk

drop view v_count

--Q7

create view  displayEmp 
as
select  EmpNo , EmpLname  
from HumanResource.Employee 
where HumanResource.Employee.DeptNo  ='d2'

select * from displayEmp

--Q8
create view  lastName
as
select EmpLname 
from displayEmp 
where SUBSTRING(  EmpLname,1 ,Len(EmpLname -1))='J'

--Q9

create view v_dept 
as
select DeptNo , DeptName 
from Company.Department

select *from v_dept

--Q10

insert into v_dept values('d4' , '‘Development’')

--Q11
create view v_2006_check
as
select EmpNo ,ProjectNo from Works_on
where Enter_Date between '1-1-2006' and '31-12-2006'

