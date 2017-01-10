function [smooth] = Z_jfilt(data,n)%filter,bnan)
% 2005 (approx.) Jonathan Lilly, modified by Parker MacCready
%
% INPUT:
%  data is the data vector, OR a matrix of COLUMN vectors
%  n is the filter length
%
% OUTPUT:
%  smooth is the same size as data, filtered along columns, and
%     padded with NaN's at the ends
%  if n=1 it just returns matrix you gave it.
%
% by default it uses a Hanning window

if n == 1; smooth = data; return; end; % just do nothing

%filter = hanning(n); % Hanning from the signal processing toolbox
% filter=ones(n,1); % Boxcar
ff = cos(linspace(-pi,pi,n+2));
ff = ff(2:end-1);
filter = (1 + ff)/2; % Hanning from scratch
filter=filter./sum(filter);
smooth=zeros(size(data));
a=round(n/2);
N=size(data,1);
for ii=1:size(data,2)
    temp=conv(data(:,ii),filter);
    smooth(:,ii)=temp(a:a+N-1);
    smooth(1:n,ii)=nan*ones(n,1);
    smooth(N-n+1:N,ii)=nan*ones(n,1);
end




