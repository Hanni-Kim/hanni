---
description: Generate an implementation plan for new featuresgit or refactoring existing code.
tools: ['codebase', 'fetch', 'findTestFiles', 'githubRepo', 'search', 'usages']
---
# Planning mode instructions
당신은 Planning 모드에 있습니다. 새로운 기능 구현 또는 기존 코드 리팩토링을 위한 구현 계획을 작성하는 것이 임무입니다.
코드 수정은 하지 말고, 오직 계획만 작성하세요.

계획서는 다음과 같은 섹션을 포함하는 마크다운 문서로 작성됩니다:
* 개요(Overview): 기능 또는 리팩토링 작업에 대한 간단한 설명
* 요구사항(Requirements): 해당 기능 또는 리팩토링 작업의 요구사항 목록
* 구현 단계(Implementation Steps): 기능 또는 리팩토링 작업을 구현하기 위한 상세 단계 목록
* 테스트(Testing): 해당 기능 또는 리팩토링 작업을 검증하기 위해 구현해야 할 테스트 목록

---
## 개요(Overview)
이 프로젝트는 새로운 기능 구현과 기존 코드 리팩토링을 체계적으로 관리하기 위한 계획을 제공합니다. 각 단계별로 명확한 목표와 실행 방법을 정의하여, 효율적이고 일관된 개발 프로세스를 지원합니다.

## 요구사항(Requirements)
1. **계획서 템플릿 구조화**: 개요, 요구사항, 구현 단계, 테스트 섹션을 포함하는 표준 템플릿 제작
2. **도구 통합**: codebase, fetch, findTestFiles, githubRepo, search, usages 도구를 활용한 계획 수립
3. **단계별 검증**: 각 구현 단계마다 명확한 완료 기준과 검증 방법 정의
4. **문서화 표준**: 마크다운 형식의 일관된 문서 작성 규칙 수립
5. **버전 관리**: 각 단계별 커밋과 적절한 커밋 메시지 작성 규칙 정의

## 구현 단계(Implementation Steps)
### Phase 1: 프로젝트 초기화
1. **Git 저장소 설정**
   - Git 저장소 초기화 및 원격 저장소 연결
   - .gitignore 파일 생성 및 설정
   - 초기 README.md 작성

2. **프로젝트 구조 설정**
   - .github 폴더 및 하위 디렉터리 생성
   - chatmodes, instructions, docs 폴더 구조 생성
   - 기본 템플릿 파일들 생성

### Phase 2: 핵심 기능 구현
3. **Chat Mode 시스템 구현**
   - plan.chatmode.md 완성
   - azure.chatmode.md 구현
   - 각 chatmode별 특화 기능 정의

4. **Instructions 시스템 구현**
   - database.instructions.md 작성
   - python.instructions.md 작성
   - review.instructions.md 작성
   - test.instructions.md 작성

### Phase 3: 문서화 및 검증
5. **문서화 완성**
   - 각 스타일 가이드 문서 작성 (docs 폴더)
   - spec.md 작성 (프로젝트 명세서)
   - 사용자 가이드 작성

6. **검증 및 최적화**
   - 각 기능별 동작 테스트
   - 문서 일관성 검토
   - 코드 품질 검증

