//
//  ViewController.m
//  gcdTest
//
//  Created by shoron on 15/12/15.
//  Copyright © 2015年 com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Handler

- (IBAction)testDispatchSyncHandler:(id)sender {
    [self testDispatchSync];
}

- (IBAction)testDispatchAsyncHandler:(id)sender {
    [self testDispatchAsync];
}

- (IBAction)testDispatchAfterHandler:(id)sender {
    [self testDispatchAfter];
}

- (IBAction)testDispatchApplyHandler:(id)sender {
    [self testDispatchApply];
}

- (IBAction)testDispatchOnceHandler:(id)sender {
    [self testDispatchOnce];
}

- (IBAction)testDispatchGroupAsyncHandler:(id)sender {
    [self testDispatchGroupAsync];
}

#pragma mark - Private Methods

// 交叉创建 串行/并行队列
- (dispatch_queue_t)getDispatchQueue {
    static BOOL isConcurrentQueue = NO;
    dispatch_queue_t queue;
    if (isConcurrentQueue) {
        NSLog(@" *** 交叉创建串行并行队列。 创建并行队列成功 ***");
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    } else {
        NSLog(@" *** 交叉创建串行并行队列。 创建串行队列成功 ***");
        queue = dispatch_queue_create("test",DISPATCH_QUEUE_SERIAL);
    }
    isConcurrentQueue = !isConcurrentQueue;
    return queue;
}

- (void)testDispatchSync {
    NSLog(@" ********** dispatch_sync 测试开始 **********");
    NSLog(@" 本次测试共有3个任务，ABC，其运行时间分别为，3，9，5秒。可以修改运行时间来测试不同队列，不同运行时间下的测试结果");
    NSDate *startDate = [NSDate date];
    __block NSInteger tastNumber = 0;
    dispatch_queue_t queue = [self getDispatchQueue];
    
    dispatch_sync(queue, ^(){
        [NSThread sleepForTimeInterval:3];
        NSDate *endDate = [NSDate date];
        
        NSLog(@" Task A: 完成。花费时间为 %f seconds 。当前线程为： %@ ",[endDate timeIntervalSinceDate:startDate],[NSThread currentThread]);
        tastNumber++;
        if (tastNumber == 3) {
            NSDate *endDate = [NSDate date];
            NSLog(@" ********** dispatch_sync 测试完成. 所花时间一共为 %f ********** ",[endDate timeIntervalSinceDate:startDate]);
        }
    });
    
    dispatch_sync(queue, ^(){
        [NSThread sleepForTimeInterval:9];
        NSDate *endDate = [NSDate date];
        
        NSLog(@" Task B: 完成。花费时间为 %f seconds 。当前线程为： %@ ",[endDate timeIntervalSinceDate:startDate],[NSThread currentThread]);
        tastNumber++;
        if (tastNumber == 3) {
            NSDate *endDate = [NSDate date];
            NSLog(@" ********** dispatch_sync 测试完成. 所花时间一共为 %f ********** ",[endDate timeIntervalSinceDate:startDate]);
        }
    });
    
    dispatch_sync(queue, ^(){
        [NSThread sleepForTimeInterval:5];
        NSDate *endDate = [NSDate date];
        
        NSLog(@" Task C: 完成。花费时间为 %f seconds 。当前线程为： %@ ",[endDate timeIntervalSinceDate:startDate],[NSThread currentThread]);
        tastNumber++;
        if (tastNumber == 3) {
            NSDate *endDate = [NSDate date];
            NSLog(@" ********** dispatch_sync 测试完成. 所花时间一共为 %f ********** ",[endDate timeIntervalSinceDate:startDate]);
        }
    });
    
    /**
     *  备注：
     *
     *  同步执行任务会阻塞
     *  当同步执行时，不会创建新线程。不管是串行队列还是并行队列。
     */
}

- (void)testDispatchAsync {
    NSLog(@" ********** dispatch_async 测试开始 **********");
    NSLog(@" 本次测试共有3个任务，ABC，其运行时间分别为，3，9，5秒。可以修改运行时间来测试不同队列，不同运行时间下的测试结果");
    NSDate *startDate = [NSDate date];
    __block NSInteger tastNumber = 0;
    dispatch_queue_t queue = [self getDispatchQueue];

    dispatch_async(queue, ^(){
        [NSThread sleepForTimeInterval:3];
        NSDate *endDate = [NSDate date];
        
        NSLog(@" Task A: 完成。花费时间为 %f seconds 。当前线程为： %@ ",[endDate timeIntervalSinceDate:startDate],[NSThread currentThread]);
        tastNumber++;
        if (tastNumber == 3) {
            NSDate *endDate = [NSDate date];
            NSLog(@" ********** dispatch_async 测试完成. 所花时间一共为 %f ********** ",[endDate timeIntervalSinceDate:startDate]);
        }
    });
    
    dispatch_async(queue, ^(){
        [NSThread sleepForTimeInterval:9];
        NSDate *endDate = [NSDate date];
        
        NSLog(@" Task B: 完成。花费时间为 %f seconds 。当前线程为： %@ ",[endDate timeIntervalSinceDate:startDate],[NSThread currentThread]);
        tastNumber++;
        if (tastNumber == 3) {
            NSDate *endDate = [NSDate date];
            NSLog(@" ********** dispatch_async 测试完成. 所花时间一共为 %f ********** ",[endDate timeIntervalSinceDate:startDate]);
        }
    });
    
    dispatch_async(queue, ^(){
        [NSThread sleepForTimeInterval:5];
        NSDate *endDate = [NSDate date];
        
        NSLog(@" Task C: 完成。花费时间为 %f seconds 。当前线程为： %@ ",[endDate timeIntervalSinceDate:startDate],[NSThread currentThread]);
        tastNumber++;
        if (tastNumber == 3) {
            NSDate *endDate = [NSDate date];
            NSLog(@" ********** dispatch_async 测试完成. 所花时间一共为 %f ********** ",[endDate timeIntervalSinceDate:startDate]);
        }
    });

}

