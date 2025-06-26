use Library

select * from Author
select * from Book
select * from Book_Author
select * from Borrowing
select * from Category
select * from Employee
select * from [Floor]
select * from Publisher
select * from Shelf
select * from User_phones
select * from Users

--1. Write a query that displays Full name of an employee who has more than 3 letters in his/her First Name.{1 Point}
select concat(Fname,' ',Lname)
from Employee
where len(Fname) > 3 

--2. Write a query to display the total number of Programming books available in the library
--with alias name NO OF PROGRAMMIN BOOKS {1 Point}
select count(Title) 'NO OF PROGRAMMIN BOOKS'
from Book

--3. Write a query to display the number of books published by (HarperCollins) with the alias name 'NO_OF_BOOKS'. {1 Point}
select count(Publisher_id) 'NO_OF_BOOKS'
from Book
where Publisher_id = 1

--4. Write a query to display the User SSN and name, date of borrowing and due date 
--of the User whose due date is before July 2022. {1 Point}
select SSN, [User_Name], Borrow_date, Due_date
from Users join Borrowing
on Users.SSN = Borrowing.User_ssn
where Due_date < '2022-07-01'

--5. Write a query to display book title, author name and display in the following format,
-- [Book Title] is written by [Author Name]. {2 Points}
select concat(Title ,' is written by ', [Name])
from Book join Book_Author
on Book.Id = Book_Author.Book_id
join Author on Book_Author.Author_id = Author.Id

--6. Write a query to display the name of users who have letter 'A' in their names. {1 Point}
select [User_Name]
from Users
where [User_Name] like '%A%'

--7. Write a query that display user SSN who makes the most borrowing{2 Points}
select top(1) User_ssn, count(*) as borrow
from Borrowing
group by User_ssn
order by borrow desc

--8. Write a query that displays the total amount of money that each user paid for borrowing books. {2 Points}
select User_ssn, sum(Amount)
from Borrowing
group by User_ssn

--9. write a query that displays the category which has the book that has the minimum amount of money for borrowing. {2 Points}
select Cat_name
from Category join Book
on Category.Id  = Book.Cat_id
join  Borrowing
on Book.Id = Borrowing.Book_id
where Amount = (select min(Amount) from Borrowing)

--10.write a query that displays the email of an employee if it's not found, 
--display address if it's not found, display date of birthday. {1 Point}
select coalesce(Email, [Address], DOB)
from Employee

--11.Write a query to list the category and number of books in each category with the alias name 'Count Of Books'. {1 Point}
select Cat_name, sum(Cat_id)
from Category join Book
on Category.Id = Book.Cat_id
group by Cat_name

--12.Write a query that display books id which is not found in floor num = 1 and shelf-code = A1.{2 Points}
select Book.Id
from Book join Shelf
on Book.Shelf_code = Shelf.Code
where Shelf_code not in (select Shelf.Code Code from Shelf where Shelf.Floor_num = 1)
--if you want the book to be in shelf A1 then nothing will be retrieved as that is in floor 1 so i ignored the request

--13.Write a query that displays the floor number , Number of Blocks and number of employees working on that floor.{2 Points}
select F.Number, F.Num_blocks, count(E.Id) 'Num of Employees'
from [Floor] F join Employee E 
on F.Number = E.Floor_no
group by F.Number, F.Num_blocks

--14.Display Book Title and User Name to designate Borrowing that occurred within the period ‘3/1/2022’ and ‘10/1/2022’.{2 Points}
select B.Title,  U.[User_Name]
from
Book B join Borrowing BR
on B.Id = BR.Book_id
join Users U
on BR.User_ssn = U.SSN
where BR.Borrow_date between '2022-03-01' and '2022-10-01'

--15.Display Employee Full Name and Name Of his/her Supervisor as Supervisor Name.{2 Points}
select concat(A.Fname, ' ', A.Lname) 'Employee Name', concat(B.Fname, ' ', B.Lname) 'Supervisor Name' 
from Employee A
left join Employee B
on A.Super_id = B.Id

