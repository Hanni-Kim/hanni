# Python Style Guide

Python 개발을 위한 상세한 스타일 가이드입니다.

## 🎯 코드 포맷팅

### 1. 들여쓰기 및 줄 길이
```python
# Good: 4칸 들여쓰기, 명확한 구조
def calculate_order_total(
    items: List[OrderItem],
    tax_rate: Decimal = Decimal('0.1'),
    discount_rate: Decimal = Decimal('0.0')
) -> Decimal:
    """주문 총액을 계산합니다."""
    if not items:
        raise ValueError("주문 항목이 비어있습니다.")
    
    subtotal = sum(
        item.price * item.quantity 
        for item in items
    )
    
    discount_amount = subtotal * discount_rate
    tax_amount = (subtotal - discount_amount) * tax_rate
    
    return subtotal - discount_amount + tax_amount

# Bad: 불규칙한 들여쓰기, 긴 줄
def calculate_order_total(items, tax_rate=0.1, discount_rate=0.0):
  if not items: raise ValueError("주문 항목이 비어있습니다.")
  subtotal = sum(item.price * item.quantity for item in items)
  return subtotal - (subtotal * discount_rate) + ((subtotal - (subtotal * discount_rate)) * tax_rate)
```

### 2. Import 구조
```python
# Good: 정렬된 import 구조
# 1. 표준 라이브러리
import json
import logging
from datetime import datetime, timezone
from decimal import Decimal
from typing import Dict, List, Optional, Union

# 2. 서드파티 라이브러리
import pandas as pd
import requests
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, validator
from sqlalchemy import Column, Integer, String, create_engine

# 3. 로컬 애플리케이션
from src.models.customer import Customer
from src.services.order_service import OrderService
from src.utils.validators import validate_email

# Bad: 무작위 import 순서
from src.models.customer import Customer
import json
from fastapi import FastAPI
import pandas as pd
from src.services.order_service import OrderService
import requests
```

## 🏗️ 클래스 및 함수 설계

### 1. 클래스 설계 패턴
```python
# Good: 단일 책임 원칙 준수
from dataclasses import dataclass
from enum import Enum
from typing import Optional, List
from decimal import Decimal

class OrderStatus(Enum):
    """주문 상태 열거형"""
    PENDING = "pending"
    CONFIRMED = "confirmed"
    PROCESSING = "processing"
    SHIPPED = "shipped"
    DELIVERED = "delivered"
    CANCELLED = "cancelled"

@dataclass(frozen=True)
class Money:
    """통화 값 객체"""
    amount: Decimal
    currency: str = "KRW"
    
    def __post_init__(self):
        if self.amount < 0:
            raise ValueError("금액은 음수일 수 없습니다.")
    
    def add(self, other: 'Money') -> 'Money':
        """다른 Money 객체와 더합니다."""
        if self.currency != other.currency:
            raise ValueError("통화가 다릅니다.")
        return Money(self.amount + other.amount, self.currency)

class Order:
    """주문을 나타내는 도메인 엔티티"""
    
    def __init__(
        self,
        order_id: str,
        customer_id: str,
        items: List['OrderItem']
    ):
        self._order_id = order_id
        self._customer_id = customer_id
        self._items = items.copy()
        self._status = OrderStatus.PENDING
        self._created_at = datetime.now(timezone.utc)
    
    @property
    def order_id(self) -> str:
        """주문 ID를 반환합니다."""
        return self._order_id
    
    @property
    def total_amount(self) -> Money:
        """총 주문 금액을 계산합니다."""
        total = Decimal('0')
        for item in self._items:
            total += item.price.amount * item.quantity
        return Money(total)
    
    def confirm(self) -> None:
        """주문을 확정합니다."""
        if self._status != OrderStatus.PENDING:
            raise ValueError(f"대기 상태의 주문만 확정할 수 있습니다. 현재 상태: {self._status}")
        self._status = OrderStatus.CONFIRMED
    
    def cancel(self, reason: str) -> None:
        """주문을 취소합니다."""
        if self._status in [OrderStatus.SHIPPED, OrderStatus.DELIVERED]:
            raise ValueError("배송 중이거나 완료된 주문은 취소할 수 없습니다.")
        self._status = OrderStatus.CANCELLED
        self._cancellation_reason = reason
```

