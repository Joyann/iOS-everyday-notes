- 进制
  
  - 二进制以__0b__或__0B__开头，如0b001。（数字0不是字母O）
    
  - 八进制以__0__开头，如067。
    
  - 十六进制以__0x__或__0X__开头，如0x48B。
    
  - 打印一个数的八进制和十六进制：
    
    ``` 
    int a = 13;
    printf("10->8: %o\n", a);
    printf("10->16: %x\n", a);
    ```
    
  - 定义一个二进制数、八进制数、十六进制,打印其对应的10 进制
    
    ``` 
    int a = 0b00000000000000000000000000001101;
    printf("2->10: %d\n", a);
    
    a = 015;
    printf("8->10: %d\n", a);
    
    a = 0xd;
    printf("16->10: %d\n", a);
    
    输出结果:
    2->10: 13
    8->10: 13
    16->10: 13
    ```
    
  - 进制转换
  
- 原码，反码，补码
  
  - 正数的原码，反码，补码都一样。__三码合一__。
    
  - 负数的第一位为__符号位__，反码是原码取反，补码是反码加一。
    
  - 正数和负数在计算机的内存中都以__补码__的形式存在。
    
  - 对于负数, 补码表示方式也是人脑无法直观看出其数值的。 通常也需要转换成原码在计算其数值。
    
  - __为什么要引入反码和补码?__
    
    - > 现在我们知道了计算机可以有三种编码方式表示一个数. 对于正数因为三种编码方式的结果都相同, 所以不需要过多解释。
      > 
      > 但是对于负数, 可见原码, 反码和补码是完全不同的. 既然原码才是被人脑直接识别并用于计算表示方式, 为何 还会有反码和补码呢?
      > 
      > 首先, 因为人脑可以知道第一位是符号位, 在计算的时候我们会根据符号位, 选择对真值区域的加减。但是对于计算机, 加减乘数已经是最基础的运算, 要设计的 尽量简单. 计算机辨别"符号位"显然会让计算机的基础电路设计变得十分复杂! 于是人们想出了 将符号位也参与运算的方法. 我们知道, 根据运算法则减去一个正数等于加上一个负数, 即: 1-1 = 1 + (-1) = 0 , 所以机器可以只有加法而没有减法, 这样计算机运算的设计就更简单了.
      
    - 例:
      
      > 计算十进制的表达式: 1-1=0
      > 
      > 1 - 1 = 1 + (-1) = [00000001]原 + [10000001]原 = [10000010]原 = -2
      > 
      > 如果用原码表示, 让符号位也参与计算, 显然对于减法来说, 结果是不正确的.这也就是为何计算 机内部不使用原码表示一个数.
      > 
      > 为了解决原码做减法的问题, 出现了反码：
      > 
      > ``` 
      >    1 - 1 = 1 + (-1) = [0000 0001]原 + [1000 0001]原           
      >  = [0000 0001]反 + [1111 1110]反
      >  = [1111 1111]反
      >  = [1000 0000]原 (1111 1111,符号位不变,其他为逐位取反)
      >  = -0
      > ```
      > 
      > 发现用反码计算减法, 结果的真值部分是正确的. 而唯一的问题其实就出现在"0"这个特殊的数值 上. 虽然人们理解上+0和-0是一样的, 但是0带符号是没有任何意义的. 而且会有[0000 0000]原和 [1000 0000]原两个编码表示0。
      > 
      > 于是补码的出现, 解决了0的符号以及两个编码的问题：
      > 
      > ``` 
      >    1-1 = 1 + (-1) = [0000 0001]原 + [1000 0001]原
      >  = [0000 0001]补 + [1111 1111]补
      >  = [0000 0000]补
      >  = [0000 0000]原
      > ```
      > 
      > - 这样0用[0000 0000]表示, 而以前出现问题的-0则不存在了.而且可以用[1000 0000]表示-128: (-1) + (-127) = [1000 0001]原 + [1111 1111]原 = [1111 1111]补 + [1000 0001]补 = [1000 0000]补
      > - -1-127的结果应该是-128, 在用补码运算的结果中, [1000 0000]补 就是-128. 但是注意因为实际 上是使用以前的-0的补码来表示-128, 所以-128并没有原码和反码表示.(对-128的补码表示[1000 0000]补算出来的原码是[0000 0000]原, 这是不正确的)
  
- 位运算符
  
  - __& 按位与__ 
    
    - 规律：二进制中，与1相&就保持原位，与0相&就为0。
      
    - 应用场景：
      
      1. 按位与运算通常用来对某些位清0或保留某些位。例如把a的高位都清0，保留低八位，那么就a&255。
         
      2. 判断奇偶: 将变量a与1做位与运算，若结果是1，则 a是奇数；若结果是0，则 a是偶数。
         
      3. 任何数和1进行&操作,得到这个数的最低位。
         
         >   1001
         > 
         > &0001
         > 
         > =0001
         > 
         > ​
         
      4. 想把某一位置0。
         
         >   11111111
         > 
         > &11111011
         > 
         > =11111011
    
  - __| 按位或__
    
  - __^ 按位异或__
    
    - 规律：
      
      1. 相同整数相^的结果是0。比如5^5=0。
      2. 多个整数相^的结果跟顺序无关。比如5^6^7=5^7^6。因此得出结论：__a^b^a = b__。
      
    - 使用位运算实现交换两个数的值：
      
      ``` 
      a = a^b;
      b = b^a;
      a = a^b;
      ```
    
  - __~ 取反__
  
