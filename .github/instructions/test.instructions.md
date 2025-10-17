# Test Instructions

효과적이고 체계적인 테스트 작성을 위한 종합 가이드라인입니다.

## 🎯 테스트 철학

### 1. 테스트 피라미드
```
    E2E Tests (Few)
   ─────────────────
  Integration Tests (Some)
 ─────────────────────────────
Unit Tests (Many)
```

- **Unit Tests (70%)**: 빠르고 안정적인 단위 테스트
- **Integration Tests (20%)**: 컴포넌트 간 상호작용 테스트  
- **E2E Tests (10%)**: 전체 시스템 검증

### 2. 핵심 원칙
- **FIRST**: Fast, Independent, Repeatable, Self-validating, Timely
- **AAA**: Arrange, Act, Assert 패턴 사용
- **Given-When-Then**: BDD 스타일 테스트 구성
- **Test-Driven Development**: 테스트 우선 개발 권장

## 📝 단위 테스트 작성법

### 1. 기본 구조
```python
import pytest
from unittest.mock import Mock, patch
from datetime import datetime, timezone

class TestOrderService:
    """주문 서비스 테스트 클래스"""
    
    def test_create_order_success(self):
        """정상적인 주문 생성 테스트"""
        # Given (준비)
        customer = Customer(id=1, name="John Doe", email="john@example.com")
        product = Product(id=1, name="Test Product", price=100.0, stock=10)
        order_repository = Mock()
        inventory_service = Mock()
        
        # 의존성 모킹
        inventory_service.check_availability.return_value = True
        inventory_service.reserve_stock.return_value = True
        order_repository.save.return_value = Order(id=1, customer=customer)
        
        service = OrderService(order_repository, inventory_service)
        
        # When (실행)
        result = service.create_order(customer, [product], quantity=2)
        
        # Then (검증)
        assert result is not None
        assert result.customer == customer
        assert len(result.items) == 1
        assert result.total_amount == 200.0
        
        # 모킹된 메서드 호출 검증
        inventory_service.check_availability.assert_called_once_with(product, 2)
        inventory_service.reserve_stock.assert_called_once_with(product, 2)
        order_repository.save.assert_called_once()
```

### 2. 예외 상황 테스트
```python
def test_create_order_insufficient_stock_raises_exception(self):
    """재고 부족 시 예외 발생 테스트"""
    # Given
    customer = Customer(id=1, name="John Doe", email="john@example.com")
    product = Product(id=1, name="Test Product", price=100.0, stock=1)
    
    inventory_service = Mock()
    inventory_service.check_availability.return_value = False
    
    service = OrderService(Mock(), inventory_service)
    
    # When & Then
    with pytest.raises(InsufficientStockError) as exc_info:
        service.create_order(customer, [product], quantity=5)
    
    assert "Insufficient stock" in str(exc_info.value)
    assert exc_info.value.product_id == product.id
    assert exc_info.value.requested_quantity == 5

def test_create_order_invalid_customer_raises_exception(self):
    """잘못된 고객 정보 시 예외 발생 테스트"""
    # Given
    invalid_customer = None
    product = Product(id=1, name="Test Product", price=100.0, stock=10)
    
    service = OrderService(Mock(), Mock())
    
    # When & Then
    with pytest.raises(ValueError, match="Customer cannot be None"):
        service.create_order(invalid_customer, [product], quantity=1)
```

### 3. 파라미터화된 테스트
```python
@pytest.mark.parametrize("price,quantity,expected_total", [
    (10.0, 1, 10.0),
    (25.5, 2, 51.0),
    (100.0, 0, 0.0),
    (0.0, 5, 0.0),
])
def test_calculate_total_amount(price, quantity, expected_total):
    """다양한 입력값에 대한 총액 계산 테스트"""
    # Given
    product = Product(id=1, name="Test", price=price, stock=100)
    
    # When
    result = calculate_total_amount(product, quantity)
    
    # Then
    assert result == expected_total

@pytest.mark.parametrize("email,is_valid", [
    ("valid@example.com", True),
    ("user.name@domain.co.uk", True),
    ("invalid-email", False),
    ("@example.com", False),
    ("user@", False),
    ("", False),
])
def test_email_validation(email, is_valid):
    """이메일 유효성 검증 테스트"""
    assert validate_email(email) == is_valid
```