### 2. 함수 설계 원칙
```python
# Good: 순수 함수, 단일 책임
def calculate_shipping_cost(
    weight_kg: Decimal,
    distance_km: int,
    shipping_method: str
) -> Money:
    """배송비를 계산합니다.
    
    Args:
        weight_kg: 무게(kg)
        distance_km: 거리(km)  
        shipping_method: 배송 방법 ('standard', 'express', 'overnight')
    
    Returns:
        계산된 배송비
        
    Raises:
        ValueError: 잘못된 배송 방법이거나 음수 값인 경우
    """
    if weight_kg <= 0 or distance_km <= 0:
        raise ValueError("무게와 거리는 양수여야 합니다.")
    
    base_rates = {
        'standard': Decimal('5.0'),
        'express': Decimal('10.0'),
        'overnight': Decimal('20.0')
    }
    
    if shipping_method not in base_rates:
        raise ValueError(f"지원하지 않는 배송 방법: {shipping_method}")
    
    base_cost = base_rates[shipping_method]
    weight_cost = weight_kg * Decimal('2.0')
    distance_cost = Decimal(distance_km) * Decimal('0.1')
    
    return Money(base_cost + weight_cost + distance_cost)

# Bad: 부작용이 있고 책임이 많은 함수
def process_order(order_data, customer_email):
    # 여러 책임: 검증, 계산, 저장, 이메일 발송
    global order_counter
    order_counter += 1  # 전역 상태 변경
    
    # 파라미터 검증, 재고 확인, 가격 계산, DB 저장, 이메일 발송 등...
    pass
```

## 🎭 예외 처리 패턴

### 1. 커스텀 예외 클래스
```python
# Good: 의미있는 예외 계층구조
class DomainError(Exception):
    """도메인 레벨 기본 예외"""
    pass

class ValidationError(DomainError):
    """검증 오류"""
    def __init__(self, field: str, message: str):
        self.field = field
        self.message = message
        super().__init__(f"{field}: {message}")

class BusinessRuleViolationError(DomainError):
    """비즈니스 규칙 위반"""
    pass

class InsufficientStockError(BusinessRuleViolationError):
    """재고 부족 오류"""
    def __init__(self, product_id: str, requested: int, available: int):
        self.product_id = product_id
        self.requested = requested
        self.available = available
        super().__init__(
            f"상품 {product_id}의 재고가 부족합니다. "
            f"요청: {requested}, 가용: {available}"
        )

# 사용 예
def reserve_stock(product_id: str, quantity: int) -> None:
    """재고를 예약합니다."""
    try:
        current_stock = get_current_stock(product_id)
        if current_stock < quantity:
            raise InsufficientStockError(product_id, quantity, current_stock)
        
        update_stock(product_id, current_stock - quantity)
        
    except DatabaseError as e:
        logger.error(f"재고 업데이트 중 DB 오류: {e}")
        raise
    except Exception as e:
        logger.error(f"예상치 못한 오류: {e}")
        raise
```

### 2. Context Manager 활용
```python
# Good: 리소스 관리를 위한 Context Manager
from contextlib import contextmanager
import logging

@contextmanager
def database_transaction(session):
    """데이터베이스 트랜잭션 컨텍스트 매니저"""
    try:
        session.begin()
        yield session
        session.commit()
        logger.info("트랜잭션 커밋 완료")
    except Exception as e:
        session.rollback()
        logger.error(f"트랜잭션 롤백: {e}")
        raise
    finally:
        session.close()

# 사용 예
def create_order_with_items(order_data: dict, items_data: List[dict]):
    """주문과 항목들을 트랜잭션으로 생성"""
    with database_transaction(get_session()) as session:
        order = Order(**order_data)
        session.add(order)
        session.flush()  # ID 생성을 위해
        
        for item_data in items_data:
            item = OrderItem(order_id=order.id, **item_data)
            session.add(item)
```

## 🧪 테스트 친화적 코드

