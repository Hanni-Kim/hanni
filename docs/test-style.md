# Test Style Guide

테스트 작성을 위한 상세한 스타일 가이드입니다.

## 🎯 테스트 작성 원칙

### 1. 명확한 테스트 구조 (AAA 패턴)
```python
# Good: 명확한 3단계 구조
def test_order_total_calculation_with_discount():
    """할인이 적용된 주문의 총액 계산을 테스트합니다."""
    
    # Arrange (준비)
    items = [
        OrderItem(product_id="P001", price=Decimal("100.00"), quantity=2),
        OrderItem(product_id="P002", price=Decimal("50.00"), quantity=1)
    ]
    discount_rate = Decimal("0.1")  # 10% 할인
    
    # Act (실행)
    result = calculate_order_total(items, discount_rate)
    
    # Assert (검증)
    expected_total = Decimal("225.00")  # (200 + 50) * 0.9
    assert result == expected_total
    assert result.scale == 2  # 소수점 자릿수 확인

# Bad: 구조가 불명확한 테스트
def test_order():
    items = [OrderItem("P001", 100, 2)]
    assert calculate_order_total(items, 0.1) == 180
```

### 2. 의미있는 테스트 메서드명
```python
# Good: 테스트 의도가 명확한 이름
def test_should_raise_exception_when_order_items_is_empty():
    """주문 항목이 비어있을 때 예외를 발생시켜야 합니다."""
    
def test_should_calculate_correct_shipping_cost_for_express_delivery():
    """특급 배송의 배송비를 정확히 계산해야 합니다."""
    
def test_should_return_false_when_user_is_not_authenticated():
    """사용자가 인증되지 않았을 때 False를 반환해야 합니다."""

# Bad: 의도가 불명확한 이름
def test_order_calculation():
def test_shipping():
def test_user_auth():
```

### 3. 테스트 데이터 관리
```python
# Good: 팩토리 패턴을 이용한 테스트 데이터 생성
import factory
from factory import fuzzy

class CustomerFactory(factory.Factory):
    class Meta:
        model = Customer
    
    name = factory.Faker('name')
    email = factory.Faker('email')
    phone = factory.Faker('phone_number')
    is_active = True
    created_at = factory.Faker('date_time_this_year')

class OrderFactory(factory.Factory):
    class Meta:
        model = Order
    
    customer = factory.SubFactory(CustomerFactory)
    order_date = factory.Faker('date_this_year')
    status = fuzzy.FuzzyChoice(['PENDING', 'CONFIRMED', 'SHIPPED'])
    total_amount = fuzzy.FuzzyDecimal(10.00, 1000.00, precision=2)

# 사용 예
def test_order_confirmation_email_sending():
    # Given
    order = OrderFactory(status='CONFIRMED')
    email_service = Mock()
    
    # When
    send_order_confirmation(order, email_service)
    
    # Then
    email_service.send_email.assert_called_once_with(
        to=order.customer.email,
        subject='주문 확인',
        body=f'주문 {order.id}가 확정되었습니다.'
    )

# Bad: 하드코딩된 테스트 데이터
def test_order_confirmation():
    customer = Customer(
        id=1, 
        name="홍길동", 
        email="hong@example.com",
        phone="010-1234-5678",
        is_active=True,
        created_at=datetime(2024, 1, 1)
    )
    order = Order(
        id=1,
        customer=customer,
        order_date=datetime(2024, 1, 15),
        status='CONFIRMED',
        total_amount=150.00
    )
    # 테스트 로직...
```

## 🧪 단위 테스트 패턴

