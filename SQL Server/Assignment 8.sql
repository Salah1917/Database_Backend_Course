----------------------------------------------Part 1---------------------------------------------------------------
use IKEA_Company
select * from Works_on
select * from HR.Project
select * from HR.Employee

--using the previous view try enter new department data where dept# is ’d4’ and dept name is ‘Development’
-- i dont have the previous view

--Create view name “v_2006_check” that will display employee Number, the project Number where he works and the date of joining the project which must be from the first of January and the last of December 2006.this view will be used to insert data so make sure that the coming new data must match the condition
create view v_2006_check
as
select EmpNo, w.ProjectNo, Enter_Date
from Works_on w join HR.Project p
on w.ProjectNo = p.ProjectNo
where 
    Enter_Date between '2006-01-01' and '2006-12-31'
with check option


----------------------------------------------Part 2---------------------------------------------------------------
select * from Department
select * from Student
-- 1. Create a stored procedure to show the number of students per department.[use ITI DB] 
create or alter proc calcNumberOfStudents
as
begin 
select Dept_Name, count(St_Id)
from Department left join Student
on Department.Dept_Id = Student.Dept_Id
        group by Dept_Name;
end

exec calcNumberOfStudents


select * from Works_for
-- 2. Create a stored procedure that will check for the Number of employees in the project 100
--if they are more than 3 print message to the user “'The number of employees in the project 100 is 3 or more'”
--if they are less display a message to the user “'The following employees work for the project 100'” in
--addition to the first name and last name of each one. [MyCompany DB] 
create or alter proc employeeCheck
as
begin

declare @number int
select @number = count(*) from Works_for where Pno = 100
if @number > 3 select 'The number of Employees in the project 100 is 3 or more'
else select 'The following employees work for the project 100', Fname, Lname 
from Employee
join Works_for
on Employee.SSN = Works_for.ESSn
where Pno = 100

end

exec employeeCheck


-- 3. Create a stored procedure that will be used in case an old employee has left the project and a new one
--becomes his replacement. The procedure should take 3 parameters (old Emp. number, new Emp.
--number and the project number) and it will be used to update works_on table. [MyCompany DB]
create or alter proc replaceEmployee @oldEmp int, @newEmp int, @projectNum int
as
begin
update Works_for
set ESSn = @newEmp
where Pno = @projectNum and ESSn = @oldEmp
end

exec replaceEmployee @oldEmp = 0, @newEmp = 0, @projectNum = 0;


----------------------------------------------------------Part 3----------------------------------------------------
-- 1. Create a stored procedure that calculates the sum of a given range of numbers
create or alter proc rangeSum @start int, @end int
as begin
declare @sum int = 0
declare @i int = 0
 while @i <= @end
  begin
   set @sum += @i;
   set @i += 1;
  end
  select @sum
end

exec rangeSum @start = 2, @end = 10



-- 2. Create a stored procedure that calculates the area of a circle given its radius
create or alter proc circleArea @radius float
as
begin
declare @area float
set @area = @radius * @radius * 3.14
select @area

end

exec circleArea @radius = 1.5


-- 3. Create a stored procedure that calculates the age category based on a person's age
--( Note: IF Age < 18 then Category is Child and if  Age >= 18 AND Age < 60 then Category is Adult otherwise  Category is Senior)
create or alter proc ageCategory @age int
as
begin
    declare @category varchar(20);

    if @age < 18
        set @category = 'Child';
    else if @age < 60
        set @category = 'Adult';
    else
        set @category = 'Senior';

    select @category
end

exec ageCategory @age = 20

-- 4. Create a stored procedure that determines the maximum, minimum, and average of a given set of numbers
--( Note : set of numbers as Numbers = '5, 10, 15, 20, 25')
-- i could not do it

--------------------------------------------------Part 4----------------------------------------------------------
--Create a trigger to prevent anyone from inserting a new record in the Department table
--( Display a message for user to tell him that he can’t insert a new record in that table )
use ITI
create or alter trigger departmentTrigger
on Department
instead of insert
as 
select 'You can not insert in this table'


--Create a table named “StudentAudit”. Its Columns are (Server User Name , Date, Note) 
create table StudentAudit (
    ServerUserName NVARCHAR(max) not null,
    [Date] DATE not null,
    Note NVARCHAR(MAX)
)

--Create a trigger on student table instead of delete to add Row in StudentAudit table 
--The Name of User Has Inserted the New Student
--Current  Date
--Note that will be like “try to delete Row with id = [Student Id]” 
create or alter trigger insteadOfDeletingStudent
on Student
instead of delete
as 
begin
insert into StudentAudit(ServerUserName, [Date], Note)
select SYSTEM_USER, cast(GETDATE() as Date), 'Tried to delete student with id = '+ cast(St_Id as varchar(5)) from deleted

end
