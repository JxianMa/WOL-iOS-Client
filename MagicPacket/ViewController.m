//
//  ViewController.m
//  MagicPacket
//
//  Created by MaJixian on 6/28/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import "ViewController.h"
#import <CFNetwork/CFNetwork.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

@interface ViewController ()

@end

@implementation ViewController


- (IBAction)sendMagicPacket:(UIButton *)sender
{
    //construct mac address
    unsigned char macAddrToSend[102];
    unsigned char mac[6];
    for(int i = 0; i < 6; i++)
    {
        macAddrToSend[i] = 0xff;
    }
        //substitute the mac address of your device here
    mac[0] = 0x80;
    mac[1] = 0xe6;
    mac[2] = 0x50;
    mac[3] = 0x0d;
    mac[4] = 0xda;
    mac[5] = 0x42;
    for(int i = 1; i <= 16; i++)
    {
        memcpy(&macAddrToSend[i * 6], &mac, 6 * sizeof(unsigned char));
    }
    
    //construct ip address and port number
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_len = sizeof(addr);
    addr.sin_family = AF_INET;
    addr.sin_port = htons(9);
    //substitute the ip address of your device here
    inet_aton("192.168.1.105", &addr.sin_addr);
    
    //create socket using CFSocket
    //sending magic packet through UDP protocol
    CFSocketRef WOLSocket;
    WOLSocket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_DGRAM, IPPROTO_UDP, 0, NULL, NULL);
    if ( WOLSocket == NULL) {
        NSLog(@"CfSocketCreate Failed");
    } else if( WOLSocket ) {
            NSLog(@"Socket created :)");
            CFDataRef sendAddr = CFDataCreate(NULL, (unsigned char *)&addr, sizeof(addr));
            CFDataRef Data = CFDataCreate(NULL, (const UInt8*)macAddrToSend, sizeof(macAddrToSend));
            CFSocketSendData(WOLSocket, sendAddr, Data, -1);
    }
}


@end
