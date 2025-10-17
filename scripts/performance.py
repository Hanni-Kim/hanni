#!/usr/bin/env python3
"""
성능 모니터링 및 최적화 도구
프로젝트의 성능을 분석하고 최적화 방안을 제시하는 도구
"""

import os
import time
import psutil
import json
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Tuple
import subprocess

class PerformanceMonitor:
    """성능 모니터링 클래스"""
    
    def __init__(self, workspace_path: str = None):
        self.workspace_path = Path(workspace_path) if workspace_path else Path.cwd()
        self.metrics = {}
        
    def analyze_file_sizes(self) -> Dict[str, any]:
        """파일 크기 분석"""
        print("📁 파일 크기 분석 중...")
        
        file_stats = {
            'total_files': 0,
            'total_size': 0,
            'large_files': [],
            'by_extension': {},
            'recommendations': []
        }
        
        for file_path in self.workspace_path.rglob('*'):
            if file_path.is_file() and not self._should_ignore_file(file_path):
                try:
                    size = file_path.stat().st_size
                    file_stats['total_files'] += 1
                    file_stats['total_size'] += size
                    
                    # 대용량 파일 확인 (10MB 이상)
                    if size > 10 * 1024 * 1024:
                        file_stats['large_files'].append({
                            'path': str(file_path.relative_to(self.workspace_path)),
                            'size': size,
                            'size_mb': round(size / (1024 * 1024), 2)
                        })
                    
                    # 확장자별 통계
                    ext = file_path.suffix.lower() or 'no_extension'
                    if ext not in file_stats['by_extension']:
                        file_stats['by_extension'][ext] = {'count': 0, 'total_size': 0}
                    
                    file_stats['by_extension'][ext]['count'] += 1
                    file_stats['by_extension'][ext]['total_size'] += size
                    
                except Exception as e:
                    print(f"  ⚠️ 파일 분석 오류 - {file_path}: {e}")
        
        # 권장사항 생성
        if file_stats['large_files']:
            file_stats['recommendations'].append(
                "대용량 파일들을 Git LFS로 관리하거나 .gitignore에 추가하는 것을 고려하세요."
            )
            
        return file_stats
    
    def analyze_git_performance(self) -> Dict[str, any]:
        """Git 저장소 성능 분석"""
        print("🔄 Git 성능 분석 중...")
        
        git_stats = {
            'repo_size': 0,
            'commit_count': 0,
            'branch_count': 0,
            'untracked_files': 0,
            'large_commits': [],
            'recommendations': []
        }
        
        try:
            # .git 디렉토리 크기
            git_dir = self.workspace_path / '.git'
            if git_dir.exists():
                git_stats['repo_size'] = self._get_directory_size(git_dir)
            
            # 커밋 수 확인
            result = subprocess.run(
                ['git', 'rev-list', '--count', 'HEAD'],
                capture_output=True, text=True, cwd=self.workspace_path
            )
            if result.returncode == 0:
                git_stats['commit_count'] = int(result.stdout.strip())
            
            # 브랜치 수 확인
            result = subprocess.run(
                ['git', 'branch', '-a'],
                capture_output=True, text=True, cwd=self.workspace_path
            )
            if result.returncode == 0:
                git_stats['branch_count'] = len(result.stdout.strip().split('\n'))
            
            # 추적되지 않은 파일 수
            result = subprocess.run(
                ['git', 'status', '--porcelain'],
                capture_output=True, text=True, cwd=self.workspace_path
            )
            if result.returncode == 0:
                untracked = [line for line in result.stdout.split('\n') if line.startswith('??')]
                git_stats['untracked_files'] = len(untracked)
            
            # 권장사항
            if git_stats['repo_size'] > 100 * 1024 * 1024:  # 100MB
                git_stats['recommendations'].append(
                    "저장소 크기가 큽니다. git gc 명령으로 정리하거나 대용량 파일을 확인하세요."
                )
            
            if git_stats['untracked_files'] > 10:
                git_stats['recommendations'].append(
                    "추적되지 않은 파일이 많습니다. .gitignore 파일을 검토하세요."
                )
                
        except Exception as e:
            print(f"  ⚠️ Git 분석 오류: {e}")
            
        return git_stats
    
    def analyze_documentation_health(self) -> Dict[str, any]:
        """문서 상태 분석"""
        print("📚 문서 상태 분석 중...")
        
        doc_stats = {
            'md_files_count': 0,
            'total_lines': 0,
            'avg_file_length': 0,
            'files_without_headers': [],
            'empty_files': [],
            'recommendations': []
        }
        
        md_files = list(self.workspace_path.rglob('*.md'))
        doc_stats['md_files_count'] = len(md_files)
        
        total_lines = 0
        for md_file in md_files:
            try:
                with open(md_file, 'r', encoding='utf-8') as f:
                    lines = f.readlines()
                    line_count = len(lines)
                    total_lines += line_count
                    
                    # 빈 파일 확인
                    if line_count == 0:
                        doc_stats['empty_files'].append(str(md_file.relative_to(self.workspace_path)))
                    
                    # 헤더가 없는 파일 확인
                    elif line_count > 0 and not any(line.strip().startswith('#') for line in lines):
                        doc_stats['files_without_headers'].append(str(md_file.relative_to(self.workspace_path)))
                        
            except Exception as e:
                print(f"  ⚠️ 문서 분석 오류 - {md_file}: {e}")
        
        doc_stats['total_lines'] = total_lines
        if md_files:
            doc_stats['avg_file_length'] = round(total_lines / len(md_files), 2)
        
        # 권장사항
        if doc_stats['empty_files']:
            doc_stats['recommendations'].append(
                "빈 문서 파일들이 있습니다. 내용을 추가하거나 삭제를 고려하세요."
            )
        
        if doc_stats['files_without_headers']:
            doc_stats['recommendations'].append(
                "일부 문서에 제목(헤더)이 없습니다. 문서 구조를 개선하세요."
            )
            
        return doc_stats
    
    def measure_system_performance(self) -> Dict[str, any]:
        """시스템 리소스 사용량 측정"""
        print("⚡ 시스템 성능 측정 중...")
        
        # CPU 사용률 (1초 동안 측정)
        cpu_before = psutil.cpu_percent()
        time.sleep(1)
        cpu_usage = psutil.cpu_percent()
        
        # 메모리 사용률
        memory = psutil.virtual_memory()
        
        # 디스크 사용률
        disk = psutil.disk_usage(str(self.workspace_path))
        
        performance_stats = {
            'cpu_usage_percent': cpu_usage,
            'memory_usage_percent': memory.percent,
            'memory_available_gb': round(memory.available / (1024**3), 2),
            'disk_usage_percent': round((disk.used / disk.total) * 100, 2),
            'disk_free_gb': round(disk.free / (1024**3), 2),
            'recommendations': []
        }
        
        # 성능 권장사항
        if cpu_usage > 80:
            performance_stats['recommendations'].append(
                "CPU 사용률이 높습니다. 백그라운드 프로세스를 확인하세요."
            )
        
        if memory.percent > 85:
            performance_stats['recommendations'].append(
                "메모리 사용률이 높습니다. 불필요한 애플리케이션을 종료하세요."
            )
        
        if disk.free < 5 * 1024**3:  # 5GB 미만
            performance_stats['recommendations'].append(
                "디스크 여유 공간이 부족합니다. 정리가 필요합니다."
            )
            
        return performance_stats
    
    def generate_optimization_suggestions(self, all_metrics: Dict) -> List[str]:
        """종합적인 최적화 제안 생성"""
        suggestions = []
        
        # 파일 크기 기반 제안
        if all_metrics.get('file_analysis', {}).get('large_files'):
            suggestions.append(
                "🗂️ 대용량 파일 최적화: Git LFS 사용을 고려하거나 파일을 압축하세요."
            )
        
        # Git 최적화 제안
        git_metrics = all_metrics.get('git_analysis', {})
        if git_metrics.get('repo_size', 0) > 50 * 1024 * 1024:
            suggestions.append(
                "🔄 Git 저장소 최적화: 'git gc --aggressive' 실행을 고려하세요."
            )
        
        # 문서 최적화 제안
        doc_metrics = all_metrics.get('documentation_analysis', {})
        if doc_metrics.get('empty_files') or doc_metrics.get('files_without_headers'):
            suggestions.append(
                "📚 문서 구조 개선: 빈 파일 정리 및 헤더 추가가 필요합니다."
            )
        
        # 시스템 최적화 제안
        sys_metrics = all_metrics.get('system_performance', {})
        if sys_metrics.get('memory_usage_percent', 0) > 80:
            suggestions.append(
                "⚡ 시스템 최적화: IDE의 메모리 사용량을 줄이거나 시스템을 재시작하세요."
            )
        
        # 일반적인 최적화 제안
        suggestions.extend([
            "🧹 정기적인 정리: 임시 파일과 캐시를 주기적으로 정리하세요.",
            "📊 성능 모니터링: 이 도구를 정기적으로 실행하여 성능을 추적하세요.",
            "🔧 개발 환경 최적화: 불필요한 확장 프로그램을 비활성화하세요."
        ])
        
        return suggestions
    
    def run_full_analysis(self) -> Dict[str, any]:
        """전체 성능 분석 실행"""
        print("🎯 전체 성능 분석 시작")
        print("=" * 50)
        
        start_time = time.time()
        
        # 각 분석 실행
        metrics = {
            'timestamp': datetime.now().isoformat(),
            'workspace_path': str(self.workspace_path),
            'file_analysis': self.analyze_file_sizes(),
            'git_analysis': self.analyze_git_performance(),
            'documentation_analysis': self.analyze_documentation_health(),
            'system_performance': self.measure_system_performance()
        }
        
        # 최적화 제안 생성
        metrics['optimization_suggestions'] = self.generate_optimization_suggestions(metrics)
        
        analysis_time = time.time() - start_time
        metrics['analysis_duration_seconds'] = round(analysis_time, 2)
        
        print(f"\n✅ 분석 완료 (소요시간: {analysis_time:.2f}초)")
        
        return metrics
    
    def save_report(self, metrics: Dict, output_path: str = None):
        """성능 분석 리포트 저장"""
        if not output_path:
            output_path = self.workspace_path / "performance_report.json"
        
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(metrics, f, indent=2, ensure_ascii=False)
        
        print(f"📄 성능 리포트 저장: {output_path}")
        
        # 마크다운 버전도 생성
        markdown_path = output_path.with_suffix('.md')
        self._generate_markdown_report(metrics, markdown_path)
    
    def _generate_markdown_report(self, metrics: Dict, output_path: Path):
        """마크다운 형식의 리포트 생성"""
        content = f"""# 🎯 성능 분석 리포트

**생성 일시:** {metrics['timestamp']}  
**분석 소요시간:** {metrics['analysis_duration_seconds']}초  
**워크스페이스:** {metrics['workspace_path']}

## 📊 분석 결과 요약

### 📁 파일 분석
- **총 파일 수:** {metrics['file_analysis']['total_files']:,}
- **총 크기:** {round(metrics['file_analysis']['total_size'] / (1024*1024), 2)} MB
- **대용량 파일 수:** {len(metrics['file_analysis']['large_files'])}

### 🔄 Git 저장소
- **저장소 크기:** {round(metrics['git_analysis']['repo_size'] / (1024*1024), 2)} MB
- **커밋 수:** {metrics['git_analysis']['commit_count']:,}
- **브랜치 수:** {metrics['git_analysis']['branch_count']}
- **미추적 파일 수:** {metrics['git_analysis']['untracked_files']}

### 📚 문서 상태
- **마크다운 파일 수:** {metrics['documentation_analysis']['md_files_count']}
- **평균 파일 길이:** {metrics['documentation_analysis']['avg_file_length']} 줄
- **빈 파일 수:** {len(metrics['documentation_analysis']['empty_files'])}

### ⚡ 시스템 성능
- **CPU 사용률:** {metrics['system_performance']['cpu_usage_percent']}%
- **메모리 사용률:** {metrics['system_performance']['memory_usage_percent']}%
- **디스크 여유공간:** {metrics['system_performance']['disk_free_gb']} GB

## 💡 최적화 제안

"""
        
        for i, suggestion in enumerate(metrics['optimization_suggestions'], 1):
            content += f"{i}. {suggestion}\n"
        
        content += "\n---\n*이 리포트는 자동으로 생성되었습니다.*"
        
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(content)
        
        print(f"📄 마크다운 리포트 생성: {output_path}")
    
    def _should_ignore_file(self, file_path: Path) -> bool:
        """무시할 파일인지 확인"""
        ignore_patterns = [
            '.git', '__pycache__', '.vscode/extensions', 
            'node_modules', '.pytest_cache', '.mypy_cache'
        ]
        
        path_str = str(file_path)
        return any(pattern in path_str for pattern in ignore_patterns)
    
    def _get_directory_size(self, directory: Path) -> int:
        """디렉토리 크기 계산"""
        total_size = 0
        try:
            for file_path in directory.rglob('*'):
                if file_path.is_file():
                    total_size += file_path.stat().st_size
        except Exception:
            pass
        return total_size

def main():
    import argparse
    
    parser = argparse.ArgumentParser(description="성능 모니터링 및 최적화 도구")
    parser.add_argument("--workspace", "-w", help="워크스페이스 경로", default=".")
    parser.add_argument("--output", "-o", help="리포트 출력 경로")
    parser.add_argument("--json-only", action="store_true", help="JSON 리포트만 생성")
    
    args = parser.parse_args()
    
    # 성능 모니터 인스턴스 생성
    monitor = PerformanceMonitor(args.workspace)
    
    # 전체 분석 실행
    metrics = monitor.run_full_analysis()
    
    # 리포트 저장
    output_path = Path(args.output) if args.output else None
    monitor.save_report(metrics, output_path)
    
    print("\n🎉 성능 분석이 완료되었습니다!")

if __name__ == "__main__":
    main()