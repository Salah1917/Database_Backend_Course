Use ITI
-- 1. Create a scalar function that takes a date and returns the Month name of that date.
create or alter function returnMonthNameFromDate(@date date)
returns varchar(20)
as
begin
declare @month varchar(20)
set @month = format(@date, 'MMMM')
return @month
end

select dbo.returnMonthNameFromDate('2025-11-11') as month_name


-- 2. Create a multi-statements table-valued function that takes 2 integers and returns the values between them.
create or alter function numbersInbetween(@num1 int, @num2 int)
returns @numbers table (number int)
as
begin

declare @i int = @num1 + 1

while @i < @num2
begin
insert into @numbers values(@i)
set @i = @i + 1
end

return
end

select * from dbo.numbersInbetween(6,9)


-- 3. Create a table-valued function that takes Student No and returns Department Name with Student full name.
create or alter function studentInfo(@St_No int)
returns @studentData table (Student_ID int, Dept_Name varchar(50), Student_Name varchar(50))
as
begin
insert into @studentData
select St_Id, Dept_Name, concat(St_Fname,' ',St_Lname)
from Student join Department
on Student.Dept_Id = Department.Dept_Id
where St_Id = @St_No

return
end

select * from dbo.studentInfo(3)


-- 4. Create a scalar function that takes Student ID and returns a message to user.
/*a. If first name and Last name are null, then display 'First name & last name are null
b. If First name is null, then display 'first name is null'
c. If Last name is null, then display 'last name is null.'
d. Else display 'First name & last name are not null'*/
create or alter function studentName(@St_No int)
returns varchar(50)
begin
declare @message varchar(50)
if(select St_Fname from Student where St_ID = @St_No) is null and (select St_Lname from Student where St_ID = @St_No) is null
set @message = 'Both First and Last Name are null'
else if (select St_Fname from Student where St_ID = @St_No) is not null and (select St_Lname from Student where St_ID = @St_No) is null
set @message = 'Last Name is null'
else if (select St_Fname from Student where St_ID = @St_No) is null and (select St_Lname from Student where St_ID = @St_No) is not null
set @message = 'First Name is null'
else
set @message = 'Both Names are not null'
return @message
end

select dbo.studentName(13) as [message]


--Create a function that takes an integer which represents the format of the Manager hiring date and displays department name,
--Manager Name and hiring date with this format.
--I dont understand this question


-- Create multi-statement table-valued function that takes a string.
-- a.If first name and Last name are null, then display 'First name & last name are null
-- b.If First name is null, then display 'first name is null'
-- c.If Last name is null, then display 'last name is null.'
-- d. Else display 'First name & last name are not null'
--Note: Use “ISNULL” function
create or alter function studentName2(@St_No int)
returns varchar(50)
begin

declare @message varchar(50)
declare @fname varchar(50)
declare @lname varchar(50)

select 
        @fname = St_Fname,
        @lname = St_Lname
    from Student
    where St_ID = @St_No;

if isnull(@fname, '') = '' and isnull(@lname, '') = ''
set @message = 'Both First and Last Name are null'
else if isnull(@fname, '') != '' and isnull(@lname, '') = ''
set @message = 'Last Name is null'
else if isnull(@fname, '') = '' and isnull(@lname, '') != ''
set @message = 'First Name is null'
else
set @message = 'Both Names are not null'
return @message
end

select dbo.studentName2(13) as [message]

--7.Create function that takes project number and display all employees in this project (Use My Company DB)
use MyCompany

create or alter function employeesByProjectNumber(@projectNo int)
returns @employees table (Fname varchar(50), Lname varchar(50), SSN int, Bdate date, [Address] varchar(50), Sex varchar(1), Salary int, Superssn int, Dno int, ESSN int, Pno int, [Hours] int)
as
begin 
insert into @employees
select *
from dbo.Employee join dbo.Works_for
on dbo.Employee.SSN = dbo.Works_for.ESSN
where Pno = @projectNo
return 
end
select * from dbo.employeesByProjectNumber(100)

--Part 01 (Views)
use ITI

select * from Instructor
select * from Ins_Course
select * from Course
select * from Student
select * from Stud_Course
-- a) Create a view that displays the student's full name, course name if the student has a grade more than 50.
create or alter view studentData
as
select concat(St_Fname, ' ', St_Lname), Crs_Name
from Student
join Stud_Course on Student.St_Id = Stud_Course.St_Id
join Course on Stud_Course.Crs_Id = Course.Crs_Id
where Grade > 50

-- b) Create an Encrypted view that displays manager names and the topics they teach.
create or alter view instructorData
as
select Ins_Name, Crs_Name
from Instructor
join Ins_Course on Instructor.Ins_Id = Ins_Course.Ins_Id
join Course on Ins_Course.Crs_Id = Course.Crs_Id

-- c) Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department using Schema binding and describe the meaning of Schema Binding.
-- I tried and failed

-- d) Create a view “V1” that displays student data for students who live in Alex or Cairo
create or alter view cairoAndAlexStudents
as
select *
from Student
where St_Address in ('Cairo', 'Alex')



use IKEA_Company
select * from Company.Department
select * from dbo.AuditTable1
select * from dbo.Department
select * from dbo.Works_on
select * from HR.Employee
select * from HR.Project

-- a) Create a view named “v_clerk” that will display employee Number, project Number, the date of hiring of all the jobs of the type 'Clerk'.
create or alter view v_clerk
as
select EmpNo, ProjectNo, Enter_Date
from dbo.Works_on
where Job = 'Clerk'


-- b) Create view named “v_without_budget” that will display all the projects data without budget.
create or alter view v_without_budget
as
select * from HR.Project
where Budget is null

-- c) Create view named “v_count” that will display the project name and the Number of jobs in it.
create or alter view v_count
as
select ProjectName, count(Job) as Number_Of_Jobs
from HR.Project left join dbo.Works_on
on HR.Project.ProjectNo = dbo.Works_on.ProjectNo
group by ProjectName

-- d) Create a view named “v_project_p2” that will display the emp#s for the project# ‘p2’. (use the previously created view “v_clerk”)
create or alter view v_project_p2
as

-- e) Modify the view named “v_without_budget” to display all DATA in project p1 and p2.
alter view v_without_budejet
as
select * from HR.Project
where ProjectNo in (1,2)

-- f) Delete the views “v_clerk” and “v_count”.
drop view v_clerk
drop view v_count

-- g) Create view that will display the emp# and emp last name who works on deptNumber ‘d2’.
create or alter view v_empDetails
as
select EmpNo, EmpLname
from HR.Employee
where DeptNo = 2

-- h) Display the employee lastname that contains letter “J” (Use the previous view created in Q#g).
select * from v_empDetails
where EmpLname like '%J%'

-- i) Create view named “v_dept” that will display the department# and department name
create or alter view v_dept
as
select DeptNo, DeptName
from Company.Department



