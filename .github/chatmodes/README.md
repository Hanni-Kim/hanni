# Chat Modes Directory

이 디렉터리는 다양한 작업 컨텍스트에 맞는 Chat Mode 설정 파일들을 포함합니다.

## 현재 구현된 Chat Modes

- `plan.chatmode.md` - 새로운 기능 구현 또는 리팩토링 계획 수립용
- `azure.chatmode.md` - Azure 관련 작업을 위한 특화 모드 (구현 예정)

## Chat Mode 파일 구조

각 `.chatmode.md` 파일은 다음과 같은 구조를 가집니다:

```markdown
---
description: 모드에 대한 간단한 설명
tools: ['tool1', 'tool2', 'tool3']
---
# 모드 이름
모드별 상세 지침 내용...
```

## 사용법

작업 유형에 따라 적절한 Chat Mode를 선택하여 일관되고 효율적인 작업 환경을 구성하세요.

---

*Chat Mode는 작업의 컨텍스트를 명확히 하고 필요한 도구들을 미리 정의하여 생산성을 향상시킵니다.*