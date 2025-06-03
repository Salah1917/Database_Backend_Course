------------------------------------------------------------------------Assignment 04--------------------------------------------------------------------------
----------------------------------------------------------------------------Part 1--------------------------------------------------------------------------
select * from Departments
select * from [Dependent]
select * from Employee
select * from Project
select * from Works_for


-- 1. Display all the employees Data.
select * from Employee

-- 2. Display the employee First name, last name, Salary and Department number.
select Fname, Lname, Salary, Dno from Employee

-- 3. Display all the projects names, locations and the department which is responsible for it.
select Pname, Plocation, Dname
from Project join Departments
on Project.Dnum = Departments.Dnum

-- 4. If you know that the company policy is to pay an annual commission for each employee with specific percent equals 10% of his/her annual salary. Display each employee full name and his annual commission in an ANNUAL COMM column (alias).
select Fname, Lname, Salary/10 'Annual Comm'
from Employee


-- 5. Display the employees Id, name who earns more than 1000 LE monthly.
select SSN, Fname
from Employee
where Salary > 1000

-- 6. Display the employees Id, name who earns more than 10000 LE annually.
select SSN, Fname
from Employee
where Salary > (1000/12)

-- 7. Display the names and salaries of the female employees 
select Fname, Salary
from Employee
where Sex = 'F'

-- 8. Display each department id, name which is managed by a manager with id equals 968574.
select Dnum, Dname
from Departments
where MGRSSN = 968574


-- 9. Display the ids, names and locations of the projects which are controlled with department 10. 
select Pnumber, Pname, Plocation
from Project
where Dnum = 10

----------------------------------------------------------------------------Part 2--------------------------------------------------------------------------
select * from Course
select * from Department
select * from Ins_Course
select * from Instructor
select * from Stud_Course
select * from Student
select * from Topic

-- 1. Get all instructors Names without repetition.
select distinct Ins_Name
from Instructor

-- 2. Display instructor Name and Department Name Note: display all the instructors if they are attached to a department or not.
select Ins_Name, Dept_Name
from Instructor join Department
on Instructor.Dept_Id = Department.Dept_Id

-- 3. Display student full name and the name of the course he is taking for only courses which have a grade.
select St_Fname, St_Lname
from Student join Stud_Course
on Student.St_Id = Stud_Course.St_Id
where grade is not null
-- you want 3 joins?

-- 4. Select Student first name and the data of his supervisor.
select St_Fname, Ins_Id, Ins_Name, Ins_Degree, Salary
from Student join Instructor
on Student.St_super = Instructor.Ins_Id



-- 5. Display student with the following Format. 
select St_ID 'Student ID', Concat ( St_Fname, ' ' ,St_Lname) 'Student Full Name', Dept_Name 'Department name'
from Student join Department
on Student.Dept_Id = Department.Dept_Id

----------------------------------------------------------------------------Part 3--------------------------------------------------------------------------
select * from Departments
select * from [Dependent]
select * from Employee
select * from Project
select * from Works_for

-- 1. Display the Department id, name and id and the name of its manager.
select Dname, Dnum, Fname, SSN
from Employee join Departments
on Employee.SSN = Departments.MGRSSN

-- 2. Display the name of the departments and the name of the projects under its control.
select Pname, Dname
from Project join Departments
on Project.Dnum = Departments.Dnum

-- 3. Display the full data about all the dependence associated with the name of the employee they depend on.
select Fname, ESSN, Dependent_name, D.Sex, D.Bdate
from Employee E join [Dependent] D
on E.SSN = D.ESSN

-- 4. Display the Id, name, and location of the projects in Cairo or Alex city.
select Pname, Pnumber, Plocation
from Project
where city in ('Alex','Cairo')


-- 5. Display the Projects full data of the projects with a name starting with "a" letter.
select *
from Project 
where Pname like 'a%'

-- 6. display all the employees in department 30 whose salary from 1000 to 2000 LE monthly
select *
from Employee
where Dno = 30 and Salary between 1000 and 2000

-- 7. Retrieve the names of all employees in department 10 who work more than or equal 10 hours per week on the "AL Rabwah" project.
select Fname
from Employee join Works_for
on Employee.SSN = Works_for.ESSn
where Pno = 200 and Hours >= 10 and Dno = 10

-- 8. Find the names of the employees who were directly supervised by Kamel Mohamed
select Fname, Lname
from Employee
where Superssn = 223344

-- 9. Display All Data of the managers
select *
from Employee right join Departments
on Employee.SSN = Departments.MGRSSN

-- 10. Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.
--select *
--from Employee join Project
--on Employee. = Project.Pnumber

-- 11. For each project located in Cairo City, find the project number, the controlling department name, 
--the department manager’s last name, address and birthdate.
--select Pnumber, Dname, Lname, [Address], bday

-- 12. Display All Employees data and the data of their dependents even if they have no dependents.
select *
from Employee left join [Dependent]
on Employee.SSN = [Dependent].ESSN

----------------------------------------------------------------------------Part 4--------------------------------------------------------------------------
select * from Departments
select * from [Dependent]
select * from Employee
select * from Project
select * from Works_for

-- DQL:
-- 1. Retrieve a list of employees and the projects they are working on ordered by department and within each department,
-- ordered alphabetically by last name, first name.
select E.fname, E.Lname, D.Dname, D.Dname, P.Pname
from Employee E join Works_for W 
ON E.SSN = W.ESSN
join Project P ON W.Pno = P.Pnumber
join  Departments D ON E.Dno = D.Dnum
order by D.Dname, E.lname, E.fname


-- 2. Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30% 	
update Employee
set salary = salary * 1.3
where ssn in 
(select ssn
from Employee join Works_for
on Employee.SSN = Works_for.ESSn
where Pno = 200)

-- DML:
-- 1. In the department table insert a new department called "DEPT IT”, with id 100, employee with SSN = 112233 as a manager for this department. The start date for this manager is '1-11-2006'.
insert into Departments
values('Dept IT', 100, 112233, 1-11-2006)

-- 2. Do what is required if you know that: Mrs. Oha Mohamed (SSN=968574) moved to be the manager of the new department (id = 100), and they give you (your SSN =102672) her position (Dept. 20 manager) 
-- a) First try to update her record in the department table.
update Departments
SET [MGRSSN] = 968574
WHERE MGRSSN = 112233

insert into Employee
values('Salah', 'Magdy', 102672 , 9-18-2004, 'Cairo', 'M', 1500, null, null)

-- b) Update your record to be department 20 manager.
update Departments
SET [MGRSSN] = 102672
WHERE MGRSSN = 968574

-- c) Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672)
update Employee
SET Superssn = 102672
WHERE SSN = 102660

-- 3. Unfortunately, the company ended the contract with Mr. Kamel Mohamed (SSN=223344) so try to delete him from your database in case you know that you will be temporarily in his position.
-- Hint: (Check if Mr. Kamel has dependents, works as a department manager, supervises any employees or works in any projects and handles these cases).
update [Dependent]
SET ESSN = 102672
WHERE ESSN = 223344

update Departments
SET MGRSSN = 102672
WHERE MGRSSN = 223344

update Employee
set Superssn = 102672
WHERE Superssn = 223344

delete from Employee
where SSN = 223344