### 1. 모킹 전략
```python
# Good: 적절한 모킹 범위
from unittest.mock import Mock, patch, MagicMock

class TestOrderService:
    def test_create_order_success(self):
        """주문 생성 성공 케이스"""
        # Given
        customer = CustomerFactory()
        items = [OrderItemFactory() for _ in range(2)]
        
        # 의존성 모킹
        inventory_service = Mock()
        payment_service = Mock()
        email_service = Mock()
        
        inventory_service.check_availability.return_value = True
        payment_service.process_payment.return_value = PaymentResult(
            success=True, transaction_id="TXN-123"
        )
        email_service.send_confirmation.return_value = True
        
        order_service = OrderService(
            inventory_service=inventory_service,
            payment_service=payment_service,
            email_service=email_service
        )
        
        # When
        result = order_service.create_order(customer, items)
        
        # Then
        assert result.id is not None
        assert result.customer == customer
        assert result.status == OrderStatus.PENDING
        
        # 의존성 호출 검증
        inventory_service.check_availability.assert_called()
        payment_service.process_payment.assert_called_once()
        email_service.send_confirmation.assert_called_once()

    @patch('src.services.order_service.datetime')
    def test_order_creation_timestamp(self, mock_datetime):
        """주문 생성 시간 테스트 (시간 모킹)"""
        # Given
        fixed_time = datetime(2024, 10, 17, 10, 30, 0)
        mock_datetime.now.return_value = fixed_time
        
        # When
        order = create_order(customer_id="CUST-001", items=[])
        
        # Then
        assert order.created_at == fixed_time
        mock_datetime.now.assert_called_once()
```

### 2. 예외 테스트 패턴
```python
# Good: 구체적인 예외 검증
def test_should_raise_insufficient_stock_error_with_correct_details():
    """재고 부족 시 정확한 상세 정보와 함께 예외를 발생시켜야 합니다."""
    # Given
    product_id = "PRODUCT-001"
    requested_quantity = 10
    available_quantity = 3
    
    inventory_service = Mock()
    inventory_service.get_available_quantity.return_value = available_quantity
    
    order_service = OrderService(inventory_service=inventory_service)
    
    # When & Then
    with pytest.raises(InsufficientStockError) as exc_info:
        order_service.reserve_stock(product_id, requested_quantity)
    
    # 예외 상세 정보 검증
    error = exc_info.value
    assert error.product_id == product_id
    assert error.requested_quantity == requested_quantity
    assert error.available_quantity == available_quantity
    assert "재고가 부족합니다" in str(error)

def test_should_handle_multiple_validation_errors():
    """여러 검증 오류를 적절히 처리해야 합니다."""
    # Given
    invalid_order_data = {
        "customer_email": "invalid-email",  # 잘못된 이메일
        "items": [],  # 빈 항목 리스트
        "shipping_address": ""  # 빈 주소
    }
    
    # When & Then
    with pytest.raises(ValidationError) as exc_info:
        validate_order_data(invalid_order_data)
    
    errors = exc_info.value.errors
    assert len(errors) == 3
    assert any("email" in error.field for error in errors)
    assert any("items" in error.field for error in errors)
    assert any("shipping_address" in error.field for error in errors)
```

### 3. 파라미터화된 테스트
```python
# Good: 여러 케이스를 효율적으로 테스트
@pytest.mark.parametrize("weight,distance,shipping_method,expected_cost", [
    (1.0, 10, "standard", Decimal("12.00")),  # 1kg, 10km, 일반배송
    (5.0, 50, "express", Decimal("25.00")),   # 5kg, 50km, 특급배송
    (0.5, 100, "overnight", Decimal("30.50")), # 0.5kg, 100km, 익일배송
    (2.5, 0, "standard", Decimal("10.00")),   # 2.5kg, 0km (픽업)
])
def test_calculate_shipping_cost_various_scenarios(
    weight, distance, shipping_method, expected_cost
):
    """다양한 시나리오에서 배송비 계산을 테스트합니다."""
    # When
    result = calculate_shipping_cost(
        weight_kg=Decimal(str(weight)),
        distance_km=distance,
        shipping_method=shipping_method
    )
    
    # Then
    assert result == expected_cost

@pytest.mark.parametrize("invalid_input,expected_exception", [
    ({"weight_kg": -1, "distance_km": 10}, ValueError),
    ({"weight_kg": 1, "distance_km": -10}, ValueError),
    ({"weight_kg": 1, "distance_km": 10, "shipping_method": "invalid"}, ValueError),
])
def test_calculate_shipping_cost_validation_errors(invalid_input, expected_exception):
    """배송비 계산 시 잘못된 입력에 대한 검증을 테스트합니다."""
    with pytest.raises(expected_exception):
        calculate_shipping_cost(**invalid_input)
```

