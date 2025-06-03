-----------------------------------------------------------------------Part 1------------------------------------------------------------------------------------
-- 1. Display instructors who have salaries less than the average salary of all instructors.
select *
from Instructor
where salary < (select avg(salary) from Instructor)


-- 2. Display the Department name that contains the instructor who receives the minimum salary
select Dept_Name
from Instructor join Department
on Instructor.Dept_Id = Department.Dept_Id
where salary = (select min(salary) from Instructor)


-- 3. Select max two salaries in instructor table.
select top 2 salary
from Instructor
order by salary desc

---------------------------------------------------------------------------------------------------------------------------------------------------------------
select * from Departments
select * from [Dependent]
select * from Employee
select * from Project
select * from Works_for


-- 4. Display the data of the department which has the smallest employee ID over all employees' ID.
select Dname, Dnum, MGRSSN, [MGRStart Date]
from Departments left join Employee
on Departments.Dnum = Employee.Dno
where SSN = (select min(ssn) from Employee where dno is not null)


-- 5. List the last name of all managers who have no dependents
select Lname
from Employee
where ssn not in
(select ESSN from [Dependent])


-- 6. For each department-- if its average salary is less than the average salary of all employees displays its number, name and number of its employees.
--I really dont understand the question

-- 7. Try to get the max 2 salaries using subquery.
select salary
from Employee
where salary in(
    select top 2 salary
    from Employee
    order by salary desc
)


-- 8. Display the employee number and name if he/she has at least one dependent (use exists keyword) self-study.
select SSN, Fname, Lname
from Employee
where exists (
    select 1
    from [Dependent]
    where [Dependent].ESSN = Employee.SSN)


-- 9. Write a query to select the highest two salaries in Each Department for instructors who have salaries. “Using one of Ranking Functions”
-- I couldn't do it


-- 10. Write a query to select a random student from each department.  “Using one of Ranking Functions”
-- you mean employee this is mycompany database
select top 1 * , rank() over (order by SSN Desc)
from Employee join Departments
on Employee.Dno = Departments.Dnum
order by newid()

-----------------------------------------------------------------------Part 2------------------------------------------------------------------------------------
--Restore adventureworks2012 Database Then :
select * from Sales.SalesOrderHeader
-- 1. Display the SalesOrderID, ShipDate of the SalesOrderHearder table (Sales schema) to designate SalesOrders that occurred within the period ‘7/28/2002’ and ‘7/29/2014’
select SalesOrderID, ShipDate
from Sales.SalesOrderHeader
where ShipDate between '2002-07-28' and '2014-07-29'


-- 2. Display only Products(Production schema) with a StandardCost below $110.00 (show ProductID, Name only)
select ProductID, [Name]
from Production.[Product]
where StandardCost < 110


-- 3. Display ProductID, Name if its weight is unknown
select ProductID, [Name]
from Production.[Product]
where [Weight] is null


-- 4. Display all Products with a Silver, Black, or Red Color
select *
from Production.[Product]
where Color in ('Silver', 'Black', 'Red')


-- 5. Display any Product with a Name starting with the letter B
select * 
from Production.[Product]
where [Name] like('B%')


-- 6. Run the following Query
    UPDATE Production.ProductDescription
          SET [Description] = 'Chromoly steel_High of defects'
              WHERE ProductDescriptionID = 3
--Then write a query that displays any Product description with underscore value in its description.
select [Description]
from Production.ProductDescription
where [Description] like '%\_%' escape '\' --found out escape from chatgpt had no idea this was a thing


-- 8. Display the Employees HireDate (note no repeated values are allowed)
select distinct HireDate
from Employee


-- 9. Display the Product Name and its ListPrice within the values of 100 and 120 the list should have the following format "The [product name] is only! [List price]" (the list will be sorted according to its ListPrice value)
select [Name], ListPrice
from Production.[Product]
where ListPrice between 100 and 120
order by ListPrice desc
