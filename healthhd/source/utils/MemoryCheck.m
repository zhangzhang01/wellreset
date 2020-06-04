//
//  SqliteHelper.m
//  UTVgo
//
//  Created by wen on 12-12-12.
//  Copyright (c) 2012年 UTVGO. All rights reserved.
//

#import "MemoryCheck.h"
#include <sys/sysctl.h>
#include <mach/mach.h>

@implementation MemoryCheck

+(void)Run
{
    static MemoryCheck* instance = nil;
    if(instance == nil)
    {
        instance = [[MemoryCheck alloc] init];
        [instance run];
    }
}

//MARK: 可用内存
- (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),HOST_VM_INFO,(host_info_t)&vmStats,&infoCount);
    if(kernReturn != KERN_SUCCESS) 
    {
        return NSNotFound;
    }
    return ((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0;
}


//MARK: 已使用内存
- (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO, (task_info_t)&taskInfo, &infoCount);
    if(kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return taskInfo.resident_size / 1024.0 / 1024.0;
}


-(natural_t)get_free_memory 
{
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    vm_statistics_data_t vm_stat;
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        NSLog(@"Failed to fetch vm statistics");
        return 0;
    }
    /* Stats in bytes */
    natural_t mem_free = (natural_t)(vm_stat.free_count * pagesize);
    return mem_free;
}

-(void)run
{
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(onTimerMemoryCheck:) userInfo:nil repeats:YES];
}

- (void)onTimerMemoryCheck:(id)sender
{
    NSLog(@"Memory %0.2f M %0.2f M",[self usedMemory], [self availableMemory]);
}

@end
