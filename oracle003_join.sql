/*===========================================================================
join(조인)
1. 여러개의 테이블에서 원하는 데이터를 추출해주는 쿼리문이다.
2. join은 oracle제품에서 사용되는 oracle용 join이 있고 
   모든 제품에서 공통적으로 사용되는 표준(ANSI) join이 있다.
===========================================================================*/
/*---------------------------------------------------------------------------
1. equi join
   가장 많이 사용되는 조인방법으로 조인 대상이 되는 두 테이블에서 공통적으로 존재하는 
   컬럼의 값이 일치되는 행을 연결하여 결과를 생성하는 방법이다.
----------------------------------------------------------------------------*/
/*
SELECT department_id
FROM employees;
--------------------- 서로 관계가(연결) 설정되어 있어야한다./데이터의 의미가 같아야한다.
SELECT department_id
FROM departments;
----------------------------------------------------------------------------
(둘다 department_id를 가지고 있으므로 어떤 테이블것을 사용할건지 명시가 필요하다.)
SELECT departments.department_id
FROM employees, departments; 
----------------------------------------------------------------------------
SELECT dept.department_id
FROM employees AS emp, departments AS dept; (FROM절에서는 AS를 사용하지 않는다.)
*/
----------------------------------------------------------------------------
--(1) oracle : equi join
SELECT dept.department_id, emp.first_name, emp.job_id, dept.department_name
FROM employees emp, departments dept
WHERE emp.department_id = dept.department_id;

--(2) ansi : inner join
SELECT dept.department_id, emp.first_name, emp.job_id, dept.department_name
FROM employees emp INNER JOIN departments dept
ON emp.department_id = dept.department_id;


-- employees와 departments 테이블에서 사원번호(employee_id), 부서번호(department_id),
-- 부서명(department_name)을 검색하시오.
SELECT  emp.employee_id, dept.department_id, dept.department_name
FROM employees emp, departments dept
WHERE emp.department_id = dept.department_id;

SELECT  emp.employee_id, dept.department_id, dept.department_name
FROM employees emp INNER JOIN departments dept
ON emp.department_id = dept.department_id;
-------------------------------------------------------------------------------
-- employee와 jobs 테이블에서 사원번호(employee_id), 
-- 업무번호(job_id), 업무명(job_title)을 검색하시오.
SELECT emp.employee_id, job.job_id, job.job_title
FROM employees emp, jobs job
WHERE emp.job_id = job.job_id;

SELECT emp.employee_id, job.job_id, job.job_title
FROM employees emp INNER JOIN jobs job
ON emp.job_id = job.job_id;
-------------------------------------------------------------------------------
-- job_id가 'FI_MGR'인 사원이 속한 급여(salary)의 
-- 최소값(min_salary), 최대값(max_salary)를 출력하시오.
SELECT e.job_id, e.first_name, j.min_salary, j.max_salary
FROM employees e, jobs j
WHERE e.job_id = j.job_id AND e.job_id = 'FI_MGR';

SELECT e.job_id, e.first_name, j.min_salary, j.max_salary
FROM employees e INNER JOIN jobs j
ON e.job_id = j.job_id 
WHERE e.job_id = 'FI_MGR';
-------------------------------------------------------------------------------
-- 부서가 'Seattle'인 부서에서 근무하는 직원들의 
-- first_name, hire_date, department_id, city를 출력하시오.
SELECT e.first_name, e.hire_date, d.department_id, l.city 
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id AND d.location_id = l.location_id
      AND l.city = 'Seattle';

SELECT e.first_name, e.hire_date, d.department_id, l.city 
FROM employees e INNER JOIN departments d
ON e.department_id = d.department_id 
   INNER JOIN locations l
ON d.location_id = l.location_id
WHERE l.city = 'Seattle';
-------------------------------------------------------------------------------
-- 20번 부서의 이름과 그 부서에 근무하는 사원의 이름(first_name)을 출력하시오.
SELECT e.first_name, d.department_id, d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id AND d.department_id = 20;

SELECT e.first_name, d.department_id, d.department_name
FROM employees e INNER JOIN departments d
ON e.department_id = d.department_id AND d.department_id = 20;
-------------------------------------------------------------------------------
-- 1400, 1500번 위치의 도시이름과 그곳에 있는 부서의 이름을 출력하시오.
SELECT l.location_id, l.city, d.department_name 
FROM departments d, locations l
WHERE d.location_id = l.location_id AND l.location_id IN(1400, 1500);

SELECT l.location_id, l.city, d.department_name 
FROM departments d INNER JOIN locations l
ON d.location_id = l.location_id AND l.location_id IN(1400, 1500);


/*---------------------------------------------------------------------------
2. carteian product(카티션 곱) 조인 : 테이블 행의 갯수만큼 출력해주는 조인이다. 
----------------------------------------------------------------------------*/
--(1) oracle : carteian product
SELECT e.department_id, e.first_name, e.job_id, j.job_title
FROM employees e, jobs j; --2033

