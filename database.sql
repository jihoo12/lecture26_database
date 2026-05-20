-- 1. 테이블 삭제 (외래 키 관계를 고려한 순서) [cite: 7, 8, 9, 10, 11]
DROP TABLE 예약;
DROP TABLE 상영관;
DROP TABLE 고객;
DROP TABLE 극장;

-- 2. 테이블 생성 [cite: 17, 24, 38, 44]
CREATE TABLE 극장 (
    극장번호 NUMBER PRIMARY KEY,
    극장이름 VARCHAR2(100) NOT NULL,
    위치 VARCHAR2(100)
);

CREATE TABLE 상영관 (
    극장번호 NUMBER,
    상영관번호 NUMBER,
    영화제목 VARCHAR2(200) NOT NULL,
    가격 NUMBER,
    좌석수 NUMBER,
    CONSTRAINT pk_상영관 PRIMARY KEY (극장번호, 상영관번호),
    CONSTRAINT fk_상영관_극장 FOREIGN KEY (극장번호) REFERENCES 극장(극장번호)
);

CREATE TABLE 고객 (
    고객번호 NUMBER PRIMARY KEY,
    이름 VARCHAR2(100) NOT NULL,
    주소 VARCHAR2(200)
);

CREATE TABLE 예약 (
    극장번호 NUMBER,
    상영관번호 NUMBER,
    고객번호 NUMBER,
    좌석번호 NUMBER,
    날짜 DATE,
    CONSTRAINT pk_예약 PRIMARY KEY (극장번호, 상영관번호, 고객번호),
    CONSTRAINT fk_예약_상영관 FOREIGN KEY (극장번호, 상영관번호) REFERENCES 상영관(극장번호, 상영관번호),
    CONSTRAINT fk_예약_고객 FOREIGN KEY (고객번호) REFERENCES 고객(고객번호)
);

-- 3. 예시 데이터 삽입 [cite: 64-103]
-- (생략 가능하나 쿼리 테스트를 위해 문서 내용을 기반으로 반영)
INSERT INTO 극장 VALUES (1, '강남극장', '강남');
INSERT INTO 극장 VALUES (2, '강동극장', '강동');
INSERT INTO 극장 VALUES (3, '홍대극장', '마포');
INSERT INTO 극장 VALUES (4, '신촌극장', '서대문');
INSERT INTO 극장 VALUES (5, '잠실극장', '송파');

INSERT INTO 상영관 VALUES (1, 1, '아바타', 12000, 150);
INSERT INTO 상영관 VALUES (1, 2, '범죄도시4', 11000, 120);
INSERT INTO 상영관 VALUES (2, 1, '듄2', 13000, 200);

INSERT INTO 고객 VALUES (1, '김철수', '서울시 강남구 역삼동');
INSERT INTO 고객 VALUES (2, '이영희', '서울시 강동구 천호동');

COMMIT;

---------------------------------------------------------
-- [문제 3] [cite: 148-159]
---------------------------------------------------------
-- 1) 영화 가격이 9,000원 이상인 상영관의 극장번호 추출
SELECT 극장번호 FROM 상영관 WHERE 가격 >= 9000;

-- 2) 극장별 상영관 (두 테이블 조인)
SELECT * FROM 극장 t, 상영관 s WHERE t.극장번호 = s.극장번호;

-- 3) 영화 가격이 10,000원 이상인 영화를 상영하는 극장이름
SELECT DISTINCT t.극장이름 FROM 극장 t JOIN 상영관 s ON t.극장번호 = s.극장번호 WHERE s.가격 >= 10000;

-- 4) 예약 날짜가 2024년 1월 1일 이후인 고객 정보와 예약 내용 (LEFT OUTER JOIN)
SELECT c.고객번호, c.이름, c.주소, r.극장번호, r.상영관번호, r.좌석번호, r.날짜 
FROM 고객 c LEFT OUTER JOIN 예약 r ON c.고객번호 = r.고객번호 AND r.날짜 > TO_DATE('2024-01-01','YYYY-MM-DD');

