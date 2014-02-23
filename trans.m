function H=trans(x1,y1,x1p,y1p,x2,y2,x2p,y2p,x3,y3,x3p,y3p,x4,y4,x4p,y4p)
M=[x1 y1 x1p y1p x2 y2 x2p y2p x3 y3 x3p y3p x4 y4 x4p y4p];
L1=[x1 y1 1 0 0 0 -x1*x1p -y1*x1p];
L2=[0 0 0 x1 y1 1 -x1*y1p -y1*y1p];
L3=[x2 y2 1 0 0 0 -x2*x2p -y2*x2p];
L4=[0 0 0 x2 y2 1 -x2*y2p -y2*y2p];
L5=[x3 y3 1 0 0 0 -x3*x3p -y3*x3p];
L6=[0 0 0 x3 y3 1 -x3*y3p -y3*y3p];
L7=[x4 y4 1 0 0 0 -x4*x4p -y4*x4p];
L8=[0 0 0 x4 y4 1 -x4*y4p -y4*y4p];
Y=([x1p y1p x2p y2p x3p y3p x4p y4p])';
X=[L1;L2;L3;L4;L5;L6;L7;L8];
G=X'*X;
%     if rank(G)~=8
%         H = eye(3);
%     else
        A=inv(X'*X)*X'*Y;
        H=[A(1) A(2) A(3);A(4) A(5) A(6);A(7) A(8) 1];
        %H=inv(H);
%     end
end