--16.Select Employee name and his/her salary but if there is no salary display Employee bonus. {2 Points}
select concat(Fname, ' ', Lname), coalesce(Salary, Bouns)--there is a type in the bonus column
from Employee

--17.Display max and min salary for Employees {2 Points}
select max(Salary) 'Max Salary', min(Salary) 'Min Salary'
from Employee

--18.Write a function that take Number and display if it is even or odd {2 Points}
create or alter function checkIfEvenOrOdd(@number int)
returns varchar(5)
as
begin 
declare @message varchar(5)
if @number % 2 = 0
set @message = 'Even'
else
set @message = 'Odd'
return @message
end

select dbo.checkIfEvenOrOdd('2025')

--19.write a function that take category name and display Title of books in that category {2 Points}
create or alter function getTitlesByCategory(@category varchar(30))
returns table
as
return
select Title
from Book join Category
on Book.Cat_id = Category.Id
where Cat_name = @category

select * from getTitlesByCategory('programming')

--20. write a function that takes the phone of the user and displays
--Book Title , user-name, amount of money and due-date. {2 Points}
create or alter function getDataByPhone(@phone varchar(20))
returns table
as
return
select B.Title, U.[User_Name], BR.Amount, BR.Due_date
from User_phones UP
join Users U
on UP.User_ssn = U.SSN
join Borrowing BR
on U.SSN = BR.User_ssn
join Book B
on BR.Book_id = B.Id
where UP.Phone_num = @phone

select * from getDataByPhone('0123654122')

--21.Write a function that take user name and check if its duplicated
--return Message in the following format ([User Name] is Repeated 
--[Count] times) if its not duplicated display msg with this format [user 
--name] is not duplicated,if its not Found Return [User Name] is Not Found {2 Points}
create or alter function checkUserName(@name varchar (20))
returns varchar(50)
as
begin
declare @message varchar(50)
declare @count int

select @count = count(*) from Users where [User_Name] = @name

if @count = 0
set @message = @name + ' was not found'
else if @count = 1
set @message = @name + ' is not duplicated'
else if @count > 1
set @message = @name + ' is repeated ' + cast(@count as varchar) + ' times'

return @message
end

select dbo.checkUserName('Amr Ahmed')
select dbo.checkUserName('Alaa Omar')
select dbo.checkUserName('Salah')

--22.Create a scalar function that takes date and Format to return Date With That Format. {2 Points}
create or alter function displayDate(@date varchar(15), @format varchar(20))
returns varchar(50)
as
begin
declare @formattedDate varchar(50)
declare @style int

if @format = 'mm/dd/yyyy'
    set @style = 101
else if @format = 'dd/mm/yyyy'
    set @style = 103
else if @format = 'yyyy.mm.dd'
    set @style = 102
else if @format = 'dd-mm-yyyy'
    set @style = 105
else if @format = 'yyyy/mm/dd'
    set @style = 111

set @formattedDate = convert(varchar(50), cast(@date as date) ,@style)

return @formattedDate
end

--23.Create a stored procedure to show the number of books per Category.{2 Points}
create or alter proc getNomOfBooksInCategory
as
begin
select Cat_name, count(Book.Id) 'Number of Books'
from Book join Category
on Book.Cat_id = Category.Id
group by Cat_name
end

exec getNomOfBooksInCategory

--24.Create a stored procedure that will be used in case there is an old manager who has left the 
--floor and a new one becomes his replacement. The procedure should take 3 parameters 
--(old Emp.id, new Emp.id and the floor number) and it will be used to update the floor table. {3 Points}
create or alter proc replaceOldManager @Old int, @New int, @Floor int
as
begin
update [Floor]
set MG_ID = @New
Where MG_ID = @Old and Number = @Floor
end

exec replaceOldManager @Old = 1000, @New = 1111, @Floor = 50

--25.Create a view AlexAndCairoEmp1 that displays Employee data for users who live in Alex or Cairo. {2 Points}
create or alter view AlexAndCairoEmp1
as
select * from Employee
where [Address] in ('Alex' , 'Cairo')

select * from AlexAndCairoEmp1