-- 5) 강남에 있는 모든 극장을 예약한 고객의 이름과 극장번호
SELECT DISTINCT c.이름, r.극장번호 FROM 고객 c JOIN 예약 r ON c.고객번호 = r.고객번호
WHERE NOT EXISTS (
    SELECT t.극장번호 FROM 극장 t WHERE t.위치 = '강남'
    MINUS
    SELECT r2.극장번호 FROM 예약 r2 WHERE r2.고객번호 = c.고객번호
);

---------------------------------------------------------
-- [문제 4] [cite: 160-172]
---------------------------------------------------------
-- 1) 극장테이블에서 극장이름, 위치를 추출
SELECT 극장이름, 위치 FROM 극장;

-- 2) 영화 가격이 10,000원 이하인 영화제목 추출
SELECT 영화제목 FROM 상영관 WHERE 가격 <= 10000;

-- 3) 고객테이블에서 이름, 주소 추출
SELECT 이름, 주소 FROM 고객;

-- 4) 극장 위치가 강남인 곳에서 상영 중인 영화제목 추출
SELECT s.영화제목 FROM 극장 t JOIN 상영관 s ON t.극장번호 = s.극장번호 WHERE t.위치 = '강남';

-- 5) 강남에 위치한 극장을 모두 예약한 고객 이름
SELECT c.이름 FROM 고객 c WHERE NOT EXISTS (
    SELECT t.극장번호 FROM 극장 t WHERE t.위치 = '강남'
    MINUS
    SELECT r.극장번호 FROM 예약 r WHERE r.고객번호 = c.고객번호
);

---------------------------------------------------------
-- [단순질의] [cite: 173-192]
---------------------------------------------------------
-- 1. 극장테이블에서 극장이름, 위치를 추출
SELECT 극장이름, 위치 FROM 극장;

-- 2. 위치가 '서울'인 극장의 극장이름 조회 (데이터상 '강남', '마포' 등 구체적 지명일 경우 LIKE '%서울%' 혹은 지명 사용)
SELECT 극장이름 FROM 극장 WHERE 위치 LIKE '%서울%' OR 위치 IN ('강남', '강동', '마포', '서대문', '송파');

-- 3. 가격이 10000원 이상인 상영관의 극장번호, 상영관번호, 영화제목 조회
SELECT 극장번호, 상영관번호, 영화제목 FROM 상영관 WHERE 가격 >= 10000;

-- 4. 영화제목별 상영관 수 조회
SELECT 영화제목, COUNT(*) FROM 상영관 GROUP BY 영화제목;

-- 5. 날짜가 '2024-10-01'인 모든 예약 정보 조회 (예시 데이터 날짜 기준)
SELECT * FROM 예약 WHERE 날짜 = TO_DATE('2024-10-01', 'YYYY-MM-DD');

-- 6. 주소별 고객 수 조회
SELECT 주소, COUNT(*) FROM 고객 GROUP BY 주소;

-- 7. 좌석수가 가장 많은 상영관의 극장번호와 상영관번호 조회
SELECT 극장번호, 상영관번호 FROM 상영관 WHERE 좌석수 = (SELECT MAX(좌석수) FROM 상영관);

-- 8. 고객번호별 예약 횟수 조회
SELECT 고객번호, COUNT(*) FROM 예약 GROUP BY 고객번호;

-- 9. 극장번호별 평균 가격 조회
SELECT 극장번호, AVG(가격) FROM 상영관 GROUP BY 극장번호;

-- 10. 이름이 '김'으로 시작하는 고객의 이름과 주소 조회
SELECT 이름, 주소 FROM 고객 WHERE 이름 LIKE '김%';

---------------------------------------------------------
-- [조인질의] [cite: 193-211]
---------------------------------------------------------
-- 11. 극장이름과 해당 극장의 영화제목 조회
SELECT t.극장이름, s.영화제목 FROM 극장 t JOIN 상영관 s ON t.극장번호 = s.극장번호;

-- 12. 극장이름, 영화제목, 예약 날짜 조회
SELECT t.극장이름, s.영화제목, r.날짜 FROM 극장 t JOIN 상영관 s ON t.극장번호 = s.극장번호 JOIN 예약 r ON s.극장번호 = r.극장번호 AND s.상영관번호 = r.상영관번호;

