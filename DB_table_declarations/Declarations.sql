CREATE TABLE public.courses
(
  coursenumber character varying(10) NOT NULL,
  labrequirement boolean NOT NULL,
  consentofinstructor boolean,
  CONSTRAINT "CNUM_PK" PRIMARY KEY (coursenumber)
);
 
 
CREATE TABLE public.student
(
      studentid integer NOT NULL,
      ssn integer NOT NULL,
      firstname character varying(20) NOT NULL,
      middlename character varying(20),
      lastname character varying(20) NOT NULL,
      residency character varying(10) NOT NULL,
      enrollmentstatus boolean NOT NULL,
      degreesheld character varying(30),
      periodsofattendance character varying(30) NOT NULL,
      CONSTRAINT sp_id PRIMARY KEY (studentid),
      CONSTRAINT "U_SSN" UNIQUE (ssn)
);
 
CREATE TABLE public.classes
(
      coursenumber character varying(10) NOT NULL,
      classtitle character varying(20) NOT NULL,
      CONSTRAINT "CNUM_BPK" PRIMARY KEY (coursenumber),
      CONSTRAINT "CNUM_AFK" FOREIGN KEY (coursenumber)
          REFERENCES public.courses (coursenumber) MATCH SIMPLE
              ON UPDATE NO ACTION ON DELETE NO ACTION
);
 
CREATE TABLE sections
(
  sectionid integer NOT NULL,
  quarter character varying(10) NOT NULL,
  enrollmentlimit integer NOT NULL,
  coursenumber character varying(10) NOT NULL,
  concentration character varying(20),
  year integer,
  lowerupperdivision character varying(10),
  technicalelective boolean,
  CONSTRAINT sp_sid PRIMARY KEY (sectionid),
  CONSTRAINT "CNUM_SFK" FOREIGN KEY (coursenumber)
      REFERENCES courses (coursenumber) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);
 
 
