### 7장 데이터 정제하기 

#### 7-1. 빠진 데이터를 찾아라! -- 결측치 정제하기 
```python
◆ 실습 1 : 결측치 찾기 

# 결측치 만들기 
import pandas as pd
import numpy as np 

df = pd.DataFrame({'sex' : ['M','F',np.nan,'M','F'],
                   'score' : [5,4,3,4,np.nan]})

df['score'] + 1  # Nan이 있는 상태로 연산하면 출력도 NaN이 뜬다. 

# 결측치 확인하기 -- pd.isna()
pd.isna(df)
pd.isna(df).sum() # 결측치 빈도 확인 

◆ 결측치 제거하기
# 결측치 있는 행 제거하기 -- df.dropna()

df.dropna(subset=['score']) # score 결측치 제거하기 

df_nomiss = df.dropna(subset = ['score'])
df_nomiss['score']+1

# 여러 변수에 결측치 없는 데이터 추출하기 
df_nomiss = df.dropna(subset = ['score','sex']) # score과 sex내 결측치가 있는 행 제거 
df_nomiss

# 결측치가 하나라도 있으면 제거하기 
## 해당 방법은 결측치가 하나라도 있으면 모두 제거하기 때문에, 정보 손실이 클 수 밖에 없음. 
## 그래서 분석에 사용할 변수를 직접 지정해 결측치를 제거하는 방법을 추천함 
df_nomiss2 = df.dropna() # 모든 변수에 결측치 없는 데이터 출력 
df_nomiss2

※ 알아두면 좋아요 : 결측치 제거하지 않고 분석하기 
- pd.mean(), pd.sum()은 결측치가 있으면 자동으로 제거하고 연산한다
- groupby(), agg()를 이용해 집단별 요약 통계량을 구할 때도 결측치를 제거하고 연산한다.
- 자동으로 결측치를 제거하는 기능은 편리하지만, 결측치가 있는지 모른 채로 데이터를 다루게 되는 위험성이 있다
  - 특징을 잘 이해하고 분석하기 위해 결측치가 있는지 직접 확인하고 df.dropna()를 이용해서 명시적으로 제거하는 방법을 권함. 
  
df['score'].mean()
df['score'].sum()

df.groupby('sex').agg(mean_score = ('score','mean'),
                      sum_score = ('score','sum'))

◆ 실습 2 : 결측치 대체하기 

1. 평균값으로 결측치 대체하기 

exam = pd.read_csv("c:/data/do_it_python/exam_new.csv")
exam.loc[[2,7,14],['math']] = np.nan # 2,7,14 행의 math에 NaN 할당 
pd.isna(exam).sum()

exam['math'].mean() #55.24 

exam['math'] = exam['math'].fillna(exam['math'].mean()) # mean값으로 nan값 대채
pd.isna(exam).sum() # nan값 확인 
exam['math']

※ 혼자 해보기 
# 데이터 불러오기
mpg = pd.read_csv("c:/data/do_it_python/mpg.csv")

# NaN값 할당하기
mpg.loc[[64,123,130,152,211],"hwy"] = np.nan

Q1. drv(구동 방식)별로 hwy(고속도로 연비) 평균이 어떻게 다른지 알아보려고 합니다.
    분석을 하기 전에 우선 두 변수에 결측치가 있는지 확인해야 합니다.
    drv 변수와 hwy 변수에 결측치가 몇 개 있는지 알아보세요.
    
pd.isna(mpg[['drv','hwy']]).sum() # drv는 없고, hwy는 5개 

Q2. df.dropna()를 이용해 hwy 변수의 결측치를 제거하고, 어떤 구동 방식의 hwy 평균이 높은지 알아보세요.
    하나의 pandas 구문으로 만들어야 합니다.
    
mpg.dropna(subset = ['hwy']).groupby('drv').agg(mean_hwy = ('hwy','mean'))
```

