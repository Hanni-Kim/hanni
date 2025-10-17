# Database Style Guide

데이터베이스 설계 및 개발을 위한 스타일 가이드입니다.

## 📋 명명 규칙

### 테이블 명명
```sql
-- Good: 복수형, snake_case 사용
CREATE TABLE customer_orders (
    id BIGINT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    order_date DATE NOT NULL
);

-- Bad: 단수형, camelCase 사용
CREATE TABLE customerOrder (
    ID BIGINT PRIMARY KEY,
    customerId BIGINT NOT NULL,
    orderDate DATE NOT NULL
);
```

### 컬럼 명명
- **기본 키**: `id` (단순명)
- **외래 키**: `{참조테이블}_id` (예: `customer_id`)
- **날짜/시간**: `{행위}_at` (예: `created_at`, `updated_at`)
- **불린**: `is_{상태}` (예: `is_active`, `is_deleted`)

### 인덱스 명명
```sql
-- 인덱스 명명 규칙: idx_{테이블명}_{컬럼명}
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_created_at ON orders(created_at);

-- 복합 인덱스
CREATE INDEX idx_orders_customer_status ON orders(customer_id, status);
```

## 🏗️ 스키마 설계 패턴

### 1. 표준 감사 컬럼
```sql
-- 모든 테이블에 포함할 기본 컬럼
CREATE TABLE example_table (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    
    -- 비즈니스 컬럼들
    name VARCHAR(255) NOT NULL,
    description TEXT,
    
    -- 감사 컬럼 (필수)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    created_by VARCHAR(100) NOT NULL,
    updated_by VARCHAR(100) NOT NULL,
    version INTEGER DEFAULT 1 NOT NULL
);
```

### 2. 소프트 삭제 패턴
```sql
-- 물리적 삭제 대신 소프트 삭제 사용
ALTER TABLE customers ADD COLUMN deleted_at TIMESTAMP WITH TIME ZONE;
ALTER TABLE customers ADD COLUMN deleted_by VARCHAR(100);

-- 활성 데이터만 조회하는 뷰 생성
CREATE VIEW active_customers AS
SELECT * FROM customers 
WHERE deleted_at IS NULL;
```

### 3. 상태 관리 패턴
```sql
-- ENUM 타입 사용
CREATE TYPE order_status AS ENUM (
    'PENDING',
    'CONFIRMED', 
    'PROCESSING',
    'SHIPPED',
    'DELIVERED',
    'CANCELLED'
);

CREATE TABLE orders (
    id BIGINT PRIMARY KEY,
    status order_status DEFAULT 'PENDING' NOT NULL,
    -- 상태 변경 이력 추적
    status_changed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

## 📊 성능 최적화 가이드

### 인덱스 전략
```sql
-- 1. 자주 검색되는 컬럼에 인덱스
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- 2. 복합 조건 검색용 복합 인덱스
CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);

-- 3. 부분 인덱스 (조건부 인덱스)
CREATE INDEX idx_active_orders ON orders(customer_id) 
WHERE status NOT IN ('DELIVERED', 'CANCELLED');

-- 4. 표현식 인덱스
CREATE INDEX idx_orders_month ON orders(DATE_TRUNC('month', order_date));
```

### 파티셔닝 전략
```sql
-- 날짜 기반 파티셔닝
CREATE TABLE order_history (
    id BIGINT,
    order_date DATE NOT NULL,
    customer_id BIGINT,
    total_amount DECIMAL(10,2)
) PARTITION BY RANGE (order_date);

-- 월별 파티션 생성
CREATE TABLE order_history_2024_01 PARTITION OF order_history
FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

