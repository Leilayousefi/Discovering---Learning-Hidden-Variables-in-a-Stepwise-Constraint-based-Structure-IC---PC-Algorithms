function [falseAlarmRate, detectionRate, area, th] = plotROC(confidence, testClass, col, varargin)
% You pass the scores and the classes, and the function returns the false
% alarm rate and the detection rate for different points across the ROC.
%
% [faR, dR] = plotROC(score, class)
%
%  faR (false alarm rate) is uniformly sampled from 0 to 1
%  dR (detection rate) is computed using the scores.
%
% class = 0 => target absent
% class = 1 => target present
%
% score is the output of the detector, or any other measure of detection.
% There is no plot unless you add a third parameter that is the color of
% the graph. For instance:
% [faR, dR] = plotROC(score, class, 'r')
%
% faR, dR are size 1x1250

if nargin < 3, col = []; end
[scale01] = process_options(varargin, 'scale01', 1);

[falseAlarmRate detectionRate area th] = ROC(confidence, testClass);

if ~isempty(col)
    h=plot(falseAlarmRate, detectionRate, [col '-']);
    %set(h, 'linewidth', 2);
    ex = 0.05*max(falseAlarmRate);
    ey = 0.05;
    if scale01
      axis([0-ex max(falseAlarmRate)+ex 0-ey 1+ey])
    else
      % zoom in on the top left corner
      axis([0-ex max(falseAlarmRate)*0.5+ex 0.5-ey 1+ey])
    end
    grid on
    ylabel('detection rate')
    xlabel('# false alarms')
end

