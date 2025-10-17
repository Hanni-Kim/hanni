# Hanni Project

🚀 **통합 개발 프레임워크: 생산성 향상과 코드 품질 관리를 위한 종합 솔루션**

## 📋 프로젝트 개요

이 프로젝트는 개발팀의 생산성 향상과 일관된 코드 품질 유지를 위한 통합 개발 프레임워크입니다. Chat Mode 시스템부터 AI 기반 추천 시스템까지, 개발 프로세스의 모든 단계를 지원하는 종합적인 도구와 가이드라인을 제공합니다.

## 🎯 주요 기능

- **Chat Mode 시스템**: 계획 수립 및 Azure 통합을 위한 특화된 모드
- **Instructions 시스템**: 데이터베이스, Python, 리뷰, 테스트 가이드라인
- **문서화 표준**: 일관된 스타일 가이드 및 프로젝트 명세
- **체계적인 검증**: 단계별 테스트 및 품질 보증 프로세스
- **대화형 네비게이션**: 인터랙티브한 가이드 탐색 시스템
- **AI 기반 추천**: 프로젝트 컨텍스트별 맞춤형 가이드 추천
- **자동화 도구**: 워크플로우 자동화 및 성능 최적화
- **성능 모니터링**: 프로젝트 성능 분석 및 최적화 제안

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

interactive/             # 대화형 도구
├── navigation.html      # 가이드 네비게이션 시스템
└── ai-recommendations.html  # AI 기반 추천 시스템

scripts/                 # 자동화 스크립트
├── automation.py        # 워크플로우 자동화 도구
└── performance.py       # 성능 모니터링 및 최적화 도구
```

## 🚀 시작하기

### 전제 조건
- Git이 설치되어 있어야 합니다
- Python 3.8+ (자동화 스크립트 사용 시)
- 선호하는 텍스트 에디터 또는 IDE (VS Code 권장)
- 웹 브라우저 (대화형 도구 사용 시)

### 설치 및 설정

1. **저장소 클론**
   ```bash
   git clone https://github.com/Hanni-Kim/hanni.git
   cd hanni
   ```

2. **프로젝트 구조 확인**
   ```bash
   tree .github docs interactive scripts
   ```

3. **Python 의존성 설치** (자동화 도구 사용 시)
   ```bash
   pip install psutil
   ```

## 📖 사용법

### 🎯 Core Systems

#### Chat Modes
- **Plan Mode**: 새로운 기능이나 리팩토링을 위한 계획 수립
- **Azure Mode**: Azure 관련 작업을 위한 특화 모드

#### Instructions
각 영역별 가이드라인을 참조하여 일관된 개발 진행:
- 데이터베이스 작업 시 → `database.instructions.md`
- Python 개발 시 → `python.instructions.md`
- 코드 리뷰 시 → `review.instructions.md`
- 테스트 작성 시 → `test.instructions.md`

### 🚀 Advanced Features

#### 대화형 네비게이션 시스템
```bash
# interactive/navigation.html을 브라우저에서 열기
start interactive/navigation.html  # Windows
```
- 검색 기능으로 원하는 가이드 빠르게 찾기
- 카테고리별 가이드 분류 및 탐색
- 반응형 디자인으로 모든 기기에서 사용 가능

#### AI 기반 가이드 추천
```bash
# interactive/ai-recommendations.html을 브라우저에서 열기
start interactive/ai-recommendations.html  # Windows
```
- 프로젝트 유형, 기술 스택, 팀 규모에 따른 맞춤형 추천
- AI 인사이트 및 학습 경로 제공
- 실시간 추천 업데이트

#### 자동화 도구
```bash
# 전체 프로젝트 자동화 실행
python scripts/automation.py --all

# 개별 작업 실행
python scripts/automation.py --setup      # 프로젝트 구조 설정
python scripts/automation.py --validate   # 가이드 파일 검증
python scripts/automation.py --report     # 검증 리포트 생성
python scripts/automation.py --commit     # 변경사항 자동 커밋
```

#### 성능 모니터링
```bash
# 전체 성능 분석 실행
python scripts/performance.py

# 특정 워크스페이스 분석
python scripts/performance.py --workspace /path/to/project

```

## 💡 주요 특징

### 🎯 체계적인 가이드라인
- 명확한 Chat Mode 분류로 상황별 최적화된 개발 컨텍스트 제공
- 도메인별 전문 가이드라인으로 일관된 코딩 표준 유지
- 상세한 문서화 표준으로 프로젝트 가독성 향상

### 🚀 고급 자동화 기능
- 프로젝트 구조 자동 설정 및 검증
- Git 워크플로우 자동화로 커밋 프로세스 간소화
- 성능 모니터링으로 프로젝트 최적화 지원

### 🎨 사용자 친화적 인터페이스
- 대화형 웹 인터페이스로 직관적인 가이드 탐색
- AI 기반 개인화 추천으로 맞춤형 학습 경로 제공
- 반응형 디자인으로 다양한 디바이스 지원

## 🔧 기술 스택

- **Frontend**: HTML5, CSS3, JavaScript (Vanilla)
- **Backend**: Python 3.8+
- **자동화**: Python 스크립트, Git CLI
- **문서화**: Markdown, YAML
- **성능 모니터링**: psutil 라이브러리

## � 프로젝트 현황

### ✅ 완료된 Phase들
- **Phase 1**: 프로젝트 초기화 및 Git 설정
- **Phase 2**: Chat Mode 및 Instructions 시스템 구현
- **Phase 3**: 문서화 및 검증 시스템 완성
- **Phase 4**: 고급 기능 (대화형 도구, AI 추천, 자동화, 성능 최적화)

### 📈 구현 통계
- **Chat Modes**: 2개 (Plan, Azure)
- **Instruction 가이드**: 4개 (Database, Python, Review, Test)
- **Style 가이드**: 4개 + 프로젝트 명세
- **자동화 스크립트**: 2개 (Workflow, Performance)
- **대화형 도구**: 2개 (Navigation, AI Recommendations)
- **총 커밋 수**: 8+ 개

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