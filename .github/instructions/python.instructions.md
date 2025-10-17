# Python Instructions

Python 개발에 대한 종합적인 코딩 가이드라인과 모범 사례입니다.

## 🎯 핵심 원칙

### 1. PEP 8 준수
- **들여쓰기**: 4개의 공백 사용 (탭 사용 금지)
- **줄 길이**: 79자 이내 (docstring, 주석은 72자)
- **빈 줄**: 함수/클래스 정의 사이에 적절한 빈 줄 사용
- **import**: 표준 라이브러리 → 서드파티 → 로컬 순서

### 2. Pythonic 코딩
- **Duck Typing**: "오리처럼 걷고 소리낸다면 오리다"
- **EAFP**: "허가보다 용서" (try/except 적극 활용)
- **Comprehension**: 리스트/딕셔너리 컴프리헨션 적절히 활용
- **Context Manager**: with 문을 통한 리소스 관리

## 📝 코딩 스타일

### 명명 규칙
```python
# Good: 명확하고 의미있는 이름
class CustomerOrderProcessor:
    def __init__(self, database_connection):
        self.db_connection = database_connection
        self._processing_queue = []
    
    def process_pending_orders(self):
        """대기 중인 주문들을 처리합니다."""
        pass

# Bad: 축약되거나 모호한 이름
class COP:
    def __init__(self, db):
        self.db = db
        self.q = []
    
    def proc_ord(self):
        pass
```

### 함수 작성
```python
# Good: 단일 책임 원칙 준수
def calculate_total_price(items: List[OrderItem]) -> Decimal:
    """주문 항목들의 총 가격을 계산합니다.
    
    Args:
        items: 주문 항목 리스트
        
    Returns:
        총 가격 (세금 포함)
        
    Raises:
        ValueError: 빈 항목 리스트인 경우
    """
    if not items:
        raise ValueError("Items list cannot be empty")
    
    subtotal = sum(item.price * item.quantity for item in items)
    tax = subtotal * Decimal('0.1')
    return subtotal + tax

# Bad: 여러 책임을 가진 함수
def process_order(customer_id, items, payment_info, shipping_address):
    # 재고 확인, 가격 계산, 결제 처리, 배송 처리 등 모든 것을 한 함수에서...
    pass
```

### 클래스 설계
```python
# Good: 적절한 캡슐화와 책임 분리
from dataclasses import dataclass
from typing import Optional
from decimal import Decimal

@dataclass
class Product:
    """상품 정보를 나타내는 데이터 클래스."""
    id: int
    name: str
    price: Decimal
    category: str
    stock_quantity: int = 0
    
    def is_available(self) -> bool:
        """상품이 구매 가능한지 확인합니다."""
        return self.stock_quantity > 0
    
    def reduce_stock(self, quantity: int) -> None:
        """재고를 감소시킵니다."""
        if quantity > self.stock_quantity:
            raise ValueError(f"Insufficient stock: {self.stock_quantity}")
        self.stock_quantity -= quantity

class ProductService:
    """상품 관련 비즈니스 로직을 처리합니다."""
    
    def __init__(self, repository: ProductRepository):
        self._repository = repository
    
    def find_available_products(self, category: Optional[str] = None) -> List[Product]:
        """구매 가능한 상품들을 조회합니다."""
        products = self._repository.find_by_category(category) if category else self._repository.find_all()
        return [product for product in products if product.is_available()]
```

## 🔧 개발 도구 설정

### 1. 개발 환경
```bash
# 가상환경 생성 및 활성화
python -m venv venv
source venv/bin/activate  # Linux/Mac
# 또는
venv\Scripts\activate     # Windows

# requirements.txt 관리
pip freeze > requirements.txt
pip install -r requirements.txt
```

### 2. 코드 품질 도구
```bash
# 필수 개발 도구 설치
pip install black isort flake8 mypy pytest pytest-cov

# pyproject.toml 설정
[tool.black]
line-length = 88
target-version = ['py39']

[tool.isort]
profile = "black"
multi_line_output = 3

[tool.mypy]
python_version = "3.9"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
```

### 3. pre-commit 설정
```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/psf/black
    rev: 22.3.0
    hooks:
      - id: black
  - repo: https://github.com/pycqa/isort
    rev: 5.10.1
    hooks:
      - id: isort
  - repo: https://github.com/pycqa/flake8
    rev: 4.0.1
    hooks:
      - id: flake8
  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v0.950
    hooks:
      - id: mypy
```

## 🧪 테스트 작성

### 1. 단위 테스트
```python
import pytest
from decimal import Decimal
from unittest.mock import Mock

class TestProductService:
    def test_find_available_products_returns_only_available_items(self):
        # Given
        mock_repository = Mock()
        available_product = Product(1, "Test Product", Decimal("10.00"), "Electronics", 5)
        unavailable_product = Product(2, "Out of Stock", Decimal("20.00"), "Electronics", 0)
        mock_repository.find_all.return_value = [available_product, unavailable_product]
        
        service = ProductService(mock_repository)
        
        # When
        result = service.find_available_products()
        
        # Then
        assert len(result) == 1
        assert result[0].id == 1
    
    def test_find_available_products_by_category(self):
        # Given
        mock_repository = Mock()
        electronics = Product(1, "Phone", Decimal("500.00"), "Electronics", 3)
        mock_repository.find_by_category.return_value = [electronics]
        
        service = ProductService(mock_repository)
        
        # When
        result = service.find_available_products("Electronics")
        
        # Then
        mock_repository.find_by_category.assert_called_once_with("Electronics")
        assert len(result) == 1
```

