#!/usr/bin/env python3
"""
자동화 도구 모음
프로젝트 워크플로우 자동화를 위한 Python 스크립트들
"""

import os
import sys
import json
import subprocess
import argparse
from pathlib import Path
from datetime import datetime
from typing import List, Dict, Optional

class WorkflowAutomation:
    """개발 워크플로우 자동화 클래스"""
    
    def __init__(self, workspace_path: str = None):
        self.workspace_path = Path(workspace_path) if workspace_path else Path.cwd()
        self.github_path = self.workspace_path / ".github"
        self.docs_path = self.workspace_path / "docs"
        
    def setup_project_structure(self):
        """프로젝트 구조 자동 설정"""
        print("🏗️ 프로젝트 구조 설정 중...")
        
        # 필수 디렉토리 생성
        directories = [
            self.github_path / "chatmodes",
            self.github_path / "instructions", 
            self.github_path / "workflows",
            self.docs_path,
            self.workspace_path / "interactive",
            self.workspace_path / "scripts"
        ]
        
        for directory in directories:
            directory.mkdir(parents=True, exist_ok=True)
            print(f"  ✓ 디렉토리 생성: {directory}")
            
        return True
    
    def validate_guides(self) -> Dict[str, bool]:
        """가이드 파일들의 존재 여부 검증"""
        print("📋 가이드 파일 검증 중...")
        
        required_files = {
            "Chat Modes": [
                self.github_path / "chatmodes" / "plan.chatmode.md",
                self.github_path / "chatmodes" / "azure.chatmode.md"
            ],
            "Instructions": [
                self.github_path / "instructions" / "database.instructions.md",
                self.github_path / "instructions" / "python.instructions.md",
                self.github_path / "instructions" / "review.instructions.md", 
                self.github_path / "instructions" / "test.instructions.md"
            ],
            "Style Guides": [
                self.docs_path / "database-style.md",
                self.docs_path / "python-style.md",
                self.docs_path / "review-instructions.md",
                self.docs_path / "test-style.md"
            ],
            "Project Docs": [
                self.docs_path / "spec.md",
                self.workspace_path / "README.md",
                self.workspace_path / "VALIDATION_REPORT.md"
            ]
        }
        
        results = {}
        
        for category, files in required_files.items():
            print(f"\n{category}:")
            category_results = []
            
            for file_path in files:
                exists = file_path.exists()
                status = "✓" if exists else "✗" 
                print(f"  {status} {file_path.name}")
                category_results.append(exists)
                
            results[category] = all(category_results)
            
        return results
    
    def generate_validation_report(self) -> str:
        """검증 리포트 자동 생성"""
        print("📊 검증 리포트 생성 중...")
        
        validation_results = self.validate_guides()
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        
        report_content = f"""# 🔍 프로젝트 검증 리포트

**생성 일시:** {timestamp}  
**검증 도구:** Workflow Automation Script

## 📋 검증 결과 요약

"""
        
        total_categories = len(validation_results)
        passed_categories = sum(1 for result in validation_results.values() if result)
        
        report_content += f"- **전체 카테고리:** {total_categories}\n"
        report_content += f"- **통과 카테고리:** {passed_categories}\n" 
        report_content += f"- **성공률:** {(passed_categories/total_categories)*100:.1f}%\n\n"
        
        report_content += "## 📊 카테고리별 상세 결과\n\n"
        
        for category, result in validation_results.items():
            status_icon = "✅" if result else "❌"
            status_text = "통과" if result else "실패"
            report_content += f"### {status_icon} {category} - {status_text}\n\n"
            
        # Git 상태 확인
        try:
            git_status = subprocess.run(
                ["git", "status", "--porcelain"], 
                capture_output=True, 
                text=True,
                cwd=self.workspace_path
            )
            
            if git_status.returncode == 0:
                uncommitted_files = git_status.stdout.strip()
                if uncommitted_files:
                    report_content += "## ⚠️ Git 상태\n\n"
                    report_content += "다음 파일들이 커밋되지 않았습니다:\n\n"
                    for line in uncommitted_files.split('\n'):
                        report_content += f"- `{line}`\n"
                else:
                    report_content += "## ✅ Git 상태\n\n모든 변경사항이 커밋되었습니다.\n\n"
                    
        except Exception as e:
            report_content += f"## ❌ Git 상태 확인 실패\n\n{str(e)}\n\n"
            
        # 권장사항
        report_content += """## 💡 권장사항

1. **문서 업데이트**: 프로젝트 진행에 따라 가이드 문서를 지속적으로 업데이트하세요.
2. **정기 검증**: 이 스크립트를 정기적으로 실행하여 프로젝트 상태를 점검하세요.
3. **팀 공유**: 검증 결과를 팀원들과 공유하여 일관된 개발 환경을 유지하세요.

---
*이 리포트는 자동으로 생성되었습니다.*
"""
        
        # 리포트 파일 저장
        report_path = self.workspace_path / "VALIDATION_REPORT.md"
        with open(report_path, 'w', encoding='utf-8') as f:
            f.write(report_content)
            
        print(f"✓ 검증 리포트 생성 완료: {report_path}")
        return report_content
    
    def commit_changes(self, message: str = None):
        """변경사항 자동 커밋"""
        if not message:
            message = f"Auto-commit: Project validation and updates - {datetime.now().strftime('%Y-%m-%d %H:%M')}"
            
        try:
            # Git 상태 확인
            result = subprocess.run(
                ["git", "status", "--porcelain"],
                capture_output=True,
                text=True,
                cwd=self.workspace_path
            )
            
            if result.stdout.strip():
                print("📦 Git 커밋 수행 중...")
                
                # 모든 변경사항 스테이징
                subprocess.run(["git", "add", "."], cwd=self.workspace_path)
                
                # 커밋 수행
                subprocess.run(["git", "commit", "-m", message], cwd=self.workspace_path)
                
                print(f"✓ 커밋 완료: {message}")
                return True
            else:
                print("ℹ️ 커밋할 변경사항이 없습니다.")
                return False
                
        except Exception as e:
            print(f"❌ Git 커밋 실패: {str(e)}")
            return False
    
    def create_github_issue(self, title: str, body: str, labels: List[str] = None):
        """GitHub 이슈 생성 (GitHub CLI 필요)"""
        try:
            cmd = ["gh", "issue", "create", "--title", title, "--body", body]
            
            if labels:
                cmd.extend(["--label", ",".join(labels)])
                
            result = subprocess.run(cmd, capture_output=True, text=True, cwd=self.workspace_path)
            
            if result.returncode == 0:
                print(f"✓ GitHub 이슈 생성 완료: {title}")
                return True
            else:
                print(f"❌ GitHub 이슈 생성 실패: {result.stderr}")
                return False
                
        except Exception as e:
            print(f"❌ GitHub CLI 오류: {str(e)}")
            return False