--26.create a view "V2" That displays number of books per shelf {2 Points}
create or alter view V2
as
select Shelf_code, count(Book.Shelf_code) 'Number of Books'
from Shelf join Book
on Shelf.Code = Book.Shelf_code
group by Shelf_code

select * from V2

--27.create a view "V3" That display the shelf code that have maximum number of books using the previous view "V2" {2 Points}
create or alter view V3
as
select Shelf_code
from V2
where [Number of Books] = (select max([Number of Books]) from V2)

select * from V3

--28.Create a table named ‘ReturnedBooks’ With the Following Structure :
--User SSN
--Book Id
--Due Date
--Return Date
--fees
--then create A trigger that instead of inserting the data of returned book 
--checks if the return date is the due date or not if not so the user must pay 
--a fee and it will be 20% of the amount that was paid before. {3 Points}
create table ReturnedBooks
(
User_SSN varchar(20),
Book_Id int,
Due_Date date,
Return_Date date,
fees int
)

create or alter trigger trig_ReturnedBooks
on ReturnedBooks
instead of insert
as
begin
insert into ReturnedBooks
select User_SSN, Book_Id, Due_Date, Return_Date, fees
case
    when Return_Date > Due_Date then case(Borrowing.Amount * 0.2 as int)
    else end
from inserted join Borrowing
on inserted.Usser_SSN = Borrowing.User_ssn and inserted.Book_Id = Borrowing.Book_id
end

--29.In the Floor table insert new Floor With Number of blocks 2 , employee with SSN = 20 as a manager for this 
--Floor,The start date for this manager is Now. Do what is required if you know that : Mr.Omar Amr(SSN=5) 
--moved to be the manager of the new Floor (id = 6), and they give Mr. Ali Mohamed(his SSN =12) His position . {3 Points}
insert into [Floor]
values(7,2, 20, getdate())

update [Floor]
set MG_ID = 5
where Number = 6

update [Floor]
set MG_ID = 12
where Number = 4

--30.Create view name (v_2006_check) that will display Manager id, Floor 
--Number where he/she works , Number of Blocks and the Hiring Date which must be from the first of March and
--the end of May 2022.this view will be used to insert data so make sure that the coming new data must 
--match the condition then try to insert this 2 rows and Mention What will happen {3 Point}
--Employee Id Floor Number Number of Blocks Hiring Date
--2 6 2 7-8-2023
--4 7 1 4-8-2022
create or alter view v_2006_check
as
select * 
from [Floor]
where Hiring_Date between '2022-03-01' and '2022-05-31'
with check option

insert into v_2006_check
values(9, 2, 2, '7-8-2023')

insert into v_2006_check
values(10, 4, 1, '4-8-2022')
--the view checks wether the specified condition is met and inserts based on that condition


--31.Create a trigger to prevent anyone from Modifying or Delete or Insert in the Employee table 
--( Display a message for user to tell him that he can’t take any action with this Table) {3 Point}
create or alter trigger trig_Employee
on Employee
instead of update, delete, insert
as
begin
select 'You can not take any action on this table'
end

--32.Testing Referential Integrity , Mention What Will Happen When:
--A. Add a new User Phone Number with User_SSN = 50 in User_Phones Table {1 Point}
--An error will be raised telling the user that there is a violation of the foreign key constraint since no user with the ssn 50 exists

--B. Modify the employee id 20 in the employee table to 21 {1 Point}
-- The trigger will be fired and the modification will not work and a message telling the user that he cant modify the table

--C. Delete the employee with id 1 {1 Point}
-- The trigger will be fired and the modification will not work and a message telling the user that he cant modify the table

--D. Delete the employee with id 12 {1 Point}
-- The trigger will be fired and the modification will not work and a message telling the user that he cant modify the table

--E. Create an index on column (Salary) that allows you to cluster the data in table Employee. {1 Point}
-- An error will be raised telling the user that there is an existing cluster and you cant create more than one on the same table

--33.Try to Create Login With Your Name And give yourself access Only to Employee and Floor tables
--then allow this login to select and insert data into tables and deny Delete and update 
--(Dont Forget To take screenshot to every step) {5 Points}