- (void)testDispatchApply {
    NSLog(@" ********** dispatch_apply 测试开始 **********");
    NSDate *startDate = [NSDate date];
    __block NSInteger tastNumber = 0;
    
    dispatch_queue_t queue = [self getDispatchQueue];
    
    /**
     *  多次执行同一个Block任务
     *
     *  @param 3     要重复执行的次数
     *  @param queue 任务所在的队列
     *  @param index 包含任务顺序的Block
     *
     *  @return
     */
    dispatch_apply(3, queue, ^(size_t index){
        [NSThread sleepForTimeInterval:index+1];
        NSDate *endDate = [NSDate date];
        NSLog(@"第 %lu 次执行完，运行时间为 %f, 当前线程为：%@",index,[endDate timeIntervalSinceDate:startDate],[NSThread currentThread]);
        tastNumber++;
        if (tastNumber == 3) {
            NSLog(@" ********** dispatch_apply 测试结束。 所花时间一共为 %f ********** ",[endDate timeIntervalSinceDate:startDate]);
        }
    });
}

- (void)testDispatchAfter {
    NSLog(@" ********** dispatch_after 测试开始 **********");
    NSLog(@" 本次测试共有2个任务，AB，其运行时间分别为，3，6秒. 可以修改延迟时间，来测试不同队列，不同延迟时间的情况");
    NSDate *startDate = [NSDate date];
    __block NSInteger tastNumber = 0;
    dispatch_queue_t queue = [self getDispatchQueue];
    
    /**
     *  @param DISPATCH_TIME_NOW 从何时开始计时
     *  @param NSEC_PER_SEC      从计时开始延迟多少时间
     */
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    
    /**
     *  延迟执行某个任务
     *
     *  @param time  延迟的时间
     *  @param queue 任务所在的队列
     *  @param ^     延迟执行的任务
     *
     *  @return
     */
    dispatch_after(time, queue, ^(){
        [NSThread sleepForTimeInterval:3];
        NSDate *endDate = [NSDate date];
        
        // 是为了测试，不同的任务是否在同一线程中
        NSLog(@" Task A: 完成。花费时间为 %f seconds 。当前线程为： %@ ",[endDate timeIntervalSinceDate:startDate],[NSThread currentThread]);
        tastNumber++;
        if (tastNumber == 2) {
            NSDate *endDate = [NSDate date];
            NSLog(@" ********** dispatch_after 测试完成. 所花时间一共为 %f ********** ",[endDate timeIntervalSinceDate:startDate]);
        }
    });
    
    dispatch_time_t time1 = dispatch_time(DISPATCH_TIME_NOW, 9 * NSEC_PER_SEC);
    dispatch_after(time1, queue, ^(){
        [NSThread sleepForTimeInterval:6];
        NSDate *endDate = [NSDate date];
        
        NSLog(@" Task B: 完成。花费时间为 %f seconds 。当前线程为： %@ ",[endDate timeIntervalSinceDate:startDate],[NSThread currentThread]);
        tastNumber++;
        if (tastNumber == 2) {
            NSDate *endDate = [NSDate date];
            NSLog(@" ********** dispatch_after 测试完成. 所花时间一共为 %f ********** ",[endDate timeIntervalSinceDate:startDate]);
        }
    });
}

- (void)testDispatchOnce {
    NSDate *startDate = [NSDate date];
    
    static dispatch_once_t staticOnce;
    dispatch_once(&staticOnce, ^{
        NSLog(@" ********** static dispatch_once 测试开始 **********");
        [NSThread sleepForTimeInterval:3];
        NSDate *endDate = [NSDate date];
        NSLog(@" ********** static dispatch_once 测试完成. 所花时间一共为 %f ********** ",[endDate timeIntervalSinceDate:startDate]);
    });
    
    /**
     *  备注
     *  
     *  dispatch_once 第一个参数必须是static的。传递一个非静态变量会crash。
     */
}

