#ifndef CORETELEPHONY_H_
#define CORETELEPHONY_H_

#include <CoreFoundation/CoreFoundation.h>

struct __CTServerConnection {
  int a;
  int b;
  CFMachPortRef myport;
  int c;
  int d;
  int e;
  int f;
  int g;
  int h;
  int i;
};
typedef struct __CTServerConnection CTServerConnection;
typedef CTServerConnection* CTServerConnectionRef;

struct __CellInfo {
  int servingmnc;
  int network;
  int location;
  int cellid;
  int station;
  int freq;
  int rxlevel;
  int c1;
  int c2;
};
typedef struct __CellInfo CellInfo;
typedef CellInfo* CellInfoRef;

typedef void (*CTServerConnectionCallback)(CTServerConnectionRef, CFStringRef, CFDictionaryRef, void *);

CTServerConnectionRef _CTServerConnectionCreate(CFAllocatorRef allocator, CTServerConnectionCallback, int *unknown);

mach_port_t _CTServerConnectionGetPort(CTServerConnectionRef);

void _CTServerConnectionCellMonitorStart(CFMachPortRef port, CTServerConnectionRef);

void _CTServerConnectionRegisterForNotification(CTServerConnectionRef,void *,void(*callback)(void));
void kCTCellMonitorUpdateNotification();

void _CTServerConnectionCellMonitorGetCellCount(CFMachPortRef port,CTServerConnectionRef,int *cellinfo_count);

void _CTServerConnectionCellMonitorGetCellInfo(CFMachPortRef port,CTServerConnectionRef,int cellinfo_number,CellInfoRef* ref);

int _CTServerConnectionSetVibratorState(int *, void *, int, int, int, int, int);

#endif  // CORETELEPHONY_H_
