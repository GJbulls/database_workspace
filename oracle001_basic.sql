SELECT first_name
FROM employees;
-- 실행 : Ctrl + Enter

--주석처리 한 라인
/* 주석처리     */

--도구 >환경설정 > 코드 편집기 > 글꼴 > 글꼴크기

SELECT * FROM tab;
/*
컬럼명, 테이블명에 별칭(alias)을 지정할 수 있다.
별칭(alias)에 공백이 있을 때는 ""(쌍따옴표)를 지정한다.
*/
--salary를 가져오고 10을 곱해줌 , 
SELECT Salary, salary*10 AS "b o n u s"
FROM employees;

SELECT Salary, salary*10 AS  bonus
FROM employees;

--문자의 연결 ||
SELECT last_name || '님의 급여는' || salary || '입니다.' AS name
from employees;

--DISTINCT 중복값 제거
SELECT DISTINCT first_name
FROM employees;
/*
first_name     last_name
sunder            Abel 중복
sunder            Abel 중복
sunder            Ande 중복값 아님 
*/
SELECT DISTINCT first_name, last_name
FROM employees;

--SELECT 입력 순서
SELECT column_name1, column_name2
FROM table_name1, table_name2
WHERE column_name = 'value'
GROUP BY column_name
HAVING column_name = ' value'
ORDER BY column_name ASC, column_name DESC;

--SELECT 해석 순서
FROM table_name1, table_name2
WHERE column_name = 'value'
GROUP BY column_name
HAVING column_name = ' value'
SELECT column_name1, column_name2
ORDER BY column_name ASC, column_name DESC;

--David만 출력
-- = 같다.
SELECT first_name, salary
FROM employees
WHERE first_name = 'David';

--salary 가 3000미만 일때 출력
SELECT first_name, salary
FROM employees
WHERE salary <3000;

--empolyees테이블에서 david가 아닐때의 출력
SELECT first_name, salary
FROM employees
WHERE first_name <> 'David';

SELECT first_name, salary
FROM employees
WHERE first_name != 'David';

SELECT first_name, salary
FROM employees
WHERE first_name ^= 'David';

--AND(&&) , OR(||)
--employees테이블에서 salary가 3000,9000,17000일때
--first_name, hire_date, salary를 출력하라

SELECT first_name, hire_date, salary
FROM employees
WHERE salary = 3000 OR salary = 9000 OR salary = 17000;
-- 둘 다 salary가 3000,9000,17000에 만족하는 값 출력
SELECT first_name, hire_date, salary
FROM employees
WHERE salary IN(3000 ,9000, 17000);


--employees테이블에서 salary가 3000부터 5000까지 일때의
--first_name, hire_date, salary를 출력하라
SELECT first_name, hire_date, salary
FROM employees
WHERE salary >=3000 AND salary <=5000;
--둘 다 salary 가 3000부터 5000까지 출력
SELECT first_name, hire_date, salary
FROM employees
WHERE salary BETWEEN 3000 AND 5000


--employees테이블에서 salary가 3000,9000,17000아닐때
--first_name, hire_date, salary를 출력하라

SELECT first_name, hire_date, salary
FROM employees
WHERE NOT(salary = 3000 OR salary = 9000 OR salary = 17000);
-- 둘 다 salary가 3000,9000,17000에 만족하는 값 출력
SELECT first_name, hire_date, salary
FROM employees
WHERE salary NOT IN(3000 ,9000, 17000);

--employees테이블에서 salary가 3000부터 5000까지 아닐때의
--first_name, hire_date, salary를 출력하라
SELECT first_name, hire_date, salary
FROM employees
WHERE NOT(salary >=3000 AND salary <=5000);
--둘 다 salary 가 3000부터 5000까지 출력
SELECT first_name, hire_date, salary
FROM employees
WHERE salary NOT BETWEEN 3000 AND 5000;

--employees 테이블에서 commission_pct가 null일때
--first_name, salary, commission_pct를 출력하라
SELECT first_name, salary, commission_pct
FROM employees
WHERE commission_pct IS NULL;

--employees 테이블에서 commission_pct가 null이 아닐 때
--first_name, salary, commission_pct를 출력하라
SELECT first_name, salary, commission_pct
FROM employees
WHERE commission_pct IS NOT NULL;

--employees 테이블에서 first_name에 'dar'이 포함이된
--first_name, salary,email을 출력하라 [LIKE'%%'(와일드카드)] 
SELECT first_name, salary, email
FROM employees
WHERE first_name LIKE '%der%';

--employees 테이블에서 first_name의 값중 'A'로 시작하고
--두번째 문자는 임의 문자이면 'exander'로 끝나는
--first_name, salary,email을 출력하라 
SELECT first_name, salary, email
FROM employees
WHERE first_name LIKE 'A_exander';

/*
WHERE절에서 사용된 연산자 3가지 종류
비교연산자 : =   >   >=   <   <=   !=   <>   ^=
SQL연산자 : BETWEEN a AND b,  IN    , LIKE,  IS NULL
논리연산자 : AND, OR, NOT
*/
/*
우선순위
 1.괄호( )
 2.NOT연산자
 3.비교연산자, SQL연산자
 4.AND
 5.OR
*/

