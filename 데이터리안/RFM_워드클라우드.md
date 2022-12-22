```
해당 코드는 RFM 프로젝트를 진행하며 워드 클라우드를 만들기 위해 짠 코드입니다. 
```

### wordcloud 만들기 
```python
# -*- coding: utf-8 -*-
"""
Created on Tue Oct 25 15:30:25 2022

@author: 82108
"""

# 필요한 라이브러리 

import pandas as pd 
import numpy as np 

from konlpy.tag import Okt 
from ckonlpy.tag import Twitter
import nltk
from hanspell import spell_checker


from collections import Counter
from wordcloud import WordCloud

import matplotlib.pyplot as plt 
from matplotlib import rc, font_manager
font_name = font_manager.FontProperties(fname="c:/windows/fonts/malgun.ttf").get_name()
rc('font',family=font_name)

import seaborn as sns 
from PIL import Image, ImageDraw, ImageFont

from sklearn.feature_extraction.text import CountVectorizer 

## 데이터 불러오기 
df = pd.read_csv("c:/data/데이터리안_리뷰_최종.csv")

## 맞춤법 검사 
'''
띄어쓰기와 맞춤법이 올바르지 않으면 형태소 분석 시 어려움이 많을 수 있다.
이를 위해 네이버 맞춤법 검사기 기반으로 개발 된 hanspell을 통해 맞춤법 전처리를 진행하였다. 
'''

before = pd.DataFrame(df) # 테스트에서 사용 될 데이터 
before.info()

spelled_sent = [] # 맞춤법 검사
checked_sent = [] # 검사 된 텍스트만 꺼내오기 

for i in before['텍스트']:
    spelled_sent.append(spell_checker.check(i)) 

for i in spelled_sent:
    checked_sent.append(i.checked)

after = pd.DataFrame(checked_sent,columns = ['텍스트'])
after.info()

# 데이터리안이 데이터 라이언으로 변경되어 추가적인 전처리를 진행함. 
after['텍스트'] = after['텍스트'].str.replace('데이터 라이안','데이터리안',regex=True) 
after['텍스트'] = after['텍스트'].str.replace('데이터 분석가','데이터분석가',regex=True)
after['텍스트'] = after['텍스트'].str.replace('데이터 분석','데이터분석',regex=True) 
after['텍스트'] = after['텍스트'].str.replace('매출 분석','매출분석',regex=True) 
after['텍스트'] = after['텍스트'].str.replace('RFM 분석','RFM분석',regex=True) 

# 중간 저장하기
after.to_csv("c:/data/데이터리안_리뷰_최종.csv",index=False)

# 사용자 사전 업데이트 하기 
twitter = Twitter()
twitter.add_dictionary(['매출분석','PM','기획자','DA',"문제 풀이","질의응답","질의 응답","RFM","RFM분석","ARPPU","문제풀이"], 'Noun')

# 형태소 분석 전 불용어 사전 불러오기 
korean_stopwords_path = "c:/data/korean_stop_words.txt"

# 텍스트 파일을 오픈합니다.
with open(korean_stopwords_path, encoding='utf-8') as f:
	stopwords = f.readlines()
stopwords = [x.strip() for x in stopwords]

# 추가 불용어 사전 

stop_word = ["수","것","반","부분","점","시간","정도","때","볼","알","문","이제","대해","업","줄","이","게","통해","동안","더","보고","진","이"]
stop_w = ['것',"어서","위","과","고","및","을","의","를","에","으로","볼","수","늘","반","기","수","어서","저","점","업","내","것","건","못","더","걸","이","뭘","중","건","알",
              "면","안","그","거","즐","게","까지","어요","때","덕","셔","뿐","반","기","성","달","어서","해주","적","고","면서","늘","기","해주시","보", "돈","때문","주","려고"]
stop_word2 = ["대한","달이","분석","실습","데이터","쿼리","입문","문법","방법","수업","강의","문제","아주","배우","아예","느낌","막막","가장","중간","관련","감사","데이터분석",
              "풀","었다","여주","어도","직","전","아무","비문","라가","화","끝","어가","번","뭐","데","앞",'데이터리안','데이터분석가','실','정말','신','부탁','드립','실','님들','데이터분석가']

stop_words = stop_word + stop_w + stop_word2


# twitter 형태소 분석기를 이용해서 명사와 형용사를 기반으로 워드 클라우드를 그리기 위해 명사와 형용사 추출 
sentens_tag = []

def sentence_pos(arg):
    for i in twitter.pos(arg):
        if i[1] in ['Noun']:
            sentens_tag.append(i[0])
    return set(sentens_tag)

x = after['텍스트'].to_list()
txt = ','.join(x)
sentence_pos(txt)

sentens_tag

# 불용어에서 제거 
new_result = []

for i in sentens_tag:
    if i not in stopwords:
        new_result.append(i)

final_result = []
for i in new_result:
    if i not in stop_words:
        final_result.append(i)

final_result       

len(final_result)
len(set(final_result))

# 중간 저장하기 
common_list = Counter(final_result).most_common(30)

x = pd.DataFrame(common_list, columns=['단어','빈도수'])
x.to_csv("c:/data/common_list.csv",encoding='utf-8')


# 워드 클라우드 
## list를 딕셔너리 변환 
data_f = dict(zip(x['단어'].tolist(),x['빈도수'].tolist()))

w = WordCloud(font_path = "c:/Windows/Fonts/malgun.ttf",
              background_color='white',
              width = 900, height=700, 
              max_words = 200).generate(data_f)
plt.imshow(w)
plt.axis("off") # 전처리를 안해서 모습이 난리 남 ㅠ  

type(data_f)

data_f


x.Series.astype(str)


type(common_list)

common_list = str(common_list)

----- 낙서
txt = ' '.join(df['맞춤법'])
sentence_pos(txt)

# 불용어에서 제거 
new_result = []

for i in sentens_tag:
    if i not in stopwords:
        new_result.append(i)

final_result = []
for i in new_result:
    if i not in stop_words:
        final_result.append(i)

final_result       

len(final_result)
len(set(final_result))


# 중간 저장하기 

common_list = Counter(final_result).most_common(50)
pp = pd.DataFrame(common_list, columns = ['word','cnt'])

data = dict(zip(pp['word'].tolist(),pp['cnt'].tolist()))

from wordcloud import WordCloud, STOPWORDS, ImageColorGenerator
import matplotlib.pyplot as plt
from collections import Counter
from PIL import Image
from PIL import ImageDraw
from PIL import ImageFont


icon = Image.open('c:/data/circle.png')
plt.imshow(icon) #
mask = np.array(icon)

wc = WordCloud(font_path="C:/USERS/82108/APPDATA/LOCAL/MICROSOFT/WINDOWS/FONTS/KOPUB돋움체M.TTF", #폰트
               background_color='white',                              #배경색
               width=800, height=700,                                #사이즈설정
               prefer_horizontal = 1,
               colormap = 'YlOrBr' ,
               max_words=200,
               mask = mask)                                         #단어갯수
cloud = wc.generate_from_frequencies(data)                            #사전형태 데이터
plt.figure(figsize=(10,10))                                           #액자사이즈설정
plt.axis('off')                                                       #테두리 선 없애기
plt.imshow(cloud,interpolation="bilinear")
```

    