- (void)testDispatchGroupAsync {
    NSLog(@" ********** dispatch_group_async 测试开始 **********");
    NSLog(@" 本次测试有一个串行队列一个并行队列，向串行队列中依次添加 AB 两个任务，向并行队列中依次添加 CD 两个任务。");
    NSLog(@" ABCD 的运行时间分别为 3，7，5，2秒");
    
    NSDate *startDate = [NSDate date];
    __block NSInteger tastNumber = 0;
    
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_t group = dispatch_group_create();
    

    /**
     *  将任务提交到 quque 中，同时加入到 group 中。
     *  任务的执行方式是异步的。
     */
    dispatch_group_async(group, serialQueue, ^{
        [NSThread sleepForTimeInterval:3];
        NSDate *endDate = [NSDate date];
        
        NSLog(@" Task A: 完成。花费时间为 %f seconds 。当前线程为： %@ ",[endDate timeIntervalSinceDate:startDate],[NSThread currentThread]);
        tastNumber++;
        if (tastNumber == 4) {
            NSDate *endDate = [NSDate date];
            NSLog(@" ********** dispatch_group_async 测试完成. 所花时间一共为 %f ********** ",[endDate timeIntervalSinceDate:startDate]);
        }
    });
    
    dispatch_group_async(group, concurrentQueue, ^{
        [NSThread sleepForTimeInterval:5];
        NSDate *endDate = [NSDate date];
        
        NSLog(@" Task C: 完成。花费时间为 %f seconds 。当前线程为： %@ ",[endDate timeIntervalSinceDate:startDate],[NSThread currentThread]);
        tastNumber++;
        if (tastNumber == 4) {
            NSDate *endDate = [NSDate date];
            NSLog(@" ********** dispatch_group_async 测试完成. 所花时间一共为 %f ********** ",[endDate timeIntervalSinceDate:startDate]);
        }
    });
    
    dispatch_group_async(group, serialQueue, ^{
        [NSThread sleepForTimeInterval:7];
        NSDate *endDate = [NSDate date];
        
        NSLog(@" Task B: 完成。花费时间为 %f seconds 。当前线程为： %@ ",[endDate timeIntervalSinceDate:startDate],[NSThread currentThread]);
        tastNumber++;
        if (tastNumber == 4) {
            NSDate *endDate = [NSDate date];
            NSLog(@" ********** dispatch_group_async 测试完成. 所花时间一共为 %f ********** ",[endDate timeIntervalSinceDate:startDate]);
        }
    });
    
    dispatch_group_async(group, concurrentQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSDate *endDate = [NSDate date];
        
        NSLog(@" Task D: 完成。花费时间为 %f seconds 。当前线程为： %@ ",[endDate timeIntervalSinceDate:startDate],[NSThread currentThread]);
        tastNumber++;
        if (tastNumber == 4) {
            NSDate *endDate = [NSDate date];
            NSLog(@" ********** dispatch_group_async 测试完成. 所花时间一共为 %f ********** ",[endDate timeIntervalSinceDate:startDate]);
        }
    });
    
    /**
     *  当 group 中观察的任务都执行完时，调用此方法
     *
     *  @param group       观察任务的group
     *  @param serialQueue 任务所在的queue
     *  @param ^           当group中所有的任务都完成时，所执行的动作。
     *
     *  @return
     */
    dispatch_group_notify(group, serialQueue, ^(){
        NSDate *endDate = [NSDate date];
        NSLog(@" ********** 串行队列所有任务已经完成. 所花时间一共为 %f ********** ",[endDate timeIntervalSinceDate:startDate]);
    });
    
    dispatch_group_notify(group, concurrentQueue, ^(){
        NSDate *endDate = [NSDate date];
        NSLog(@" ********** 并行队列所有任务已经完成. 所花时间一共为 %f ********** ",[endDate timeIntervalSinceDate:startDate]);
    });
    
    /**
     *  同步等待 group 中的所有任务完成。
     */
//    if (dispatch_group_wait(group, DISPATCH_TIME_FOREVER) == 0) {
//        NSDate *endDate = [NSDate date];
//        NSLog(@" ********** 串行队列所有任务已经完成. 所花时间一共为 %f ********** ",[endDate timeIntervalSinceDate:startDate]);
//    } else {
//        
//    }
    
    // 可以通过这个log打印的时间，来判断 dispatch_group_wait 和 dispatch_group_notify 是同步还是异步
    NSLog(@"testDispatchGroupAsync 结束");
    
    /**
     *  备注：
     *
     *  1: 当groud中的任务存在于多个队列中的时候，调用notify时，把其中一个queue传递进去即可。
     *     所以，测试例子中的最后两个notifiy。有一个就够了而且也不用 taskNumber 来判断任务是否完成了。
     *  2: dispatch_group_async 是异步的。所以会分别跟踪每一个任务。
     *  3: dispatch_group_notify 和 if (dispatch_group_wait(group, DISPATCH_TIME_FOREVER) == 0) 作用是相等的。
     *     不同点是，dispatch_group_notify 是异步的，不会阻塞线程。dispatch_group_wait 是同步的，是阻塞当前线程的。
     */
}

@end