## 🔧 통합 테스트

### 1. 데이터베이스 통합 테스트
```python
import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

@pytest.fixture(scope="function")
def db_session():
    """테스트용 데이터베이스 세션 픽스처"""
    engine = create_engine("sqlite:///:memory:")
    Base.metadata.create_all(engine)
    
    Session = sessionmaker(bind=engine)
    session = Session()
    
    yield session
    
    session.close()

@pytest.mark.integration
class TestOrderRepositoryIntegration:
    def test_save_and_retrieve_order(self, db_session):
        """주문 저장 및 조회 통합 테스트"""
        # Given
        repository = OrderRepository(db_session)
        customer = Customer(name="John Doe", email="john@example.com")
        order = Order(customer=customer, total_amount=100.0)
        
        # When
        saved_order = repository.save(order)
        retrieved_order = repository.find_by_id(saved_order.id)
        
        # Then
        assert retrieved_order is not None
        assert retrieved_order.customer.name == "John Doe"
        assert retrieved_order.total_amount == 100.0
    
    def test_find_orders_by_customer(self, db_session):
        """고객별 주문 조회 통합 테스트"""
        # Given
        repository = OrderRepository(db_session)
        customer1 = Customer(name="John", email="john@example.com")
        customer2 = Customer(name="Jane", email="jane@example.com")
        
        order1 = Order(customer=customer1, total_amount=100.0)
        order2 = Order(customer=customer1, total_amount=200.0)
        order3 = Order(customer=customer2, total_amount=150.0)
        
        repository.save(order1)
        repository.save(order2)
        repository.save(order3)
        
        # When
        john_orders = repository.find_by_customer(customer1)
        
        # Then
        assert len(john_orders) == 2
        assert all(order.customer.name == "John" for order in john_orders)
```

### 2. API 통합 테스트
```python
import pytest
from fastapi.testclient import TestClient
from main import app

@pytest.fixture
def client():
    """FastAPI 테스트 클라이언트 픽스처"""
    return TestClient(app)

@pytest.mark.integration
class TestOrderAPI:
    def test_create_order_endpoint(self, client):
        """주문 생성 API 통합 테스트"""
        # Given
        order_data = {
            "customer_id": 1,
            "items": [
                {"product_id": 1, "quantity": 2, "price": 25.0}
            ]
        }
        
        # When
        response = client.post("/api/orders", json=order_data)
        
        # Then
        assert response.status_code == 201
        
        response_data = response.json()
        assert response_data["customer_id"] == 1
        assert len(response_data["items"]) == 1
        assert response_data["total_amount"] == 50.0
    
    def test_get_order_endpoint(self, client):
        """주문 조회 API 통합 테스트"""
        # Given - 먼저 주문 생성
        order_data = {"customer_id": 1, "items": [{"product_id": 1, "quantity": 1, "price": 100.0}]}
        create_response = client.post("/api/orders", json=order_data)
        order_id = create_response.json()["id"]
        
        # When
        response = client.get(f"/api/orders/{order_id}")
        
        # Then
        assert response.status_code == 200
        assert response.json()["id"] == order_id
```

## 🚀 E2E 테스트