### 1. 의존성 주입 패턴
```python
# Good: 의존성 주입으로 테스트 가능한 코드
from abc import ABC, abstractmethod
from typing import Protocol

class EmailSender(Protocol):
    """이메일 발송 인터페이스"""
    def send_email(self, to: str, subject: str, body: str) -> bool:
        ...

class OrderRepository(Protocol):
    """주문 저장소 인터페이스"""
    def save(self, order: Order) -> Order:
        ...
    
    def find_by_id(self, order_id: str) -> Optional[Order]:
        ...

class OrderService:
    """주문 서비스 (의존성 주입)"""
    
    def __init__(
        self,
        order_repository: OrderRepository,
        email_sender: EmailSender,
        inventory_service: 'InventoryService'
    ):
        self._order_repository = order_repository
        self._email_sender = email_sender
        self._inventory_service = inventory_service
    
    def create_order(
        self,
        customer_id: str,
        items: List[dict]
    ) -> Order:
        """주문을 생성합니다."""
        # 재고 확인
        for item in items:
            if not self._inventory_service.check_availability(
                item['product_id'], item['quantity']
            ):
                raise InsufficientStockError(
                    item['product_id'], item['quantity'], 0
                )
        
        # 주문 생성 및 저장
        order = Order(
            order_id=generate_order_id(),
            customer_id=customer_id,
            items=[OrderItem(**item) for item in items]
        )
        
        saved_order = self._order_repository.save(order)
        
        # 확인 이메일 발송
        customer_email = get_customer_email(customer_id)
        self._email_sender.send_email(
            to=customer_email,
            subject="주문 확인",
            body=f"주문 {saved_order.order_id}가 접수되었습니다."
        )
        
        return saved_order

# 테스트에서 모킹 가능
def test_create_order():
    # Given
    mock_repository = Mock(spec=OrderRepository)
    mock_email_sender = Mock(spec=EmailSender)
    mock_inventory = Mock()
    
    mock_inventory.check_availability.return_value = True
    mock_repository.save.return_value = Order("ORD-001", "CUST-001", [])
    mock_email_sender.send_email.return_value = True
    
    service = OrderService(mock_repository, mock_email_sender, mock_inventory)
    
    # When & Then
    # 테스트 로직...
```

## 🔧 성능 최적화 패턴

### 1. 지연 평가 및 제너레이터
```python
# Good: 메모리 효율적인 대용량 데이터 처리
from typing import Generator, Iterator
import csv

def read_large_csv_file(filepath: str) -> Generator[dict, None, None]:
    """대용량 CSV 파일을 지연 평가로 읽습니다."""
    with open(filepath, 'r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        for row in reader:
            yield row

def process_orders_batch(
    orders: Iterator[dict],
    batch_size: int = 1000
) -> Generator[List[dict], None, None]:
    """주문 데이터를 배치 단위로 처리합니다."""
    batch = []
    for order in orders:
        batch.append(order)
        if len(batch) >= batch_size:
            yield batch
            batch = []
    
    if batch:  # 마지막 배치 처리
        yield batch

# 사용 예
def import_large_order_file(filepath: str) -> None:
    """대용량 주문 파일을 가져옵니다."""
    orders = read_large_csv_file(filepath)
    
    for batch in process_orders_batch(orders):
        # 배치 단위로 DB에 저장
        save_orders_batch(batch)
        print(f"처리 완료: {len(batch)}개 주문")
```

### 2. 캐싱 패턴
```python
# Good: 적절한 캐싱 전략
from functools import lru_cache, wraps
from typing import Dict, Any
import time

class TTLCache:
    """TTL(Time To Live) 캐시 구현"""
    
    def __init__(self, ttl_seconds: int = 300):
        self.ttl_seconds = ttl_seconds
        self._cache: Dict[str, tuple] = {}
    
    def get(self, key: str) -> Any:
        if key in self._cache:
            value, timestamp = self._cache[key]
            if time.time() - timestamp < self.ttl_seconds:
                return value
            else:
                del self._cache[key]
        return None
    
    def set(self, key: str, value: Any) -> None:
        self._cache[key] = (value, time.time())

# 전역 캐시 인스턴스
product_cache = TTLCache(ttl_seconds=600)  # 10분

@lru_cache(maxsize=1000)
def get_tax_rate(country_code: str, product_category: str) -> Decimal:
    """세율 정보를 캐시와 함께 조회합니다."""
    # 외부 API 호출이나 DB 조회
    return fetch_tax_rate_from_api(country_code, product_category)

def get_product_info(product_id: str) -> dict:
    """상품 정보를 TTL 캐시와 함께 조회합니다."""
    cache_key = f"product:{product_id}"
    cached_result = product_cache.get(cache_key)
    
    if cached_result is not None:
        return cached_result
    
    # 캐시 미스시 DB에서 조회
    product_info = fetch_product_from_db(product_id)
    product_cache.set(cache_key, product_info)
    
    return product_info
```

