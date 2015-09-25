- 数组的内存分配：
  
  - 前面提到过，变量在内存中是__从大到小__寻址的（内存中以字节为单位），比如00000000 00000000 00000000 00001010在内存中，00001010的地址是最小的；而数组则有些不同，数组的元素自然的从上往下排列 存储,整个数组的地址为首元素的地址。 （但是组成元素的字节还是按从大到小）![](http://7xj0kx.com1.z0.glb.clouddn.com/sznc.png)
    
  - ![](http://7xj0kx.com1.z0.glb.clouddn.com/Snip20150517_3.png)
    
    > 注意:字符在内存中是以对应ASCII值的二进制形式存储的,而非上表的形式。 在这个例子中,数组x的地址为它的首元素的地址0x08,数组ca的地址为0x03。
    
  - 注意数组越界问题，越界会访问到其他内容（比如有两个数组在内存中挨着，第一个数组越界可能会访问到第二个数组的元素），甚至会让程序崩溃。
  
- __当数组名作为函数参数时, 因为自动转换为了指针类型，所以在函数中无法动态计算除数组的元素个数__。
  
  - 在64位编译器下，指针类型默认为__8个字节__。
    
  - 有的时候我们可能想要在一个函数里面动态计算数组的个数，所以可能会这么做：
    
    ``` objective-c
    void printMyArray(int myArray[]) {
      	int length = sizeof(myArray) / sizeof(myArray[0]);
      	for(int i = 0; i < length; i++) {
        	printf("%i", myArray[i]);
      	}
    }
    
    int main() {
    	int myArray[5] = {1,2,3,4,5};
        printMyArray(myArray);
    	return 0;
    }
    ```
    
    可以看到在printMyArray函数中我们动态计算传进来的数组的个数，但是结果是错误的，因为它只能输出前两个数。
    
    这是因为，在把数组当成函数的参数的时候，数组会被认为成__指针__，所以是__8个字节__，所以计算出的length是2，所以只能输出前两个数字。
    
    解决：我们需要给出一个新的参数来获得length，在main()里面计算好length然后传入printMyArray。
    
    ``` objective-c
    void printMyArray(int myArray[], int length) {
        for(int i = 0; i < length; i++) {
            printf("%i ", myArray[i]);
        }
    }
    
    int main(int argc, const char * argv[]) {
        int myArray[5] = {1,2,3,4,5};
        int length = sizeof(myArray) / sizeof(myArray[0]);
        printMyArray(myArray, length);
        return 0;
    }
    ```
  
- “填坑法”的思想：
  
  比如给出这样一题。要求从键盘输入6个0~9的数字,排序后输出。
  
  做法有很多，”填坑法”的意思就是首先定义一个10个数的数组(0~9)，初始化都为0。
  
  接着接受用户的输入（可以用for循环），关键的一步是，将用户输入的值作为数组的下标，将这个下标所对应的值改为1（填坑），再接着for循环输出数组中值是1的索引。
  
  ``` objective-c
  // 空间换时间, 适合数据比较少
  //    1.定义数组,保存用户输入的整数
  //    一定要给数组初始化, 否则有可能是一些随机值
      int numbers[10] = {0};
  //    2.接收用户输入的整数
  //    2.1定义变量接收用户输入的整数
      int index = -1;
      for (int i = 0; i  < 6; i++) {
          printf("请输入第%d个整数\n", i + 1);
          scanf("%d", &index);
  //        将用户输入的值作为索引取修改数组中对应的元素的值为1
  //        指针的时候回来演示刚才的问题
          numbers[index] =  1 ;
      }
  
      int length = sizeof(numbers) / sizeof(numbers[0]);
      for (int i = 0; i < length; i++) {
          if (1 == numbers[i]) {
              // 输出索引
              printf("%d", i);
          }
      }
  ```
  
  这个做法的要点是数组中的初始值都为0，而数组的索引和用户输入的数字是一一对应的，所以只需要将用户输入的数字相对应的索引的元素改成1，然后再for循环输出的话相当于有序输出，最后得到结果。
  
  但是这种做法是有问题的，比如用户输入了重复的数字，但是上面的做法只能将相同的数字输出一次。我们的做法是将相同索引的元素的数字累加，之后再增加一层循环来进行输出。
  
  ``` objective-c
  //    1.定义数组,保存用户输入的整数
      int numbers[10] = {0};
  //    2.接收用户输入的整数
  //    2.1定义变量接收用户输入的整数
      int index = -1;
      for (int i = 0; i  < 6; i++) {
          printf("请输入第%d个整数\n", i + 1);
          scanf("%d", &index);
  //        将用户输入的值作为索引取修改数组中对应的元素的值为1
  //        假设 用户输入的是 1,1,1,2,2,2
          numbers[index] =  numbers[index] + 1 ;
      }
  
      int length = sizeof(numbers) / sizeof(numbers[0]);
      for (int i = 0; i < length; i++) {
  //        j = 1 因为如果数组元素中存储的值是0不用输出
  //        将i对应存储空间中的元素取出,判断需要输出几次
          for (int j = 1; j <= numbers[i]; j++) {
              printf("%d", i);// 1 1 1 2 2 2
          }
      }
  ```
  
- 选择排序
  
  - 主要思想就是，基本上默认数组中第一个元素为最大（最小）值，之后将这个元素和后面的每个元素都进行比较，以__由大到小__排序为例，当第一个值遇到比其大的，就进行交换。这样第一轮过后，第一位就是最大的。接着进行第二轮，由第二个数开始逐个比较，遇到比第二个数大的进行交换，这样第二轮之后第二个数就是第二大的了，以此类推，不断进行选择，最后完成排序。
    
    ``` objective-c
    void selectSort(int numbers[], int length) {
        for (int i = 0; i < length; i++) {
            for (int j = i + 1; j < length; j++) {
                if (numbers[i] < numbers[j]) {
                    int temp = numbers[i];
                    numbers[i] = numbers[j];
                    numbers[j] = temp;
                }
            }
        }
    }
    
    int main(int argc, const char * argv[]) {
        int myArray[] = {42, 7, 1, -3, 88};
        int length = sizeof(myArray) / sizeof(myArray[0]);
        selectSort(myArray, length);
        for (int i = 0; i < length; i++) {
            printf("%i ", myArray[i]);
        }
        return 0;
    }
    ```
    
    在写的时候可以这样想：当第一个数来比较的时候，i = 0，那么j应该等于i + 1，因为第一个数要和第二个数开始比，并且比较length - 1次；当i = 1时，j = 2，并且比较length - 2次，以此类推；上面写的是由大到小排序。
  
- 冒泡排序
  
  - 主要思想是两个相邻的元素进行比较，以__由小到大__排序为例，那么由第一个元素开始和第二个比较，如果第一个比第二个大，那么就进行交换；然后进行第二个和第三个元素的比较，以此类推，第一轮之后，那么数组的最后一个元素就是最大的，以此类推。
    
    ``` objective-c
    void bubbleSort(int numbers[], int length) {
        for (int i = 0; i < length - 1; i++) {
            for (int j = 0; j < length - i - 1; j++) {
                if (numbers[j] > numbers[j + 1]) {
                    int temp = numbers[j];
                    numbers[j] = numbers[j + 1];
                    numbers[j + 1] = temp;
                }
            }
        }
    }
    
    int main(int argc, const char * argv[]) {
        int myArray[] = {42, 7, 1, -3, 88};
        int length = sizeof(myArray) / sizeof(myArray[0]);
        bubbleSort(myArray, length);
        for (int i = 0; i < length; i++) {
            printf("%i ", myArray[i]);
        }
        return 0;
    }
    ```
    
    注意这里和选择排序不同的是，比较的并非numbers[i]和numbers[j]，而是比较的numbers[j]和numbers[j+1]，而外层循环的i代表比较的轮数，内层循环才是真正的每一轮进行的比较。这里是由小到大排序。
  
- 折半查找
  
  - 折半查找顾名思义，我们找到数组的最大值max，最小值min求出中间值mid，然后用mid作为数组下标得到对应的元素，用这个元素和目标值key进行比较：
    
    1. 如果numbers[mid] > key，那么说明key在min和mid之间，那么就设置max为mid - 1，min不变，然后重新计算mid，重复上述步骤，最后找出key。
       
    2. 如果numbers[mid] < key，那么说明key在mid和max之间，那么就设置min为mid + 1，max不变，然后重新计算mid，重复上述步骤，最后找出key。
       
    3. 注意这里的结束条件，有可能数组中有这个key，也有可能没有，那么当min > max时，说明数组中并没有这个key，要小心这种情况。
       
       ​
    
  - 折半查找要求数组必须是__有序的__。（有序表）
    
    ``` objective-c
    int binSearch(int myArray[], int length, int key) {
        int index = -1;
    
        int max = length - 1;
        int min = 0;
        int mid = (max + min) / 2;
    
        while (min <= max) {
            if (myArray[mid] > key) {
                max = mid - 1;
            } else if (myArray[mid] < key){
                min = mid + 1;
            } else if (myArray[mid] == key) {
                index = mid;
                break;
            }
            mid = (max + min) / 2;
        }
    
        return index;
    }
    
    int main(int argc, const char * argv[]) {
        int myArray[] = {-3, 1, 7, 42, 88};
        int length = sizeof(myArray) / sizeof(myArray[0]);
        int index = binSearch(myArray, length, 88);
        printf("index: %i ", index);
        return 0;
    }
    ```
    
    首先我假设index = -1，表示没有相应的值。接着获取max,min,mid的值，注意while循环的条件，在这里我用的是当min <= max的时候循环，当min > max时候跳出循环，说明并未找到key的值。在循环体里面，像刚才分析的那样判断，当myArray[mid] == key的时候说明我们找到了这个值，那么将index设置成找到值的下标，然后跳出循环。如果未找到值则index = -1。
  
- 进制转换查表法