def main():
    parser = argparse.ArgumentParser(description="개발 워크플로우 자동화 도구")
    parser.add_argument("--workspace", "-w", help="워크스페이스 경로", default=".")
    parser.add_argument("--setup", action="store_true", help="프로젝트 구조 설정")
    parser.add_argument("--validate", action="store_true", help="가이드 파일 검증")
    parser.add_argument("--report", action="store_true", help="검증 리포트 생성")
    parser.add_argument("--commit", action="store_true", help="변경사항 자동 커밋")
    parser.add_argument("--message", "-m", help="커밋 메시지")
    parser.add_argument("--all", action="store_true", help="모든 작업 수행")
    
    args = parser.parse_args()
    
    # WorkflowAutomation 인스턴스 생성
    automation = WorkflowAutomation(args.workspace)
    
    print("🚀 개발 워크플로우 자동화 도구 시작")
    print(f"📁 워크스페이스: {automation.workspace_path}")
    print("-" * 50)
    
    if args.all or args.setup:
        automation.setup_project_structure()
        print()
        
    if args.all or args.validate:
        automation.validate_guides()
        print()
        
    if args.all or args.report:
        automation.generate_validation_report()
        print()
        
    if args.all or args.commit:
        automation.commit_changes(args.message)
        print()
        
    print("✨ 자동화 작업 완료!")

if __name__ == "__main__":
    main()