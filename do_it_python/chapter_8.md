
### 8장 그래프 만들기 
#### 8-1. 파이썬으로 만들 수 있는 그래프 살펴보기
```
seaborn을 활용해서 전반적인 수업 진행 
```

### 8-2. 산점도 - 변수 간 관계 표현하기
```python
산점도 특징 
- 나이 혹은 소득처럼 연속값으로 된 두 변수의 관계를 표현할 때 사용된다.

◆ 실습 1 : 산점도 만들기 
import pandas as pd 
mpg = pd.read_csv("c:/data/do_it_python/mpg.csv")

# x 축은 displ, y축은 hwy를 타나낸 산점도 만들기
import seaborn as sns
sns.scatterplot(data=mpg,x='displ',y='hwy')

축 범위 설정하기 
- 데이터 전체가 아닌, 일부만 표현하고 싶을 때 사용 
- sns.set()의 xlim과 ylim을 통해 설정 

# x축 범위 3-6으로 제한
sns.scatterplot(data=mpg,x='displ',y='hwy').set(xlim=(3,6))

# x축 범위 3-6, y축 범위 10-30으로 제한
sns.scatterplot(data=mpg,x='displ',y='hwy').set(xlim=(3,6),ylim=(10,30))

종류별로 표식 색깔 바꾸기 
- 표식(marker)의 색을 종류별로 다르게 표현 가능
- hue 사용. 

# drv별로 표식 색깔 다르게 표현
sns.scatterplot(data=mpg,x='displ',y='hwy',hue='drv')

※ 알아두면 좋아요 : 그래프 활용하기
# 그래프 설정 바꾸기 

import matplotlib.pyplot as plt
plt.rcParams.update({'figure.dpi' : '150'}) #해상도, 기본값 72 
plt.rcParams.update({'figure.figsize' : [8,6]}) # 가로, 세로 크기, 기본값 [6,4]
plt.rcParams.update({'font.size' : 15}) #글자 크기, 기본값 10
plt.rcParams.update({'font.family' : 'Malgun Gothic'}) # 폰트, 기본값 sans-serif 
                                                      # 글자가 깨질 경우, 한글 폰트로 변경하면 된다. 

# 여러 요소를 한 번에 설정하기 
plt.rcParams.update({'figure.dip' : '150',
                     'figure.figsize' : [8,6],
                     'font.size' : '15',
                     'font.family' : 'Malgun Gothic'})

# 모든 설정 되돌리기 
plt.rcParams.update(plt.rcParamsDefault) 

# 설명 메시지 숨기기 
sns.scatterplot(data=mpg,x='displ',y='hwy');

※ 혼자서 해보기 
Q1. mpg 데이터의 cty와 hwy간에 어떤 관계가 있는가? 
= cty가 높아질수록 hwy도 함께 높아진다 (正相关)
sns.scatterplot(data=mpg,x='cty',y='hwy',hue='cty')

Q2. midwest.csv를 이용해 전체 인구와 아시아인 인구 간에 어떤 관계가 있는가? 
    x축은 poptotal, y축은 popasian으로 된 산점도를 만드세요.
    전체 인구는 50만명 이하, 아시아인 인구는 1만 명 이하인 지역에만 산점도에 표시되게 설정하세요.
midwest = pd.read_csv("c:/data/do_it_python/midwest.csv")

sns.scatterplot(data=midwest,x='poptotal',y='popasian').set(xlim=(0,500000),ylim=(0,10000))

```
#### 8-3. 막대 그래프 - 집단 간 차이 표현하기
```python
- 성별에 따른 소득 차이처럼 집단 간 차이를 표현하는데 사용 
- 여러 집단의 평균값을 비교할 때 

df_mpg = mpg.groupby('drv').agg(mean_hwy = ('hwy','mean'))
df_mpg # drv가 index 위치에 있음. seaborn으로 그래프를 만드려면 변수에 담겨있어야 한다.

df_mpg = mpg.groupby('drv',as_index=False).agg(mean_hwy = ('hwy','mean'))
df_mpg

2. 그래프 만들기 
sns.barplot(data=df_mpg, x='drv',y='mean_hwy')

3. 크기 순으로 정렬하기 
- df의 행 순서에 따라 그래프의 순서 또한 정해지기 때문에, 사전 정렬 작업을 진행해야 한다. 

# 데이터 프레임 정렬하기
df_mpg = df_mpg.sort_values('mean_hwy',ascending=False)

# 막대 그래프 만들기
sns.barplot(data=df_mpg,x='drv',y='mean_hwy')

◆ 실습 2 : 빈도 막대 그래프 만들기 --sns.countplot()
1. 집단별 빈도표 만들기
df_mpg = mpg.groupby('drv',as_index=False).agg(n=('drv','count'))

# sort작업 진행하기 
df_mpg = df_mpg.sort_values('n')

2. 그래프 만들기 
# 막대 그래프 만들기 
sns.barplot(data=df_mpg,x='drv',y='n') 

# sns.countplot() 사용해서 만들기 
sns.countplot(data=mpg,x='drv')

'''
df_mpg와 countplot()한 drv의 순서가 다르다?!
=> groupby()를 하게되면 데이터 프레임을 요약하면서 순서가 알파벳으로 변한다. 그래서 발생하는 차이. 
=> countplot은 기존의 데이터 프레임에 입력된 행 순서에 따라서 f,4,r값을 뽑아냄.  
'''

3. 막대 정렬하기 -- order 이용
# 4, f, r 순으로 막대를 정렬하기
sns.countplot(data=mpg,x='drv',order=['4','f','r']) 

# drv의 값을 빈도가 높은 순으로 출력
mpg['drv'].value_counts().index

# drv 빈도 높은 순으로 막대 정렬 
sns.countplot(data = mpg, x = 'drv', order = mpg['drv'].value_counts().index)

※ 혼자서 해보기 
Q1. 어떤 회사에서 생산한 'suv' 차종의 도시 연비가 높은지 알아보려고 합니다.
    'suv' 차종을 대상으로 'cty' 평균이 가장 높은 회사 다섯 곳을 막대 그래프로 표현해 보세요.
    막대는 연비가 높은 순으로 정렬하세요. 

# 데이터 구조 파악하기 
mpg.info()

# mpg_suv 변수를 새로 만들어 필요한 값만 출력해오기 
mpg_suv = mpg.query('category == "suv"').groupby('manufacturer',as_index=False).agg(mean_cty = ('cty','mean')).sort_values('mean_cty',ascending=False).head(5)

# 그래프 출력하기 
sns.barplot(data=mpg_suv,x='manufacturer',y='mean_cty')


Q2. 자동차 중에 어떤 category가 많은지 알아보려고 합니다. 
    자동차 종류별 빈도를 표현한 막대 그래프를 그려보세요.
# suv가 제일 많았고, 그 다음이 compact였다. 
sns.countplot(data = mpg, x = 'category', order = mpg['category'].value_counts().index)

```
