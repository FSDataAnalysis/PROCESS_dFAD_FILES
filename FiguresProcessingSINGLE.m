clear all; clc; close all 

Matrix_values=[];

prompt= {'Multiple ref:','Number of points:', 'Initial:','Final:', 'Stats_FAD_single (0/1)'};
dlg_title='Input Data';
num_lines=1;


excel_file_dFAD_single = 'mydata_dFAD_single.xlsx';

if exist(excel_file_dFAD_single)==1
    delete(excel_file_dFAD_single);
end
%%%% Modification S Santos 2014 Nov 07 
%%%% Disambiguation:

%%%% Multiple ref=0 then you look for Work of adhesion at Initial and delta FAD at final

%%%% Initial: 0.8 means find deltaFAD at 0.8FAD as defined in:
%%%% Amadei, C. A., Tang, T. C., Chiesa, M. & Santos, S.,  The Journal of Chemical Physics 139, 084708 (2013).


%%%% Multiple ref=1 then you look for Work of adhesion and delta FAD for
%%%% Number of points 

%%%% Definition of Number of points: Number of points minimum is 2.
%%%% If Number of points = 2 then work of adhesion and dFAD at Initial and Final
%%%% points. 

%%%% If Number of points >2 then it looks for other:
%%%% Example, Number of points=3 
%%%% Initial=0.05 
%%%% FInal= 0.8
%%%% (0.8-0.05)/2=0.375. Then it looks at: 0.05, 0.375 and 0.8. 

% Edis_M=cat(1, Edis_M,  Edis_max_notcropped);

default={'0','2', '0.05','0.8','1'};
answer=inputdlg(prompt,dlg_title,num_lines,default);


multiple=str2double(answer(1));
Npoints=str2double(answer(2));
initial_value=str2double(answer(3));
final_value=str2double(answer(4));
Stats_FAD_single=str2double(answer(5));

if multiple==0   
    dumb_loop=2;
    CL_vector=[initial_value final_value];
    
elseif multiple==1  
    dumb_loop=Npoints;
    
    intervals_in_between=(final_value-initial_value)/(Npoints-1);
    
    
    CL_vector=initial_value:intervals_in_between:final_value;
    
else  % it just calculates the   
    dumb_loop=2; 
end



for jjj=1:dumb_loop

    CL =CL_vector(jjj);

    ResulrMat = [];
    Res_cnt = 1;
    FileList = dir;
    FileList(1:2,:)=[];
    FolderList;
    DirLstL_0 = DirName;


    a = cd;
    b = strcat(a,'\',DirLstL_0);

    FileList = dir(cell2mat(b));
    FileList(1:2,:)=[];
    FolderList;
    DirLstL_1{1} = [b, DirName];
   
    Lp_Dir_lst = DirLstL_1;

    for Lv = 1:7
        DirLstL_Int = []; 
% 
%         Clp2=1;
        for Clp2 = 1:size(Lp_Dir_lst,1)

%                Lp2=2;
            for Lp2 = 2:length(Lp_Dir_lst{Clp2,1})
                
                DirName=[];
                d = strcat(Lp_Dir_lst{Clp2,1}(1),'\',Lp_Dir_lst{Clp2,1}(Lp2));

                FileList = dir(cell2mat(d));
                FileList(1:2,:)=[];



                FolderList;

                if isempty(DirName)==1
                continue
                end

                DirLstL_trans{Lp2-1,1} = [d, DirName];
            end
            
            DirLstL_Int = [DirLstL_Int;DirLstL_trans];
            DirLstL_trans= [];
        end

        %===============  Step 2.1  ======================================= 

        Lp_Dir_lst = DirLstL_Int;

    end

    ResulrMat(:,2)=ResulrMat(:,2).*ResulrMat(:,1);  %%% turn into work of adhesion in Joules
    
    Matrix_values(:,:,jjj)=ResulrMat;
    
   
end

close all;

if Stats_FAD_single==1
    
    number_of_points=dumb_loop;
    
    col_names={'Force Adhesion','Work of Adhesion', 'dFAD', 'Percentage'};
    
    xlswrite(excel_file_dFAD_single, col_names,1);   
    
    foo_n=size(Matrix_values);
    
    dd_number_files=foo_n(1);
    
    M_dFAD=[];
    
    number_of_files_odd=mod(number_of_points,2);
    
    if number_of_files_odd==0
        numb_points_foo=(number_of_points/2);
    
    elseif number_of_files_odd==1
        numb_points_foo=((number_of_points-1)/2);
    else
        error('Mistake in number of files at Main code Line 289');
    end
        
    for iii=1:numb_points_foo
        
        k=1+(iii-1)*2;
        New_col_1=(ones(1, dd_number_files)*CL_vector(k))';
        New_col_2=(ones(1, dd_number_files)*CL_vector(k+1))';
        dumb_1_m=[Matrix_values(:,:,k) New_col_1];
        dumb_2_m=[Matrix_values(:,:,k+1) New_col_2];
        
        M_dFAD_dumb=cat(1, dumb_1_m ,dumb_2_m);
        M_dFAD=[M_dFAD; M_dFAD_dumb];
    end
    
    if number_of_files_odd==1
    
        New_col_3=(ones(1, dd_number_files)*CL_vector(end))';
        dumb_3_m=[Matrix_values(:,:,end) New_col_3];
        M_dFAD=[M_dFAD; dumb_3_m];
    end
    
    xlswrite(excel_file_dFAD_single, M_dFAD,1, 'A2');
    
end

    