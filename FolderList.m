
cnt2 = 1;


for Lp1 = 1:length(FileList)

    FigChk = FileList(Lp1).name;
    if length(FigChk) > 5 && strcmp(FigChk(end-5:end),'52.fig')
      open(cell2mat(strcat(d,'\',FileList(Lp1).name)));
      ProcessFigure;
      
    end
    
     
    ChkPnt = FileList(Lp1).isdir;
    if ChkPnt==1
        DirName{cnt2} = FileList(Lp1).name;
        cnt2=cnt2+1;
    end
    
end