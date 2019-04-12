            fig=figure(1); clf;
            ax1=axes;
            ax1.Position=[0.01 0.01 0.98 0.86];
            ax1.Units='pixel';
            vidRes = [1280 720];
            displayed_data=imagesc(ax1,zeros(vidRes(2), vidRes(1), 1 ));
            displayed_data.ButtonDownFcn=@FullScreenToggle;
            axis image;
            pos = plotboxpos(ax1)
            t=annotation(fig,'rectangle');
            %t.String='test';
            t.Units='pixel';
            t.Position=[pos(1:2)+pos(3:4) 2 2];
            %%