SELECT count(*) FROM employees; --107
SELECT count(*) FROM jobs;      --19

--(2) ANSI : cross join
SELECT e.department_id, e.first_name, e.job_id, j.job_title
FROM employees e CROSS JOIN jobs j; --2033


/*---------------------------------------------------------------------------
3. NATURAL JOIN
   NATURAL JOIN은 두 테이블 간의 동일한 이름을 갖는 모든 컬럼들에 대해 EQUI(=) JOIN을 수행한다.
   그리고, SQL SERVER에서는 지원하지 않는 기능이다.
----------------------------------------------------------------------------*/
SELECT first_name, salary, department_id, department_name
FROM employees NATURAL JOIN departments;


/*---------------------------------------------------------------------------
4. non-equi join
   (=)동등비교연산자를 제외한 >=, <=, >, < 등의 연산자를 이용해서 조건을 지정하는 방법이다. 
----------------------------------------------------------------------------*/
--(1) oracle : NON-equi join
SELECT e.first_name, e.salary, j.min_salary, j.max_salary, j.job_title
FROM employees e, jobs j
WHERE e.job_id = j.job_id 
      AND e.salary >= j.min_salary
      AND e.salary <= j.max_salary;
      
--(2) ansi : NON-equi join
SELECT e.first_name, e.salary, j.min_salary, j.max_salary, j.job_title
FROM employees e JOIN jobs j
ON e.salary >= j.min_salary AND e.salary <= j.max_salary;


/*---------------------------------------------------------------------------
5. OUTER JOIN
   한 테이블은 데이터가 있고 다른 반대쪽에는 데이터가 없는 경우에 
   데이터가 있는 테이블의 내용을 모두 가져오는 조건이다.
----------------------------------------------------------------------------*/
--(1) oracle : OUTER JOIN
SELECT e.first_name, e.employee_id, e.department_id, d.department_id, d.department_name
FROM employees e, departments d              /* 사원테이블, 부서테이블 */
WHERE e.department_id = d.department_id;     /* 부서를 배정받은 사원들을 가져온다. */
--WHERE e.department_id = d.department_id(+); /*LEFT OUTER JOIN*/
/* 부서를 배정받지 못한 사원들도 가져온다. */

SELECT e.first_name, e.employee_id, e.department_id, d.department_id, d.department_name
FROM employees e, departments d
WHERE e.department_id(+) = d.department_id; /*RIGHT OUTER JOIN*/
/* 배정된 사원이 없는 부서들을 가져온다. */

SELECT e.first_name, e.employee_id, e.department_id, d.department_id, d.department_name
FROM employees e, departments d
WHERE e.department_id(+) = d.department_id(+); /*FULL OUTER JOIN*/
-- 출력X => ORA-01468: a predicate may reference only one outer-joined table
-- FULL OUTER JOIN은 oracle에서는 제공하지 않고 ansi에서만 제공한다.

--(2) ansi : OUTER JOIN
SELECT e.first_name, e.employee_id, e.department_id, d.department_id, d.department_name
FROM employees e LEFT OUTER JOIN departments d
ON e.department_id = d.department_id; /*LEFT OUTER JOIN*/

SELECT e.first_name, e.employee_id, e.department_id, d.department_id, d.department_name
FROM employees e RIGHT OUTER JOIN departments d
ON e.department_id = d.department_id; /*RIGHT OUTER JOIN*/

SELECT e.first_name, e.employee_id, e.department_id, d.department_id, d.department_name
FROM employees e FULL OUTER JOIN departments d
ON e.department_id = d.department_id; /*FULL OUTER JOIN*/


/*---------------------------------------------------------------------------
6. SELF JOIN
   하나의 테이블을 두 개의 테이블로 설정해서 사용하는 조인방법이다.
   하나의 테이블에 같은 데이터가 두개의 컬럼에 다른 목적으로 저장되어 있는 경우 
   ex. SELECT employee_id, first_name, manager_id FROM employees;
----------------------------------------------------------------------------*/
-- 사원테이블 w
SELECT w.employee_id AS 사원번호, w.first_name AS 사원이름, w.manager_id AS 매니저번호
FROM employees w
ORDER BY w.employee_id;

-- 매니저테이블 m
SELECT m.employee_id AS 매니저번호, m.first_name AS 매니저이름
FROM employees m
ORDER BY m.employee_id;
-------------------------------------------------------------------------------
--매니저를 배정받은 사원의 정보를 출력
--(1) oracle : SELF JOIN
SELECT w.employee_id AS 사원번호, w.first_name AS 사원이름,
       w.manager_id AS 매니저번호, m.first_name AS 매니저이름
FROM employees w, employees m
WHERE w.manager_id = m.employee_id
ORDER BY w.employee_id;

--(2) ansi : SELF JOIN
SELECT w.employee_id AS 사원번호, w.first_name AS 사원이름,
       w.manager_id AS 매니저번호, m.first_name AS 매니저이름
