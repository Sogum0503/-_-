### do_it_python 챕터 6 

```python
# -*- coding: utf-8 -*-
"""
Created on Mon Sep 26 23:47:16 2022

@author: 82108
"""

do it python 
6장 자유자재로 데이터 가공하기

6-1 데이터 전처리 | 원하는 형태로 데이터 가공하기

'''
pandas를 이용한 데이터 가공 방법

query() : 행 추출
df[] : 열(변수) 추출
sort_values() : 정렬
groupby() : 집단별로 나누기
assign() : 변수 추가
agg() : 통계치 구하기
merge() : 데이터 합치기(열)
concat() : 데이터 합치기(행)
'''

6-2 조건에 맞는 데이터만 추출하기

import pandas as pd 
exam = pd.read_csv("c:/data/exam_new.csv")
exam.head()

# exam에서 nclass가 1인 경우만 추출 
exam.query('nclass==1')

# 2반인 경우만 추출 
exam.query('nclass==2')
exam.query('math==50')

# 1반이 아닌 경우만 추출
exam.query('nclass != 1')
# 3반이 아닌 경우만 추출
exam.query('nclass != 3')

◆ 실습 1 
# 수학 점수가 50점을 초과한 경우
exam.query('math > 50')
# 수학 점수가 50점 미만인 경우
exam.query('math < 50')

# 영어 점수가 50점 이상인 경우
exam.query('english >= 50')
# 영어 점수가 80점 이하인 경우
exam.query('english <= 80')

◆ 실습 2 : 여러 조건을 충족하는 행 추출하기 
# 1반이면서 수학 점수가 50점 이상인 경우
exam.query('nclass ==1 & math >= 50')

# 2반이면서 영어 점수가 80점 이상인 경우
exam.query('nclass==2 & english >= 80')

◆ 실습 3 : 여러 조건 중 하나 이상 충족하는 행 추출하기 
# 수학 점수가 90점 이상이거나 영어 점수가 90점 이상인 경우
exam.query('math >= 90 | english >= 90')

# 영어 점수가 90점 미만이거나 과학 점수가 50점 미만인 경우
exam.query('english < 90 | science < 50')

◆ 실습 4 : 목록에 해당하는 행 추출하기 
# 1, 3, 5반에 해당하면 추출 
exam.query('nclass == 1 | nclass == 3 | nclass == 5') # using | 
exam.query('nclass in [1,3,5]') # using in


◆ 실습 5 : 추출한 행으로 데이터 만들기
# nclass가 1인 행을 추출해 nclass1에 할당하기
nclass1 = exam.query('nclass == 1')
nclass1.mean()
nclass1['math'].mean()

# nclass가 2인 행 추출해 nclass 2에 할당하기
nclass2 = exam.query('nclass==2')
nclass2.mean()

◆ 실습 6 : 문자 변수를 이용해 조건에 맞는 행 추출하기 
df = pd.DataFrame({'sex' : ['F','M','F','M'],
                   'country' : ['Korea','China','Japan','USA']})

df 

# 전체 조건에 작은 따옴표, 추출할 문자에 큰 따옴표 사용 
df.query('sex == "F" & country == "Korea"')
df.query("sex == 'M' & country == 'China'")

◆ 알아 두면 좋아요 
1. 외부 변수를 이용해 추출하기 
데이터 프레임에 들어 있는 변수가 아니라도 별도의 변수를 이용해 행을 추출하려면 변수명 앞에 @를 붙이면 된다

var = 3 
exam.query('nclass == @var')

2. 파이썬에서 사용하는 기호
operators = pd.DataFrame({'산술 연산자' : ['//','%'],
                          '기능' : ['나눗셈의 몫','나눗셈의 나머지']})
operators

3. 데이터 프레임 출력 제한 설정하기 
pd.set_option('display.max_rows',None) # 모든 행 출력하도록 설정
pd.set_option('display.max_columns',None) # 모든 열 출력하도록 설정 

# 만약 커널을 새로 실행하지 않고 설정을 되돌리려면..
pd.reset_option('display.max_rows') # 행 출력 제한 되돌리기
pd.reset_option('display.max_columns') #  열 출력 제한 되돌리기
pd.reset_option('all') #  모든 설정 되돌리기 


◆ 혼자서 해보기 
mpg = pd.read_csv("c:/data/mpg.csv")

Q1. 자동차 배기량에 따라 고속도로 연비가 다른지 알아보려고 합니다. 
    displ(배기량)이 4 이하인 자동차와 5 이상인 자동차 중 어떤 자동차의 hwy(고속도로 연비) 평균이 더 높은지 알아보세요

displ4 = mpg.query('displ <= 4')
displ5 = mpg.query('displ >= 5')

x = round(displ4['hwy'].mean(),2)
y = round(displ5['hwy'].mean(),2)

if x > y:
    print("배기량이 4 이하인 자동차의 고속도로 연비가 더 좋습니다") #채택 
else:
    print("배기량이 5 이상인 자동차의 고속도로 연비가 더 좋습니다")
    
Q2. 자동차 제조 회사에 따라 도시 연비가 어떻게 다른지 알아보려고 합니다.
    'audi'와 'toyota'중 어느 manufacturer(자동차 제조 회사)의 cty(도시 연비) 평균이 더 높은지 알아보세요.

audi = mpg.query('manufacturer == "audi"')
toyota = mpg.query('manufacturer == "toyota"')

a = audi['cty'].mean()
t = toyota['cty'].mean()

Q3. 'chevrolet','ford','honda' 자동차의 고속도로 연비 평균을 알아보려고 합니다. 
    세 회사의 데이터를 추출한 다음 hwy 전체 평균을 구해보세요

cfh = mpg.query('manufacturer in ["chevrolet","ford","honda"]')
round(cfh['hwy'].mean(),2) # 22.51 

6-3 필요한 변수만 추출하기

exam['math'] # math만 출력 
exam[['nclass','math','english']] # 여러변수 함께 출력 

알아두면 좋아요 
1. 변수가 1개 일 때 데이터 프레임 유지하기 

type(exam['math']) # Series 
type(exam[['math']]) # DataFrame

◆ 실습 1 : 변수 제거하기 
df.drop() # 미리보기 

exam.drop(columns = 'math') 
exam.drop(columns = ['math','english'])

◆ 실습 2 : pandas 함수 조합하기
# nclass가 1인 행만 추출한 다음 enlgish 추출
exam.query('nclass == 1')['english']

# math가 50 이상인 행만 추출한 다음 id, math 추출
exam.query('math >= 50')[['id','math']]

exam.query('math >= 50')[['id','math']].head(10) #head를 통해 일부만 추출하여 미리보기
 
◆ 실습 3: 가독성 있게 코드 줄 바꾸기 
# 주피터, 코랩에서만 사용 가능한 듯? 
exam.query('math >= 50')  \
        [['id','math']] \
        .head()

혼자서 해보기 ~ 
Q1. category, cty변수를 추출해 새로운 데이터를 만드시오

cnt = mpg[['category','cty']]
cnt.head()

Q2. category가 suv인 자동차와 compact인 자동차 중 어떤 자동차의 cty 평균이 높은지 출력하시오
suv_m = mpg.query('category == "suv"')['cty'].mean()
compact_m = mpg.query('category == "compact"')['cty'].mean()

if suv_m > compact_m:
    print('suv의 cty 평균이 compact 보다 높습니다')
else:
    print('compact의 cty 평균이 suv 보다 높습니다.') # 채택 

6-4 순서대로 정렬하기
df.sort_values()

◆ 실습 1 : 오름차순 정렬하기 
exam.sort_values('math')

◆ 실습 2 : 내림차순 정렬하기
exam.sort_values('math',ascending = False)

◆ 실습 3 : 여러 정렬 기준 적용하기
exam.sort_values(['nclass','math'],ascending = [True,False]) # nclass 오름차순, math 내림차순 

※ 혼자서 해보기 
Q1. audi에서 생산한 자동차 중에 어떤 모델의 hwy가 높은지 알아보려고 한다 top 5의 결과값을 출력해주세요
mpg.query('manufacturer == "audi"').sort_values('hwy',ascending = False)['model'].head(5)

6-5 파생변수 추가하기
df.assign() # 미리보기 

# total 변수 추가
exam.assign(total = exam['math'] + exam['english'] + exam['science'])

# 여러 파생변수 한 번에 추가하기 
exam = exam.assign(
        total = exam['math'] + exam['english'] + exam['science'],
        mean = (exam['math']+exam['english'] + exam['science'])/3)

exam = exam.drop(columns = ['total','mean'])

◆ 실습 1 : df.assign()에 np.where() 적용하기 -- 몇번 더 보기 
# 조건에 따라 다른 값을 부여한 변수를 추가할 수 있다. 

import numpy as np
exam.assign(test = np.where(exam['science'] >= 60, 'pass','fail'))

◆ 실습 2 : 추가한 변수를 pandas 함수에 바로 활용하기
# total 변수 추가, total 기준 정렬
exam.assign(total = exam['math'] + exam['english'] + exam['science']).sort_values('total')

◆ 실습 3 : lambda 이용해 데이터 프레임 명 줄이기
# 긴 데이터 프레임명 지정 
long_name = pd.read_csv('c:/data/exam_new.csv')

# long_name 직접 입력
long_name.assign(new=long_name['math'] + long_name['english'] + long_name['science'])

# long_name 대신 x 입력
long_name.assign(new = lambda x: x['math']+x['english']+x['science'])

# 앞에서 만든 변수를 활용해 다시 변수 만들기 
exam.assign(total = exam['math'] + exam['english'] + exam['science'],
            mean = lambda x : x['total']/3)

## 파생변수명을 통일하여 가독성 높이기 
exam.assign(total = lambda x : x['math']+x['english']+x['science'],
            mean = lambda x: x['total']/3)

## 주의 : 앞에서 만든 파생 변수를 이용해 다시 파생 변수를 만들 때 lambda를 사용하지 않고 프레임명을 그대로 쓰면 에러가 발생함
exam.assign(total = exam['math'] + exam['english'] + exam['science'],
            mean = exam['total']/3) ## KeyError: 'total'

※ 혼자서 해보기 
new_mpg = mpg.copy() # 복사본 만들기

new_mpg = new_mpg.assign(sum_CtyHwy = new_mpg['cty']+new_mpg['hwy']) # 합산 연비 컬럼 생성
new_mpg = new_mpg.assign(avg_CtyHwy = new_mpg['sum_CtyHwy']/2) # 평균 연비 변수 
new_mpg.sort_values(['avg_CtyHwy'],ascending = False).head(3)['model'] # 평균 연비가 가장 높은 자동차 3종 

## 한꺼번에 출력하기 
mpg.assign(sum_CtyHwy = lambda x: x['cty']+x['hwy'],
           avg_CtyHwy = lambda x: x['sum_CtyHwy']/2).sort_values(['avg_CtyHwy'],ascending=False).head(3)


6-6 집단별로 요약하기 
df.groupby()
df.agg()

◆ 실습 1 : 집단별로 요약하기
# 전체 요약 통계량 구하기 : df.agg()
exam.agg(mean_math = ('math','mean')) ## groupby()에 적용해 집단별 요약값을 구할 때 사용된다
exam['math'].mean()

# 집단별 요약 통계량 구하기 : df.groupby() + agg()
exam.groupby('nclass').agg(mean_math=('math','mean'))

'''
알아두면 좋아요 : 변수를 인덱스로 바꾸지 않기 

groupby()의 기본값은 변수를 인덱스로 바꾸도록 설정되어 있음.
df.groupby()에 as_index=False를 입력하여 변수를 인덱스로 바꾸지 않고 원래대로 유지할 수 있음

exam.groupby('nclass',as_index=False).agg(mean_math = ('math','mean'))
'''

# 여러 요약 통계량 한꺼번에 구하기 
exam.groupby('nclass').agg(mean_math = ('math','mean'),
                           sum_math = ('math','sum'),
                           median_math = ('math','median'),
                           n = ('nclass','count')) # 학생 수 

'''
알아두면 좋아요 : 모든 변수의 요약 통계량 한 번에 구하기 
agg() 대신 mean()이나 sum()과 같은 요약 통계량 함수를 적용하면 모든 변수의 요약 통계량을 구할 수 있다. 

exam.groupby('nclass').mean()
'''

◆ 실습 1 : 집단별로 다시 집단 나누기 
-- 집단을 나눈 다음 다시 하위 집단으로 나눌 수 있음. 

# 제조 회사 및 구동 방식별 그룹화 
mpg.groupby(['manufacturer','drv']).agg(mean_cty = ('cty','mean'))

# audi의 drv별 빈도
mpg.query('manufacturer == "audi"').groupby(['drv']).agg(n=('drv','count'))
# chevrolet의 drv별 빈도 
mpg.query('manufacturer == "chevrolet"').groupby(['drv']).agg(n=('drv','count'))


● 알아두면 좋아요 : values_counts()로 집단별 빈도 간단하게 구하기 
mpg['drv'].value_counts()

장점 
- 짧은 코드로 빈도를 구할 수 있음
- 빈도 기준으로 내림차순 정렬

단점 
- 출력 결과가 DataFrame이 아닌 Series 자료구조로, query() 함수를 적용할 수 없음 

mpg['drv'].value_counts().qeury('n>100') #AttributeError 

mpg['drv'].value_counts() \ # drv 빈도 구하기
    .to_frame('n') \ # 데이터 프레임으로 바꾸기, 변수명 n으로 바꾸기
        .rename_axis('drv') \ # axis 이름에 drv 지정 
            .query('n>100') # n이 100을 초과한 경우 추출 
            
◆ 실습 2 : pandas 함수 조합하기
Q. 제조 회사별로 'suv' 자동차의 도시 및 고속도로 합산 연비 평균을 구해 내림차순 정렬하고, 1~5위까지 출력하기 
mpg.query('category == "suv"').assign(total=(mpg['hwy']+mpg['cty'])/2).groupby('manufacturer').agg(mean_tot = ('total','mean')).sort_values('mean_tot',ascending=False).head()


※ 혼자서 해보기 
Q1. 
mpg.groupby('category').agg(avg_cty = ('cty','mean'))

Q2. 
mpg.groupby('category').agg(avg_cty = ('cty','mean')).sort_values('avg_cty',ascending=False)

Q3. 
mpg.groupby('manufacturer').agg(avg_hwy = ('hwy','mean')).sort_values('avg_hwy',ascending=False).head(3)
# honda, volswagen, hyundai 

Q4. 
mpg.query('category == "compact"').groupby('manufacturer').agg(n=('manufacturer','count')).sort_values('n',ascending = False)
mpg.query('category == "compact"').value_counts('manufacturer')


6-7 데이터 합치기 

◆실습 1 : 가로로 합치기 
- pd.merge()

# 중간고사 데이터
test1 = pd.DataFrame({'id' : [1,2,3,4,5],
                      'midtern' : [60,80,70,90,85]})
# 기말고사 데이터 
test2 = pd.DataFrame({'id' : [1,2,3,4,5],
                      'final' : [70,83,65,95,80]})

total = pd.merge(test1, test2, how = 'left', on = 'id') # 되게 SQL같다 
total

## 다른 데이터 활용해 변수 추가하기 
name = pd.DataFrame({'nclass' : [1,2,3,4,5],
                     'teacher' : ['kim','lee','park','choi','jung']})

## nclass 기준으로 합쳐서 exam_new에 할당
exam_new = pd.merge(exam,name,how='left',on='nclass')
exam_new

◆ 실습 2 : 세로로 합치기 pd.concat()
주의
- 합치려는 두 데이터의 변수명이 같아야 한다
- 만약 변수명이 다르다면 pd.rename을 통해 똑같이 맞춰줘야 한다. 


# 학생 1-5번 시험 데이터 만들기
group_a = pd.DataFrame({'id':[1,2,3,4,5],
                        'test':[60,80,70,90,85]})

# 학생 6-10번 시험 데이터 만들기 
group_b = pd.DataFrame({'id':[6,7,8,9,10],
                        'test':[70,83,65,95,80]})

# 데이터 합쳐서 gorup_all에 할당
group_all = pd.concat([group_a,group_b],ignore_index=True) # ignore_index를 하지 않으면 기존 index가 중첩이 됨 
group_all.reset_index(drop=True) # 기존 인덱스 삭제 

※ 혼자서 해보기 
fuel = pd.DataFrame({'fl':['c','d','e','p','r'],
                     'price_fl':[2.35,2.38,2.11,2.76,2.22]})

Q1.앞에서 만든 fuel 데이터를 이용해서 mpg 데이터에 price_fl(연료가격) 변수를 추가하세요
mpg=pd.merge(mpg,fuel,how='left',on='fl')

Q2.
mpg[['model','fl','price_fl']].head(5) 

-----------------------------------------------------------------------------
분석 도전

문제 1. popadults는 해당 지역 성인 인구, poptotal은 전체 인구를 나타냅니다.
       midwest 데이터에 '전체 인구 대비 미성년 인구 백분율' 변수를 추가하세요.

# 데이터 불러오기
midwest = pd.read_csv("c:/data/do_it_python/midwest.csv")

# 데이터 훑어보기
pd.set_option('display.max_columns',None)
midwest.head()

midwest = midwest.assign(popteens_per = 100*((midwest['poptotal']-midwest['popadults'])/midwest['poptotal']))

문제 2. 미성년 인구 백분율이 가장 높은 상위 5개 country의 미성년 인구 백분율을 출력하세요 
midwest.sort_values('popteens_per',ascending=False).head(5)['popteens_per']

문제 3. 분류표의 기준에 따라 미성년 비율 등급 변수를 추가하고, 각 등급에 몇 개의 지역이 있는지 알아보세요.
# grade 변수 추가하기 
import numpy as np
midwest['grade'] = np.where(midwest['popteens_per'] >= 40, 'large',
                    np.where(midwest['popteens_per'] >= 30, 'middle','small'))

# solution 1 : using groupby 
midwest.groupby('grade').agg(n = ('grade','count'))

# solution 2 : using value_counts 
midwest['grade'].value_counts()

문제 4. popasian은 해당 지역의 아시아인 인구를 나타냅니다. '전체 인구 대비 아시아인 인구 백분율' 변수를 추가하고,
        하위 10개 지역의 state, county 아시아인 인구 백분율을 출력하세요 
        
midwest.assign(asian_ratio = (100*(midwest['popasian']/midwest['poptotal']))).sort_values('asian_ratio').head(10)[['state','county','asian_ratio']]
```
