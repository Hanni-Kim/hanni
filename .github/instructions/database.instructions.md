# Database Instructions

데이터베이스 설계, 개발, 운영에 관한 종합 가이드라인입니다.

## 🎯 핵심 원칙

### 1. 설계 원칙
- **정규화**: 3NF까지 정규화를 기본으로 하되, 성능 요구사항에 따라 비정규화 고려
- **명명 규칙**: 일관된 테이블, 컬럼, 인덱스 명명 규칙 준수
- **데이터 타입**: 적절한 데이터 타입 선택으로 저장 공간 최적화
- **제약 조건**: PK, FK, CHECK, UNIQUE 제약 조건 적절히 활용

### 2. 성능 최적화
- **인덱스 전략**: 쿼리 패턴을 분석하여 효율적인 인덱스 설계
- **쿼리 최적화**: 실행 계획 분석 및 쿼리 튜닝
- **파티셔닝**: 대용량 테이블에 대한 수평/수직 파티셔닝 고려
- **캐싱**: 적절한 캐싱 전략으로 DB 부하 분산

## 📝 SQL 작성 규칙

### 기본 스타일
```sql
-- Good: 명확하고 읽기 쉬운 형태
SELECT 
    customer_id,
    customer_name,
    order_date,
    total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= '2024-01-01'
    AND o.status = 'COMPLETED'
ORDER BY o.order_date DESC;

-- Bad: 한 줄로 작성된 복잡한 쿼리
SELECT customer_id,customer_name,order_date,total_amount FROM customers c INNER JOIN orders o ON c.customer_id=o.customer_id WHERE o.order_date>='2024-01-01' AND o.status='COMPLETED' ORDER BY o.order_date DESC;
```

### 명명 규칙
- **테이블**: `snake_case` 사용 (예: `customer_orders`)
- **컬럼**: `snake_case` 사용 (예: `created_at`)
- **인덱스**: `idx_tablename_columnname` 형식
- **제약 조건**: `ck_tablename_condition` 형식

### CTE 활용
```sql
-- 복잡한 쿼리는 CTE로 구조화
WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', order_date) as month,
        SUM(total_amount) as total_sales
    FROM orders 
    WHERE order_date >= '2024-01-01'
    GROUP BY DATE_TRUNC('month', order_date)
),
sales_growth AS (
    SELECT 
        month,
        total_sales,
        LAG(total_sales) OVER (ORDER BY month) as prev_month_sales
    FROM monthly_sales
)
SELECT 
    month,
    total_sales,
    ROUND(((total_sales - prev_month_sales) / prev_month_sales * 100), 2) as growth_rate
FROM sales_growth
WHERE prev_month_sales IS NOT NULL;
```

## 🔒 보안 가이드라인

### 1. 접근 제어
- **최소 권한 원칙**: 필요한 최소한의 권한만 부여
- **역할 기반 접근**: 사용자별 개별 권한보다 역할 기반 권한 관리
- **정기적인 권한 검토**: 권한의 적절성을 정기적으로 검토

### 2. 데이터 보호
- **암호화**: 민감한 데이터는 컬럼 수준 암호화 적용
- **마스킹**: 개발/테스트 환경에서 개인정보 마스킹
- **백업 암호화**: 백업 데이터도 암호화하여 저장

### 3. SQL Injection 방지
```sql
-- Good: 파라미터화된 쿼리 사용
PREPARE stmt FROM 'SELECT * FROM users WHERE user_id = ?';
EXECUTE stmt USING @user_id;

-- Bad: 동적 SQL 직접 연결
-- "SELECT * FROM users WHERE user_id = " + userInput
```

## 📊 모니터링 및 유지보수

### 1. 성능 모니터링
- **실행 계획**: 정기적인 쿼리 실행 계획 분석
- **인덱스 사용률**: 사용되지 않는 인덱스 식별 및 제거
- **대기 이벤트**: 병목 지점 식별을 위한 대기 이벤트 모니터링
- **리소스 사용률**: CPU, 메모리, I/O 사용률 추적

### 2. 데이터 품질
- **데이터 검증**: 정기적인 데이터 무결성 검사
- **이상 데이터 탐지**: 통계적 방법을 통한 이상값 탐지
- **데이터 프로파일링**: 데이터 분포 및 품질 지표 분석

### 3. 백업 및 복구
```sql
-- 백업 스크립트 예시
BACKUP DATABASE [ProductionDB] 
TO DISK = '/backup/ProductionDB_Full.bak'
WITH COMPRESSION, CHECKSUM, INIT;

-- 로그 백업
BACKUP LOG [ProductionDB] 
TO DISK = '/backup/ProductionDB_Log.trn'
WITH COMPRESSION, CHECKSUM;
```

## 🚀 Best Practices

### 1. 개발 단계
- **코드 리뷰**: 모든 DB 변경사항은 코드 리뷰 필수
- **마이그레이션**: 스키마 변경은 마이그레이션 스크립트로 관리
- **테스트**: 단위 테스트 및 통합 테스트 작성
- **문서화**: ERD 및 데이터 사전 최신 상태 유지

### 2. 운영 단계
- **변경 관리**: 모든 운영 변경은 승인 프로세스 거쳐서 진행
- **모니터링 설정**: 적절한 알림 및 대시보드 구성
- **용량 계획**: 성장률 기반 용량 계획 수립
- **재해 복구**: 정기적인 재해 복구 테스트 실시

## 🔧 도구 및 기술

### 추천 도구
- **설계**: ERDCloud, draw.io, Lucidchart
- **개발**: DBeaver, SQL Server Management Studio, pgAdmin
- **모니터링**: Grafana, DataDog, New Relic
- **마이그레이션**: Flyway, Liquibase

### 기술 스택 고려사항
- **RDBMS**: PostgreSQL, MySQL, SQL Server 특성 고려
- **NoSQL**: MongoDB, Redis 등 용도에 맞는 선택
- **클라우드**: AWS RDS, Azure SQL, GCP Cloud SQL 활용

---

*데이터베이스는 애플리케이션의 핵심입니다. 신중한 설계와 지속적인 관리를 통해 안정적이고 확장 가능한 시스템을 구축하세요.*