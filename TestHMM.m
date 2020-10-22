function [outpred2] = TestHMM(bnet, test, class, k, order, step, var)
%function [pred LSS] = TestHMM(bnet, test, class, order, step)

%takes in a bnet and a testset as a cell of cells test{i}{x,t}
    bnet
    outpred=[];
    seqnum=length(test);
    [n temp] = size(test{1});

    hs = k; % num of hidden states or 1 if LDS

    stest=test;
    
    for loop = 1:seqnum
        [n testlen] = size(test{loop});

        stesti=(stest{loop})
        testdata{loop}=[cell(1,testlen); (stesti)]

      
        testplotdat{loop}=stesti;
    end

    nnodes = n+1;% vars + 1 hidden


       
    plotxy=[];
    %NEED TO BUILD A LOOP HERE FOR ALL TEST SET CELLS
    for loop=1:seqnum
        
        
    %to set the engine based on bnet2
    %engine = smoother_engine(hmm_2TBN_inf_engine(bnet2));
    engine = jtree_unrolled_dbn_inf_engine(bnet, order);
    %engine = smoother_engine(jtree_2TBN_inf_engine(bnet2));

    
    %testlen=length(testplotdat{loop})
    
    %inc-step prediction on all data
    [n testlen] = size(test{loop});
    pred=zeros(n+1,testlen-(order-1));
    %confused=testdata{loop}
    
    for t = 1:(testlen-1)
        
    testinput = cell(nnodes,order);
  	for i = 2:nnodes
        testinput{i,1}=testdata{loop}{i,t};
        %testinput{i,2}=testdata{loop}{i,t+1};
    end
        testinput;
   
        [engine, ll] = enter_evidence(engine, testinput);

        [engine, ll] = enter_evidence(engine, testinput);

    %        marg = marginal_nodes(engine, 1, 1);        
    %        marg.T;
            marg = marginal_nodes(engine, 1, order);%order);
            % if HMM
            besthx=1;
            besthp=0;
            for hx=1:hs
                if marg.T(hx)>besthp
                    besthp=marg.T(hx);
                    besthx=hx-1;
                end
            end
        pred(1,t)= marg.T(2);%besthx;%
        for i = 2:n+1
            marg = marginal_nodes(engine, i, order);
            bestx=1;
            bestp=0;
            for j=1:bnet.node_sizes(i)
                if marg.T(j)>bestp
                    bestp=marg.T(j);
                    bestx=j;
                end
            end
            bestp
            bestx
            pred(i,t)=bestx;%marg.mu;
            %TEMP
            if i==var %complication var 2)
                pred(i,t)=marg.T(2);
            end
        end
    
    % pred=pred';
    end%t

    outpred2{loop}= pred';

    size(stesti);
    end

end

