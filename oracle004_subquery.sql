/*==============================================================================
 서브쿼리(SUBQUERY)란?  하나의 SQL문안에 포함되어 있는 또 다른 SQL문을 말한다.
 - 서브쿼리는 알려지지 않은 기준을 이용한 검색을 위해 사용한다.
 - 서브쿼리는 메인쿼리가 서브쿼리를 포함하는 종속적인 관계이다.
 - 서브쿼리는 메인쿼리의 컬럼을 모두 사용할 수 있지만 메인쿼리는 서브쿼리의 컬럼을 사용할 수 없다. 
 - 질의 결과에 서브쿼리 컬럼을 표시해야 한다면 조인방식으로 변환하거나 
   함수, 스칼라 서브쿼리(scarar subquery)등을 사용해야 한다. 
--------------------------------------------------------------------------------  
1.스칼라 쿼리 : SELECT
2.인라인 뷰 : FROM
3.서브쿼리
==============================================================================*/
-- 90번 부서에 근무하는 Lex 사원의 근무하는 부서명을 출력하시오.
SELECT department_name
FROM departments
WHERE department_id = 90;

-- Lex가 근무하는 부서명을 출력하시오. 
SELECT department_id
FROM employees
WHERE first_name = 'Lex';

SELECT department_name
FROM departments
WHERE department_id = 90;

-- join
SELECT d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id
      AND e.first_name = 'Lex';

-- subquery    
SELECT department_name
FROM departments
WHERE department_id = (
                        SELECT department_id
                        FROM employees
                        WHERE first_name = 'Lex'
                        );  
-- ()안의 값이 90을 나타내주기 때문에 WHERE department_id = 90; 와 동일한 의미가 된다.   
--------------------------------------------------------------------------------
-- 'Lex'와 동일한 업무(job_id)를 가진 
-- 사원의 이름(first_name), 업무명(job_title), 입사일(hire_date)을 출력하시오.
SELECT e.first_name, j.job_title, e.hire_date
FROM employees e, jobs j
WHERE e.job_id = j.job_id
      AND e.job_id = (
                      SELECT job_id
                      FROM employees
                      WHERE first_name = 'Lex' 
                      ); /*job_id = AD_VP*/
--------------------------------------------------------------------------------
-- 'IT'에 근무하는 사원이름(first_name), 부서번호를 출력하시오.
SELECT first_name, department_id
FROM employees
WHERE department_id = (
                        SELECT department_id
                        FROM departments
                        WHERE department_name = 'IT'
                        ); /*department_id = 60*/
-----------------------------------------------------------------------------
-- 'Bruce'보다 급여를 많이 받는 사원이름(first_name), 부서명, 급여를 출력하시오.
SELECT e.first_name, d.department_name, e.salary
FROM employees e, departments d
WHERE e.department_id = d.department_id
AND e.salary > (
               SELECT salary
               FROM employees
               WHERE first_name = 'Bruce'
               ) /*e.salary > 6000*/
ORDER BY e.salary;
--------------------------------------------------------------------------------
-- 부서별로 가장 급여를 많이 받는 사원이름, 부서번호, 급여를 출력하시오.(IN)
SELECT e.first_name, e.department_id, e.salary
FROM employees e
WHERE e.salary;

SELECT department_id, max(salary)
FROM employees
GROUP BY department_id;

-- 서브쿼리에서 넘겨지는 값이 2개이면 메인쿼리에서도 받는 값이2개 있어야하며 ( )소괄호로 묶어준다.
SELECT e.first_name, e.department_id, e.salary
FROM employees e
WHERE (e.department_id, e.salary) IN (
                  SELECT department_id, max(salary)
                  FROM employees
                  GROUP BY department_id
                  )
ORDER BY department_id;
--------------------------------------------------------------------------------
-- 30부서의 모든 사원들의 급여보다 더 많은 급여를 받는 사원이름, 급여, 입사일을 출력하시오.(ALL)
-- (서브쿼리에서 max()함수를 사용하지 않는다.)
SELECT first_name, salary, hire_date
FROM employees
WHERE salary > ALL (
                    --30부서의 모든 사원들이 받는 급여 (최고급여 : 11000)
                    SELECT salary
                    FROM employees
                    WHERE department_id = 30
                    )
ORDER BY salary;
--------------------------------------------------------------------------------
-- 30부서 사원들이 받는 최저급여보다 높은 급여를 받는 사원이름, 급여, 입사일을 출력하시오.(ANY)
-- (서브쿼리에서 min()함수를 사용하지 않는다.)
SELECT first_name, salary, hire_date
FROM employees
WHERE salary > ANY (
                    --30부서의 모든 사원들이 받는 급여 (최저급여 : 2500)
                    SELECT salary
                    FROM employees
                    WHERE department_id = 30
                    )
ORDER BY salary;
--------------------------------------------------------------------------------
-- 사원이 있는 부서만 출력하시오.
SELECT count(*)
FROM departments; /*총 부서 : 27개*/

SELECT department_id, department_name
FROM departments
WHERE department_id IN (
                       --사원이 있는 부서
                       SELECT DISTINCT department_id
                       FROM employees
                       WHERE department_id IS NOT NULL
                       );

-- EXISTS로 구현
SELECT department_id, department_name
FROM departments d
WHERE EXISTS (
             SELECT 1
             FROM employees e
             WHERE e.department_id = d.department_id
             );
