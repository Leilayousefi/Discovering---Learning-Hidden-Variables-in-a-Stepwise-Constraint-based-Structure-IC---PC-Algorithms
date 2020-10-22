clear all
clc

%%%DIABETES DATA
file_spec = 'PaviaDatMacVasc.xlsx';
data0 = xlsread(file_spec);
% Pavdat = csvread('NEWDATA.csv', 1);
data1=data0(:,[1:13]);

data1(:,[2]) = Discretise(data1(:,[2])', 3)';
data1(:,[9:13]) = Discretise(data1(:,[9:13])', 3)';
data1(:,2:13)=data1(:,2:13)+1;
tot_y = cell(1,8);
tot_y_unbalanced = cell(1,8);
tot_t = cell(1,8);
tot_t_unbalanced = cell(1,8);
traincases = [1:179];
tot_x = cell(1,8);
testcases = [180:356];
data1= data1(1000:12936,:);
traincases = [1:169];
testcases = [170:347];

dataa = data1;

[datlen datn]=size(data1);
%datn=datn-1;
datcell={};
datcell_pos= {};
datcell_neg = {};
patcell=[];
patc = [];
% patcell_Pos = [];
% patcell_Neg = [];
% datcell_Pos = [];
% datcell_Neg = [];
% datc_both ={};
% datcell_both = {};
% datcell_traincell_BT = {};
classcell={};
count=1;
patlen=0;
ids=[];
patient = 0;
  overlap_p = 0;
        overlap_N = 0;
        datc = [];
         traindat = {};
    trainIDout = {};
     testdat = {};
    testIDout = {};
    ID = [];
for i = 2:datlen
    if (dataa(i,1)==dataa(i-1,1))
        patcell=[patcell;dataa(i,:)];
        patlen=patlen+1;
%         limt_1=limt_1+1;
    else
        if (patlen>1)
            patient = patient +1;
            datcell{count}=[num2cell(patcell(:,2:datn)')];
            classcell{count}=[num2cell(patcell(:,3)')];
            count=count+1;
            ids = [ids dataa(i,1)];
        end
        patcell=[dataa(i,:)];  
        patlen=1;
    end
end
seqnum=length(datcell);
    [temp n] = size(datcell{1});

traincell=datcell(traincases);
testcell=datcell(testcases);
testclass = [];
for var = 2:5
%%
% Unbalanced Data
ns=[3 2 2 2 2 2 2 3 3 3 3 3];
[dags inter] = PATReveal(ns, traincell);
ns=[3 2 2 2 2 2 2 3 3 3 3 3 3 2 2 2 2 2 2 3 3 3 3 3];
[dags intra] = PATK2(ns, traincell);
intra1 = round(intra);
inter1 = round(inter);
[bnet LLtrace] = TrainHMM(traincell, [1:datn],[],2,intra1, inter1)% cell2num(traincell)

[outpred] = TestHMM(bnet,testcell,testclass, 2, 2, 2,var+1)
% draw_graph(bnet.dag)
patlen=length(outpred)
y_unb=[];
t_unb=[];
for i = 1:patlen
    temp1=cell2mat(testcell{i}(var,:))
    temp1=temp1(2:length(temp1))'
    temp2=outpred{i}(:,var+1)

    y_unb = [y_unb;temp2];
    t_unb = [t_unb;temp1];
end
tot_t_unbalanced{var} = t_unb;
tot_y_unbalanced{var} = y_unb;
% [err cm] = confusion(t'-1,y')
% hold on
% plotrocc(t'-1,y')
% hold off
% plotconfusion(t'-1,y')

% Unbalanced Data end
%%


%%

%%
%%
%%
%%var 
[traini3 traind3 traincelladd3] = TSBootstrapPAT6(traincell,var);
    traincell3 = [traincell traincelladd3];
ns=[3 2 2 2 2 2 2 3 3 3 3 3];
[dags, inter] = PATReveal(ns, traincell3);
ns=[3 2 2 2 2 2 2 3 3 3 3 3 3 2 2 2 2 2 2 3 3 3 3 3];
[dags intra] = PATK2(ns, traincell3);
intra1 = round(intra);
inter1 = round(inter);
[bnet LLtrace3] = TrainHMM(traincell3, [1:datn],[],2,intra1, inter1)% cell2num(traincell)
[outpred] = TestHMM(bnet,testcell,testclass, 2, 2, 2,var+1)
% draw_graph(bnet3.dag)
patlen=length(outpred)
y=[];
t=[];
x=[];file_spec
for i = 1:patlen
    temp1=cell2mat(testcell{i}(var,:))
    temp1=temp1(2:length(temp1))'
    temp2=outpred{i}(:,var+1)
    temp3=outpred{i}(:,1);
    x = [x;temp3];
    y = [y;temp2];
    t = [t;temp1];
end
disp('for var result is')
tot_t{var} = t;
tot_y{var} = y;
tot_x{var} = x;
% tot_y = [tot_y,y]
end %for var

% % % % % L = cellfun('size',testcell,2)'
% [err3 cm3] = confusion(t3'-1,y3')
% hold on
% plotrocc(t3'-1,y3')
% hold off
% plotconfusion(t3'-1,y3')
%%balanced algorithm
%%
% Scatter plot
%%
% [datlen datn]=size(data1);
% subplot(datn,1,1);
% for p=1:(datn-2)
%     
%     subplot(datn,1,p);
%     for i = 1:(length(outpred))
%         
%         [temp testlen]=size(testcell{i});
%         %scatter
%         plot(outpred{i}(:,p+1),cell2mat(testcell{i}(p,2:testlen)), '.');
%         
%         hold on
%     end
% end
%%
%%end scatter
%%
% % % % [err cm] = confusion(t'-1,y')
% % % % [fp tp]= roc([t-1,y])
% % % % auc1 = auc([t-1,y])
% % % % plot(tp,fp)