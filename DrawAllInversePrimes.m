close all
clear
vals=101:300;
vals=vals(isprime(vals));

for i = 1:length(vals)
    val = vals(i);
    N=1500;
    digits(N)
    num=vpa(1/val,N);
    base = 6;
    
    num1=floor(num);
    if num1>0
        nums=dec2base(double(num1),base);
        num = num-floor(num);
    else
        nums='';
    end
    
    while length(nums)<N
        num = num*base;
        nums=[nums char(floor(num))];
        num = num-floor(num);
    end
    
    while nums(1)=='0'
        nums=nums(2:end);
    end
    
    pts = [0 0];
    dir = 0;
    for i = 1:length(nums)
        dir = mod(dir+str2double(nums(i)),base);
        pts(i+1,:)=pts(i,:)+[cos(2*pi*(dir)/base) sin(2*pi*(dir)/base)];
    end
    
    figure
    line(pts(:,1),pts(:,2))
    axis equal
    
    xlim([min(min(pts(:,1))) max(max(pts(:,1)))]+[-1 1])
    ylim([min(min(pts(:,2))) max(max(pts(:,2)))]+[-1 1])
    box on;
    title(['Num = 1/' num2str(val) ', base = ' num2str(base)])
    saveas(gcf,['base' num2str(base) 'Val' num2str(val) '.png'])
    close
end