## 📝 문서화 패턴

### 1. Docstring 스타일
```python
# Good: Google 스타일 docstring
def calculate_compound_interest(
    principal: Decimal,
    annual_rate: Decimal,
    years: int,
    compounding_frequency: int = 12
) -> Decimal:
    """복리 이자를 계산합니다.

    주어진 원금에 대해 연간 이자율과 복리 계산 빈도를 고려하여
    지정된 기간 후의 총 금액을 계산합니다.

    Args:
        principal: 원금 (양수)
        annual_rate: 연간 이자율 (소수점으로 표현, 예: 0.05 = 5%)
        years: 투자 기간 (년)
        compounding_frequency: 연간 복리 계산 횟수 (기본값: 12, 월복리)

    Returns:
        복리 적용 후 총 금액

    Raises:
        ValueError: 원금이나 이자율이 음수인 경우
        ValueError: 기간이나 복리 빈도가 0 이하인 경우

    Example:
        >>> calculate_compound_interest(
        ...     principal=Decimal('1000'),
        ...     annual_rate=Decimal('0.05'),
        ...     years=5
        ... )
        Decimal('1283.36')

    Note:
        공식: A = P(1 + r/n)^(nt)
        A = 최종 금액, P = 원금, r = 연간 이자율
        n = 연간 복리 빈도, t = 시간(년)
    """
    if principal <= 0:
        raise ValueError("원금은 양수여야 합니다.")
    
    if annual_rate < 0:
        raise ValueError("이자율은 음수일 수 없습니다.")
    
    if years <= 0 or compounding_frequency <= 0:
        raise ValueError("기간과 복리 빈도는 양수여야 합니다.")
    
    rate_per_period = annual_rate / compounding_frequency
    total_periods = compounding_frequency * years
    
    return principal * (1 + rate_per_period) ** total_periods
```

### 2. 타입 힌트 활용
```python
# Good: 명확한 타입 힌트
from typing import Dict, List, Optional, Union, TypeVar, Generic, Callable
from datetime import datetime
from decimal import Decimal

T = TypeVar('T')
K = TypeVar('K')
V = TypeVar('V')

class Repository(Generic[T]):
    """제네릭 저장소 인터페이스"""
    
    def save(self, entity: T) -> T:
        """엔티티를 저장합니다."""
        raise NotImplementedError
    
    def find_by_id(self, entity_id: str) -> Optional[T]:
        """ID로 엔티티를 조회합니다."""
        raise NotImplementedError
    
    def find_all(self) -> List[T]:
        """모든 엔티티를 조회합니다."""
        raise NotImplementedError

class OrderRepository(Repository[Order]):
    """주문 저장소 구현"""
    
    def find_by_customer(self, customer_id: str) -> List[Order]:
        """고객별 주문을 조회합니다."""
        pass
    
    def find_by_date_range(
        self,
        start_date: datetime,
        end_date: datetime
    ) -> List[Order]:
        """날짜 범위로 주문을 조회합니다."""
        pass

# 콜백 함수 타입 정의
OrderValidator = Callable[[Order], bool]
OrderProcessor = Callable[[Order], None]

def process_orders_with_validation(
    orders: List[Order],
    validator: OrderValidator,
    processor: OrderProcessor
) -> Dict[str, int]:
    """검증과 함께 주문을 처리합니다."""
    results = {"processed": 0, "failed": 0}
    
    for order in orders:
        if validator(order):
            processor(order)
            results["processed"] += 1
        else:
            results["failed"] += 1
    
    return results
```

---

*일관된 Python 스타일은 코드의 가독성과 유지보수성을 크게 향상시킵니다.*