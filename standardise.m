function [ result,m,s] = standardise(data)
%the function removes the sample mean from each observation and 
%and then divides by the sample standard deviation

%[n m]= size(data);
datMean=mean(data);
datStd=std(data);


%result= zeros(1,length(data));
result=[];

%matrix needs to be converted to a row vector

%transformation
 [nb_rows, nb_cols] = size(data); % determine number of rows and columns
 for row_i = 1:nb_rows
  for col_i = 1:nb_cols
    result(row_i, col_i) = (data(row_i, col_i) - datMean(col_i)) / datStd(col_i);
  end
 end 
 m=mean(result);
 s=std(result);
 
end