%read
[vfile,videofolder]=uigetfile({'*.MOV';'*.avi';'*.mp4'},'VideoFileSelector');
videofile = [videofolder '/' vfile];
videoread=VideoReader(videofile);
videoread.CurrentTime = videoread.Duration/2;
imgframe = readFrame(videoread);
figure, imshow(imgframe) ;
pause

%%
%centroid = [1168,533];
centroid = [966,461];
%edge = [1619 528];
edge = [1461 484];
distance_rad = ((((centroid(1)-edge(1)).^2)+((centroid(2)-edge(2)).^2))^(1/2));
%% X and Y are from the 'detections' file. If you have only meta_data, use the code below this section
a=zeros(length(Y),1); %preallocation for speed
b=zeros(length(X),1);
for i=1:length(X)
    a(i) = mean(cell2mat(Y(i))); %calculating group center. Does not account for splitting of groups.
    b(i) = mean(cell2mat(X(i)));
end
%%
z = (((a-centroid(1)).^2) + ((b-centroid(2)).^2)).^(1/2); %distance from centroid%
hist(z./distance_rad,30); title('Distance from the center');ylabel('counts');xlabel('distance(normalized)');
scatterplot([a b]); title('Position of fish group');
%
%Problem : X and Y coordinates are WAY off. Solution : In the algorithm, X
%coordinate is actually the Y coordinate..
%What jitesh said : As the arena size gets smaller perturbation will
%increase
% hist(z, [20,20]); xlabel('X-coordinate');ylabel('Y-coordinate');zlabel('Frames');
% set(gcf,'renderer','opengl');
%  set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
%z = [ a-centroid(1) b-centroid(2)];
%scatterplot(z)
%use meta_data(3rd and 4th columns) to calculate center

%% This code is incase you are using the meta_data file
%load trac_metadata file
c = zeros(1,max(meta_data(:,1)));
d = zeros(1,max(meta_data(:,1)));
for i = 1:max(meta_data(:,1))
 j = find(meta_data(:,1)==i);
 c(i) = mean(meta_data(j,3));
 (j/length(meta_data))*100
 d(i) = mean(meta_data(j,4));
end
%scatterplot([c,d]); title('Position of fish group');
%%
z = (((d-centroid(1)).^2) + ((c-centroid(2)).^2)).^(1/2); %distance from centroid,not normalized
hist(z./distance_rad,30); title('Distance from the center');ylabel('counts');xlabel('distance(normalized)');

for i = 1:length(z)
    if z(i)>300
        cent(i) = 1;  %this is the edge
    else
        cent(i) = 0;  %this is not the edge.
    end
end



%hist3(filtop_p, z./distance_rad,[30,30])