CREATE TABLE public.currentenrollment
(
  studentid integer NOT NULL,
  coursenumber character varying(10) NOT NULL,
  sectionid integer NOT NULL,
  enrolledwaitlisted character varying(20) NOT NULL,
  gradingoption character varying(20) NOT NULL,
  units integer,
  CONSTRAINT "ENR_PK" PRIMARY KEY (studentid, coursenumber),
  CONSTRAINT "CO_EWFK" FOREIGN KEY (coursenumber)
      REFERENCES public.courses (coursenumber) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "SEC_EWFK" FOREIGN KEY (sectionid)
      REFERENCES public.sections (sectionid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "STUD_EWFK" FOREIGN KEY (studentid)
      REFERENCES public.student (studentid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);
 
 
CREATE TABLE public.department
(
      departmenttitle character varying(20) NOT NULL,
      CONSTRAINT "DP_DT" PRIMARY KEY (departmenttitle)
);
 
CREATE TABLE public.departmentcourses
(
      coursenumber character varying(10) NOT NULL,
      departmenttitle character varying(20) NOT NULL,
      CONSTRAINT "C_NUM" PRIMARY KEY (coursenumber),
      CONSTRAINT "CNUM_FK" FOREIGN KEY (coursenumber)
          REFERENCES public.courses (coursenumber) MATCH SIMPLE
              ON UPDATE NO ACTION ON DELETE NO ACTION,
      CONSTRAINT "DP_FK" FOREIGN KEY (departmenttitle)
          REFERENCES public.department (departmenttitle) MATCH SIMPLE
              ON UPDATE NO ACTION ON DELETE NO ACTION
);
 
CREATE TABLE public.faculty
(
      facultyname character varying(20) NOT NULL,
      facultytitle character varying(20) NOT NULL,
      department character varying(20),
      CONSTRAINT "FP_ID" PRIMARY KEY (facultyname),
      CONSTRAINT "FP_DT" FOREIGN KEY (department)
          REFERENCES public.department (departmenttitle) MATCH SIMPLE
              ON UPDATE NO ACTION ON DELETE NO ACTION
);
 
CREATE TABLE public.facultyclasses
(
      facultyname character varying(20) NOT NULL,
      sectionid integer NOT NULL,
      whentaught character varying(10),
      CONSTRAINT "FCL_PK" PRIMARY KEY (facultyname, sectionid),
      CONSTRAINT "FAC_FK" FOREIGN KEY (facultyname)
          REFERENCES public.faculty (facultyname) MATCH SIMPLE
              ON UPDATE NO ACTION ON DELETE NO ACTION,
      CONSTRAINT "SEC_FK" FOREIGN KEY (sectionid)
          REFERENCES public.sections (sectionid) MATCH SIMPLE
              ON UPDATE NO ACTION ON DELETE NO ACTION
);
 
CREATE TABLE public.graduatedegrees
(
  graduatedegreetitle character varying(20) NOT NULL,
  concentration character varying(20) NOT NULL,
  type character varying(10) NOT NULL,
  CONSTRAINT "PG_GDT" PRIMARY KEY (graduatedegreetitle, concentration)
);
 
CREATE TABLE public.meetings
(
  sectionid integer NOT NULL,
  meetingtype character varying(20) NOT NULL,
  meetingdate character varying(20) NOT NULL,
  meetingstart character varying(20) NOT NULL,
  building character varying(20) NOT NULL,
  room character varying(20) NOT NULL,
  meetingend character varying(20) NOT NULL,
  CONSTRAINT "SID_PK" PRIMARY KEY (sectionid),
  CONSTRAINT "SID_FK" FOREIGN KEY (sectionid)
      REFERENCES public.sections (sectionid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);
 
 
CREATE TABLE public.ms
(
      studentid integer NOT NULL,
      department character varying(20) NOT NULL,
      CONSTRAINT "MS_ID" PRIMARY KEY (studentid),
      CONSTRAINT "F_ID" FOREIGN KEY (studentid)
          REFERENCES public.student (studentid) MATCH SIMPLE
              ON UPDATE NO ACTION ON DELETE NO ACTION,
      CONSTRAINT "MF_DT" FOREIGN KEY (department)
          REFERENCES public.department (departmenttitle) MATCH SIMPLE
              ON UPDATE NO ACTION ON DELETE NO ACTION
);
 
CREATE TABLE public.phd
(
      studentid integer NOT NULL,
      candidacy boolean NOT NULL,
      advisor character varying(20),
      department character varying(20) NOT NULL,
      CONSTRAINT "PP_ID" PRIMARY KEY (studentid),
      CONSTRAINT "F_A" FOREIGN KEY (advisor)
          REFERENCES public.faculty (facultyname) MATCH SIMPLE
              ON UPDATE NO ACTION ON DELETE NO ACTION,
      CONSTRAINT "PP_DT" FOREIGN KEY (department)
          REFERENCES public.department (departmenttitle) MATCH SIMPLE
              ON UPDATE NO ACTION ON DELETE NO ACTION,
      CONSTRAINT f_id FOREIGN KEY (studentid)
          REFERENCES public.student (studentid) MATCH SIMPLE
              ON UPDATE NO ACTION ON DELETE NO ACTION
);
 
CREATE TABLE public.prereqs
(
      coursenumber character varying(10) NOT NULL,
      prereqcourse character varying(10) NOT NULL,
      CONSTRAINT "REQ_PK" PRIMARY KEY (coursenumber, prereqcourse),
      CONSTRAINT "CNUM_PFK" FOREIGN KEY (coursenumber)
          REFERENCES public.courses (coursenumber) MATCH SIMPLE
              ON UPDATE NO ACTION ON DELETE NO ACTION,
      CONSTRAINT "PC_FK" FOREIGN KEY (prereqcourse)
          REFERENCES public.courses (coursenumber) MATCH SIMPLE
              ON UPDATE NO ACTION ON DELETE NO ACTION
);
 
CREATE TABLE public.probation
(
      studentid integer NOT NULL,
      probationperiod character varying(20) NOT NULL,
      probationreason character varying(100) NOT NULL,
      CONSTRAINT "SP_ID" PRIMARY KEY (studentid),
      CONSTRAINT "PF_ID" FOREIGN KEY (studentid)
          REFERENCES public.student (studentid) MATCH SIMPLE
              ON UPDATE NO ACTION ON DELETE NO ACTION
);
 
CREATE TABLE public.studentpastclasses
(
  studentid integer NOT NULL,
  sectionid integer NOT NULL,
  grade character varying(10),
  units integer,
  CONSTRAINT "PAST_PK" PRIMARY KEY (studentid, sectionid),
  CONSTRAINT "STUD_SFK" FOREIGN KEY (studentid)
      REFERENCES public.student (studentid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "STUD_SPK" FOREIGN KEY (sectionid)
      REFERENCES public.sections (sectionid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);
 
 
CREATE TABLE public.thesiscommittee
(
      studentid integer NOT NULL,
      facultyname character varying(20) NOT NULL,
      CONSTRAINT "TP_I" PRIMARY KEY (studentid),
      CONSTRAINT "TF_FF" FOREIGN KEY (facultyname)
          REFERENCES public.faculty (facultyname) MATCH SIMPLE
              ON UPDATE NO ACTION ON DELETE NO ACTION,
      CONSTRAINT "TF_IS" FOREIGN KEY (studentid)
          REFERENCES public.student (studentid) MATCH SIMPLE
              ON UPDATE NO ACTION ON DELETE NO ACTION
);
 
CREATE TABLE public.undergraduate
(
      studentid integer NOT NULL,
      major character varying(20) NOT NULL,
      minor character varying(20),
      college character varying(10) NOT NULL,
      CONSTRAINT "PU_ID" PRIMARY KEY (studentid),
      CONSTRAINT "F_ID" FOREIGN KEY (studentid)
          REFERENCES public.student (studentid) MATCH SIMPLE
              ON UPDATE NO ACTION ON DELETE NO ACTION
);
 
CREATE TABLE undergraduatedegrees
(
  undergraduatedegreetitle character varying(20) NOT NULL,
  minlowerdivisionunits integer,
  minupperdivisionunits integer,
  totalunitsrequired integer,
  averagegrade character varying(10),
  technicalunitsrequired integer,
  CONSTRAINT "UP_U" PRIMARY KEY (undergraduatedegreetitle)
);
 
 
CREATE TABLE public.workinggraddegree
(
  studentid integer NOT NULL,
  graddegreetitle character varying(20) NOT NULL,
  CONSTRAINT "SID_WD" PRIMARY KEY (studentid),
  CONSTRAINT "FS_ID" FOREIGN KEY (studentid)
      REFERENCES public.student (studentid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);
 
CREATE TABLE public.workingundergraddegree
(
      studentid integer NOT NULL,
      undergraddegreetitle character varying(20) NOT NULL,
      CONSTRAINT "WP_S" PRIMARY KEY (studentid),
      CONSTRAINT "WF_SI" FOREIGN KEY (studentid)
          REFERENCES public.student (studentid) MATCH SIMPLE
              ON UPDATE NO ACTION ON DELETE NO ACTION,
      CONSTRAINT "WF_UU" FOREIGN KEY (undergraddegreetitle)
          REFERENCES public.undergraduatedegrees (undergraduatedegreetitle) MATCH SIMPLE
              ON UPDATE NO ACTION ON DELETE NO ACTION
);
 
CREATE TABLE public.concentrations
(
  studentid integer NOT NULL,
  concentrationtitle character varying(20) NOT NULL,
  unitsnecessary integer,
  mingpa double precision,
  CONSTRAINT "ID_CONC" PRIMARY KEY (studentid, concentrationtitle),
  CONSTRAINT "ID_STU" FOREIGN KEY (studentid)
      REFERENCES public.student (studentid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);
 
 
CREATE TABLE GRADE_CONVERSION
( LETTER_GRADE CHAR(2) NOT NULL,
NUMBER_GRADE DECIMAL(2,1)
);
insert into grade_conversion values('A+', 4.0);
insert into grade_conversion values('A', 4.0);
insert into grade_conversion values('A-', 3.7);
insert into grade_conversion values('B+', 3.3);
insert into grade_conversion values('B', 3.0);
insert into grade_conversion values('B-', 2.7);
insert into grade_conversion values('C+', 2.3);
insert into grade_conversion values('C', 2.0);
insert into grade_conversion values('C-', 1.7);
insert into grade_conversion values('D', 1.0);
insert into grade_conversion values('F', 0.0);
 
CREATE TABLE public.allmeetings
(
  date character varying(10),
  times character varying(10),
  row integer
);
 
insert into allmeetings values ('Sunday', '8:00 AM', 1);
insert into allmeetings values ('Sunday', '9:00 AM', 2);
insert into allmeetings values ('Sunday', '10:00 AM', 3);
insert into allmeetings values ('Sunday', '11:00 AM', 4);
insert into allmeetings values ('Sunday', '12:00 PM', 5);
insert into allmeetings values ('Sunday', '1:00 PM', 6);
insert into allmeetings values ('Sunday', '2:00 PM', 7);
insert into allmeetings values ('Sunday', '3:00 PM', 8);
insert into allmeetings values ('Sunday', '4:00 PM', 9);
insert into allmeetings values ('Sunday', '5:00 PM', 10);
insert into allmeetings values ('Sunday', '6:00 PM', 11);
insert into allmeetings values ('Sunday', '7:00 PM', 12);
insert into allmeetings values ('Sunday', '8:00 PM', 13);
insert into allmeetings values ('Monday', '8:00 AM', 14);
insert into allmeetings values ('Monday', '9:00 AM', 15);
insert into allmeetings values ('Monday', '10:00 AM', 16);
insert into allmeetings values ('Monday', '11:00 AM', 17);
insert into allmeetings values ('Monday', '12:00 PM', 18);
insert into allmeetings values ('Monday', '1:00 PM', 19);
insert into allmeetings values ('Monday', '2:00 PM', 20);
insert into allmeetings values ('Monday', '3:00 PM', 21);
insert into allmeetings values ('Monday', '4:00 PM', 22);
insert into allmeetings values ('Monday', '5:00 PM', 23);
insert into allmeetings values ('Monday', '6:00 PM', 24);
insert into allmeetings values ('Monday', '7:00 PM', 25);
insert into allmeetings values ('Monday', '8:00 PM', 26);
insert into allmeetings values ('Tuesday', '8:00 AM', 27);
insert into allmeetings values ('Tuesday', '9:00 AM', 28);
insert into allmeetings values ('Tuesday', '10:00 AM', 29);
insert into allmeetings values ('Tuesday', '11:00 AM', 30);
insert into allmeetings values ('Tuesday', '12:00 PM', 31);
insert into allmeetings values ('Tuesday', '1:00 PM', 32);
insert into allmeetings values ('Tuesday', '2:00 PM', 33);
insert into allmeetings values ('Tuesday', '3:00 PM', 34);
insert into allmeetings values ('Tuesday', '4:00 PM', 35);
insert into allmeetings values ('Tuesday', '5:00 PM', 36);
insert into allmeetings values ('Tuesday', '6:00 PM', 37);
insert into allmeetings values ('Tuesday', '7:00 PM', 38);
insert into allmeetings values ('Tuesday', '8:00 PM', 39);
insert into allmeetings values ('Wednesday', '8:00 AM', 40);
insert into allmeetings values ('Wednesday', '9:00 AM', 41);
insert into allmeetings values ('Wednesday', '10:00 AM', 42);
insert into allmeetings values ('Wednesday', '11:00 AM', 43);
insert into allmeetings values ('Wednesday', '12:00 PM', 44);
insert into allmeetings values ('Wednesday', '1:00 PM', 45);
insert into allmeetings values ('Wednesday', '2:00 PM', 46);
insert into allmeetings values ('Wednesday', '3:00 PM', 47);
insert into allmeetings values ('Wednesday', '4:00 PM', 48);
insert into allmeetings values ('Wednesday', '5:00 PM', 49);
insert into allmeetings values ('Wednesday', '6:00 PM', 50);
insert into allmeetings values ('Wednesday', '7:00 PM', 51);
insert into allmeetings values ('Wednesday', '8:00 PM', 52);
insert into allmeetings values ('Thursday', '8:00 AM', 53);
insert into allmeetings values ('Thursday', '9:00 AM', 54);
insert into allmeetings values ('Thursday', '10:00 AM', 55);
insert into allmeetings values ('Thursday', '11:00 AM', 56);
insert into allmeetings values ('Thursday', '12:00 PM', 57);
insert into allmeetings values ('Thursday', '1:00 PM', 58);
insert into allmeetings values ('Thursday', '2:00 PM', 59);
insert into allmeetings values ('Thursday', '3:00 PM', 60);
insert into allmeetings values ('Thursday', '4:00 PM', 61);
insert into allmeetings values ('Thursday', '5:00 PM', 62);
insert into allmeetings values ('Thursday', '6:00 PM', 63);
insert into allmeetings values ('Thursday', '7:00 PM', 64);
insert into allmeetings values ('Thursday', '8:00 PM', 65);
insert into allmeetings values ('Friday', '8:00 AM', 66);
insert into allmeetings values ('Friday', '9:00 AM', 67);
insert into allmeetings values ('Friday', '10:00 AM', 68);
insert into allmeetings values ('Friday', '11:00 AM', 69);
insert into allmeetings values ('Friday', '12:00 PM', 70);
insert into allmeetings values ('Friday', '1:00 PM', 71);
insert into allmeetings values ('Friday', '2:00 PM', 72);
insert into allmeetings values ('Friday', '3:00 PM', 73);
insert into allmeetings values ('Friday', '4:00 PM', 74);
insert into allmeetings values ('Friday', '5:00 PM', 75);
insert into allmeetings values ('Friday', '6:00 PM', 76);
insert into allmeetings values ('Friday', '7:00 PM', 77);
insert into allmeetings values ('Friday', '8:00 PM', 78);
insert into allmeetings values ('Saturday', '8:00 AM', 79);
insert into allmeetings values ('Saturday', '9:00 AM', 80);
insert into allmeetings values ('Saturday', '10:00 AM', 81);
insert into allmeetings values ('Saturday', '11:00 AM', 82);
insert into allmeetings values ('Saturday', '12:00 PM', 83);
insert into allmeetings values ('Saturday', '1:00 PM', 84);
insert into allmeetings values ('Saturday', '2:00 PM', 85);
insert into allmeetings values ('Saturday', '3:00 PM', 86);
insert into allmeetings values ('Saturday', '4:00 PM', 87);
insert into allmeetings values ('Saturday', '5:00 PM', 88);
insert into allmeetings values ('Saturday', '6:00 PM', 89);
insert into allmeetings values ('Saturday', '7:00 PM', 90);
insert into allmeetings values ('Saturday', '8:00 PM', 91);



 
CREATE OR REPLACE FUNCTION meetingfunc()
RETURNS trigger AS
$$
DECLARE 
    var1 int;
BEGIN
    select count(m.sectionid) into var1
    from meetings m
    where m.sectionid = NEW.sectionid 
    AND m.meetingdate = NEW.meetingdate
    AND m.meetingstart = NEW.meetingstart;
    
    IF var1 > 0 THEN RAISE EXCEPTION 'Cannot add % for section % 
    because this section is already meeting at this time', NEW.meetingtype, NEW.sectionid;
    END IF;
    raise notice 'Adding % for section % on % at %', 
    NEW.meetingtype, NEW.sectionid, NEW.meetingdate, NEW.meetingstart;
   
    
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;
 
DROP TRIGGER IF EXISTS meeting_trigger ON meetings;
CREATE TRIGGER meeting_trigger
BEFORE INSERT ON meetings
FOR EACH ROW EXECUTE PROCEDURE meetingfunc();
 
 
 
 
 
 
CREATE OR REPLACE FUNCTION enrollmentfunc()
RETURNS trigger AS
$$
declare 
    var1 int;
    var2 int;
BEGIN
    select count(c.studentid) into var1
    from currentenrollment c
    where c.sectionid = NEW.sectionid;
    
    select enrollmentlimit into var2 
    from sections
    where sectionid = NEW.sectionid;
      
    IF var1 >= var2 THEN RAISE EXCEPTION 
    'Cannot add Student % because enrollment limit of % has been reached for Section %',
    NEW.studentid, var2, NEW.sectionid;
    END IF;
    raise notice 'Students % has been added to Section %', NEW.studentid, NEW.sectionid;
    
  
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;
 
DROP TRIGGER IF EXISTS enrollment_trigger ON currentenrollment;
CREATE TRIGGER enrollment_trigger
BEFORE INSERT ON currentenrollment
FOR EACH ROW EXECUTE PROCEDURE enrollmentfunc();
 
 
 
 
 
 
CREATE OR REPLACE FUNCTION facultyfunc()
RETURNS trigger AS
$$
DECLARE 
    var1 int;
    
BEGIN
      CREATE TABLE facultytimes AS (select DISTINCT m.meetingdate, m.meetingstart
    from meetings m, facultyclasses f
    where m.sectionid = f.sectionid
    and f.facultyname = NEW.facultyname);
    
    select count(m.meetingstart) into var1
    from meetings m, facultytimes t
    where m.sectionid = NEW.sectionid
    and t.meetingstart = m.meetingstart 
    and t.meetingdate = m.meetingdate GROUP BY m.meetingdate;
 
    DROP TABLE IF EXISTS facultytimes;
 
    IF var1 > 0 THEN RAISE EXCEPTION 'Faculty % cannot be added to Section % 
    because they are already teaching another section at this time', NEW.facultyname, NEW.sectionid;
    END IF;
    raise notice 'Faculty % added to Section %', NEW.facultyname, NEW.sectionid;
      
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;
 
DROP TRIGGER IF EXISTS faculty_trigger ON facultyclasses;
CREATE TRIGGER faculty_trigger
BEFORE INSERT ON facultyclasses
FOR EACH ROW EXECUTE PROCEDURE facultyfunc();
 
 
 
 
create table public.CPQG
(
course character varying(20),
professor character varying(20),
quarter character varying(20),
year integer,
grade character varying(2),
sumgrade integer
);
insert into CPQG (course, professor, quarter, year, grade, sumgrade) select tableID.C, tableID.F, tableID.Q, tableID.Y, 'A', sum(tableID.ID) from (select p.GRADE, 
count(p.GRADE) as ID, s.COURSENUMBER as C, f.facultyname as F, s.QUARTER as Q, s.YEAR as Y from STUDENTPASTCLASSES p, FACULTYCLASSES f, SECTIONS s 
where p.SECTIONID = s.SECTIONID and f.SECTIONID = p.SECTIONID and p.GRADE like 'A%' GROUP BY p.GRADE,s.COURSENUMBER, f.facultyname, s.QUARTER, s.YEAR) 
as tableID GROUP BY tableID.C, tableID.F, tableID.Q, tableID.Y union select tableID.C, tableID.F, tableID.Q, tableID.Y, 'B',
sum(tableID.ID) from (select p.GRADE, count(p.GRADE) as ID, s.COURSENUMBER as C,
f.facultyname as F, s.QUARTER as Q, s.YEAR as Y from STUDENTPASTCLASSES p, FACULTYCLASSES f, SECTIONS s where p.SECTIONID = s.SECTIONID and f.SECTIONID = p.SECTIONID and 
p.GRADE like 'B%' GROUP BY p.GRADE,s.COURSENUMBER, f.facultyname, s.QUARTER, s.YEAR) as tableID GROUP BY tableID.C, tableID.F, tableID.Q, tableID.Y
 union select tableID.C, tableID.F, tableID.Q, tableID.Y, 'C', sum(tableID.ID) from (select p.GRADE, count(p.GRADE) as ID, 
s.COURSENUMBER as C, f.facultyname as F, s.QUARTER as Q, s.YEAR as Y from STUDENTPASTCLASSES p, FACULTYCLASSES f,
SECTIONS s where p.SECTIONID = s.SECTIONID and f.SECTIONID = p.SECTIONID and p.GRADE like 'C%' GROUP BY p.GRADE,s.COURSENUMBER, f.facultyname, s.QUARTER, s.YEAR) as 
tableID GROUP BY tableID.C, tableID.F, tableID.Q, tableID.Y
union select tableID.C, tableID.F, tableID.Q, 
tableID.Y, 'D', sum(tableID.ID) from (select p.GRADE, count(p.GRADE) as ID, s.COURSENUMBER as C,
 f.facultyname as F, s.QUARTER as Q, s.YEAR as Y from STUDENTPASTCLASSES p, FACULTYCLASSES f, SECTIONS s where p.SECTIONID = s.SECTIONID and f.SECTIONID = p.SECTIONID 
and p.GRADE like 'D%' GROUP BY p.GRADE,s.COURSENUMBER, f.facultyname, s.QUARTER, s.YEAR) as tableID GROUP BY tableID.C, tableID.F, tableID.Q, tableID.Y
union select tableID.C, tableID.F, tableID.Q, 
tableID.Y, 'F', sum(tableID.ID) from (select p.GRADE, count(p.GRADE) as ID, s.COURSENUMBER as C,
 f.facultyname as F, s.QUARTER as Q, s.YEAR as Y from STUDENTPASTCLASSES p, FACULTYCLASSES f, SECTIONS s where p.SECTIONID = s.SECTIONID and f.SECTIONID = p.SECTIONID 
and p.GRADE like 'F%' GROUP BY p.GRADE,s.COURSENUMBER, f.facultyname, s.QUARTER, s.YEAR) as tableID GROUP BY tableID.C, tableID.F, tableID.Q, tableID.Y;
 
 
create table public.CPG
(
course character varying(20),
professor character varying(20),
grade character varying(2),
sumgrade integer
);
insert into CPG (course, professor, grade, sumgrade) select tableID.C, tableID.F, 'A', sum(tableID.ID) from (select p.GRADE, 
count(p.GRADE) as ID, s.COURSENUMBER as C, f.facultyname as F from STUDENTPASTCLASSES p, FACULTYCLASSES f, SECTIONS s 
where p.SECTIONID = s.SECTIONID and f.SECTIONID = p.SECTIONID and p.GRADE like 'A%' GROUP BY p.GRADE,s.COURSENUMBER, f.FACULTYNAME) 
as tableID GROUP BY tableID.C, tableID.F union
select tableID.C, tableID.F, 'B', sum(tableID.ID) from (select p.GRADE, 
count(p.GRADE) as ID, s.COURSENUMBER as C, f.facultyname as F from STUDENTPASTCLASSES p, FACULTYCLASSES f, SECTIONS s 
where p.SECTIONID = s.SECTIONID and f.SECTIONID = p.SECTIONID and p.GRADE like 'B%' GROUP BY p.GRADE,s.COURSENUMBER, f.FACULTYNAME) 
as tableID GROUP BY tableID.C, tableID.F union
select tableID.C, tableID.F, 'C', sum(tableID.ID) from (select p.GRADE, 
count(p.GRADE) as ID, s.COURSENUMBER as C, f.facultyname as F from STUDENTPASTCLASSES p, FACULTYCLASSES f, SECTIONS s 
where p.SECTIONID = s.SECTIONID and f.SECTIONID = p.SECTIONID and p.GRADE like 'C%' GROUP BY p.GRADE,s.COURSENUMBER, f.FACULTYNAME) 
as tableID GROUP BY tableID.C, tableID.F union
select tableID.C, tableID.F, 'D', sum(tableID.ID) from (select p.GRADE, 
count(p.GRADE) as ID, s.COURSENUMBER as C, f.facultyname as F from STUDENTPASTCLASSES p, FACULTYCLASSES f, SECTIONS s 
where p.SECTIONID = s.SECTIONID and f.SECTIONID = p.SECTIONID and p.GRADE like 'D%' GROUP BY p.GRADE,s.COURSENUMBER, f.FACULTYNAME) 
as tableID GROUP BY tableID.C, tableID.F union
select tableID.C, tableID.F, 'F', sum(tableID.ID) from (select p.GRADE, 
count(p.GRADE) as ID, s.COURSENUMBER as C, f.facultyname as F from STUDENTPASTCLASSES p, FACULTYCLASSES f, SECTIONS s 
where p.SECTIONID = s.SECTIONID and f.SECTIONID = p.SECTIONID and p.GRADE like 'F%' GROUP BY p.GRADE,s.COURSENUMBER, f.FACULTYNAME) 
as tableID GROUP BY tableID.C, tableID.F;
 
 
 
 
 
 
  
CREATE OR REPLACE FUNCTION CPGupdatefunc()
RETURNS trigger AS
$$
DECLARE
   var1 varchar;
   var2 varchar;
   var3 int; 
 
BEGIN
select s.coursenumber, f.facultyname into var1, var2
    from sections s, facultyclasses f
    where NEW.sectionid = s.sectionid 
    and f.sectionid = s.sectionid;
  
select count(*) into var3 from cpg
where course = var1 and professor = var2 and NEW.grade LIKE (grade || '%');
 
IF var3 > 0 THEN UPDATE cpg SET sumgrade = sumgrade + 1
    WHERE course = var1 and professor = var2 and NEW.grade LIKE (grade || '%');
    ELSIF NEW.grade LIKE 'A%' THEN
INSERT INTO cpg VALUES (var1, var2,'A', 1);
ELSIF NEW.grade LIKE 'B%' THEN
INSERT INTO cpg VALUES (var1, var2,'B', 1);
ELSIF NEW.grade LIKE 'C%' THEN
INSERT INTO cpg VALUES (var1, var2,'C', 1);
ELSIF NEW.grade LIKE 'D%' THEN
INSERT INTO cpg VALUES (var1, var2,'D', 1);
ELSE INSERT INTO cpg VALUES (var1, var2,'F', 1);
 
END IF;
 
UPDATE CPG SET SUMGRADE = SUMGRADE - 1
WHERE OLD.grade LIKE (grade || '%')
AND course = var1
AND professor = var2;
 
DELETE FROM cpg WHERE sumgrade = 0; 
 
 
RETURN NEW;
END;
$$
LANGUAGE plpgsql;
 
DROP TRIGGER IF EXISTS cpg_update_trigger ON studentpastclasses;
CREATE TRIGGER cpg_update_trigger
BEFORE UPDATE ON studentpastclasses
FOR EACH ROW EXECUTE PROCEDURE CPGupdatefunc();
 
 
 
 
  
  
CREATE OR REPLACE FUNCTION cpginsertgrade()
RETURNS trigger AS
$$
declare 
    var1 varchar;
    var2 varchar;
    var3 int; 
BEGIN
    select s.coursenumber, f.facultyname into var1, var2
    from sections s, facultyclasses f
    where NEW.sectionid = s.sectionid 
    and f.sectionid = s.sectionid;
    
    raise notice 'Adding student %', NEW.studentid;
    
     select count(*) into var3 from cpg
    where course = var1 and professor = var2 and NEW.grade LIKE (grade || '%'); 
  
    IF var3 > 0 THEN UPDATE cpg SET sumgrade = sumgrade + 1
    WHERE course = var1 and professor = var2 and NEW.grade LIKE (grade || '%');
    ELSIF NEW.grade LIKE 'A%' THEN
INSERT INTO cpg VALUES (var1, var2,'A', 1);
ELSIF NEW.grade LIKE 'B%' THEN
INSERT INTO cpg VALUES (var1, var2,'B', 1);
ELSIF NEW.grade LIKE 'C%' THEN
INSERT INTO cpg VALUES (var1, var2,'C', 1);
ELSIF NEW.grade LIKE 'D%' THEN
INSERT INTO cpg VALUES (var1, var2,'D', 1);
ELSE INSERT INTO cpg VALUES (var1, var2,'F', 1);
 
END IF; 
    
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;
 
DROP TRIGGER IF EXISTS cpg_insert_trigger ON studentpastclasses;
CREATE TRIGGER cpg_insert_trigger
BEFORE INSERT ON studentpastclasses
FOR EACH ROW EXECUTE PROCEDURE cpginsertgrade();
 
 
CREATE OR REPLACE FUNCTION CPQGupdatefunc()
RETURNS trigger AS
$$
DECLARE
   var1 varchar;
   var2 varchar;
   var3 varchar;
   var4 int;
   var5 int; 
 
BEGIN
select s.coursenumber, f.facultyname, s.quarter, s.year into var1, var2, var3, var4
    from sections s, facultyclasses f
    where NEW.sectionid = s.sectionid 
    and f.sectionid = s.sectionid;
  
select count(*) into var5 from cpqg
where course = var1 and professor = var2 and quarter = var3 and year = var4 and NEW.grade LIKE (grade || '%');
 
IF var5 > 0 THEN UPDATE cpqg SET sumgrade = sumgrade + 1
    WHERE course = var1 and professor = var2 and quarter = var3 and year = var4 and NEW.grade LIKE (grade || '%');
    ELSIF NEW.grade LIKE 'A%' THEN
INSERT INTO cpqg VALUES (var1, var2, var3, var4, 'A', 1);
ELSIF NEW.grade LIKE 'B%' THEN
INSERT INTO cpqg VALUES (var1, var2, var3, var4, 'B', 1);
ELSIF NEW.grade LIKE 'C%' THEN
INSERT INTO cpqg VALUES (var1, var2, var3, var4, 'C', 1);
ELSIF NEW.grade LIKE 'D%' THEN
INSERT INTO cpqg VALUES (var1, var2, var3, var4, 'D', 1);
ELSE INSERT INTO cpqg VALUES (var1, var2, var3, var4, 'F', 1);
 
END IF;
 
UPDATE CPQG SET SUMGRADE = SUMGRADE - 1
WHERE OLD.grade LIKE (grade || '%')
AND course = var1
AND professor = var2
AND quarter = var3
AND year = var4;
 
DELETE FROM cpqg WHERE sumgrade = 0; 
 
 
RETURN NEW;
END;
$$
LANGUAGE plpgsql;
 
DROP TRIGGER IF EXISTS cpqg_update_trigger ON studentpastclasses;
CREATE TRIGGER cpqg_update_trigger
BEFORE UPDATE ON studentpastclasses
FOR EACH ROW EXECUTE PROCEDURE CPQGupdatefunc();
 
 
 
 
 
CREATE OR REPLACE FUNCTION cpqginsertgrade()
RETURNS trigger AS
$$
declare 
    var1 varchar;
    var2 varchar;
    var3 varchar;
    var4 int;
    var5 int; 
BEGIN
    select s.coursenumber, f.facultyname, s.quarter, s.year into var1, var2, var3, var4
    from sections s, facultyclasses f
    where NEW.sectionid = s.sectionid 
    and f.sectionid = s.sectionid;
    
    raise notice 'Adding student %', NEW.studentid;
    
    select count(*) into var5 from cpqg
    where course = var1 and professor = var2 and quarter = var3 and year = var4 and NEW.grade LIKE (grade || '%'); 
  
    IF var5 > 0 THEN UPDATE cpqg SET sumgrade = sumgrade + 1
    WHERE course = var1 and professor = var2 and quarter = var3 and year = var4 and NEW.grade LIKE (grade || '%');
    ELSIF NEW.grade LIKE 'A%' THEN
INSERT INTO cpqg VALUES (var1, var2, var3, var4,'A', 1);
ELSIF NEW.grade LIKE 'B%' THEN
INSERT INTO cpqg VALUES (var1, var2, var3, var4,'B', 1);
ELSIF NEW.grade LIKE 'C%' THEN
INSERT INTO cpqg VALUES (var1, var2, var3, var4,'C', 1);
ELSIF NEW.grade LIKE 'D%' THEN
INSERT INTO cpqg VALUES (var1, var2, var3, var4,'D', 1);
ELSE INSERT INTO cpqg VALUES (var1, var2, var3, var4,'F', 1);
 
    END IF; 
    
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;
 
DROP TRIGGER IF EXISTS cpqg_insert_trigger ON studentpastclasses;
CREATE TRIGGER cpqg_insert_trigger
BEFORE INSERT ON studentpastclasses
FOR EACH ROW EXECUTE PROCEDURE cpqginsertgrade();
 
