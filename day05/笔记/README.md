- switch语句中的default一般放在最后，__break__可写可不写，因为即使不写，default语句执行完switch也会退出了。但是如果把default语句写在前面，就要注意写__break__，因为如果不写，default会使下面的case都消失，也会造成__穿透__，即把下面的语句也执行了。
  
  ``` C
    default:
        printf("error\n");
        break;
    case 1:
        printf("hello");
        break;
  ```
  
   如果上面的default没有break，那么下面的”hello”也会输出。
  
- 选中一个变量名，command + control + e ，可以同时修改多个名字。相对于command + f 呼出搜索栏，这个方法更”智能”，不像在搜索栏里那样容易误改。
  
- system(“say 想说的话”) 好玩 
  
- command + shift + N    Xcode新建工程
  
- do-while后面是有;的
  
- command + option + 左/右键    收起/打开代码
  
- 打印三角形：

``` 
*
**
***
****
*****

for(int i = 0; i< 5; i++){
    for(int j = 0; j <= i; j++){
        printf("*\t");
    }
    printf("\n");
}
```

``` 
*****
****
***
**
*

for(int i = 0; i< 5; i++){
        for(int j = i; j < 5; j++){
            printf("*\t");
        }
        printf("\n");
    }


```

> 	__规律__：
> 
> 		 尖尖朝上，改变内循环的条件表达式，让内循环的条件表达式随着外循环的i值变化(注意<变成了<=)；
> 
> 		尖尖朝下，改变内循环的初始化表达式，让内循环的初始化表达式随着外循环的i值变化；

打印正三角形：

``` 
--*
-***
*****

for (int i = 0; i < 3; i++) {
    for (int j = i; j < 2; j++) {
        printf("-");
    }
    for (int n = 0; n <= i * 2; n++) {
        printf("*");
    }
    printf("\n");
}
```

打印99乘法表：

``` 
1 * 1 = 1
1 * 2 = 2     2 * 2 = 4
1 * 3 = 3     2 * 3 = 6     3 * 3 = 9

 for (int i = 1; i <= 9; i++) {
      for (int j = 1; j <= i; j++) {
          printf("%d * %d = %d \t", j, i, (j * i));
      }
      printf("\n");
  }
```

遇到类似问题就以上面总结的规律来考虑，如果是打印正三角形，在第二层循环的条件语句中*2即可。

- 双层for循环中，外层循环代表__行数__，内层循环代表__列数__，所以看到以下图案： 
  
  \``` C
  
  *
  
  **

------

------

  \```

  ​



  应该马上想到第一层for循环4次(4行)，第二层for循环4次(4列)，再根据尖尖向上的原则来打印出来。