-- 13. 고객 이름과 해당 고객의 예약 날짜 조회
SELECT c.이름, r.날짜 FROM 고객 c JOIN 예약 r ON c.고객번호 = r.고객번호;

-- 14. 극장이름, 영화제목, 고객이름, 좌석번호 조회
SELECT t.극장이름, s.영화제목, c.이름, r.좌석번호 FROM 극장 t JOIN 상영관 s ON t.극장번호 = s.극장번호 JOIN 예약 r ON s.극장번호 = r.극장번호 AND s.상영관번호 = r.상영관번호 JOIN 고객 c ON r.고객번호 = c.고객번호;

-- 15. 영화제목별 총 예약 수 조회
SELECT s.영화제목, COUNT(r.고객번호) FROM 상영관 s JOIN 예약 r ON s.극장번호 = r.극장번호 AND s.상영관번호 = r.상영관번호 GROUP BY s.영화제목;

-- 16. 위치가 '강남'인 극장에서 상영 중인 영화제목과 가격 조회
SELECT s.영화제목, s.가격 FROM 극장 t JOIN 상영관 s ON t.극장번호 = s.극장번호 WHERE t.위치 = '강남';

-- 17. 예약이 한 건도 없는 고객의 이름 조회 (LEFT JOIN)
SELECT c.이름 FROM 고객 c LEFT JOIN 예약 r ON c.고객번호 = r.고객번호 WHERE r.고객번호 IS NULL;

-- 18. 극장별 총 예약 수 조회
SELECT t.극장이름, COUNT(r.고객번호) FROM 극장 t JOIN 예약 r ON t.극장번호 = r.극장번호 GROUP BY t.극장이름;

-- 19. 가격이 15000원 이상인 상영관을 예약한 고객번호와 영화제목 조회
SELECT r.고객번호, s.영화제목 FROM 상영관 s JOIN 예약 r ON s.극장번호 = r.극장번호 AND s.상영관번호 = r.상영관번호 WHERE s.가격 >= 15000;

-- 20. 고객별 총 예약 횟수와 이름 조회
SELECT c.이름, COUNT(r.고객번호) FROM 고객 c JOIN 예약 r ON c.고객번호 = r.고객번호 GROUP BY c.고객번호, c.이름;

---------------------------------------------------------
-- [부속질의] [cite: 212-234]
---------------------------------------------------------
-- 21. 가장 많은 예약이 발생한 극장번호 조회
SELECT 극장번호 FROM 예약 GROUP BY 극장번호 HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM 예약 GROUP BY 극장번호);

-- 22. 예약 기록이 있는 고객의 이름과 주소 (IN 사용)
SELECT 이름, 주소 FROM 고객 WHERE 고객번호 IN (SELECT 고객번호 FROM 예약);

-- 23. 상영관이 3개 이상 등록된 극장의 극장이름 조회
SELECT 극장이름 FROM 극장 WHERE 극장번호 IN (SELECT 극장번호 FROM 상영관 GROUP BY 극장번호 HAVING COUNT(*) >= 3);

-- 24. 전체 상영관 평균 가격보다 비싼 상영관의 영화제목과 가격 조회
SELECT 영화제목, 가격 FROM 상영관 WHERE 가격 > (SELECT AVG(가격) FROM 상영관);

-- 25. 예약 기록이 전혀 없는 고객의 이름 (NOT IN 사용)
SELECT 이름 FROM 고객 WHERE 고객번호 NOT IN (SELECT DISTINCT 고객번호 FROM 예약);

-- 26. 예약된 적이 없는 극장의 극장이름 조회
SELECT 극장이름 FROM 극장 WHERE 극장번호 NOT IN (SELECT DISTINCT 극장번호 FROM 예약);

-- 27. 예약 횟수가 전체 고객 평균 예약 횟수보다 많은 고객번호 조회
SELECT 고객번호 FROM 예약 GROUP BY 고객번호 HAVING COUNT(*) > ( SELECT AVG(COUNT(*)) FROM 예약 GROUP BY 고객번호 );