- 左移运算符和右移运算符
  
  - 把整数a的各二进位全部左移n位，高位丢弃，低位补0。左移n位其实就是乘以2的n次方。__由于左移是丢弃最高位，0补最低位，所以符号位也会被丢弃，左移出来的结果值可能会改变正负性。__
    
  - 把整数a的各二进位全部右移n位，保持符号位不变。右移n位其实就是除以2的n次方。__为正数时， 符号位为0，最高位补0。为负数时，符号位为1，最高位是补0或是补1，取决于编译系统的规定。__
    
  - 例：
    
    - 写一个函数把一个10进制数按照二进制格式输出
      
    - 分析：
      
      > 13 -----> 0000 0000 0000 0000 0000 0000 0000 1101
      > 
      > 0000 0000 0000 0000 0000 0000 0000 1101 13
      > 
      > 0000 0000 0000 0000 0000 0000 0000 0001 1
      > 
      > 每次取 一个数的最后一个二进制位
      > 
      > 任何一个数和1进行&(按位与)得到任何一个数的二进制的最后
      > 
      > 一位
      
    - 实现：
      
      ``` 
          int len = sizeof(int)*8;
          int temp;
          for (int i=0; i<len; i++) {
              temp = num; //每次都在原数的基础上进行移位运算
              temp = temp>>(31-i); //每次移动的位数
              int t = temp&1; //取出最后一位
              if(i!=0&&i%4==0)printf(" "); printf("%d",t);
          }
      ```
  
- 变量的存储
  
  - 一个变量所占用的存储空间，不仅跟变量类型有关，而且还跟编译器环境有关系。同一种类型的变量，在不同编译器环境下所占用的存储空间又是不一样的。
    
  - 任何变量在内存中都是以二进制的形式存储。一个负数的二进制形式，其实就是对它的正数的二进制形式进行取反后再+1。
    
  - 变量的首地址,是变量所占存储空间字节地址最小的那个地址。（因为变量的字节的地址在内存中是__由大到小__的，以0b00000000 00000000 00000000 00001010为例，__00001010__属于低字节，位于这个变量所占4个字节的最上面的那个字节，也就是地址最小的字节。类似Excel中的四个表格，低字节位于最上面（地址最小））。
    
    ​
  
- 类型说明符
  
  - > 在64位编译器环境下:
    > 
    > 	short占2个字节(16位)
    > 
    > 	int占4个字节(32位)
    > 
    > 	long占8个字节(64位)
    > 
    > 因此，如果使用的整数不是很大的话，可以使用short代替int，这样的话，更节省内存开销。
    
  - > ANSI \ ISO制定了以下规则：
    > 
    > ​        short跟int至少为16位(2字节)
    > 
    > ​        long至少为32位(4字节)
    > 
    > ​        short的长度不能大于int，int的长度不能大于long
    > 
    > ​        char一定为为8位(1字节)，毕竟char是我们编程能用的最小数据类型
    
  - - 32位编译器：long long 占 __8个字节__, long 占 __4个字节__。
    - 64位编译器：long long 和 long 都是 __8个字节__。
    
  - - long long int == long long
    - long int == long
    - short int == short
    
    ​
  
- char型数据存储原理
  
  - char a=‘a'  ——> 取出'a'的ASCII码值,97,然后转换2进制,存储在一个字节中。
  - 个人理解，ASCII表就是为字符设计的，因为字符在内存中存储时首先取出这个字符的ASCII码值，然后转换成二进制之后存储。而且一个字符占一个字节，所以共8位，取值范围是-2^7~2^7-1，所以ASCII表也是0~127。
  
- 数组
  
  - 初始化数组
    
    - int ages[3] = {4, 6, 9};
    - int nums[10] = {1,2};    // 其余的自动初始化为0
    - int nums[] = {1,2,3,5,6};    // 根据大括号中的元素个数确定数组元素的个数
    - int nums[5] = {[4] = 3,[1] = 2};    // 指定元素个数,同时给指定元素进行初始化
    - int nums[3];  nums[0] = 1;  nums[1] = 2;  nums[2] = 3;    // 先定义，后初始化
    - 定义但是未初始化，数组中有值，但是是垃圾值。
    - 对于数组来说,一旦有元素被初始 化,其他元素都被赋值0。
    
  - 计算数组中元素的个数
    
    - int count = sizeof(数组) / sizeof(数组[0])    // 数组的长度 = 数组占用的总字节数 / 数组元素占用的字节数
      
      ​
    
  - 数组注意事项
    
    - __在定义数组的时候[]里面只能写整型常量或者是返回整型常量的表达式。__
      
      > int ages['A'] = {19, 22, 33};
      > 
      > printf("ages[0] = %d\n", ages[0]);
      > 
      > int ages[5 + 5] = {19, 22, 33};
      > 
      > printf("ages[0] = %d\n", ages[0]);
      > 
      > int ages['A' + 5] = {19, 22, 33};
      > 
      > printf("ages[0] = %d\n", ages[0])
      
    - __错误写法__。
      
      - 没有指定元素个数（int nums[] = {1,2,3,5,6}; 这样是可以的，但是如果先声明，并没有初始化，则是错误的）
        
        > int a[];    // 错误
        
      - []中不能放变量
        
        > int number = 10;
        > 
        > int ages[number]; // 不报错, 但是没有初始化, 里面是随机值
        
        
        > int number = 10;
        > 
        > int ages[number] = {19, 22, 33} // 直接报错
        
      - > int ages10[5];
        > 
        > ages10 = {19, 22, 33};    // 错误。只能在定义数组的时候进行一次性（全部赋值）的初始化
        
      - 访问数组越界。