### 1. Selenium을 이용한 웹 E2E 테스트
```python
import pytest
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

@pytest.fixture(scope="class")
def driver():
    """웹드라이버 픽스처"""
    driver = webdriver.Chrome()
    driver.implicitly_wait(10)
    yield driver
    driver.quit()

@pytest.mark.e2e
class TestOrderFlowE2E:
    def test_complete_order_flow(self, driver):
        """전체 주문 플로우 E2E 테스트"""
        # Given
        driver.get("http://localhost:3000")
        
        # When - 로그인
        login_button = driver.find_element(By.ID, "login-button")
        login_button.click()
        
        username_input = driver.find_element(By.ID, "username")
        password_input = driver.find_element(By.ID, "password")
        
        username_input.send_keys("testuser@example.com")
        password_input.send_keys("testpassword")
        
        submit_button = driver.find_element(By.ID, "submit")
        submit_button.click()
        
        # 상품 페이지로 이동
        WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.CLASS_NAME, "product-list"))
        )
        
        # 상품 선택 및 장바구니 추가
        add_to_cart_button = driver.find_element(By.CLASS_NAME, "add-to-cart")
        add_to_cart_button.click()
        
        # 장바구니 확인
        cart_icon = driver.find_element(By.ID, "cart-icon")
        cart_icon.click()
        
        # 주문 완료
        checkout_button = driver.find_element(By.ID, "checkout")
        checkout_button.click()
        
        # Then
        success_message = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.CLASS_NAME, "order-success"))
        )
        assert "주문이 완료되었습니다" in success_message.text
```

### 2. API E2E 테스트
```python
@pytest.mark.e2e
class TestOrderWorkflowE2E:
    def test_complete_order_workflow(self, client):
        """전체 주문 워크플로우 E2E 테스트"""
        # 1. 고객 생성
        customer_data = {"name": "John Doe", "email": "john@example.com"}
        customer_response = client.post("/api/customers", json=customer_data)
        assert customer_response.status_code == 201
        customer_id = customer_response.json()["id"]
        
        # 2. 상품 생성
        product_data = {"name": "Test Product", "price": 100.0, "stock": 10}
        product_response = client.post("/api/products", json=product_data)
        assert product_response.status_code == 201
        product_id = product_response.json()["id"]
        
        # 3. 주문 생성
        order_data = {
            "customer_id": customer_id,
            "items": [{"product_id": product_id, "quantity": 2}]
        }
        order_response = client.post("/api/orders", json=order_data)
        assert order_response.status_code == 201
        order_id = order_response.json()["id"]
        
        # 4. 주문 상태 확인
        status_response = client.get(f"/api/orders/{order_id}")
        assert status_response.status_code == 200
        assert status_response.json()["status"] == "PENDING"
        
        # 5. 결제 처리
        payment_data = {"order_id": order_id, "amount": 200.0, "method": "CARD"}
        payment_response = client.post("/api/payments", json=payment_data)
        assert payment_response.status_code == 201
        
        # 6. 최종 주문 상태 확인
        final_status = client.get(f"/api/orders/{order_id}")
        assert final_status.json()["status"] == "PAID"
```

## 📊 테스트 커버리지 및 품질

### 1. 커버리지 측정
```bash
# 커버리지 측정 및 보고서 생성
pytest --cov=src --cov-report=html --cov-report=term-missing

# 최소 커버리지 기준 설정
pytest --cov=src --cov-fail-under=85
```

### 2. 테스트 성능 모니터링
```python
import time
import pytest

@pytest.fixture(autouse=True)
def measure_test_time(request):
    """각 테스트 실행 시간 측정"""
    start_time = time.time()
    yield
    end_time = time.time()
    duration = end_time - start_time
    
    if duration > 5.0:  # 5초 이상 걸리는 테스트 경고
        pytest.warns(UserWarning, f"Test {request.node.name} took {duration:.2f}s")
```

### 3. 테스트 데이터 관리
```python
import pytest
import factory
from factory import fuzzy

class CustomerFactory(factory.Factory):
    """고객 테스트 데이터 팩토리"""
    class Meta:
        model = Customer
    
    name = factory.Faker('name')
    email = factory.Faker('email')
    phone = factory.Faker('phone_number')
    created_at = factory.Faker('date_time_this_year')

class ProductFactory(factory.Factory):
    """상품 테스트 데이터 팩토리"""
    class Meta:
        model = Product
    
    name = factory.Faker('text', max_nb_chars=50)
    price = fuzzy.FuzzyDecimal(10.0, 1000.0, precision=2)
    stock = fuzzy.FuzzyInteger(0, 100)
    category = factory.Faker('word')

@pytest.fixture
def sample_customer():
    """샘플 고객 데이터 픽스처"""
    return CustomerFactory()

@pytest.fixture
def sample_products():
    """샘플 상품 데이터 픽스처"""
    return ProductFactory.create_batch(3)
```

