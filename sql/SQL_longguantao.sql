--ORACLE  
--AUTHOR:LONGGUANTAO
--1����1��ͳ��20171001��20171007�ڼ��ۼƷ���pv����100�������û�����
SELECT COUNT(DISTINCT C.MSISDN)
  FROM (SELECT A.MSISDN, SUM(A.PV) PV
          FROM PAGEVISIT A,
               (SELECT DISTINCT MSISDN FROM USER_INFO WHERE SEX = '��') B
         WHERE A.RECORD_DAY BETWEEN '20171001' AND '20171007'
           AND A.MSISDN = B.MSISDN
         GROUP BY A.MSISDN) C
 WHERE C.PV > 100;

--1����2��ͳ��20171001��20171007�ڼ���������3���з��ʵ��û��嵥
SELECT DISTINCT D.MSISDN
  FROM (SELECT C.MSISDN, COUNT(*) DAYS --������������
          FROM (SELECT B.MSISDN, (B.RECORD_DAY - ROWNUM) RN --��������ʱ������-�кŵĲ�ֵ��ͬ
                  FROM (SELECT DISTINCT A.MSISDN, A.RECORD_DAY --���û�����������ȥ������
                          FROM PAGEVISIT A
                         ORDER BY 1, 2) B) C
         GROUP BY C.MSISDN, C.RN) D
 WHERE D.DAYS >= 3;

--2��ͳ��ÿ��������н������top3���û��б�   ��������|Ա������|н��
SELECT D.DEPT_NAME, E.NAME, E.SALARY
  FROM EMPLOYEE E,
       (SELECT B.DEPARTMENTID, B.SALARY --ȡ��ÿ������ǰ��������ֵ
          FROM (SELECT A.*,
                       ROW_NUMBER() OVER(PARTITION BY A.DEPARTMENTID ORDER BY A.SALARY DESC) AS RN
                  FROM (SELECT DISTINCT DEPARTMENTID, SALARY --�����š�����ȥ��
                          FROM EMPLOYEE) A) B
         WHERE B.RN <= 3) C,
       DEPARTMENT D
 WHERE E.DEPARTMENTID = C.DEPARTMENTID
   AND E.SALARY = C.SALARY
   AND E.DEPARTMENTID = D.DEPARTMENTID(+);

--3��дһ�� SQL ͳ��2013-10-01����2013-10-03���ڼ䣬ÿ��ǽ�ֹ�û���ȡ����
SELECT A.REQUEST_AT DAY,
       ROUND(COUNT(CASE
                     WHEN UPPER(A.STATUS) IN
                          ('CANCELLED_BY_DRIVER', 'CANCELLED_BY_CLIENT') THEN
                      A.STATUS
                     ELSE
                      NULL
                   END) / COUNT(*),
             2) CANCELLATION_RATE
  FROM TRIPS A, (SELECT DISTINCT USER_ID FROM USERS WHERE BANNED = 'YES') B
 WHERE A.CLIENT_ID = B.USER_ID
   AND A.DRIVER_ID = B.USER_ID
   AND A.REQUEST_AT BETWEEN '2013-10-01' AND '2013-10-03'
 GROUP BY A.REQUEST_AT;