FROM employees w JOIN employees m
ON w.manager_id = m.employee_id
ORDER BY w.employee_id;
-------------------------------------------------------------------------------
--모든 사원의 정보와 매니저를 출력
SELECT w.employee_id AS 사원번호, w.first_name AS 사원이름,
       w.manager_id AS 매니저번호, m.first_name AS 매니저이름
FROM employees w, employees m
WHERE w.manager_id = m.employee_id(+)
ORDER BY w.employee_id;
-------------------------------------------------------------------------------
--매니저의 정보가 없으면(=NULL값이면) 'CEO'를 출력하라.
SELECT w.employee_id AS 사원번호, w.first_name AS 사원이름,
       w.manager_id AS 매니저번호, nvl(m.first_name, 'CEO') AS 매니저이름
FROM employees w, employees m
WHERE w.manager_id = m.employee_id(+)
ORDER BY w.employee_id;


/*---------------------------------------------------------------------------
 USING
----------------------------------------------------------------------------*/
SELECT department_id, first_name, job_id, department_name
FROM employees INNER JOIN departments
USING(department_id)
--ON emp.departmnet_id = dept.department_id
WHERE department_id = 30;


/*============================================================================
 문제
============================================================================*/
/*
 1) EMPLOYEES 테이블에서 입사한 달(hire_date) 별로 인원수를 조회하시오 . 
    <출력: 월        직원수   >
*/
SELECT to_char(hire_date, 'mm') AS 월, count(*) AS 직원수
FROM employees
GROUP BY hire_date
ORDER BY hire_date;

--answ
SELECT to_char(hire_date, 'mm') AS 월, count(*) AS 직원수
FROM employees
GROUP BY to_char(hire_date, 'mm')
ORDER BY 월;
/* ORDER BY to_char(hire_date, 'mm'); 
   ORDER BY절보다 SELECT절이 먼저 수행되므로 ORDER BY를 다르게 구현해준다. */
/*----------------------------------------------------------------------------
2) 각 부서에서 근무하는 직원수를 조회하는 SQL 명령어를 작성하시오. 단, 직원수가 5명 이하인 부서 정보만 
   출력되어야 하며 부서정보가 없는 직원이 있다면 부서명에 “<미배치인원>” 이라는 문자가 출력되도록 하시오. 
   그리고 출력결과는 직원수가 많은 부서먼저 출력되어야 합니다.
*/
SELECT nvl(d.department_name, '<미배치인원>') AS 부서명, count(*) AS 직원수
FROM employees e FULL JOIN departments d
ON e.department_id = d.department_id 
GROUP BY d.department_name
HAVING count(*) <= 5
ORDER BY 직원수 DESC;

--answ
SELECT nvl(d.department_name, '<미배치인원>'), count(*) AS 인원수
FROM employees e, departments d
WHERE e.department_id = d.department_id(+)
GROUP BY d.department_name
HAVING  count(*) <= 5
ORDER BY 인원수 DESC;
/*---------------------------------------------------------------------------- 
3) 각 부서 이름 별로 2005년 이전에 입사한 직원들의 인원수를 조회하시오.
   <출력 :    부서명		입사년도	인원수  >
*/
SELECT d.department_name AS 부서명, count(e.department_id) AS 인원수
FROM employees e, departments d
WHERE e.department_id = d.department_id 
      AND to_char(hire_date, 'yyyy') <= '2005'
GROUP BY d.department_name;

--answ
SELECT d.department_name AS 부서명, to_char(hire_date, 'yyyy') AS 입사년도,
       count(*) AS 인원수
FROM employees e, departments d
GROUP BY d.department_name, to_char(hire_date, 'yyyy')
HAVING to_char(hire_date, 'yyyy') <= '2005'
ORDER BY 입사년도;
/*----------------------------------------------------------------------------
4) 직책(job_title)에서 'Manager'가 포함이된 
   사원의 이름(first_name), 직책(job_title), 부서명(department_name)을 조회하시오.
*/
SELECT e.first_name AS "사원의 이름" , j.job_title AS 직책, d.department_name AS 부서명
FROM employees e, jobs j, departments d
WHERE e.department_id = d.department_id AND e.job_id = j.job_id 
      AND j.job_title LIKE '%Manager%';
      
--answ
SELECT first_name, job_title, department_name /*컬럼이 특정 테이블에서만 존재하기때문에 지정안해도 가능*/
FROM employees e, jobs j, departments d
WHERE e.job_id = j.job_id 
      AND e.department_id = d.department_id
      AND j.job_title LIKE '%Manager%';
/*----------------------------------------------------------------------------
5)'Executive' 부서에 속에 있는 직원들의 관리자 이름을 조회하시오. 
   단, 관리자가 없는 직원이 있다면 그 직원 정보도 출력결과에 포함시켜야 합니다.
   <출력 : 부서번호 직원명  관리자명  >
*/
SELECT d.department_id AS 부서번호, w.first_name AS 직원명, m.first_name AS 관리자명
FROM employees w, employees m, departments d
WHERE w.manager_id = m.employee_id(+)
      AND w.department_id = d.department_id
      AND d.department_name = 'Executive';













