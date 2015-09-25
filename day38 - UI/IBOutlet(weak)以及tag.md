- 为什么IBOutlet属性是weak的？
  
  因为当我们将控件拖到Storyboard上，相当于新创建了一个对象，而这个对象是加到视图控制器的view上，view有一个__subViews__属性，这个属性是一个数组，里面是这个view的所有子view，而我们加的控件就位于这个数组中，那么说明，实际上我们的控件对象是属于__view__的，也就是说view对加到它上面的控件是强引用。当我们使用Outlet属性的时候，我们是在viewController里面使用，而这个Outlet属性是有view来进行强引用的，我们在viewController里面__仅仅是对其使用，并没有必要拥有它，所以是weak的__。
  
  如果将weak改为strong，也是没有问题的，并不会造成强引用循环。当viewController的指针指向其他对象或者为nil，这个viewController销毁，那么对控件就少了一个强引用指针。然后它的view也随之销毁，那么subViews也不存在了，那么控件就又少了一个强引用指针，如果没有其他强引用，那么这个控件也会随之销毁。
  
  不过，既然没有必将Outlet属性设置为strong，那么用weak就好了: ]


- 一个控件可以在viewController里面有多个Outlet属性，就相当于一个对象，可以有多个指针指向它（多个引用）。
  
  但是一个Outlet属性只能对应一个控件，也就是说，如果有button1和button2，button1在viewController里面有一个名为button的Outlet属性，此时button指向button1，但是如果用button2给button重新赋值，那么此时button指向button2。也就是说，后来的覆盖原来的。
  
- 一个控件可以在viewController里面触发多个IBAction。比如有一个button控件，在viewController里面有几个方法，那么点击button，会触发所有的这些方法。
  
  如果我有多个控件，比如button1,button2,button3，它们也可以同时绑定一个buttonClick方法，无论点击button1,button2还是button3，都会触发这个buttonClick方法。
  
- 上面说了，button1,button2,button3有可能都触发buttonClick方法，如果想在buttonClick方法里面区分到底是哪个button触发的可能有好几种做法。
  
  1. 可以给这三个button各设置一个Outlet属性，然后在buttonClick里面判断sender和哪个Outlet属性是同一对象，这样就可以区分了。但是很明显，这样并不合理，因为创建的三个属性有些浪费。
  2. 我们可以给三个button各加一个tag，在buttonClick里面通过switch(或者if...)判断，sender的tag和给各个button加上的tag是否一致，如果一致则为同一对象。
  
- __要慎用tag__。因为view有一个viewWithTag:方法，可以在view的子view里面找到和我们传入的tag相同的view，这样哪怕不给这个控件创建Outlet属性，也可以通过tag找到这个对象。但是很明显，这个方法要遍历子view，比较每个子view的tag，这样效率并不高，所以尽量要避免这种情况。