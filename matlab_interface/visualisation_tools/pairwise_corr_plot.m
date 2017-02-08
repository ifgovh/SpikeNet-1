function [ah_bi, ah_uni ] = pairwise_corr_plot(X, VarName, varargin)
% This function visualizes pairwise correlations among multiple variables
% using 3D histogram and also plots univariate histograms. All of the axes
% limits and color scales are synchronized across the subplots. The layout
% of the subplots is designed to eliminate any duplicated axis labels/ticks.
%
% [ah_bi, ah_uni ] = pairwise_corr_plot(X, VarName, varargin)
% 
% Input arguments:
%               X: a matrix where each column is a variable
%         VarName: a cell array that contains the names of the variables
%
% Output arguments:
%           ah_bi: a vector of axes handles for the bivariate histograms
%          ah_uni: a vector of axes handles for the univariate histograms
%
% 0ptional input arguments that can be given in the name-value pair format:
%     subplot_pos: a 3-by-1 vector [m, n, p1] that defined the subplot
%                  position of the top-left subplot generated by this
%                  function.
%          n_bins: number of bins for the histograms
%  label_fontsize: font size of the x/y labels
%   text_fontsize: font size of the texts
%   axis_fontsize: font size of the axis tick labels
%
% Yifan Gu, 8-Feb-207
% yigu8115@gmail.com

n_var = length(VarName); % number of variables
subplot_pos = [n_var n_var 1];
n_bins = 20; % number of bins for the histograms
label_fontsize = 6;
text_fontsize = 6;
axis_fontsize = 6;

% Read varargin
var_len = length(varargin);
if mod(var_len,2) ~= 0
    error('0ptional input arguments that can be given in the name-value pair format.')
end
for i = 1:var_len/2
    eval([varargin{i*2-1}, '= varargin{i*2};']);
end
m = subplot_pos(1);
n = subplot_pos(2);
p1 = subplot_pos(3);

% check input
[m1,n1] = ind2sub([m, n], p1);
if m1 + n_var - 1 > m || n1 + n_var - 1 > n
    error('Not enough subplot positions available!')
end


ah_bi = [];
ah_uni = [];
bi_caxis_max = 0;
uni_yaxis_max = 0;
for i = 1:n_var
    for j = 1:n_var
        % subplot position
        p = p1 + n*(i-1) + j-1;
        % histogram bin edges
        bin_edge_x = linspace(min(X(:,j)), max(X(:,j)), n_bins+1)';
        bin_edge_y = linspace(min(X(:,i)), max(X(:,i)), n_bins+1)';
        bin_centre_x = (bin_edge_x(1:end-1)+bin_edge_x(2:end))/2;
        bin_centre_y = (bin_edge_y(1:end-1)+bin_edge_y(2:end))/2;
        if i == j % do univariate histogram
            
            ah = subplot(m,n, p);
            ah_uni = [ah_uni ah]; %#ok<AGROW>
            [N] = histc(X(:,j), bin_edge_x);
            if i == n_var
                barh(bin_centre_x, N(1:end-1), 'FaceColor','none','EdgeColor','b');
                ylim(minmax(bin_edge_x'));
                 uni_yaxis_max = max(uni_yaxis_max, max(xlim));
            else
                bar(bin_centre_x, N(1:end-1), 'FaceColor','none','EdgeColor','b');
                xlim(minmax(bin_edge_x'));
                 uni_yaxis_max = max(uni_yaxis_max, max(ylim));
            end
            if i > 1
                set(ah,'ytick',[]);
            end
            box on;
            set(ah,'xtick',[], 'fontSize', axis_fontsize );
           
           
            
        elseif i > j % do bivariate histogram
            ah = subplot(m,n, p);
            ah_bi = [ah_bi ah]; %#ok<AGROW>
            [N] = hist3([X(:,j) X(:,i)], 'Edges', {bin_edge_x, bin_edge_y});
            imagesc(bin_centre_x, bin_centre_y, N(1:end-1,1:end-1));
            if i == n_var
                xlabel(VarName{j},'FontSize', label_fontsize)
            else
                set(ah,'xtick',[]);
            end
            if j == 1
                ylabel(VarName{i},'FontSize', label_fontsize)
            else
                set(ah,'ytick',[]);
            end
            bi_caxis_max = max(bi_caxis_max, max(caxis));
            % Calculate and show the correlation coefficient
            cof = corrcoef(X(:,j), X(:,i), 'rows', 'complete');
            r_str = sprintf('r = %.3f', cof(1,2));
            pos = get(gca,'position');
            set(gca,'fontsize', text_fontsize);
            % use dummy axes to make positioning text easier
            axes('Parent', gcf, 'Position', pos, 'Visible', 'off', 'XLim', [0, 1],'YLim', [0, 1], 'NextPlot', 'add'); %#ok<LAXES>
            text (0.5, 1.02, r_str, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center', 'FontSize', text_fontsize);
            set(ah,'YDir','normal','fontsize', axis_fontsize );
        end
    end
end

% synchronize y limits for univariate histograms
for i = 1:n_var
    if i < n_var
        set(ah_uni(i), 'Ylim', [0 uni_yaxis_max]);
    else
        set(ah_uni(i), 'Xlim', [0 uni_yaxis_max]);
    end
end
% synchronize color scale for bivariate histograms
for i = 1:length(bi_caxis_max)
    caxis(ah_bi(i), [0, bi_caxis_max]);
end

end
