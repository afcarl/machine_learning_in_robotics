function draw_wheel( x ,y,length,width,angle )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    nbDrawingSeg = 40;
    t = linspace(-pi, pi, nbDrawingSeg)';
    D=[length^2 0;
        0 width^2];
    V=[cos(angle) cos(angle-pi/2);
        sin(angle) sin(angle-pi/2)];
    Sigma = V*D/V; 
    Mu = [x y];

    stdev = sqrtm(1.0.*Sigma);     %For plotting twice of standarddeviation
    X = [cos(t) sin(t)] * real(stdev) + repmat(Mu,nbDrawingSeg,1);
    %patch(X(:,1), X(:,2), lightcolor, 'lineWidth', 2, 'EdgeColor', color);
    h = plot(X(:,1),X(:,2),'-','lineWidth',2,'color',[0 0 1]);
    %h(nbData+j) = plot(Mu(1,:), Mu(2,:), 'x', 'lineWidth', 2, 'color', color);
  

    
end