--employees 테이블에서 job_id 오름차순으로 출력
SELECT first_name, email, job_id
FROM employees
ORDER BY job_id ASC; -- 오름차순

SELECT first_name, email, job_id
FROM employees
ORDER BY job_id; -- 오름차순

--employees 테이블에서 department id를 오름차순하고
--first_name를 내림차순(DESC)으로
--first_name, email, job_id를 출력하시오.
SELECT department_id, first_name, salary
FROM employees
ORDER BY department_id ASC, first_name DESC;

--employees 테이블에서 업무(job_id)가 'FI_ACCOUNT'인 사원들의
--급여가 높은순으로 first_name, job_id, salary를 출력하시오
SELECT first_name, job_id, salary
FROM employees
WHERE job_id = 'FI_ACCOUNT'
ORDER BY salary DESC;

/*/////////////////////////////////////
//문제 DESC employees;
////////////////////////////////////// */
-- 1) employees테이블에서 급여가 17000이하인 사원의 사원번호, 사원명(first_name), 급여를 출력하시오.
      SELECT employee_id,first_name ,salary
      FROM employees
      WHERE salary <= 17000;


-- 2) employees테이블에서 2005년 1월 1일 이후에 입사한 사원을 출력하시오.
         SELECT hire_date, first_name 
         FROM employees
         WHERE hire_date >= '2005-01-01';
       /*4월 21일전(<) / 4월 21일이전(=<) */
-- 3) employees테이블에서 급여가 5000이상이고 업무(job_id)이 'IT_PROG'이 사원의 사원명(first_name), 급여, 업무을 출력하시오.
             SELECT first_name, salary, job_id 
             FROM employees
             WHERE job_id = 'IT_PROG' AND salary >=5000 ;

-- 4) employees테이블에서 부서번호가 10, 40, 50 인 사원의 사원명(first_name), 부서번호, 이메일(email)을 출력하시오.
             SELECT department_id, first_name, email 
             FROM employees
             WHERE department_id IN(10 ,40, 50);

-- 5) employees테이블에서 사원명(first_name)이 even이 포함된 사원명,급여,입사일을 출력하시오.
            SELECT  first_name, salary, hire_date 
            FROM employees
            WHERE first_name LIKE '%even%';
-- 6) employees테이블에서 사원명(first_name)이 teve앞뒤에 문자가 하나씩 있는 사원명,급여,입사일을 출력하시오.
            SELECT hire_date, first_name 
         FROM employees
         WHERE hire_date >= '2005-01-01';

-- 7) employees테이블에서 급여가 17000이하이고 커미션이 null이 아닐때의 사원명(first_name), 급여, 
--  커미션을 출력하시오.
          
  
-- 8) 2005년도에 입사한 사원의 사원명(first_name),입사일을 출력하시오.
      

-- 9) 커미션 지급 대상인 사원의 사원명(first_name), 커미션을 출력하시오.
         

-- 10) 사번이 206인 사원의 이름(first_name)과 급여를 출력하시오.
         

-- 11) 급여가 3000이 넘는 업무(job_id),급여(salary)를 출력하시오.
        

-- 12)'ST_MAN'업무을 제외한 사원들의 사원명(first_name)과 업무(job_id)을 출력하시오.
        

-- 13) 업무이 'PU_CLERK' 인 사원 중에서 급여가 10000 이상인 사원명(first_name),업무(job_id),급여(salary)을 출력하시오.
        

-- 14) commission을 받는 사원명(first_name)을 출력하시오.
         
-- 15) 20번 부서와 30번 부서에 속한 사원의 사원명(fist_name), 부서를 출력하시오.
         

-- 16) 급여가 많은 사원부터 출력하되 급여가 같은 경우 사원명(first_name) 순서대로 출력하시오.
         SELECT *
         FROM employees
         ORDER BY salary DESC, first_name ASC;
   
-- 17) 업무이 'MAN' 끝나는 사원의 사원명(first_name), 급여(salary), 업무(job_id)을 출력하시오.
         SELECT first_name, salary, job_id
         FROM employees
         WHERE job_id LIKE '%MAN%';
         
         
/*===================================
집합 연산자 (Set Operation)
===================================
-둘 이상의 query결과를 하나의 결과로 조합한다.
-select의 인자 갯수가 같아야 한다.
    첫번째 select가 2개이면 두번째 select도 2개여야 한다.
-타입이 일치해야 한다.  
    예를 들어 character이면 character이여야 한다.
*/
--합집합(UNION)--
SELECT department_id, first_name, last_name
FROM employees
WHERE department_id =20 OR department_id =40
UNION 
SELECT department_id, first_name, last_name
FROM employees
WHERE department_id =20 OR department_id =60;

--intersect(교집합)--
SELECT department_id, first_name, last_name
FROM employees
WHERE department_id =20 OR department_id =40
intersect 
SELECT department_id, first_name, last_name
FROM employees
WHERE department_id =20 OR department_id =60;

--minus(=except)(차집합)--
SELECT department_id, first_name, last_name
FROM employees
WHERE department_id =20 OR department_id =40
minus 
SELECT department_id, first_name, last_name
FROM employees
WHERE department_id =20 OR department_id =60;















