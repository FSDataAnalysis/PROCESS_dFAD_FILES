gcf;
h_t = findobj(gca,'displayname','Conservative force: Sader-Katan: Smooth');

txts = get(findobj('type','text'),'string');
F_min = txts(1);
F_min = str2double(F_min{1,1}(12:23));


X_t = get(h_t,'xdata');
Y_t = get(h_t,'ydata');
close;
figure(100);
hold on;
plot(X_t,Y_t,'displayname',cell2mat(strcat(d,'\',FileList(Lp1).name)));

whr = find(Y_t>CL*min(Y_t));
Rel_Y = Y_t;
Rel_Y(whr) = [];

Rel_X = X_t;
Rel_X(whr) = [];

cnt1 = 1;
C_V=[];
while cnt1 < length(Rel_X)
    whr = find(Rel_X==Rel_X(1,cnt1));
    C_V = [C_V; Rel_X(1,whr(1)) mean(Rel_Y(1,whr))];
    if length(whr)>1
    Rel_X(:,whr)=[];
    end
    cnt1 = cnt1+1;
end


d_Rel_X = C_V(2:end,1)-C_V(1:end-1,1);

Area_depth = sum(d_Rel_X.*(C_V(1:end-1,2)-CL*min(Y_t)));
figure(100);
bar(C_V(:,1),C_V(:,2)-CL*min(Y_t));
hold off

ResulrMat(Res_cnt,1:3) = [F_min Area_depth   C_V(1,1)-C_V(end,1)];
Ref_Result(Res_cnt,1) = (strcat(d,'\',FileList(Lp1).name));

Res_cnt = Res_cnt+1;
