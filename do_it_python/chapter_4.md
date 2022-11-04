### chapter 4 : 데이터 프레임의 세계로 
```python
## 데이터를 입력해서 데이터 프레임 만들기

import pandas as pd

df = pd.DataFrame({'name' : ['김지훈','이유진','박동현','김민지'],
                   'english' : [90,80,60,70],
                   'math' : [50,60,100,20]})

df

## 데이터 프레임으로 분석하기 

df['english']

sum(df['english']) # 합계 출력
sum(df['math'])

sum(df['english'])/4 #영어 점수 평균 
sum(df['math'])/4 # 수학 점수 평균 

## 혼자서 해보기 
### 데이터 프레임 출력 
fruit = pd.DataFrame({'제품' : ['사과','딸기','수박'],
                  '가격' : [1800,1500,3000],
                  '판매량' : [24,38,13]})

### 과일의 가격 평균과 판매량 평균 구하기
sum(fruit['가격'])/len(fruit['가격']) 
sum(fruit['판매량'])/len(fruit['판매량'])


4.3. 외부 데이터 이용하기 - 출적된 시험 성적 데이터를 불러오자 

# 엑셀 파일 불러오기 : pd.read_excel 
df_exam = pd.read_excel('c:/data/excel_exam.xlsx')
df_exam 

## 분석하기
sum(df_exam['english'])/20
sum(df_exam['science'])/20

## 행 개수 구하기 : len()
sum(df_exam['english'])/len(df_exam)
sum(df_exam['science'])/len(df_exam)

## 만약 첫 행이 변수명이 아닌 데이터로 되어있다면? : header = None
df_exam_noval = pd.read_excel('excel_exam_noval.xlsx',header = None)
df_exam_noval 


## 만약 엑셀 파일에 시트가 여러개 있다면 ? : shee_name 지정 
df_exam = pd.read_excel('excel_exam.xlsx',sheet_name = 'Sheet2')
df_exam = pd.read_excel('excel_exam.xlsx',shee_name = 2) # 세 번째 시트 불러오기 

# CSV 파일 불러오기 
df_csv_exam = pd.read_csv("c:/data/exam.csv")
df_csv_exam

# 데이터 프레임을 csv 파일로 저장하기 
df_midterm = pd.DataFrame({'english' : [90,80,60,70],
                           'math' : [50,60,100,20],
                           'nclass' : [1,1,2,2]})

df_midterm.to_csv("c:/data/output_newdata.csv",index=False) # index번호는 제외하고 저장하기
```
