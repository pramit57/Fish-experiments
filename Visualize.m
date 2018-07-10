%%visualize
if (size(filtop_r) == [length(filtop_r) 2])
    filtop_r = filtop_r(:,2);
end
X = [filtop_p, filtop_r];
figure
hist3(X, [20,20]); xlabel('Polarization');ylabel('Rotation');
set(gcf,'renderer','opengl');
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
%%
figure
subplot(211);plot(movmean(filtop_p(1:2500),10),'r');ylabel('polarization');
subplot(212);plot(movmean(filtop_r(1:2500),10),'b');ylabel('rotation');xlabel('frames');
figure
plot(movmean(filtop_p(1:2500),10),'r');hold on; plot(movmean(filtop_r(1:2500),10),'b');
%%
% Points :
x = filtop_p;
y = filtop_r;

% Bin the data:
pts = linspace(0, 1, 100);
N = histcounts2(y(:), x(:), pts, pts);

% Plot points (for comparison):
subplot(1, 2, 1);
scatter(x, y, 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));

% Plot heatmap:
subplot(1, 2, 2);
imagesc(pts, pts, N);
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');

%%
% Generate grid and compute minimum distance:
% Bin the data:
pts = linspace(0, 1, 202);
N = histcounts2(y(:), x(:), pts, pts);

% Create Gaussian filter matrix:
[xG, yG] = meshgrid(-5:5);
sigma = 2.5;
g = exp(-xG.^2./(2.*sigma.^2)-yG.^2./(2.*sigma.^2));
g = g./sum(g(:));

% % Plot scattered data (for comparison):
% subplot(1, 2, 1);
% scatter(x, y, 'r.');
% axis equal;
% set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));

% Plot heatmap:
% subplot(1, 2, 2);
figure
imagesc(pts, pts, conv2(N, g, 'same'));
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');

%%
subplot(2,1,1);plot(movmean(x,500),'r');hold on;plot(movmean(y,500),'b');hold off; subplot(2,1,2); plot(movmean(z,500),'y.')

X = [filtop_p, z];
figure
hist3(X, [20,20]); xlabel('Polarization');ylabel('distance');
set(gcf,'renderer','opengl');
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
hold on
Y = [filtop_r, z];

hist3(Y, [20,20]); xlabel('Rotation');ylabel('distance');
set(gcf,'renderer','opengl');
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
%%
%to get transition values : use 0,1,2,3 for
%swarm,milling,polarized,transition regime.
%We visualize this with respect to distance (should be easier since
%transitions are few and far between.
%Find transition frequency(all non-0 values in transition array) as a proportion of the time spent near the
%boundary or edge.
X = [filtop_p filtop_r];
for i=1:length(X)
    if and(X(i,1) > 0.65 , X(i,2) > 0.65)
        state(i) = 3;
    elseif and(X(i,1) > 0.65, X(i,2) < 0.35)
        state(i) = 2;
    elseif and(X(i,1)<0.65, X(i,2) > 0.35)
        state(i) = 1;
    else
        state(i) = 0; %#ok<*SAGROW>
    end
end
dist_transition = [state' z];
hist3(dist_transition, [20,20]); xlabel('State');ylabel('Distance');
set(gcf,'renderer','opengl');
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
slope1=state(2:end)-state(1:end-1);  %If its 0, it means there is no transition
slope1(:,108616) = 0; %important to concatenate the matrix with others
subplot(2,1,1);plot(slope1(1:2500),'r');subplot(2,1,2);plot(z(1:2500),'b');
dist_transition = [slope1' z];   
plot(dist_transition)
dist_transition1 = [slope1',cent'];   
%% Find frequency of transition as a proportion of center or edge
edge_transition = dist_transition1(find(dist_transition1(:,2)==1)); %find all edge indices

center_transition = dist_transition1(find(dist_transition1(:,2)==0)); %find all center indices


Prop=[mean(center_transition~=0)*100,mean(edge_transition~=0)*100] %proportion of transition at - center, edge 