## 🔧 테스트 도구 및 설정

### 1. pytest 설정
```ini
# pytest.ini
[tool:pytest]
testpaths = tests
python_files = test_*.py *_test.py
python_classes = Test*
python_functions = test_*
addopts = 
    -v
    --strict-markers
    --disable-warnings
    --tb=short
markers =
    unit: Unit tests
    integration: Integration tests
    e2e: End-to-end tests
    slow: Slow running tests
    performance: Performance tests
```

### 2. 테스트 환경 분리
```python
# conftest.py
import pytest
import os

@pytest.fixture(scope="session")
def test_environment():
    """테스트 환경 설정"""
    original_env = os.environ.get("ENV")
    os.environ["ENV"] = "test"
    yield
    if original_env:
        os.environ["ENV"] = original_env
    else:
        os.environ.pop("ENV", None)

@pytest.fixture(scope="function")
def clean_database():
    """각 테스트 후 데이터베이스 정리"""
    yield
    # 테스트 후 정리 로직
    cleanup_test_data()
```

### 3. CI/CD 통합
```yaml
# .github/workflows/test.yml
name: Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Set up Python
        uses: actions/setup-python@v2
        with:
          python-version: 3.9
      
      - name: Install dependencies
        run: |
          pip install -r requirements.txt
          pip install -r requirements-dev.txt
      
      - name: Run unit tests
        run: pytest tests/unit/ -v
      
      - name: Run integration tests
        run: pytest tests/integration/ -v
      
      - name: Generate coverage report
        run: pytest --cov=src --cov-report=xml
      
      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v1
```

## 🎭 모킹 및 테스트 더블

### 1. Mock 사용법
```python
from unittest.mock import Mock, patch, MagicMock

def test_external_api_call():
    """외부 API 호출 모킹 테스트"""
    with patch('requests.get') as mock_get:
        # Given
        mock_response = Mock()
        mock_response.status_code = 200
        mock_response.json.return_value = {"status": "success", "data": []}
        mock_get.return_value = mock_response
        
        service = ExternalAPIService()
        
        # When
        result = service.fetch_data()
        
        # Then
        assert result["status"] == "success"
        mock_get.assert_called_once_with("https://api.example.com/data")

@patch.object(EmailService, 'send_email')
def test_order_notification(mock_send_email):
    """이메일 전송 모킹 테스트"""
    # Given
    mock_send_email.return_value = True
    service = OrderService()
    order = Order(id=1, customer_email="test@example.com")
    
    # When
    service.send_confirmation(order)
    
    # Then
    mock_send_email.assert_called_once_with(
        to="test@example.com",
        subject="주문 확인",
        body=pytest.any(str)
    )
```

### 2. Fixture와 DI 활용
```python
@pytest.fixture
def mock_payment_gateway():
    """결제 게이트웨이 모킹 픽스처"""
    gateway = Mock(spec=PaymentGateway)
    gateway.process_payment.return_value = PaymentResult(
        success=True,
        transaction_id="TXN123",
        amount=100.0
    )
    return gateway

def test_order_payment_processing(mock_payment_gateway):
    """주문 결제 처리 테스트"""
    # Given
    service = OrderService(payment_gateway=mock_payment_gateway)
    order = Order(id=1, total_amount=100.0)
    
    # When
    result = service.process_payment(order)
    
    # Then
    assert result.success is True
    assert result.transaction_id == "TXN123"
    mock_payment_gateway.process_payment.assert_called_once()
```

---

*좋은 테스트는 코드의 품질을 보장하고, 리팩토링의 안전망을 제공하며, 개발자의 자신감을 높여줍니다.*