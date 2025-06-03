create database Sales
 
use Sales

create table [Owner]
(
ID int primary key identity (1, 1),
Name varchar(50) not null
);

create table Sales_Office
(
Number int primary key identity (1, 1),
[Location] varchar(max)
);

create table Property
(
ID int primary key identity (1, 1),
[Address] varchar(max) not null,
City varchar(20) not null,
[State] varchar(20) not null,
Code varchar(10) not null, --string so it can have 0 at the beggining
Off_Number int,
foreign key (Off_Number) references Sales_Office(Number)
);

create table Employee
(
ID int primary key identity (1, 1),
Name varchar(50) not null,
Off_Number int,
foreign key (Off_Number) references Sales_Office(Number)
);

create table Prop_Owner
(
Own_ID int,
Prop_Id int,
[Percent] float
primary key (Own_ID, Prop_Id),
foreign key (Own_ID) references [Owner](ID),
foreign key (Prop_Id) references Property(ID)
);
---------------------------------------------------------------------------------------------------------------------------------------------------------------
create database Music

use Music

create table Musician
(
ID int primary key identity(1,1),
[Name] varchar(50) not null,
Ph_Number varchar(13) not null,--+201012345678
City varchar(20) not null,
Street varchar(20) not null
);

create table Instrument
(
[Name] varchar(50) primary key,
[Key] varchar(10) not null
);

create table Song
(
Tittle varchar(50) primary key,
Author varchar(50) not null
);

create table Mus_song
(
Mus_ID int,
Song_Tittle varchar(50),
primary key (Mus_ID, Song_Tittle),
foreign key (Mus_ID) references Musician(ID),
foreign key (Song_Tittle) references Song(Tittle)
);

create table Album
(
ID int primary key identity(1,1),
Tittle varchar(50) not null,
[Date] date not null,
Mus_ID int not null,
foreign key (Mus_ID) references Musician(ID),
);

create table Album_song
(
Album_ID int,
Song_Tittle varchar(50),
primary key (Album_ID, Song_Tittle),
foreign key (Album_ID) references Album(ID),
foreign key (Song_Tittle) references Song(Tittle)
);

create table Mus_Instrument
(
Mus_ID int,
Inst_Name varchar(50),
primary key (Mus_ID, Inst_Name),
foreign key (Mus_ID) references Musician(ID),
foreign key (Inst_Name) references Instrument([Name])
);

---------------------------------------------------------------------------------------------------------------------------------------------------------------
create database ITI2

use ITI2

create table Departments
(
ID int primary key identity(1,1),
[Name] varchar(50) not null,
Hiring_Date date not null
);

create table Instructors
(
ID int primary key identity(1,1),
[Name] varchar(50) not null,
[Address] varchar(50) not null,
Bonus float default(0),
Salary float not null,
Hour_Rate float not null,
Dep_ID int,
foreign key (Dep_ID) references Departments(ID)
);

create table Students
(
ID int primary key identity(1,1),
Fname varchar(50) not null,
Lnamne varchar(50) not null,
Age int not null,
[Address] varchar(50) not null,
Dep_ID int,
foreign key (Dep_ID) references Departments(ID)
);

create table Topics
(
ID int primary key identity(1,1),
[Name] varchar(50) not null
)

create table Courses
(
ID int primary key identity(1,1),
[Name] varchar(50) not null,
Duration int not null,
[Description] varchar(max) not null,
Top_ID int,
foreign key (Top_ID) references Topics(ID)
);

create table Stud_Course
(
Student_ID int,
Course_ID int,
Grade float not null,
primary key(Student_ID,Course_ID),
foreign key (Student_ID) references Students(ID),
foreign key (Course_ID) references Courses(ID)
);

create table Course_Instructor
(
Course_ID int,
Inst_ID int,
Evaluation varchar(20) not null,
primary key(Course_ID,Inst_ID),
foreign key (Course_ID) references Courses(ID),
foreign key (Inst_ID) references Instructors(ID)
);

---------------------------------------------------------------------------------------------------------------------------------------------------------------
create database hospital

create table Consultant
(
ID int primary key identity(1,1),
[Name] varchar(50) not null
);

create table Ward
(
ID int primary key identity(1,1),
[Name] varchar(50) not null
);

create table Patient
(
ID int primary key identity(1,1),
[Name] varchar(50) not null,
DOB date not null,
Ward_ID int,
Con_ID int,
foreign key (Ward_ID) references Ward(ID),
foreign key (Con_ID) references Consultant(ID)
);

create table Nurse
(
Number int primary key identity(1,1),
[Name] varchar(50) not null,
[Address] varchar(50) not null,
Ward_ID int,
foreign key (Ward_ID) references Ward(ID),
);

create table Drugs
(
Code int primary key identity(1,1),
Dosage float not null
);

create table Drug_Brand
(
Code int,
Brand varchar(20) not null,
foreign key (Code) references Drugs(Code)
);

create table Nruse_Drug_Patient
(
Nur_Num int,
Drug_Code int,
Pat_ID int,
[Date] date not null,
[Time] time not null,
Dosage float not null default(0),
primary key(Pat_ID, [Date], [Time]),
foreign key (Nur_Num) references Nurse(Number),
foreign key (Drug_Code) references Drugs(Code),
foreign key (Pat_ID) references Patient(ID)
);
