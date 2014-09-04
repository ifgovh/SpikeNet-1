function RasterYG( Result_cell, save_figure )
%   -1 for no figure, 0 for displaying figure, 1 for saving figure
%
%   If the firing history is too long, data will be segmented into several
%   history fractions and plotted separately.
disp('RasterYG...');
tic;


if nargin == 0
    Result_cell = CollectRYG();
end
if nargin <= 1
    save_figure = 1; % default
end
if save_figure == 1
    figure_visibility = 'off'; % 'on', 'off'
else
    figure_visibility = 'on';
end

Result_num = length(Result_cell);

for r_num = 1:Result_num
    R = Result_cell{r_num};
    reduced_step_tot = R.reduced_step_tot;
    comments = R.comments;
    % Num_pop = R_temp.Num_pop; % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    Num_pop = 1;
    
    sample_size = 500; % sample neurons for raster plot
    seg_size = 4*10^4; % 2*10^4 for 2-pop, segmentation size for each plot
    seg_num = ceil(reduced_step_tot/seg_size);
    for seg = 1:seg_num
        
        %-------------------------------------------------------------------------%
        % Plot
        h_raster = figure('NumberTitle','Off','Name','Raster plot','units','normalized','position',[0 0 1 1], ...
            'visible', figure_visibility, 'Color','w', 'PaperPositionMode', 'default');
        axes_matrix = zeros(3,Num_pop);
        for pop_ind = 1:Num_pop
            % Plot raster plot
            axes_matrix(1,pop_ind) = subplot(5,Num_pop,(0:3)*Num_pop+pop_ind);hold on;
            raster_plot(R, pop_ind, seg, seg_size, sample_size);
            % Plot number of spikes
            axes_matrix(2,pop_ind) = subplot(5,Num_pop,4*Num_pop+pop_ind);hold on;
            num_spikes_plot(R, pop_ind, seg, seg_size);
%             % Plot number of refractory neurons
%             axes_matrix(3,pop_ind) = subplot(7,Num_pop,5*Num_pop+pop_ind);hold on;
%             num_ref_plot(R, pop_ind, seg, seg_size);
        end
        
        % Link axes to synchronise them when zooming
        for pop_ind = 1:Num_pop
            linkaxes(axes_matrix(1:2,pop_ind),'x');
        end
        
%         % Keep tick lables while remove tick marks
%         for pop_ind = 1:Num_pop
%             for i = 1:2
%                 set(axes_matrix(i,pop_ind), 'Ticklength', [0 0]);
%             end
%         end
        

        
        
%         % Write comments
%         subplot(7,Num_pop,6*Num_pop+(1:Num_pop), 'visible','off')
%         text(0.5, 0.5, comments, ...
%             'VerticalAlignment', 'top', ...
%             'HorizontalAlignment', 'center',...
%             'FontSize',10,'FontWeight','normal', 'interpreter', 'none'); % ...'interpreter', 'none'... to show underscore
        
        
        % save figure
        if save_figure == 1
            fprintf('\t Saving figure...');
            print(h_raster, '-dpdf', strcat( R.stamp, '_raster_',sprintf('%02g-', num2str(seg))));
            delete(h_raster);
            fprintf('done.\n');
        else
            next = input('\t Next figure?');
            delete(h_raster);
        end
        
    end
end

toc;

end


%         % Set initial y-axes to be same, since only one property can be linked
%         for i = 2:3
%             ylimData = [inf -inf]; % initialise ylim
%             % find common ylim
%             for pop_ind = 1:Num_pop
%                 ylimData_new = ylim(axes_matrix(i,pop_ind));
%                 ylimData(1) = min(ylimData(1),ylimData_new(1));
%                 ylimData(2) = max(ylimData(2),ylimData_new(2));
%             end
%             % set common ylim
%             for pop_ind = 1:Num_pop
%                 ylim(axes_matrix(i,pop_ind),ylimData);
%             end
%         end