### 2. 통합 테스트
```python
@pytest.mark.integration
class TestProductIntegration:
    def test_full_product_workflow(self, db_session):
        # 실제 데이터베이스를 사용한 통합 테스트
        repository = ProductRepository(db_session)
        service = ProductService(repository)
        
        # 상품 생성
        product = Product(None, "Integration Test", Decimal("15.00"), "Test", 2)
        saved_product = repository.save(product)
        
        # 조회 테스트
        found_products = service.find_available_products("Test")
        assert len(found_products) == 1
        assert found_products[0].name == "Integration Test"
```

## 🚀 성능 최적화

### 1. 프로파일링
```python
import cProfile
import pstats
from functools import wraps

def profile_function(func):
    """함수 실행 시간을 프로파일링하는 데코레이터."""
    @wraps(func)
    def wrapper(*args, **kwargs):
        pr = cProfile.Profile()
        pr.enable()
        result = func(*args, **kwargs)
        pr.disable()
        
        stats = pstats.Stats(pr)
        stats.sort_stats('tottime')
        stats.print_stats(10)  # 상위 10개 함수만 출력
        
        return result
    return wrapper
```

### 2. 메모리 최적화
```python
# Good: 제너레이터 사용으로 메모리 효율성
def read_large_file(filename):
    """대용량 파일을 메모리 효율적으로 읽습니다."""
    with open(filename, 'r') as file:
        for line in file:
            yield line.strip()

# Good: __slots__ 사용으로 메모리 절약
class Point:
    __slots__ = ['x', 'y']
    
    def __init__(self, x: float, y: float):
        self.x = x
        self.y = y
```

### 3. 비동기 프로그래밍
```python
import asyncio
import aiohttp

async def fetch_data(session: aiohttp.ClientSession, url: str) -> dict:
    """비동기적으로 데이터를 가져옵니다."""
    async with session.get(url) as response:
        return await response.json()

async def fetch_multiple_data(urls: List[str]) -> List[dict]:
    """여러 URL에서 동시에 데이터를 가져옵니다."""
    async with aiohttp.ClientSession() as session:
        tasks = [fetch_data(session, url) for url in urls]
        return await asyncio.gather(*tasks)
```

## 📦 패키지 관리

### 1. 의존성 관리
```toml
# pyproject.toml
[project]
name = "my-project"
version = "0.1.0"
description = "Project description"
dependencies = [
    "fastapi>=0.68.0",
    "sqlalchemy>=1.4.0",
    "pydantic>=1.8.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=6.0.0",
    "black>=22.0.0",
    "isort>=5.0.0",
    "mypy>=0.950",
]
```

### 2. 로깅 설정
```python
import logging
from typing import Optional

def setup_logging(level: str = "INFO", log_file: Optional[str] = None) -> None:
    """로깅을 설정합니다."""
    logging_config = {
        'version': 1,
        'disable_existing_loggers': False,
        'formatters': {
            'standard': {
                'format': '%(asctime)s [%(levelname)s] %(name)s: %(message)s'
            },
        },
        'handlers': {
            'console': {
                'class': 'logging.StreamHandler',
                'level': level,
                'formatter': 'standard',
                'stream': 'ext://sys.stdout'
            },
        },
        'loggers': {
            '': {  # root logger
                'handlers': ['console'],
                'level': level,
                'propagate': False
            }
        }
    }
    
    if log_file:
        logging_config['handlers']['file'] = {
            'class': 'logging.handlers.RotatingFileHandler',
            'level': level,
            'formatter': 'standard',
            'filename': log_file,
            'maxBytes': 10485760,  # 10MB
            'backupCount': 5,
        }
        logging_config['loggers']['']['handlers'].append('file')
    
    logging.config.dictConfig(logging_config)
```

## 🔒 보안 고려사항

### 1. 입력 검증
```python
from pydantic import BaseModel, validator
import re

class UserInput(BaseModel):
    email: str
    password: str
    
    @validator('email')
    def validate_email(cls, v):
        pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        if not re.match(pattern, v):
            raise ValueError('Invalid email format')
        return v.lower()
    
    @validator('password')
    def validate_password(cls, v):
        if len(v) < 8:
            raise ValueError('Password must be at least 8 characters')
        return v
```

### 2. 환경 변수 관리
```python
from pydantic import BaseSettings

class Settings(BaseSettings):
    database_url: str
    secret_key: str
    debug: bool = False
    
    class Config:
        env_file = ".env"

settings = Settings()
```

---

*Python의 철학 "Simple is better than complex"를 항상 기억하며, 읽기 쉽고 유지보수하기 좋은 코드를 작성하세요.*