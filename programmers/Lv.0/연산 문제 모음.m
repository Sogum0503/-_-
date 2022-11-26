## 연산 관련 문제 모음

### 1. 두 수의 곱 
**문제 설명**
```
정수 num1, num2가 매개변수 주어집니다. num1과 num2를 곱한 값을 return 하도록 solution 함수를 완성해주세요.
```
**풀이**
```python
def solution(num1,num2):
    answer = num1 * num2
    return answer
```

--------------------
### 나머지 구하기
**문제 설명**
```
정수 num1, num2가 매개변수로 주어질 때, num1를 num2로 나눈 나머지를 return 하도록 solution 함수를 완성해주세요.
```
**풀이**
```python
def solution(num1,num2):
    answer = num1 % num2
    return answer
```

--------------------
### 두 수의 합 
**문제 설명**
```
정수 num1과 num2가 주어질 때, num1과 num2의 합을 return하도록 soltuion 함수를 완성해주세요.
```
**풀이**
```python
def solution(num1, num2):
    answer = num1+num2
    return answer
```

---------------------
### 짝수의 합 
**문제조건**
* 정수 n이 주어질 때, n이하의 짝수를 모두 더한 값을 return 하도록 solution 함수를 작성해주세요.

**풀이**
```python
def solution(n):
    answer = 0
    
    for i in range(n + 1):
        if i % 2 == 0:
            answer += i
            
    return answer 
```

-----------------
### 두 수의 나눗셈
**문제조건**
* 정수 num1과 num2가 매개변수로 주어질 때, num1을 num2로 나눈 값에 1,000을 곱한 후 정수 부분을 return 하도록 soltuion 함수를 완성해주세요.

**풀이**
```python
def solution(num1, num2):
    answer = int((num1/num2)*1000)
    return answer
```
