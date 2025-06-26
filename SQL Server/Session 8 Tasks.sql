create or alter view vw_EmployeeBasicInfo(EmpID,EmpFullName, EmpEmail, EmpJobTitle, EmpDepartment)
as
select 
EmployeeID,
concat(FirstName, ' ', LastName),
Email,
JobTitle,
DepartmentName
from Employee join Department
on Employee.Dept_ID = Department.ID

select * from dbo.vw_EmployeeBasicInfo



create or alter view vw_HighSalaryEmployees(EmpID,EmpFullName, EmpSalary, EmpDepartment)
as
select
EmployeeID,
concat(FirstName, ' ', LastName),
Salary,
DepartmentName
from Employee join Department
on Employee.Dept_ID = Department.ID
where Salary > (select avg(salary) from Employee)

select * from vw_HighSalaryEmployees


create or alter proc sp_GetEmployeeDetails @EmployeeID int
whith encryption
as 
select
EmployeeID,
concat(FirstName, ' ', LastName),
Email,
JobTitle,
DepartmentName
from Employee join Department
on Employee.Dept_ID = Department.ID
where EmployeeID = @EmployeeID


create or alter proc sp_AddNewEmployee @FirstName varchar(max), @LastName varchar(max), @Email varchar(50), @HireDate date, @JobTitle varchar(max), @DepartmentID int, @Salary int
with encryption
as
begin
begin try
Insert into Employee(First_Name, Last_Name, Email, Hire_Date, Job_Title, Department_ID, Salary)
values (@FirstName, @LastName, @Email, @HireDate, @JobTitle, @DepartmentID, @Salary)
end try

begin catch
select 'Sorry this Employee cant be inserted'
end catch
end

exec proc sp_AddNewEmployee 'Ahmed', 'Mohamed','ahmed@gmail.com','2025-1-1','Backend Developer', 20 , 2500