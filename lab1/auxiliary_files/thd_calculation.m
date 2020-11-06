clear all
close all

x=[textread('resultsc.txt')/128; zeros(1020, 1)];
%thd(x,10e3, 7)

fs = 10000;
N = length(x);
figure
z=fft(x)/(127/128);
df=fs/N;
f=0:df:(fs/2);
figure
plot(f, 20*log10( abs( z(1:(length(z)+1)/2) ) ) );
%bq=[0.4140625, 0.4140625];
%aq=[1, -0.1640625];
bq=[53/128, 62/128, 8/128];
aq=[1, 0 ,-3/128];
in=[127; zeros(N-1,1)]/128;
sw=[0,0];
y=zeros(1,length(in));
for ii = 1:length(in)
    w=(in(ii)+aq(2)*sw(2));
    y(ii)=(bq(1)*w+bq(2)*sw(1)+bq(3)*sw(2));
    sw(2)=sw(1);
    sw(1)=w;
end
[h, w] = freqz(bq, aq);
hold on
plot(w/pi*fs/2, 20*log10(abs(h)), '--'); 