#### 7-2. 이상한 데이터를 찾아라! -- 이상치 제거하기
```python
◆ 실습 1 : 이상치 제거하기 - 존재할 수 없는 값 
# sex는 1(남자) 2(여자) . score은 1~5의 값만 가져야 하는 상황. 

df = pd.DataFrame({'sex':[1,2,1,3,2,1],
                   'score':[5,4,3,4,2,6]})

# 이상치 확인하기 -- df.value_counts()
## sort_index()를 적용하면 빈도 기준으로 내림차순 정렬하지 않고, 변수의 값 순서(=인덱스)로 정렬합니다. 
df['sex'].value_counts().sort_index()
df['score'].value_counts().sort_index()

# 결측 처리하기  -- np.where()
## sex가 3이면 NaN값 부여 
df['sex'] = np.where(df['sex'] == 3, np.nan, df['sex'])
df

## score가 5보다 크면 NaN 부여
df['score'] = np.where(df['score']>5, np.nan, df['score']) 
df

# 결측치를 제거해서 분석 -- 평균값 구하기
df.dropna(subset = ['sex','score']).groupby('sex').agg(mean_score=('score','mean'))

※ 알아두면 좋아요 : np.where()은 문자와 NaN을 함께 반환할 수 없습니다. 
df = pd.DataFrame({'x1':[1,1,2,2]})
df['x2'] = np.where(df['x1'] == 1, 'a', np.nan)

df
df.isna().sum() # NaN값이 없다고 나온다. 

다음 절차를 따르면 변수의 문자와 NaN으로 함께 구성할 수 있음.
1. np.where()을 이용해 결측치로 만들 값에 문자를 부여 
# 결측치로 만들 값에 문자 부여 
df['x2'] = np.where(df['x1']==1,'a','etc')

2. df.replace()를 이용해 결측치로 만들 문자를 np.nan으로 바꾼다.
# etc를 NaN로 변경 
df['x2'] = df['x2'].replace('etc',np.nan)
df.isna().sum() # NaN값 2개 생성 

◆ 실습 2 : 잇아치 제거하기 - 극단적인 값 

방법 1. 상자 그림으로 극단치 기준 정하기 
: 중심에서 크게 벗어난 값을 극단치로 간주하기 

step 1. 상자 그림 살펴보기 
import seaborn as sns
sns.boxplot(data=mpg,y='hwy')

step 2. 극단치 기준값 구하기 
# 1사분위수, 3사분위수 구하기  -- df.quantile()
pct25 = mpg['hwy'].quantile(.25)
pct25

pct75 = mpg['hwy'].quantile(.75)
pct75# 27

# IQR(inter quantile range) 구하기 
iqr = pct75-pct25
iqr # 9

# 하한, 상한 구하기 
- 하한 : 1사분위수보다 IQR의 1.5배만큼 더 작은 값
- 상한 : 3사분위수보다 IQR의 1.5배만큼 더 큰 값 

pct25-1.5*iqr # 하한, 4.5 
pct75+1.5*iqr # 상한 40.5 

step 3. 극단치를 결측 처리하기 
# 4.5~40.5에서 벗어나면 NaN.부여
mpg['hwy'] = np.where((mpg['hwy'] < 4.5) | (mpg['hwy'] > 40.5), np.nan, mpg['hwy'])

# 결측치 빈도 확인
mpg['hwy'].isna().sum() # 3개 

step 4. 결측치 제거하고 분석하기
mpg.dropna(subset=['hwy']).groupby('drv').agg(mean_hwy=('hwy','mean'))

```

#### 혼자서 해보기 
```python
'''
이상치가 들어 있는 npg 데이터를 활용해 분석 문제를 해결해보세요. 

drv (구동 방식)
- 4(사륜구동)
- f(전륜구동)
- r(후륜구동)

몇 개의 행에 존재할 수 없는 값 k를 할당
cty(도시 연비) 변수에 극단적으로 크거나 작은 값을 할당 
'''

# 사전 준비
mpg.loc[[9,13,57,92],'drv'] = 'k' #drv 이상치 할당 
mpg.loc[[28,42,128,202],'cty'] = [3,4,39,42] # cty 이상치 할당 

Q1. drv에 이상치가 있는지 확인하세요. 이상치를 결측 처리한 다음 이상치가 사라져있는지 확인하세요
    결측 처리를 할 때는 df.isna()를 활용하세요 

# value_counts()를 활용해서 레벨 확인 
mpg['drv'].value_counts().sort_index() # 이상치 'k'값 확인 

# np.where()을 활용해서 결측 처리 
mpg['drv'] = np.where(mpg['drv']=='k',np.nan,mpg['drv']) # 'k'값이면 NaN값 처리하기 
mpg['drv'].value_counts().sort_index() # 이상치 더블 체크 

# nan값 확인하기 
mpg.isna().sum() # drv에 4개의 결측치 확인됨 

Q2. 상자 그림을 이용해 cty에 이상치가 있는지 확인하세요. 
    상자 그림 기준으로 정상 범위를 벗어난 값을 결측 처리한 다음 다시 상자 그림을 만들어 이상치가 사라졌는지 확인하세요 

import seaborn as sns 
sns.boxplot(data=mpg,y='cty') # 총 8개 정도의 극단값 확인됨 

# 1분위,3분위 값 구하기 
cty25 = mpg['cty'].quantile(.25)
cty75 = mpg['cty'].quantile(.75)

# iqr값 구하기 
cty_iqr = cty75-cty25

# 상한 하한값 구하기 
cty25 - 1.5 * cty_iqr # 6.5
cty75 + 1.5 * cty_iqr # 26.5 

# 극단값 결측 처리 
mpg['cty'] = np.where((mpg['cty']<6.5) | (mpg['cty']>26.5), np.nan, mpg['cty'])

# 다시 박스플롯 확인하기
sns.boxplot(data=mpg,y='cty') # 없음 

Q3. 이상치를 제거한 다음 drv별로 cty 평균이 어떻게 다릅니까? pandas 구문으로 만드세요. 
mpg.dropna(subset=['drv','cty']).groupby('drv').agg(mean_cty = ('cty','mean')) # f > 4 > r 순으로 mean_cty가 높았다.
```

