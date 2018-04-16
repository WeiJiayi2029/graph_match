clc;
clear;
%%  Read the image and grayscale
%M, N, C可重复利用
dst = imread('31.png');dst_g = rgb2gray(dst);
src=imread('32.png');
[M, N, C] = size(src);
for i=1:M
    for j=1:N
        src(i,j)=src(i,j)/255;
    end
end
src_g= rgb2gray(src);

im=src_g==0;%binarizing the image
%% MSER
regions1 = detectMSERFeatures(dst_g);
regions2 = detectMSERFeatures(src_g);
% figure; imshow(src_g); hold on;
% plot(regions2,'showPixelList',true,'showEllipses',false)
% plot(regions2);
%% Get image boundaries
%% Picture1
[piece1,N]=size(regions1);
result1=zeros(size(dst_g));
for i=1:piece1
    reg1=regions1(i,1);
    [M1,N1]=size(reg1.PixelList);
    coordinate1=reg1.PixelList(1,1);
    for j=1:M1
        x=coordinate1(j,2);
        y=coordinate1(j,1);
        result1(x,y)=255;
    end
    %figure;imshow(result1);
    %把太小的区域去掉
    result1=bwareaopen(result1,8);
    %获取边界，不要孔
    [contours1,L]=bwboundaries(result1,'noholes');
%% for show
    %使用彩色图显示标记对象，其中背景为灰色，区域边界轮廓为红色。
%    imshow(label2rgb(L, @jet, [.5 .5 .5]));hold on; 
%     for k=1:length(contours1)
%         boundary=contours1{k};
%         plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 1)
%     end 
end
%% Picture2
[piece2,N]=size(regions2);
result2=zeros(size(src_g));
for i=1:piece2
    reg2=regions2(i,1);
    [M1,N1]=size(reg2.PixelList);
    coordinate2=reg2.PixelList(1,1);
    for j=1:M1
        x=coordinate2(j,2);
        y=coordinate2(j,1);
        result2(x,y)=255;
    end
    result2=bwareaopen(result2,8);
    [contours2,L]=bwboundaries(result2,'noholes');
    %使用彩色图显示标记对象，其中背景为灰色，区域边界轮廓为红色。
%     imshow(label2rgb(L, @jet, [.5 .5 .5]));hold on; 
%     for k=1:length(contours2)
%         boundary=contours2{k};
%         plot(boundary(:,2), boundary(:,1), 'm', 'LineWidth', 1)
%     end 
end
%%  for test
% for k=1:length(contours2)
%         boundary=contours2{k};
%         for m=1:length(boundary)/5
%             boundary1(m,2)=boundary(m*5,2);boundary1(m,1)=boundary(m*5,1);
%         end
%         plot(boundary1(:,2), boundary1(:,1), 'w', 'LineWidth', 1)
% end
%%
figure;
 for k=1:length(contours1)
     boundary1=contours1(k);
     boundary1=boundary1.';
     [boundary1,seglist(k),precision_list,reliability_list,precision_edge,reliability_edge, time_edge] = linefit_Prasad_RDP_opt(boundary1);
     %drawedgelist(boundary1,size(im),1,[0 0 1],gcf);
     drawseglist(seglist(k),size(im),1,[0 0 0],gcf);
     legend('edge','polygonal approximation');  
 end
 seglist=seglist.';
% figure;
% for k=1:length(contours2)
%      boundary2=contours2(k);
%      boundary2=boundary2.';
%      [boundary2,seglist(k),precision_list,reliability_list,precision_edge,reliability_edge, time_edge] = linefit_Prasad_RDP_opt(boundary2);
%      %drawedgelist(boundary2,size(im),1,[0 0 1],gcf);
%      drawseglist(seglist(k),size(im),1,[0 0 0],gcf);
%      legend('edge','polygonal approximation');  
%  end
%  seglist=seglist.';
    