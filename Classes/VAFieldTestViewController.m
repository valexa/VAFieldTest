//
//  VAFieldTestViewController.m
//  VAFieldTest
//
//  Created by Vlad Alexa on 7/6/10.
//  Copyright NextDesign 2010. All rights reserved.
//

#import "CoreTelephony.h"
#include <dlfcn.h>

CFMachPortRef mach_port;
CTServerConnectionRef conn;
CFRunLoopSourceRef source;	

void ConnectionCallback(CTServerConnectionRef connection, CFStringRef string, CFDictionaryRef dictionary, void *data) {
	NSLog(@"ConnectionCallback");
	CFShow(dictionary);
}

void NotifCallback(){
	NSLog(@"NotifCallback");
}

void Dump(void* x, int size) {
	char* c = (char*)x;
	int i;
	for (i = 0; i < size; i++) {
		printf(" %x ", c[i]);
	}
	NSLog(@"Dumped");
}

void start_monitor(){
	conn = _CTServerConnectionCreate(kCFAllocatorDefault, ConnectionCallback,NULL);
	NSLog(@"connection=%d",conn);	
	//Dump(conn, sizeof(struct __CTServerConnection));	
	mach_port_t port  = _CTServerConnectionGetPort(conn);
	NSLog(@"port=%d",port);		
	mach_port = CFMachPortCreateWithPort(kCFAllocatorDefault,port,NULL,NULL, NULL);	
	NSLog(@"mach_port=%x",CFMachPortGetPort(mach_port));	
	source = CFMachPortCreateRunLoopSource ( kCFAllocatorDefault, mach_port, 0);
	CFRunLoopAddSource([[NSRunLoop currentRunLoop] getCFRunLoop], source, kCFRunLoopCommonModes);
	_CTServerConnectionCellMonitorStart(mach_port,conn);	
	
}

void register_notification(){
	if (!mach_port || !conn) return;	
	void *libHandle = dlopen("/System/Library/Frameworks/CoreTelephony.framework/CoreTelephony", RTLD_LOCAL | RTLD_LAZY);
	void *kCTCellMonitorUpdateNotification = dlsym(libHandle, "kCTIndicatorsSignalStrengthNotification");
	if( kCTCellMonitorUpdateNotification== NULL) NSLog(@"Could not find kCTCellMonitorUpdateNotification");	
	int x = 0; //placehoder for callback
	_CTServerConnectionRegisterForNotification(conn,kCTCellMonitorUpdateNotification,&x); 	
}

void printInfo(){
	if (!mach_port || !conn) return;
	
	int count = 0;
	_CTServerConnectionCellMonitorGetCellCount(mach_port, conn, &count);
	
	if (count > 0) {
		int i;
		for (i = 0; i < count; i++) {
			CellInfoRef cellinfo;
			_CTServerConnectionCellMonitorGetCellInfo(mach_port, conn, i, &cellinfo);
			NSLog(@"Cell site: %d, MNC: %d ", i, cellinfo->servingmnc);
			NSLog(@"Location: %d, Cell ID: %d, Station: %d, ", cellinfo->location,cellinfo->cellid, cellinfo->station);
			NSLog(@"Freq: %d, RxLevel: %d, ", cellinfo->freq, cellinfo->rxlevel);
			NSLog(@"C1: %d, C2: %d", cellinfo->c1, cellinfo->c2);
		}		
	}else {
		NSLog(@"No Cell info");		
	}
}


int getSignalStrength()
{
	void *libHandle = dlopen("/System/Library/Frameworks/CoreTelephony.framework/CoreTelephony", RTLD_LAZY);
	int (*CTGetSignalStrength)();
	CTGetSignalStrength = dlsym(libHandle, "CTGetSignalStrength");
	if( CTGetSignalStrength == NULL) NSLog(@"Could not find CTGetSignalStrength");	
	int result = CTGetSignalStrength();
	dlclose(libHandle);	
	return result;
}

#import "VAFieldTestViewController.h"

@implementation VAFieldTestViewController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];	
	
	start_monitor();	
	register_notification();	
	
	//[(NSValue *)[(NSDictionary *)userInfo objectForKey:@"kCTIndicatorsSignalStrength"] getValue:&rawStrength];	
	//kCTIndicatorsSignalStrength
	//kCTIndicatorsSignalStrengthNotification
	//kCTIndicatorsGradedSignalStrength
	//kCTIndicatorsRawSignalStrength	
	
	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(signalLoop) userInfo:nil repeats:YES];	
	[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(infoLoop) userInfo:nil repeats:YES];			
	
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return  YES;
}

- (void)dealloc {
    [super dealloc];
}

-(void)signalLoop{		
	[strength setText:[NSString stringWithFormat:@"%i",getSignalStrength()]];
}

-(void)infoLoop{
	printInfo();
}

@end
