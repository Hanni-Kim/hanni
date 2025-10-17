# Hanni Project

🚀 **새로운 기능 구현과 기존 코드 리팩토링을 체계적으로 관리하는 개발 프로젝트**

## 📋 프로젝트 개요

이 프로젝트는 개발 과정에서 새로운 기능 구현과 기존 코드 리팩토링을 체계적으로 관리하기 위한 계획과 도구를 제공합니다. 각 단계별로 명확한 목표와 실행 방법을 정의하여, 효율적이고 일관된 개발 프로세스를 지원합니다.

## 🎯 주요 기능

- **Chat Mode 시스템**: 계획 수립 및 Azure 통합을 위한 특화된 모드
- **Instructions 시스템**: 데이터베이스, Python, 리뷰, 테스트 가이드라인
- **문서화 표준**: 일관된 스타일 가이드 및 프로젝트 명세
- **체계적인 검증**: 단계별 테스트 및 품질 보증 프로세스

## 📂 프로젝트 구조

```
.github/
├── chatmodes/           # Chat mode 정의 파일들
│   ├── plan.chatmode.md
│   └── azure.chatmode.md
└── instructions/        # 개발 가이드라인
    ├── database.instructions.md
    ├── python.instructions.md
    ├── review.instructions.md
    └── test.instructions.md

docs/                    # 문서화
├── database-style.md
├── python-style.md
├── review-instructions.md
├── test-style.md
└── spec.md             # 프로젝트 명세서
```

## 🚀 시작하기

### 전제 조건
- Git이 설치되어 있어야 합니다
- 선호하는 텍스트 에디터 또는 IDE (VS Code 권장)

### 설치 및 설정

1. **저장소 클론**
   ```bash
   git clone https://github.com/Hanni-Kim/hanni.git
   cd hanni
   ```

2. **프로젝트 구조 확인**
   ```bash
   tree .github docs
   ```

## 📖 사용법

### Chat Modes
- **Plan Mode**: 새로운 기능이나 리팩토링을 위한 계획 수립
- **Azure Mode**: Azure 관련 작업을 위한 특화 모드

### Instructions
각 영역별 가이드라인을 참조하여 일관된 개발 진행:
- 데이터베이스 작업 시 → `database.instructions.md`
- Python 개발 시 → `python.instructions.md`
- 코드 리뷰 시 → `review.instructions.md`
- 테스트 작성 시 → `test.instructions.md`

## 🔧 개발 단계

### Phase 1: 프로젝트 초기화
- [x] Git 저장소 설정
- [ ] 프로젝트 구조 완성

### Phase 2: 핵심 기능 구현
- [ ] Chat Mode 시스템 구현
- [ ] Instructions 시스템 구현

### Phase 3: 문서화 및 검증
- [ ] 문서화 완성
- [ ] 검증 및 최적화

## 🤝 기여하기

1. Fork 프로젝트
2. 새로운 기능 브랜치 생성 (`git checkout -b feature/AmazingFeature`)
3. 변경사항 커밋 (`git commit -m 'Add some AmazingFeature'`)
4. 브랜치에 Push (`git push origin feature/AmazingFeature`)
5. Pull Request 생성

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 `LICENSE` 파일을 참조하세요.

## 🙋‍♀️ 문의사항

프로젝트에 대한 질문이나 제안사항이 있으시면 [Issues](https://github.com/Hanni-Kim/hanni/issues)를 통해 문의해 주세요.

---

**Created with ❤️ by Hanni Kim**