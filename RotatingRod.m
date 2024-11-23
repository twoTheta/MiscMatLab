close all
clear

filename = 'test.mp4';
v = VideoWriter(filename,'MPEG-4');
open(v);

x0 = 0.1;
v0 = 0;
OM = 2*pi/10;
dt = 1/60;

ViewWidth = 5;
trange = [0 10];
t = trange(1):dt:trange(2);

%%% Solutions for trajectory
A=(x0+v0/OM)/2;
B=(x0-v0/OM)/2;

x=A*exp(OM*t)+B*exp(-OM*t);
xdot = OM*(A*exp(OM*t)-B*exp(-OM*t));

F_cf = OM^2*x;
F_cor = -2*OM*xdot;
F_rod_rot = -F_cor;
F_rod_in = [F_cor.*sin(th); -F_cor.*cos(th)];

th = t*OM;
x_in = x.*cos(th);
y_in = x.*sin(th);

%%% Make the graphe
fig = figure("Position",[0 0 800 400]);
i = 1;

%%%% Inertial Frame
subplot(1,2,1)

scatter(0,0,'k','markerfacecolor','k');  hold on;
p_IN=scatter(x_in(i),y_in(i),'ok');
A_rod_in = quiver(x_in(i),y_in(i),F_rod_in(1,i),F_rod_in(2,i),'r','linewidth',2,'MaxHeadSize',0.5);
l_in = line([-1 1]*ViewWidth,[-1 1]*ViewWidth*tan(th(i)),'color','k');
traj = plot(x_in(1),y_in(1));  hold off;

xlim([-1 1]*ViewWidth)
axis equal
ylim([-1 1]*ViewWidth)
box on;
set(gca,'xtick',-ViewWidth:1:ViewWidth)
set(gca,'ytick',-ViewWidth:1:ViewWidth)
grid on;

text(0,ViewWidth+1,"Inertial Frame","HorizontalAlignment","center")

%%%% Rotating Frame
subplot(1,2,2)

scatter(0,0,'k','markerfacecolor','k'); hold on;
p_NI=scatter(x(i),0,'ok');
line([-1 1]*ViewWidth,[0 0],'color','k')
A_cf = quiver(x(i),0,F_cf(i),0,'b','linewidth',2,'MaxHeadSize',0.5);
A_cor = quiver(x(i),0,0,F_cor(i),'linewidth',2,'MaxHeadSize',0.5);
A_rod = quiver(x(i),0,0,-F_cor(i),'r','linewidth',2,'MaxHeadSize',0.5); hold off

xlim([-1 1]*ViewWidth)
axis equal
ylim([-1 1]*ViewWidth)

set(gca,'xtick',-ViewWidth:1:ViewWidth)
set(gca,'ytick',-ViewWidth:1:ViewWidth)


box on;
grid on;
text(0,ViewWidth+1,"Rotating Frame","HorizontalAlignment","center")



writeVideo(v,getframe(gcf))

while (abs(x_in(i))<=ViewWidth && abs(y_in(i))<=ViewWidth)
    i=i+1;
    set(p_NI, 'xdata', x(i));
    set(A_cf,"XData", x(i));
    set(A_cf,"UData",F_cf(i));
    set(A_cor,"XData", x(i));
    set(A_cor,"VData",F_cor(i));
    set(A_rod,"XData", x(i));
    set(A_rod,"VData",-F_cor(i));

    set(p_IN, 'xdata', x_in(i));
    set(p_IN, 'ydata', y_in(i));
    set(A_rod_in,"XData", x_in(i));
    set(A_rod_in,"YData", y_in(i));
    set(A_rod_in,"UData", F_rod_in(1,i));
    set(A_rod_in,"VData", F_rod_in(2,i));

    set(traj,"XData",x_in(1:i));
    set(traj,"YData",y_in(1:i));

    set(l_in,"YData",[-1 1]*ViewWidth*tan(th(i)));

    writeVideo(v,getframe(gcf))
end
close(v)
