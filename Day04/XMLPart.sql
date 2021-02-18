--use SD32-Company Database 
--Q1 A 
select * from HR.Employee
for xml raw('Employee')
--Q1 B 
select * from HR.Employee
for xml raw('Employee'), elements, root('Employees')

--use ITI Database

alter view XMLData
WITH ENCRYPTION
as
select Department.Dept_Name,Ins_Name
from Department
inner join Instructor on Department.Dept_Id = Instructor.Dept_Id
--Error--
/*select * from XMLData
for xml auto,elements,root('ALLinstrauctor')
*/
--Q2 A
select Department.Dept_Name,Ins_Name
from Department
inner join Instructor on Department.Dept_Id = Instructor.Dept_Id
for xml auto,elements,root('ALLinstrauctor')

--Q2 B
select Department.Dept_Name "@Department_Name",
       Ins_Name "instructor"
from Department
inner join Instructor on Department.Dept_Id = Instructor.Dept_Id
for xml path('Departmen'), root('Instructors_inside_Department')

--Q3
--step1 create xml document
declare @docs xml ='<customers>
              <customer FirstName="Bob" Zipcode="91126">
                     <order ID="12221">Laptop</order>
              </customer>
              <customer FirstName="Judy" Zipcode="23235">
                     <order ID="12221">Workstation</order>
              </customer>
              <customer FirstName="Howard" Zipcode="20009">
                     <order ID="3331122">Laptop</order>
              </customer>
              <customer FirstName="Mary" Zipcode="12345">
                     <order ID="555555">Server</order>
              </customer>
       </customers>'

--step2 create handeler to pointer to root xml tree
declare @hdocs int
--step3 create xml tree
Exec sp_xml_preparedocument @hdocs output, @docs 
--step4 read xml tree and create table
SELECT * into customers
FROM OPENXML (@hdocs, '//customer')  --levels  XPATH Code
WITH (FirstName varchar(20) '@FirstName',
	  Zipcode int '@Zipcode', 
	  orderName varchar(10) 'order',
	  orderID int 'order/@ID'
	  )
--step5 delete xml tree from memory
Exec sp_xml_removedocument @hdocs
select * from customers