## 🔗 통합 테스트 패턴

### 1. 데이터베이스 통합 테스트
```python
# Good: 트랜잭션 롤백을 이용한 격리
import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

@pytest.fixture(scope="session")
def db_engine():
    """테스트용 데이터베이스 엔진"""
    engine = create_engine("postgresql://test:test@localhost/test_db")
    yield engine
    engine.dispose()

@pytest.fixture(scope="function")
def db_session(db_engine):
    """각 테스트마다 독립적인 데이터베이스 세션"""
    connection = db_engine.connect()
    transaction = connection.begin()
    
    Session = sessionmaker(bind=connection)
    session = Session()
    
    yield session
    
    session.close()
    transaction.rollback()
    connection.close()

@pytest.mark.integration
class TestOrderRepositoryIntegration:
    def test_save_and_retrieve_order_with_items(self, db_session):
        """주문과 항목을 저장하고 조회하는 통합 테스트"""
        # Given
        repository = OrderRepository(db_session)
        
        customer = Customer(name="홍길동", email="hong@example.com")
        db_session.add(customer)
        db_session.flush()  # ID 생성을 위해
        
        order = Order(customer_id=customer.id, total_amount=Decimal("150.00"))
        order.items = [
            OrderItem(product_id="P001", quantity=2, price=Decimal("50.00")),
            OrderItem(product_id="P002", quantity=1, price=Decimal("50.00"))
        ]
        
        # When
        saved_order = repository.save(order)
        retrieved_order = repository.find_by_id(saved_order.id)
        
        # Then
        assert retrieved_order is not None
        assert retrieved_order.customer_id == customer.id
        assert retrieved_order.total_amount == Decimal("150.00")
        assert len(retrieved_order.items) == 2
        
        # 관련 데이터 검증
        assert retrieved_order.items[0].order_id == saved_order.id
        assert sum(item.price * item.quantity for item in retrieved_order.items) == Decimal("150.00")
```

### 2. API 통합 테스트
```python
# Good: FastAPI 테스트 클라이언트 활용
from fastapi.testclient import TestClient
import pytest

@pytest.fixture
def authenticated_client():
    """인증된 클라이언트"""
    client = TestClient(app)
    
    # 테스트용 사용자 로그인
    login_response = client.post("/auth/login", json={
        "email": "test@example.com",
        "password": "testpassword"
    })
    token = login_response.json()["access_token"]
    
    client.headers.update({"Authorization": f"Bearer {token}"})
    return client

@pytest.mark.integration
class TestOrderAPIIntegration:
    def test_create_order_end_to_end(self, authenticated_client, db_session):
        """주문 생성 전체 플로우 통합 테스트"""
        # Given - 테스트 데이터 준비
        customer = CustomerFactory()
        products = ProductFactory.create_batch(2, stock_quantity=10)
        db_session.add_all([customer] + products)
        db_session.commit()
        
        order_data = {
            "customer_id": customer.id,
            "items": [
                {
                    "product_id": products[0].id,
                    "quantity": 2
                },
                {
                    "product_id": products[1].id,
                    "quantity": 1
                }
            ],
            "shipping_address": {
                "street": "서울시 강남구 테헤란로 123",
                "city": "서울",
                "postal_code": "06159"
            }
        }
        
        # When
        response = authenticated_client.post("/api/orders", json=order_data)
        
        # Then
        assert response.status_code == 201
        
        response_data = response.json()
        assert response_data["customer_id"] == customer.id
        assert len(response_data["items"]) == 2
        assert response_data["status"] == "PENDING"
        assert "id" in response_data
        
        # 데이터베이스 검증
        created_order = db_session.query(Order).filter_by(
            id=response_data["id"]
        ).first()
        assert created_order is not None
        assert created_order.customer_id == customer.id
        
        # 재고 감소 확인
        updated_products = db_session.query(Product).filter(
            Product.id.in_([p.id for p in products])
        ).all()
        assert updated_products[0].stock_quantity == 8  # 10 - 2
        assert updated_products[1].stock_quantity == 9  # 10 - 1

    def test_order_creation_with_insufficient_stock(self, authenticated_client, db_session):
        """재고 부족 시나리오 통합 테스트"""
        # Given
        customer = CustomerFactory()
        product = ProductFactory(stock_quantity=1)  # 재고 1개만
        db_session.add_all([customer, product])
        db_session.commit()
        
        order_data = {
            "customer_id": customer.id,
            "items": [{"product_id": product.id, "quantity": 5}]  # 5개 요청
        }
        
        # When
        response = authenticated_client.post("/api/orders", json=order_data)
        
        # Then
        assert response.status_code == 400
        assert "재고가 부족합니다" in response.json()["detail"]
        
        # 재고가 변경되지 않았는지 확인
        updated_product = db_session.query(Product).filter_by(id=product.id).first()
        assert updated_product.stock_quantity == 1
```

