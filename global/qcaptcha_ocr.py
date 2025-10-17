import os
import json
import base64
import requests
from PIL import Image
from collections import Counter

# OpenAI API Key (직접 입력)
api_key = "sk-proj-lzVi7CvFkyFsZyLtF2DAT3BlbkFJ3ZechQYZZBtaMpQ6ZzKz"

# 이미지를 인코딩하는 함수
def encode_image(image_path):
    if not os.path.exists(image_path):
        raise FileNotFoundError(f"파일이나 디렉토리가 존재하지 않습니다: '{image_path}'")
    with open(image_path, "rb") as image_file:
        return base64.b64encode(image_file.read()).decode('utf-8')

# 이미지에서 특정 색상이 포함되어 있는지 확인하는 함수
def contains_specific_colors(image_path, target_colors):
    image = Image.open(image_path).convert("RGB")
    pixels = image.getdata()
    for pixel in pixels:
        if any(all(abs(pixel[channel] - color[channel]) <= 10 for channel in range(3)) for color in target_colors):
            return True
    return False

# 타겟 색상 (RGB)
target_colors = [
    (126, 197, 183),  # #7EC5B7
    (166, 217, 212),  # #A6D9D4
    (201, 222, 227)   # #C9DEE3
]

# 이미지 디렉토리 경로
images_directory = r"C:\\qcaptcha"

# 디렉토리 내의 모든 jfif 및 jpeg 파일 목록
image_files = [f for f in os.listdir(images_directory) if f.endswith(('.jfif', '.jpeg', '.jpg', '.png', '.svg'))]

# 결과를 저장할 리스트
results = []

for image_file in image_files:
    # 현재 이미지 경로
    image_path = os.path.join(images_directory, image_file)

    # 경로 확인
    print(f"이미지 경로: {image_path}")
    print(f"파일 존재 여부: {os.path.exists(image_path)}")

    try:
        # base64 문자열 얻기
        base64_image = encode_image(image_path)
    except FileNotFoundError as e:
        print(e)
        continue

    # 이미지에서 특정 색상 포함 여부 확인
    is_blue_background = contains_specific_colors(image_path, target_colors)

    if is_blue_background:
        print(f"{image_file} 이미지의 배경색은 파란색입니다. 텍스트 추출을 건너뜁니다.")
        continue

    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {api_key}"
    }

    payload = {
        "model": "gpt-4o",
        "messages": [
            {
                "role": "system",
                "content": "이미지 배경색이 파란색인지 여부를 분석하고, 배경색이 파란색이 아닌 경우에만 이미지 내의 문자열을 추출합니다. 결과는 4자리 알파벳과 숫자의 조합입니다."
            },
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": "이미지에서 텍스트를 추출해 주세요. 텍스트는 알파벳과 숫자의 조합으로 4자리입니다."
                    },
                    {
                        "type": "image_url",
                        "image_url": {
                            "url": f"data:image/jpeg;base64,{base64_image}"
                        }
                    }
                ]
            }
        ],
        "max_tokens": 1500
    }

    response = requests.post("https://api.openai.com/v1/chat/completions", headers=headers, json=payload)

    # API 응답 출력
    print(f"{image_file} 이미지에 대한 응답:")
    print("응답 상태 코드:", response.status_code)
    print("응답 내용:", response.text)

    # 응답 데이터를 변수에 저장
    data = response.json()

    # 응답 형식 확인 및 결과 저장
    if 'choices' in data:
        extracted_text = data['choices'][0]['message']['content']
        results.append(extracted_text)
        print(f"추출된 텍스트: {extracted_text}")
    else:
        print("API 응답에 'choices'가 포함되어 있지 않습니다.")

# 최종 결과 리스트 출력
print("최종 추출된 텍스트:", results)

# 결과 리스트에서 "" 안의 문자열 추출
extracted_results = []
for result in results:
    start_index = result.find('"') + 1
    end_index = result.find('"', start_index)
    if start_index != 0 and end_index != -1:
        extracted_text = result[start_index:end_index]
        extracted_results.append(extracted_text)

# 자리수별로 문자 빈도수 계산
counters = [Counter() for _ in range(4)]

for result in extracted_results:
    if len(result) == 4:  # 문자열 길이가 4자인지 확인
        for i, char in enumerate(result):
            counters[i][char] += 1

# 각 자리에서 가장 많이 등장한 문자 선택
most_common_chars = [counter.most_common(1)[0][0] for counter in counters]

# 최종 조합
final_combination = ''.join(most_common_chars)

# 최종 조합 출력
print("최종 조합:", final_combination)

# 최종 조합을 qcaptcha.txt 파일로 저장
output_path = os.path.join(images_directory, "qcaptcha.txt")
with open(output_path, "w") as file:
    file.write(final_combination)

print(f"최종 조합이 {output_path}에 저장되었습니다.")
