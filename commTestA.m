clc;
instrreset; delete(instrfindall); clear all; close all; 

ipA = '192.168.0.2';  % Luis Pc Home Ip 
portA = 50000;        
ipB = '192.168.0.6';  % Luis Mac Ip 
portB = 50001;  
udpA = udp(ipB,portB,'LocalPort',portA);
fopen(udpA);