## 🚀 E2E 테스트 패턴

### 1. 웹 애플리케이션 E2E 테스트
```python
# Good: Page Object 패턴 사용
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

class LoginPage:
    """로그인 페이지 Page Object"""
    
    def __init__(self, driver):
        self.driver = driver
        self.wait = WebDriverWait(driver, 10)
    
    def navigate_to(self):
        self.driver.get("http://localhost:3000/login")
        return self
    
    def enter_email(self, email):
        email_input = self.wait.until(
            EC.presence_of_element_located((By.ID, "email"))
        )
        email_input.clear()
        email_input.send_keys(email)
        return self
    
    def enter_password(self, password):
        password_input = self.driver.find_element(By.ID, "password")
        password_input.clear()
        password_input.send_keys(password)
        return self
    
    def click_login(self):
        login_button = self.driver.find_element(By.ID, "login-button")
        login_button.click()
        return self
    
    def is_error_displayed(self):
        try:
            error_element = self.driver.find_element(By.CLASS_NAME, "error-message")
            return error_element.is_displayed()
        except:
            return False

class OrderPage:
    """주문 페이지 Page Object"""
    
    def __init__(self, driver):
        self.driver = driver
        self.wait = WebDriverWait(driver, 10)
    
    def add_product_to_cart(self, product_name):
        product_element = self.wait.until(
            EC.element_to_be_clickable((By.XPATH, f"//h3[text()='{product_name}']/..//button[@class='add-to-cart']"))
        )
        product_element.click()
        return self
    
    def proceed_to_checkout(self):
        checkout_button = self.wait.until(
            EC.element_to_be_clickable((By.ID, "checkout-button"))
        )
        checkout_button.click()
        return self
    
    def get_order_confirmation_number(self):
        confirmation_element = self.wait.until(
            EC.presence_of_element_located((By.CLASS_NAME, "order-confirmation"))
        )
        return confirmation_element.get_attribute("data-order-id")

@pytest.mark.e2e
class TestOrderFlowE2E:
    @pytest.fixture(scope="class")
    def driver(self):
        """웹드라이버 픽스처"""
        options = webdriver.ChromeOptions()
        options.add_argument("--headless")  # CI 환경에서 headless 모드
        options.add_argument("--no-sandbox")
        options.add_argument("--disable-dev-shm-usage")
        
        driver = webdriver.Chrome(options=options)
        driver.implicitly_wait(10)
        
        yield driver
        
        driver.quit()
    
    def test_complete_order_purchase_flow(self, driver):
        """전체 주문 구매 플로우 E2E 테스트"""
        # Given - 로그인
        login_page = LoginPage(driver)
        login_page.navigate_to() \
                  .enter_email("customer@example.com") \
                  .enter_password("password123") \
                  .click_login()
        
        # 로그인 성공 확인
        WebDriverWait(driver, 10).until(
            EC.url_contains("/dashboard")
        )
        
        # When - 상품 주문
        order_page = OrderPage(driver)
        order_page.add_product_to_cart("테스트 상품 A") \
                  .add_product_to_cart("테스트 상품 B") \
                  .proceed_to_checkout()
        
        # 결제 정보 입력
        self._fill_payment_info(driver)
        self._submit_order(driver)
        
        # Then - 주문 완료 확인
        order_number = order_page.get_order_confirmation_number()
        assert order_number is not None
        assert len(order_number) > 0
        
        # 데이터베이스에서 주문 확인 (추가 검증)
        order = self._get_order_from_db(order_number)
        assert order.status == "CONFIRMED"
        assert len(order.items) == 2
    
    def _fill_payment_info(self, driver):
        """결제 정보 입력 헬퍼 메서드"""
        card_number = driver.find_element(By.ID, "card-number")
        card_number.send_keys("4111111111111111")
        
        expiry = driver.find_element(By.ID, "expiry")
        expiry.send_keys("12/25")
        
        cvv = driver.find_element(By.ID, "cvv")
        cvv.send_keys("123")
    
    def _submit_order(self, driver):
        """주문 제출 헬퍼 메서드"""
        submit_button = driver.find_element(By.ID, "submit-order")
        submit_button.click()
        
        # 처리 중 로딩 대기
        WebDriverWait(driver, 30).until(
            EC.presence_of_element_located((By.CLASS_NAME, "order-success"))
        )
```

