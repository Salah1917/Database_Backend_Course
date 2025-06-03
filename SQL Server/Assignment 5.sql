select * from Topic
select * from Course
select * from Student
select * from Department
select * from Instructor


-----------------------------------------------------------------------Part 1-----------------------------------------------------------------------------------

-- 1. Retrieve a number of students who have a value in their age. 
select count(St_Age) from Student


-- 2. Display number of courses for each topic name
select Top_Name, count(*) as Num_Of_Courses
from Course inner join Topic on  Course.Top_Id = Topic.Top_Id
group by Top_Name

-- 3. Display student with the following Format (use isNull function)
select isnull(St_Id , 0) as Student_ID, Concat ( St_Fname, ' ' , isnull(St_Lname , '----')) as Student_Name , isnull(Dept_Name , '----') as Department_Name 
from Student left join Department on Student.Dept_Id = Department.Dept_Id

-- 4. Select instructor name and his salary but if there is no salary display value ‘0000’ . “use one of Null Function” 
select Ins_Name, isnull(Salary, '0000')
from Instructor

-- 5. Select Supervisor first name and the count of students who supervises on them
select A.St_Fname, count(A.St_Id)
from Student as A join Student as B on A.St_Id = B.St_super
group by A.St_Fname

-- 6. Display max and min salary for instructors
select Min(Salary) as Min_Salary, Max(Salary) as Max_Salary
from Instructor

-- 7. Select Average Salary for instructors
select Avg(Salary) as Average_Salary
from Instructor

-- 8. Display number of courses for each topic name
-- redundant go to question 2

-- 9. Select Supervisor first name and the count of students who supervises on them
-- redundant go to question 5

-- 10. Display instructors who have salaries less than the average salary of all instructors.
select Salary from Instructor
where Salary < (select Avg(Salary) from Instructor)

-- 11. Display the Department name that contains the instructor who receives the minimum salary
select Dept_Name from Instructor inner join Department on Instructor.Dept_Id = Department.Dept_Id
where Salary = (select Min(Salary) from Instructor)


-----------------------------------------------------------------------Part 2-----------------------------------------------------------------------------------
select * from Departments
select * from [Dependent]
select * from Employee
select * from Project
select * from Works_for


-- 1. For each project, list the project name and the total hours per week (for all employees) spent on that project.
select Pname, Sum(Hours) as Total_Hours
from Project join Works_for on Project.Pnumber = Works_for.Pno
group by Pname;

-- 2. For each department, retrieve the department name and the maximum, minimum and average salary of its employees
select Dname, Max(Salary) AS Max_Salary, Min(Salary) AS Min_Salary, Avg(Salary) as Avg_Salary
from Departments join Employee on Departments.Dnum = Employee.Dno
group by Dname;


-- 3. Display the data of the department which has the smallest employee ID over all employees' ID.
-- The employee in question doesnt have a department(null)
select * from Departments join Employee on Departments.Dnum = Employee.Dno
where Employee.SSN = (select Min(SSN) from Employee)

-- 4. List the last name of all managers who have no dependents
select Lname from Employee left join [Dependent] on Employee.SSN = [Dependent].ESSN
where SSN in (select Superssn from Employee where Superssn is not null) and SSN is null

-- 5. For each department-- if its average salary is less than the average salary of all employees display its number, name and number of its employees.
-- requires subquery

-- 6. Try to get the max 2 salaries using subquery.
-- requires subquery

-- 7. Display the employee number and name if he/she has at least one dependent (use exists keyword) self-study
-- requires subquery