CREATE TABLE order_history_2024_02 PARTITION OF order_history  
FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');
```

## 🔐 보안 모범 사례

### 1. 컬럼 레벨 암호화
```sql
-- 민감 정보 암호화 컬럼
CREATE TABLE customers (
    id BIGINT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    -- 암호화된 개인정보
    encrypted_ssn BYTEA,  -- 주민번호 암호화
    encrypted_phone BYTEA, -- 전화번호 암호화
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 2. Row Level Security (RLS)
```sql
-- 행 수준 보안 활성화
ALTER TABLE customer_data ENABLE ROW LEVEL SECURITY;

-- 정책 생성: 사용자는 자신의 데이터만 조회 가능
CREATE POLICY customer_isolation ON customer_data
    FOR ALL TO application_role
    USING (customer_id = current_setting('app.current_customer_id')::BIGINT);
```

### 3. 권한 관리
```sql
-- 역할 기반 권한 관리
CREATE ROLE readonly_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly_user;

CREATE ROLE data_analyst;
GRANT SELECT ON customers, orders, products TO data_analyst;
GRANT SELECT ON analytics_views TO data_analyst;

CREATE ROLE application_user;
GRANT SELECT, INSERT, UPDATE ON customers, orders TO application_user;
```

## 🧪 데이터 검증 및 제약조건

### 1. 도메인 제약조건
```sql
-- 이메일 형식 검증
ALTER TABLE customers 
ADD CONSTRAINT check_email_format 
CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

-- 가격 범위 검증
ALTER TABLE products 
ADD CONSTRAINT check_price_positive 
CHECK (price > 0 AND price < 1000000);

-- 날짜 논리 검증
ALTER TABLE orders 
ADD CONSTRAINT check_delivery_date 
CHECK (delivered_at IS NULL OR delivered_at >= created_at);
```

### 2. 참조 무결성
```sql
-- 외래 키 제약조건
ALTER TABLE orders 
ADD CONSTRAINT fk_orders_customer 
FOREIGN KEY (customer_id) REFERENCES customers(id)
ON DELETE RESTRICT ON UPDATE CASCADE;

-- 계층 구조 제약조건
ALTER TABLE categories 
ADD CONSTRAINT fk_categories_parent 
FOREIGN KEY (parent_id) REFERENCES categories(id)
ON DELETE CASCADE;
```

## 📈 모니터링 및 유지보수

### 1. 성능 모니터링 쿼리
```sql
-- 느린 쿼리 식별
SELECT 
    query,
    calls,
    total_time,
    mean_time,
    rows
FROM pg_stat_statements 
ORDER BY mean_time DESC 
LIMIT 10;

-- 인덱스 사용률 확인
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch
FROM pg_stat_user_indexes 
ORDER BY idx_scan DESC;
```

### 2. 테이블 통계 정보
```sql
-- 테이블 크기 및 행 수 확인
SELECT 
    schemaname,
    tablename,
    n_tup_ins,
    n_tup_upd,
    n_tup_del,
    n_live_tup,
    n_dead_tup
FROM pg_stat_user_tables
ORDER BY n_live_tup DESC;
```

## 🔄 마이그레이션 가이드

### 1. 스키마 변경 패턴
```sql
-- 1단계: 새 컬럼 추가 (NULL 허용)
ALTER TABLE customers ADD COLUMN middle_name VARCHAR(100);

-- 2단계: 기본값으로 데이터 채우기
UPDATE customers SET middle_name = '' WHERE middle_name IS NULL;

-- 3단계: NOT NULL 제약조건 추가
ALTER TABLE customers ALTER COLUMN middle_name SET NOT NULL;

-- 4단계: 인덱스 추가 (필요시)
CREATE INDEX idx_customers_middle_name ON customers(middle_name);
```

### 2. 대용량 데이터 마이그레이션
```sql
-- 배치 처리로 안전한 마이그레이션
DO $$
DECLARE
    batch_size INTEGER := 10000;
    processed INTEGER := 0;
BEGIN
    LOOP
        UPDATE customers 
        SET normalized_email = LOWER(TRIM(email))
        WHERE id IN (
            SELECT id FROM customers 
            WHERE normalized_email IS NULL 
            LIMIT batch_size
        );
        
        GET DIAGNOSTICS processed = ROW_COUNT;
        
        IF processed = 0 THEN
            EXIT;
        END IF;
        
        COMMIT;
        PERFORM pg_sleep(1); -- 시스템 부하 방지
    END LOOP;
END $$;
```

---

*일관된 데이터베이스 스타일은 팀의 생산성을 높이고 유지보수를 용이하게 합니다.*