### 2. 성능 테스트 패턴
```python
# Good: 성능 기준을 명확히 정의한 테스트
import time
import pytest
from concurrent.futures import ThreadPoolExecutor, as_completed

@pytest.mark.performance
class TestOrderServicePerformance:
    def test_order_creation_response_time(self):
        """주문 생성 응답 시간 테스트 (< 500ms)"""
        # Given
        customer = CustomerFactory()
        items = [OrderItemFactory() for _ in range(5)]
        
        order_service = OrderService()
        
        # When
        start_time = time.time()
        order = order_service.create_order(customer, items)
        end_time = time.time()
        
        # Then
        response_time = (end_time - start_time) * 1000  # ms 변환
        assert response_time < 500, f"응답 시간이 너무 느립니다: {response_time}ms"
        assert order.id is not None
    
    def test_concurrent_order_creation_performance(self):
        """동시 주문 생성 성능 테스트 (100개 주문, < 5초)"""
        # Given
        num_orders = 100
        customers = CustomerFactory.create_batch(num_orders)
        
        def create_single_order(customer):
            items = [OrderItemFactory()]
            return OrderService().create_order(customer, items)
        
        # When
        start_time = time.time()
        
        with ThreadPoolExecutor(max_workers=10) as executor:
            futures = [
                executor.submit(create_single_order, customer)
                for customer in customers
            ]
            
            results = []
            for future in as_completed(futures):
                try:
                    result = future.result()
                    results.append(result)
                except Exception as e:
                    pytest.fail(f"주문 생성 실패: {e}")
        
        end_time = time.time()
        
        # Then
        total_time = end_time - start_time
        assert total_time < 5.0, f"동시 주문 처리 시간이 너무 느립니다: {total_time}초"
        assert len(results) == num_orders
        assert all(order.id is not None for order in results)
    
    @pytest.mark.slow
    def test_large_order_processing_memory_usage(self):
        """대용량 주문 처리 메모리 사용량 테스트"""
        import psutil
        import os
        
        # Given
        process = psutil.Process(os.getpid())
        initial_memory = process.memory_info().rss / 1024 / 1024  # MB
        
        customer = CustomerFactory()
        large_order_items = [OrderItemFactory() for _ in range(10000)]  # 1만개 항목
        
        # When
        order_service = OrderService()
        order = order_service.create_order(customer, large_order_items)
        
        final_memory = process.memory_info().rss / 1024 / 1024  # MB
        memory_increase = final_memory - initial_memory
        
        # Then
        assert memory_increase < 100, f"메모리 사용량이 너무 높습니다: {memory_increase}MB"
        assert order.id is not None
        assert len(order.items) == 10000
```

---

*일관된 테스트 스타일은 코드의 신뢰성을 높이고, 팀의 개발 속도와 품질을 동시에 향상시킵니다.*