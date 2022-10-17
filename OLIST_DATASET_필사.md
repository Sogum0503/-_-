### 데이터 셋

* 데이터 출처 : kaggle의 olist sellers dataset을 사용했습니다 
  * url : https://www.kaggle.com/olistbr/brazilian-ecommerce?select=olist_sellers_dataset.csv

### 분석 목표 
* 현재 상황을 파악하여 매출 개선 계획 


```python
import numpy as np
import pandas as pd 
import seaborn as sns
import matplotlib.pyplot as plt 
```

EDA 진행 


```python
# order 데이터 불러오기 

order_items = pd.read_csv('c:/data/olist/olist_order_items_dataset.csv')
order_items.info()
order_items.head() ##  간단하게 데이터 파악 
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 112650 entries, 0 to 112649
    Data columns (total 7 columns):
     #   Column               Non-Null Count   Dtype  
    ---  ------               --------------   -----  
     0   order_id             112650 non-null  object 
     1   order_item_id        112650 non-null  int64  
     2   product_id           112650 non-null  object 
     3   seller_id            112650 non-null  object 
     4   shipping_limit_date  112650 non-null  object 
     5   price                112650 non-null  float64
     6   freight_value        112650 non-null  float64
    dtypes: float64(2), int64(1), object(4)
    memory usage: 6.0+ MB
    




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>order_id</th>
      <th>order_item_id</th>
      <th>product_id</th>
      <th>seller_id</th>
      <th>shipping_limit_date</th>
      <th>price</th>
      <th>freight_value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>00010242fe8c5a6d1ba2dd792cb16214</td>
      <td>1</td>
      <td>4244733e06e7ecb4970a6e2683c13e61</td>
      <td>48436dade18ac8b2bce089ec2a041202</td>
      <td>2017-09-19 09:45:35</td>
      <td>58.90</td>
      <td>13.29</td>
    </tr>
    <tr>
      <th>1</th>
      <td>00018f77f2f0320c557190d7a144bdd3</td>
      <td>1</td>
      <td>e5f2d52b802189ee658865ca93d83a8f</td>
      <td>dd7ddc04e1b6c2c614352b383efe2d36</td>
      <td>2017-05-03 11:05:13</td>
      <td>239.90</td>
      <td>19.93</td>
    </tr>
    <tr>
      <th>2</th>
      <td>000229ec398224ef6ca0657da4fc703e</td>
      <td>1</td>
      <td>c777355d18b72b67abbeef9df44fd0fd</td>
      <td>5b51032eddd242adc84c38acab88f23d</td>
      <td>2018-01-18 14:48:30</td>
      <td>199.00</td>
      <td>17.87</td>
    </tr>
    <tr>
      <th>3</th>
      <td>00024acbcdf0a6daa1e931b038114c75</td>
      <td>1</td>
      <td>7634da152a4610f1595efa32f14722fc</td>
      <td>9d7a1d34a5052409006425275ba1c2b4</td>
      <td>2018-08-15 10:10:18</td>
      <td>12.99</td>
      <td>12.79</td>
    </tr>
    <tr>
      <th>4</th>
      <td>00042b26cf59d7ce69dfabb4e55b4fd9</td>
      <td>1</td>
      <td>ac6c3623068f30de03045865e4e10089</td>
      <td>df560393f3a51e74553ab94004ba5c87</td>
      <td>2017-02-13 13:57:51</td>
      <td>199.90</td>
      <td>18.14</td>
    </tr>
  </tbody>
</table>
</div>




```python
# products 데이터 불러오기 
products = pd.read_csv('c:/data/olist/olist_products_dataset.csv')
products.info()
products.head()