/* 
 메인쿼리의 department_id 값과 서브쿼리의 department_id를 비교해서 true인 값을 리턴한다. 
 서브쿼리에서 WHERE가 조건을 하나라도 만족하여 true라면 서브쿼리는 true로 메인쿼리를 수행한다. 
 => 연관 서브쿼리 (상관관계 서브쿼리)
*/

-- NOT EXISTS 사원이 없는 부서만 출력하시오.
SELECT department_id, department_name
FROM departments d
WHERE NOT EXISTS (
                 SELECT 1
                 FROM employees e
                 WHERE e.department_id = d.department_id
                 );
--------------------------------------------------------------------------------
-- 관리자가 있는 사원의 정보를 출력하시오. 
--(SELF JOIN을 이용해서 했던 것을 EXISTS를 이용하여 구현)
SELECT w.employee_id, w.first_name, w.manager_id
FROM employees w
WHERE EXISTS (
             SELECT 1
             FROM employees m
             WHERE w.manager_id = m.employee_id
             ); /*관리자가 존재하면 1을 리턴하므로 true*/

-- 관리자가 없는 사원의 정보를 출력하시오. 
SELECT w.employee_id, w.first_name, w.manager_id
FROM employees w
WHERE NOT EXISTS (
                 SELECT 1
                 FROM employees m
                 WHERE w.manager_id = m.employee_id
                 );                
/*------------------------------------------------------------------------------
ROWNUM
1. oracle의 SELECT문 결과에 대해서 논리적인 일련번호를 부여한다.
2. ROWNUM은 조회되는 행수를 제한할 때 많이 사용한다.
3. rownum=1, rownum <=3;, rownum <3 (가능)
   rownum=3, rownum >=3;, rownum >3 (불가능)
------------------------------------------------------------------------------*/
SELECT rownum , first_name, salary
FROM employees; --o


SELECT rownum, first_name, salary
FROM employees
WHERE rownum =1; --o

SELECT rownum, first_name, salary
FROM employees
WHERE rownum <=3; --o

SELECT rownum, first_name, salary
FROM employees
WHERE rownum =3; --X

SELECT rownum, first_name, salary
FROM employees
WHERE rownum >=3; --X

SELECT b.* 
FROM (SELECT rownum AS rm, a.* 
FROM (SELECT * FROM employees
      ORDER BY salary DESC) a
      )b
WHERE b.rm >=6 AND b.rm <=10;

/*-----------------------------------------------------------------------------
1.oracle에서 데이터를 구분할 수 있는 유일한 값이다.
2.SELECT문에서 rowid를 사용할 수 있다.
3.rowid를 통해서 데이터가 어떤 데이터파일, 어느 블록에 저장되어 있는지 알수 있다.
4.rowid구조(총18자리)
 오브젝트 번호(1~6) : 오브젝트 별로 유일한 값을 가지고 있으며, 해당 오브젝트가 속해 있는 값이다.
 파일번호 (7~9) : 테이블페이스(tablesapce)에 속해 있는 데이터 파일에 대한 상대 파일번호이다.
 블록번호 (10~15) : 데이터 파일 내부에서 어느 블록에 데이터가 있는지 알려준다.
 데이터번호(16~18) : 데이터 블록에 데이터가 저장되어 있는 순서를 의미한다.
 
[block size확인]-8kbyte가 저장됨
SQL> conn sys/a1234 as sysdba
connected.
SQL> show user
USER is "SYS"
SQL> show parameter db block size
----------------------------------------------------------------------------*/
SELECT rowid, first_name, salary
FROM employees;



/*============================================================================
       문제
============================================================================*/
--1) department_id가 60인 부서의 도시명을 알아내는 SELECT문장을 기술하시오

    
--2) 사번이 107인 사원과 부서가같고,167번의 급여보다 많은 사원들의 사번,이름(first_name),급여를 출력하시오.
   
                  
--3) 급여평균보다 급여를 적게받는 사원들중 커미션을 받는 사원들의 
--사번,이름(first_name),급여,커미션 퍼센트를 출력하시오.
    
    
--4) 각 부서의 최소급여가 20번 부서의 최소급여보다 많은 부서의 번호와 그부서의 최소급여를 출력하시오.
 
    
--5) 사원번호가 177인 사원과 담당 업무가 같은 사원의 사원이름(first_name)과 담당업무(job_id)하시오.   

  
--6) 최소 급여를 받는 사원의 이름(first_name), 담당 업무(job_id) 및 급여(salary)를 표시하시오(그룹함수 사용).

				
--7) 업무별 평균 급여가 가장 적은  업무(job_id)를 찾아 업무(job_id)와 평균 급여를 표시하시오.

					  
--8) 각 부서의 최소 급여를 받는 사원의 이름(first_name), 급여(salary), 부서번호(department_id)를 표시하시오.


--9) 담당 업무가 프로그래머(IT_PROG)인 모든 사원보다 급여가 적으면서 업무가 프로그래머(IT_PROG)가 아닌  
--   사원들의 사원번호(employee_id), 이름(first_name), 담당 업무(job_id), 급여(salary)를 출력하시오.
           

--10) 부하직원이 없는 모든 사원의 이름을 표시하시오.
