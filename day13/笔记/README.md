- 只有指针是可以运算（移动）的，数组名是不可以的。
  
  ``` c
   int x[10];
   x++;  //illegal
   int* p = x;
   p++; //legal
  ```
  
- 两指针变量相减所得之差是两个指针所指数组元素之间相差的元素个数。
  
  - 实际上是两个指针值(地址)相减之差再除以该数组元素的长度(字节数)。
  - (pointer2地址值 - pointer地址值) / sizeof(所指向数据类型)
  - 指针之间可以相减,但不可以相加(相加无意义)。
  
- 定义字符串：
  
  - 字符数组：
    
    ``` C
    char string[] = "hello";
    printf("%s\n",string);
    ```
    
  - 字符串指针指向字符串：
    
    ``` C
    char *str = "hello"
    ```
  
- __使用字符数组来保存的字符串是存在”栈”里的，所以它是可读可写的，所以我们可以修改字符数组里的某个元素的值。__
  
  __但是，使用字符指针来保存字符串，它保存的是字符串常量地址，"常量区"是只读的，所以是不可改的。__
  
  ``` C
  char *str = "hello";
  *(str+1) = 'w'; // 错误
  ```
  
- 使用注意：
  
  ``` C
  char *str;
  scanf("%s", str); 
  
  /* str是一个野指针,他并没有指向某一块内存空间,所以不允许这样写。如果给str分配内存空间是可以这样用的 */
  
   /********* 数组的方法****************/  
    
   char name[20];  
   scanf("%s",name);    
    
  /************* 给字符针针分配内存空间的办法***********/  
    
   char *name;  
   name=(char*)malloc(50);      //此时name已经指向一个刚刚分配的地址空间。  
   scanf("%s",name);  
  ```
  
  ​
  
- 指针函数__（是函数，返回值是指针）__注意：
  
  如果函数返回一个字符串，那么如果用一个数组以下面的形式来接的话，是会报错的：
  
  ``` C
  char *test() {
      return "hello";
  }
  
  int main(int argc, const char * argv[]) {
      
      char names[10];
      
      names = test();
  
      return 0;
  }
  ```
  
  这是因为，返回的字符串相当于一个这样的数组：{‘h’, ‘e’, ‘l’, ‘l’, ‘o’, ‘\0’}，但是前面我们说过，数组如果在定义的时候没有用{}这种方式初始化，那么后面就不能再用这种方式初始化了，所以会出错。
  
  解决方法：将__char names[10]__改为__char *names__或者__char names[10]直接等于test()__。
  
  ​
  
- 函数指针__（是指针，指向函数）__:
  
  - 格式：函数的返回值类型 (*指针变量名) (形参1, 形参2, ...);
    
    ``` C
    int sum(int a,int b)
    {
      return a + b;
    }
    
    int (*p)(int,int);
    p = sum;
    ```
    
  - 应用场景：
    
    - 调用函数
      
    - 将函数作为参数在函数间传递
      
    - 函数指针能更灵活：
      
      ``` C
      int minus(int a, int b) 
      {
      	return (a - b);
      }
      
      int add(int a, int b)
      {
      	return (a + b);
      }
      
      int myFunction(int a, int b, int (*funcP) (int, int))
      {
      	return funcP(a, b);
      }
      
      int main()
      {
      	int minusResult = myFunction(10, 20, minus);
          int addResult = myFunction(10, 20, add);
        	...
      	return 0;
      }
      
      /*
      	函数指针能让程序更灵活，比如后续有乘、除函数的时候，只需实现这两个函数然后在主函数调用myFunction函数即可。如果是多人协作，不同的人写不同的功能，如果我们来写myFunction那么基本就不用修改就可以一直使用，非常灵活。
      */
      ```
      
      ​
    
  - 技巧：
    
    1、把要指向函数头拷贝过来
    
    2、把函数名称使用小括号括起来
    
    3、在函数名称前面加上一个*
    
    4、修改函数名称
    
  - 使用注意：
    
    - 由于这类指针变量存储的是一个函数的入口地址，所以对它们作加减运算(比如p++)是无意义的。
      
    - 如上例，如果想使用p这个函数指针，可以直接向使用sum一样：
      
      ``` C
      int result = p(10, 10);
      ```
      
      也可以这样：
      
      ``` C
      int result = (*p)(10, 10);
      ```
      
      ​
  
- 结构体是一种__自定义数据类型__，注意，它是__数据类型__。
  
  ``` C
  struct Student {
       char *name;
       int age;
   };
  
   struct Student stu;
  ```
  
  注意，结构体的后面是有 __;__ 的。
  
- 在使用结构体类型的时候，要加上__struct__关键字。
  
- 定义结构体类型的同时定义变量：
  
  ``` C
  struct Student {
      char *name;
      int age;
  } stu;
  ```
  
  这种在定义的同时也定义了变量，就相当于：
  
  ``` 
  struct Student {
       char *name;
       int age;
   };
  
   struct Student stu;
  ```
  
  定义结构体类型的同时定义变量，以后如果想继续使用这个结构体类型，仍然可以使用常规的方式定义：
  
  ``` C
  struct Student newStu;
  ```
  
- 匿名结构体定义结构体变量：
  
  ``` C
  struct {
      char *name;
      int age;
  } stu;
  ```
  
  这种匿名方式与上面的方式相比，虽然看起来更简洁（省去了结构名），但是要注意，这只能定义一个stu变量，而不能再定义新的变量，因为结构名没有了。
  