```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 32951 entries, 0 to 32950
    Data columns (total 9 columns):
     #   Column                      Non-Null Count  Dtype  
    ---  ------                      --------------  -----  
     0   product_id                  32951 non-null  object 
     1   product_category_name       32341 non-null  object 
     2   product_name_lenght         32341 non-null  float64
     3   product_description_lenght  32341 non-null  float64
     4   product_photos_qty          32341 non-null  float64
     5   product_weight_g            32949 non-null  float64
     6   product_length_cm           32949 non-null  float64
     7   product_height_cm           32949 non-null  float64
     8   product_width_cm            32949 non-null  float64
    dtypes: float64(7), object(2)
    memory usage: 2.3+ MB
    




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>product_id</th>
      <th>product_category_name</th>
      <th>product_name_lenght</th>
      <th>product_description_lenght</th>
      <th>product_photos_qty</th>
      <th>product_weight_g</th>
      <th>product_length_cm</th>
      <th>product_height_cm</th>
      <th>product_width_cm</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1e9e8ef04dbcff4541ed26657ea517e5</td>
      <td>perfumaria</td>
      <td>40.0</td>
      <td>287.0</td>
      <td>1.0</td>
      <td>225.0</td>
      <td>16.0</td>
      <td>10.0</td>
      <td>14.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>3aa071139cb16b67ca9e5dea641aaa2f</td>
      <td>artes</td>
      <td>44.0</td>
      <td>276.0</td>
      <td>1.0</td>
      <td>1000.0</td>
      <td>30.0</td>
      <td>18.0</td>
      <td>20.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>96bd76ec8810374ed1b65e291975717f</td>
      <td>esporte_lazer</td>
      <td>46.0</td>
      <td>250.0</td>
      <td>1.0</td>
      <td>154.0</td>
      <td>18.0</td>
      <td>9.0</td>
      <td>15.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>cef67bcfe19066a932b7673e239eb23d</td>
      <td>bebes</td>
      <td>27.0</td>
      <td>261.0</td>
      <td>1.0</td>
      <td>371.0</td>
      <td>26.0</td>
      <td>4.0</td>
      <td>26.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>9dc1a7de274444849c219cff195d0b71</td>
      <td>utilidades_domesticas</td>
      <td>37.0</td>
      <td>402.0</td>
      <td>4.0</td>
      <td>625.0</td>
      <td>20.0</td>
      <td>17.0</td>
      <td>13.0</td>
    </tr>
  </tbody>
</table>
</div>




```python
# category 데이터 불러오기 
category_translation = pd.read_csv("c:/data/olist/product_category_name_translation.csv")
category_translation.info()
category_translation.head()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 71 entries, 0 to 70
    Data columns (total 2 columns):
     #   Column                         Non-Null Count  Dtype 
    ---  ------                         --------------  ----- 
     0   product_category_name          71 non-null     object
     1   product_category_name_english  71 non-null     object
    dtypes: object(2)
    memory usage: 1.2+ KB
    




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>product_category_name</th>
      <th>product_category_name_english</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>beleza_saude</td>
      <td>health_beauty</td>
    </tr>
    <tr>
      <th>1</th>
      <td>informatica_acessorios</td>
      <td>computers_accessories</td>
    </tr>
    <tr>
      <th>2</th>
      <td>automotivo</td>
      <td>auto</td>
    </tr>
    <tr>
      <th>3</th>
      <td>cama_mesa_banho</td>
      <td>bed_bath_table</td>
    </tr>
    <tr>
      <th>4</th>
      <td>moveis_decoracao</td>
      <td>furniture_decor</td>
    </tr>
  </tbody>
</table>
</div>




```python
# order 데이터 불러오기
orders = pd.read_csv('c:/data/olist/olist_orders_dataset.csv')
orders.info()
orders.head()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 99441 entries, 0 to 99440
    Data columns (total 8 columns):
     #   Column                         Non-Null Count  Dtype 
    ---  ------                         --------------  ----- 
     0   order_id                       99441 non-null  object
     1   customer_id                    99441 non-null  object
     2   order_status                   99441 non-null  object
     3   order_purchase_timestamp       99441 non-null  object
     4   order_approved_at              99281 non-null  object
     5   order_delivered_carrier_date   97658 non-null  object
     6   order_delivered_customer_date  96476 non-null  object
     7   order_estimated_delivery_date  99441 non-null  object
    dtypes: object(8)
    memory usage: 6.1+ MB
    




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>order_id</th>
      <th>customer_id</th>
      <th>order_status</th>
      <th>order_purchase_timestamp</th>
      <th>order_approved_at</th>
      <th>order_delivered_carrier_date</th>
      <th>order_delivered_customer_date</th>
      <th>order_estimated_delivery_date</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>e481f51cbdc54678b7cc49136f2d6af7</td>
      <td>9ef432eb6251297304e76186b10a928d</td>
      <td>delivered</td>
      <td>2017-10-02 10:56:33</td>
      <td>2017-10-02 11:07:15</td>
      <td>2017-10-04 19:55:00</td>
      <td>2017-10-10 21:25:13</td>
      <td>2017-10-18 00:00:00</td>
    </tr>
    <tr>
      <th>1</th>
      <td>53cdb2fc8bc7dce0b6741e2150273451</td>
      <td>b0830fb4747a6c6d20dea0b8c802d7ef</td>
      <td>delivered</td>
      <td>2018-07-24 20:41:37</td>
      <td>2018-07-26 03:24:27</td>
      <td>2018-07-26 14:31:00</td>
      <td>2018-08-07 15:27:45</td>
      <td>2018-08-13 00:00:00</td>
    </tr>
    <tr>
      <th>2</th>
      <td>47770eb9100c2d0c44946d9cf07ec65d</td>
      <td>41ce2a54c0b03bf3443c3d931a367089</td>
      <td>delivered</td>
      <td>2018-08-08 08:38:49</td>
      <td>2018-08-08 08:55:23</td>
      <td>2018-08-08 13:50:00</td>
      <td>2018-08-17 18:06:29</td>
      <td>2018-09-04 00:00:00</td>
    </tr>
    <tr>
      <th>3</th>
      <td>949d5b44dbf5de918fe9c16f97b45f8a</td>
      <td>f88197465ea7920adcdbec7375364d82</td>
      <td>delivered</td>
      <td>2017-11-18 19:28:06</td>
      <td>2017-11-18 19:45:59</td>
      <td>2017-11-22 13:39:59</td>
      <td>2017-12-02 00:28:42</td>
      <td>2017-12-15 00:00:00</td>
    </tr>
    <tr>
      <th>4</th>
      <td>ad21c59c0840e6cb83a9ceb5573f8159</td>
      <td>8ab97904e6daea8866dbdbc4fb7aad2c</td>
      <td>delivered</td>
      <td>2018-02-13 21:18:39</td>
      <td>2018-02-13 22:20:29</td>
      <td>2018-02-14 19:46:34</td>
      <td>2018-02-16 18:17:02</td>
      <td>2018-02-26 00:00:00</td>
    </tr>
  </tbody>
</table>
</div>




#### 각 데이터 셋 설명 
* order_items
    * 주문 1건 당 해당 주문 id, 물건 개수, 상품 id, 판매자 id, 배송 기한, 상품 가격, 배송비  
* products
    * 판매 중인 상품들의 카테고리, 이름 및 설명 길이, 제품 사진, 크기 정보 
* category_translation
    * 각 카테고리 이름 '포르투갈어 -> 영어'의 번역본
* orders 
    * 주문 id, 고객 id, 주문 상태 정보와 해당 상태가 된 날짜를 나타냄 

### 데이터 전처리 

#### products 


```python
products.info() # Null값이 없음을 파악 
products.head() # 간략하게 데이터 파악
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 32951 entries, 0 to 32950
    Data columns (total 2 columns):
     #   Column                 Non-Null Count  Dtype 
    ---  ------                 --------------  ----- 
     0   product_id             32951 non-null  object
     1   product_category_name  32341 non-null  object
    dtypes: object(2)
    memory usage: 515.0+ KB
    




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>product_id</th>
      <th>product_category_name</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1e9e8ef04dbcff4541ed26657ea517e5</td>
      <td>perfumaria</td>
    </tr>
    <tr>
      <th>1</th>
      <td>3aa071139cb16b67ca9e5dea641aaa2f</td>
      <td>artes</td>
    </tr>
    <tr>
      <th>2</th>
      <td>96bd76ec8810374ed1b65e291975717f</td>
      <td>esporte_lazer</td>
    </tr>
    <tr>
      <th>3</th>
      <td>cef67bcfe19066a932b7673e239eb23d</td>
      <td>bebes</td>
    </tr>
    <tr>
      <th>4</th>
      <td>9dc1a7de274444849c219cff195d0b71</td>
      <td>utilidades_domesticas</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 필요한 컬럼(product_id, category_name)만 잘라내기