-- 28. 좌석수가 가장 적은 상영관이 속한 극장의 극장이름 조회
SELECT 극장이름 FROM 극장 WHERE 극장번호 IN (SELECT 극장번호 FROM 상영관 WHERE 좌석수 = (SELECT MIN(좌석수) FROM 상영관));

-- 29. '2024-10-01'에 예약이 발생한 상영관의 영화제목 조회
SELECT 영화제목 FROM 상영관 WHERE (극장번호, 상영관번호) IN (SELECT 극장번호, 상영관번호 FROM 예약 WHERE 날짜 = TO_DATE('2024-10-01', 'YYYY-MM-DD'));

-- 30. 두 번 이상 예약한 고객의 이름 조회
SELECT 이름 FROM 고객 WHERE 고객번호 IN (SELECT 고객번호 FROM 예약 GROUP BY 고객번호 HAVING COUNT(*) >= 2);

---------------------------------------------------------
-- [상관부속질의] [cite: 235-254]
---------------------------------------------------------
-- 31. 본인 고객번호로 예약 기록이 존재하는 고객 이름 (EXISTS 사용)
SELECT c.이름 FROM 고객 c WHERE EXISTS (SELECT 1 FROM 예약 r WHERE r.고객번호 = c.고객번호);

-- 32. 같은 극장 내 상영관 평균 가격보다 비싼 상영관의 영화제목과 가격
SELECT s1.영화제목, s1.가격 FROM 상영관 s1 WHERE s1.가격 > (SELECT AVG(s2.가격) FROM 상영관 s2 WHERE s2.극장번호 = s1.극장번호);

-- 33. 해당 극장에 예약된 건수가 5건 이상인 극장의 극장이름
SELECT t.극장이름 FROM 극장 t WHERE (SELECT COUNT(*) FROM 예약 r WHERE r.극장번호 = t.극장번호) >= 5;

-- 34. 좌석번호가 '15'번인 기록이 존재하는 고객 이름 (문서 예시 '15'번 기준)
SELECT c.이름 FROM 고객 c WHERE EXISTS (SELECT 1 FROM 예약 r WHERE r.고객번호 = c.고객번호 AND r.좌석번호 = 15);

-- 35. 예약된 기록이 하나도 없는 상영관의 영화제목 (NOT EXISTS 사용)
SELECT s.영화제목 FROM 상영관 s WHERE NOT EXISTS (SELECT 1 FROM 예약 r WHERE r.극장번호 = s.극장번호 AND r.상영관번호 = s.상영관번호);

-- 36. 같은 고객이 동일 날짜에 두 건 이상 예약한 고객번호와 날짜
SELECT DISTINCT r1.고객번호, r1.날짜 FROM 예약 r1 WHERE EXISTS (SELECT 1 FROM 예약 r2 WHERE r2.고객번호 = r1.고객번호 AND r2.날짜 = r1.날짜 AND (r1.극장번호 <> r2.극장번호 OR r1.상영관번호 <> r2.상영관번호));

-- 37. 소속된 모든 상영관의 가격이 10000원 이상인 극장의 극장이름 (NOT EXISTS 활용)
SELECT t.극장이름 FROM 극장 t WHERE NOT EXISTS (SELECT 1 FROM 상영관 s WHERE s.극장번호 = t.극장번호 AND s.가격 < 10000);

-- 38. 서로 다른 극장에 2곳 이상 예약한 고객의 이름
SELECT c.이름 FROM 고객 c WHERE (SELECT COUNT(DISTINCT r.극장번호) FROM 예약 r WHERE r.고객번호 = c.고객번호) >= 2;

-- 39. 같은 극장 내에서 좌석수가 가장 많은 상영관의 영화제목
SELECT s1.영화제목 FROM 상영관 s1 WHERE s1.좌석수 = (SELECT MAX(s2.좌석수) FROM 상영관 s2 WHERE s2.극장번호 = s1.극장번호);

-- 40. 가장 최근 날짜에 예약한 고객의 이름 조회
SELECT c.이름 FROM 고객 c WHERE EXISTS (SELECT 1 FROM 예약 r WHERE r.고객번호 = c.고객번호 AND r.날짜 = (SELECT MAX(날짜) FROM 예약));

EXIT