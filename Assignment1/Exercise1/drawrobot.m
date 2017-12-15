function drawrobot( x,y,theta )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    %Robot parameters

    Radius = 10;
    wheel_dia =5; 
    
    %Draw body
    circle(x,y,Radius,3,[0 0 1]);  

    %Draw heading_Direction
    circle(x+Radius*0.8*cos(theta),y+Radius*0.8*sin(theta),Radius/10,3,[1 0 0]);
    
    %Draw right_Wheel
    draw_wheel(x+Radius*cos(theta-pi/2),y+Radius*sin(theta-pi/2),wheel_dia,wheel_dia/2,theta);
    
    %Draw left_Wheel
    draw_wheel(x+Radius*cos(theta+pi/2),y+Radius*sin(theta+pi/2),wheel_dia,wheel_dia/2,theta);
%     axis equal;
end