products = products[['product_id','product_category_name']]
products.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>product_id</th>
      <th>product_category_name</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1e9e8ef04dbcff4541ed26657ea517e5</td>
      <td>perfumaria</td>
    </tr>
    <tr>
      <th>1</th>
      <td>3aa071139cb16b67ca9e5dea641aaa2f</td>
      <td>artes</td>
    </tr>
    <tr>
      <th>2</th>
      <td>96bd76ec8810374ed1b65e291975717f</td>
      <td>esporte_lazer</td>
    </tr>
    <tr>
      <th>3</th>
      <td>cef67bcfe19066a932b7673e239eb23d</td>
      <td>bebes</td>
    </tr>
    <tr>
      <th>4</th>
      <td>9dc1a7de274444849c219cff195d0b71</td>
      <td>utilidades_domesticas</td>
    </tr>
  </tbody>
</table>
</div>




```python
# Null값 확인하기 
products.isna().sum() 
```




    product_id                 0
    product_category_name    610
    dtype: int64




```python
# 10개 정도만 Nullrf값이 뜬 row데이터 파악해보기 
products[products['product_category_name'].isnull()].head(10)

order_items[order_items['product_id'] == 'b0a0c5dd78e644373b199380612c350a'] ## order_items에서 해당 상품이 몇개 정도 팔렸는가 확인
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>order_id</th>
      <th>order_item_id</th>
      <th>product_id</th>
      <th>seller_id</th>
      <th>shipping_limit_date</th>
      <th>price</th>
      <th>freight_value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>103749</th>
      <td>eb9afe3c048ef7be0e99305193ee4ded</td>
      <td>2</td>
      <td>b0a0c5dd78e644373b199380612c350a</td>
      <td>0c8380b62e38e8a1e6adbeba7eb9688c</td>
      <td>2017-04-03 19:55:20</td>
      <td>89.9</td>
      <td>20.95</td>
    </tr>
  </tbody>
</table>
</div>




```python
## 추적할 수 없는 데이터이기 때문에 NaN값을 un_classified 으로 분류하기

products['product_category_name'][products['product_category_name'].isnull()] = 'unclassified'
products['product_category_name'].value_counts().loc[lambda x: x == 610] # 잘 되었나 확인해보기 
```

    C:\Users\82108\anaconda3\lib\site-packages\pandas\core\series.py:992: SettingWithCopyWarning: 
    A value is trying to be set on a copy of a slice from a DataFrame
    
    See the caveats in the documentation: https://pandas.pydata.org/pandas-docs/stable/user_guide/indexing.html#returning-a-view-versus-a-copy
      self._where(~key, value, inplace=True)
    




    unclassified    610
    Name: product_category_name, dtype: int64



#### Products의 Product_category_name을 영어로 변경하기 


```python

```