- __结构体变量的初始化：__
  
  1. 先定义结构体变量,然后再初始化
     
     ``` C
     struct Student {
          char *name;
          int age;
      };
     
     struct Student stu = {“QY", 21};
     ```
     
  2. 定义的同时初始化
     
     ``` C
     struct Student {
          char *name;
          int age;
      } stu = {“QY", 21};
     ```
     
  3. 可以使用另外一已经存在的结构体初始化新的结构体
     
     ``` C
     struct Student stu2 = stu;
     ```
     
  4. 先定义stu再初始化（与1对应）：
     
     ``` C
     struct Student stu3;
     stu3 = (struct Student){"QY", 21};
     
     /*
     这种情况要与数组对应起来，因为前面说过数组是不可以这样子的，其实结构体是可以的，但是要加上强制类型转换，告诉编译器这不是数组而是一个结构体。
     */
     ```
     
  5. 下面的做法是错误的：
     
  6. ``` C
     struct Student {
          char *name;
          int age;
      };
     struct Student stu;
     stu = {“QY", 21}; // 错误，需要强制类型转换
     ```
     
  7. 或者以这种方式来给成员赋值：
     
     ``` C
     struct Student {
          char *name;
          int age;
      };
      struct Student stu;
     
      stu.age = 27;
     ```
  
- 结构体变量占用存储空间大小
  
  1. 找到成员里占用字节最大的来分配空间，如int a, double b, char c，则一次分配8个字节。要注意对齐的问题来看总共多少个字节。注意声明变量的顺序，不同顺序分配的字节数也不一样。比如现在这个顺序要分配8 + 8 + 8个字节，但是如果int a, char c, double b则分配 8 + 8个字节。
     
  2. 可以通过__#pragma pack(2)__来设置__对齐模数__，这样一次分配2个字节。
     
     ``` c
     struct A
     {
         int my_test_a; // 分配2次，共4个字节
         char my_test_b; //分配1次，共2个字节
         double my_struct_a; //分配4次，共8个字节
         int my_struct_b; //分配2次，共4个字节
         char my_struct_c; //分配1，共2个字节
     }
     
     /* 结果是共有20个字节。
     */
     ```
  
- 结构体数组：
  
  跟结构体变量一样，结构体数组也有3种定义方式 ：
  
  - 先定义结构体类型，再定义结构体数组
    
    ``` C
    struct Student {
        char *name;
        int age;
    };
    struct Student stu[5];
    ```
    
  - 定义结构体类型的同时定义结构体数组
    
    ``` C
    struct Student {
        char *name;
        int age;
    } stu[5];
    ```
    
  - 匿名结构体定义结构体结构体数组
    
    ``` C
    struct {
        char *name;
        int age;
    } stu[5];
    ```
  
  结构体数组初始化：
  
  - 定义的同时进行初始化
    
    ``` C
    struct { 
      char *name; 
      int age; 
    } stu[2] = { {"jo", 27}, {"y", 30} };
    ```
    
  - 先定义,后初始化,整体赋值
    
    ``` C
    s[1] = (struct stu){23,"hello"};
    ```
    
  - 先定义,后初始化 分开赋值
    
    ``` C
    s[1].age=12; 
    strcpy(stu[1].name, "hello");
    ```
  
- __结构指针变量中的值是所指向的结构变量的首地址__。
  
- struct 结构名 *结构指针变量名
  
- 示例：
  
  ``` c
  // 定义一个结构体类型
  struct Student {
      char *name;
      int age;
  };
  
  // 定义一个结构体变量
  struct Student stu = {“QY", 21};
  
  // 定义一个指向结构体的指针变量
  struct Student *p;
  
  // 指向结构体变量stu
  p = &stu;
  
  /*
  这时候可以用3种方式访问结构体的成员
  */
  // 方式1：结构体变量名.成员名
  printf("name=%s, age = %d \n", stu.name, stu.age);
  
  // 方式2：(*指针变量名).成员名
  printf("name=%s, age = %d \n", (*p).name, (*p).age);
  
  // 方式3：指针变量名->成员名
  printf("name=%s, age = %d \n", p->name, p->age);
  
  ```
  
- 通过结构体指针访问结构体成员：
  
  - (*结构指针变量).成员名
  - 结构指针变量->成员名(用熟)
  - (pstu)两侧的括号不可少,因为成员符“.”的优先级高于“”。 如去掉括号写作pstu.num则等效于(pstu.num),这样,意义就完全不对了。
  
- 在用结构指针的时候，就把它当作int *a来看，比如：
  
  ``` C
  struct Student stu = ... //相当于 int a = ...
  struct Student *p; //相当于 int *p
  p = &stu; //相当于 p = &a
  ```
  
- 结构体变量作为参数传递是值传递，而结构指针则是址传递。
  
- 枚举：
  
  枚举通常是一些固定的取值范围，如一年四季，一周七天这种。
  
  与结构体类似：
  
  ``` c
  enum　枚举名　{
      枚举元素1,
      枚举元素2,
      ……
  };
  
  enum Season {
      spring,
      summer,
      autumn,
      Winter
  };
  enum Season s;
  定义枚举类型的同时定义枚举变量
  enum Season {
      spring,
      summer,
      autumn,
       winter
  } s;
  省略枚举名称，直接定义枚举变量
  enum{
      spring,
       summer,
       autumn,
       winter
  } s;
  
  s = spring; //等价于s = 0;
  s = 3; //等价于s = winter;
  ```
  
  枚举类型本质上来说就是__整形__，默认为0,1,2,3…，但是也可以赋值，比如第三个赋值为10，那么第1个为0，第2个为1，第3个为10，第4个为11。
  
  通常来说，枚举的规范为：以__k + 枚举名称 + 枚举元素名__。比如：
  
  ``` C
  enum Season {
      kSeasonSpring,
      kSeasonSummer,
      kSeasonAutumn,
      kSeasonWinter
  };
  
  enum Season s = kSeasonSummer;
  ```