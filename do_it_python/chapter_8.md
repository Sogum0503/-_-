
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

#### 8-4. 선 그래프 - 시간에 따라 달라지는 데이터 표현하기
```python
특징 
- 시간에 따라 달라지는 데이터를 표현할 때 
- 환율, 주가지수 등 경제지표에서 주로 사용

◆ 실습 1 : 시계열 그래프 만들기
# economics 불러오기
economics = pd.read_csv("c:/data/do_it_python/economics.csv")
economics.info()
economics.head() 

sns.lineplot(data = economics,x = 'date', y = 'unemploy')

* x축에 연도 표시하기 
# 현재 economics 데이터의 date가 문자 타입으로 되어있음. 이걸 datetime64로 변경해야 한다.

1) 날짜 시간 타입 변수 만들기
# 날짜 시간 타입 변수 만들기 
economics['date2'] = pd.to_datetime(economics['date']) 

# 변수 타입 확인
economics.info()

# 날짜 시간 타입으로 변경해도 값은 변하지 않는다.
economics[['date','date2']]

# 날짜 시간 타입으로 되어있으면, df.dt를 활용해 연,월,일 출력이 가능하다.
economics['date2'].dt.year
economics['date2'].dt.month
economics['date2'].dt.day

2) 연도 변수 만들기 
# 연도 변수 추가
economics['year'] = economics['date2'].dt.year
economics.head()

3) x축에 연도 표시하기
# x축에 연도 표시
sns.lineplot(data = economics, x = 'year', y = 'unemploy')

sns.lineplot(data = economics, x = 'year', y = 'unemploy', ci = None) # 신뢰구간 표시하지 않기 

4) 해석
실업자 수는 약 5년 주기로 등락을 반복하고, 2005년부터 급격하게 증가했다가 2010년부터 다시 감소하는 추세를 보인다.

※ 혼자서 해보기 
Q1. psavert(개인 저축률)가 시간에 따라 어떻게 변하는가?
    연도별 개인 저축률의 변화를 나타낸 시계열 그래프를 만들어보자

# 시간의 흐름에 따라 개인 저축률이 하락하고 있다. 실업률이 급격하게 증가한 2005년에 개인 저축률 또한 최저점을 찍었고, 그 이후에 다시 성장하는 추세를 보인다.
sns.lineplot(data = economics, x = 'year', y = 'psavert',ci = None)

## 상관관계 알아보기 
'''
상관관계를 구해보자 생각했던 이유는, 시간의 흐름에 따라서 psavert도 증가하고 unemploye도 증가해서였다.
뭔가 결과가 좀 씁쓸하다... 회귀를 돌리지 않아서 무조건적으로 year->x라는 결론을 내리지는 못하지만, 
일반적으로 생각했을 때 시간이 점점 흐를수록 개인 경제에서 긍정적인 측면은 负相关  부정적인 측면은 正相关한 관계가 되고있다. 
'''
corrdata = economics.corr(method = 'pearson').round(2)
sns.heatmap(data=corrdata , annot = True, annot_kws = {'size':9})

Q2. 2014년 월별 psavert의 변화를 나타낸 시계열 그래프를 만들어 보세요. 
# 월 변수 추가 
economics['month'] = economics['date2'].dt.month

# 2014년 추출 
month_14 = economics.query('year == 2014')

# 선 그래프 생성하기
sns.lineplot(data = month_14, x = 'month', y = 'psavert',ci=None)
```

#### 8-5. 상자 그림 - 집단 간 분포 차이 표현하기 
```python
특징
- 데이터의 분포 또는 퍼져 있는 형태를 표현 
- 데이터가 어떻게 분포하고 있는지 알 수 있다. (평균값 보다 더 많은 정보를 시각적으로 얻을 수 있습니다)

◆ 실습 1 : 상자 그림 만들기 
# 구동 방식별 고속도로 연비 
sns.boxplot(data = mpg, x = 'drv', y = 'hwy')

※ 혼자서 해보기 
Q1. categoryk compact subcompact suv인 자동차의 cty가 어떻게 다른지 알아보자.
    세 차종의 cty를 나타낸 상자 그림을 만들어보세요.

x = mpg.query('category in ("compact","subcompact","suv")')
sns.boxplot(data = x, x = 'category' , y = 'cty')

```
