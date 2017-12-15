function Simulate_robot(v,w)
    X = 0;
    Y = 0;
    Theta = 0;
    del_t = 1;
    X_Rec=[];
    Y_Rec=[];
    iterations = 100;
    
    %Simulate using learned model
    load('params');
    figure;
    X = 0; 
    Y = 0;
    Theta = 0;
    X_Rec=[];
    Y_Rec=[];
    if(w==0)
        w=realmin; 
    end

    %Simulate robot trajectory
    for i=1:iterations
       for j=1:size(par,2) 
           Output = par{j}(1);
           for Add_Poly=1:(size(par{j},1)-1)/3
                Output = Output + par{j}(2 + (Add_Poly-1)*3) * v^Add_Poly + par{j}(3 + (Add_Poly-1)*3) * w^Add_Poly + par{j}(4 + (Add_Poly-1)*3) * (v*w)^Add_Poly;
           end 
           if(j==1)
               X_local = Output;
           elseif(j==2)   
              Y_local = Output;
           else
              Theta_local = Output;
           end
       end
       Rot = [cos(Theta) -sin(Theta);sin(Theta) cos(Theta)];
       [XY_Trans] = Rot*[X_local;Y_local];
       X = X + XY_Trans(1); 
       Y = Y + XY_Trans(2);
       X_Rec=[X_Rec X];
       Y_Rec=[Y_Rec Y];
       Theta = Theta + Theta_local;
       clf;
       hold on;
       axis([-150 150 -150 150]);
       plot(X_Rec,Y_Rec,'color',[0 1 0],'linewidth',5);
       drawrobot( X,Y,Theta ); 
       xlabel('Robot trajectory simulation using the learned model parameters');
       drawnow;
    end
end






